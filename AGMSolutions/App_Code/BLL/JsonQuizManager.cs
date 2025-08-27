using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;

/// <summary>
/// Advanced JSON Quiz Manager - Handles JSON quiz uploads and dynamic quiz generation
/// Supports MCQ, DRAGDROP, DROPDOWN, and MIXED question types as per system requirements
/// </summary>
public class JsonQuizManager
{
    private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

    #region Quiz JSON Models
    
    public class QuizJsonStructure
    {
        public string SubjectCode { get; set; }
        public string QuizTitle { get; set; }
        public int QuizDurationMinutes { get; set; }
        public int AttemptsAllowed { get; set; }
        public string OVERALLTYPE { get; set; } // MCQ, DRAGDROP, DROPDOWN, MIXED
        public List<QuestionJson> Questions { get; set; }
    }

    public class QuestionJson
    {
        public string Q_ID { get; set; }
        public string QuestionText { get; set; }
        public string TYPE { get; set; } // MCQ, DRAGDROP, DROPDOWN
        public Dictionary<string, string> Options { get; set; }
        public string CorrectAnswer { get; set; }
        public int Points { get; set; }
        public string Explanation { get; set; }
        public List<string> MultipleCorrectAnswers { get; set; } // For DROPDOWN multi-select
        public string DragDropConfiguration { get; set; } // JSON config for drag-drop
    }

    #endregion

    #region JSON Quiz Upload and Processing

    /// <summary>
    /// Upload and process JSON quiz file
    /// </summary>
    public static UploadResult UploadJsonQuiz(HttpPostedFile jsonFile, int courseId, int createdBy)
    {
        try
        {
            if (jsonFile == null || jsonFile.ContentLength == 0)
                return new UploadResult { Success = false, Message = "No file uploaded or file is empty." };

            if (!jsonFile.FileName.EndsWith(".json", StringComparison.OrdinalIgnoreCase))
                return new UploadResult { Success = false, Message = "Invalid file format. Please upload a JSON file." };

            if (jsonFile.ContentLength > 5 * 1024 * 1024) // 5MB limit
                return new UploadResult { Success = false, Message = "File size too large. Maximum 5MB allowed." };

            // Read JSON content
            string jsonContent;
            using (var reader = new StreamReader(jsonFile.InputStream))
            {
                jsonContent = reader.ReadToEnd();
            }

            // Validate and parse JSON
            var quizData = ValidateAndParseJson(jsonContent);
            if (quizData == null)
                return new UploadResult { Success = false, Message = "Invalid JSON format or structure." };

            // Create quiz in database
            int quizId = CreateQuizFromJson(quizData, courseId, createdBy);
            
            return new UploadResult 
            { 
                Success = true, 
                Message = $"Quiz '{quizData.QuizTitle}' uploaded successfully with {quizData.Questions.Count} questions.",
                QuizId = quizId
            };
        }
        catch (Exception ex)
        {
            return new UploadResult { Success = false, Message = $"Upload failed: {ex.Message}" };
        }
    }

    /// <summary>
    /// Validate JSON structure and parse into quiz object
    /// </summary>
    private static QuizJsonStructure ValidateAndParseJson(string jsonContent)
    {
        try
        {
            var quizData = JsonConvert.DeserializeObject<QuizJsonStructure>(jsonContent);
            
            // Validate required fields
            if (string.IsNullOrEmpty(quizData.QuizTitle) || 
                string.IsNullOrEmpty(quizData.SubjectCode) ||
                quizData.Questions == null || 
                quizData.Questions.Count == 0)
            {
                return null;
            }

            // Validate question types
            var validTypes = new[] { "MCQ", "DRAGDROP", "DROPDOWN" };
            foreach (var question in quizData.Questions)
            {
                if (!validTypes.Contains(question.TYPE?.ToUpper()))
                {
                    throw new ArgumentException($"Invalid question type: {question.TYPE}. Supported types: MCQ, DRAGDROP, DROPDOWN");
                }

                if (string.IsNullOrEmpty(question.QuestionText) || string.IsNullOrEmpty(question.Q_ID))
                {
                    throw new ArgumentException("Question text and Q_ID are required for all questions.");
                }
            }

            return quizData;
        }
        catch (JsonException)
        {
            return null;
        }
    }

    /// <summary>
    /// Create quiz and questions in database from JSON data
    /// </summary>
    private static int CreateQuizFromJson(QuizJsonStructure quizData, int courseId, int createdBy)
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            using (var transaction = connection.BeginTransaction())
            {
                try
                {
                    // Create quiz
                    string quizSql = @"
                        INSERT INTO Quizzes (CourseID, Title, Description, TimeLimit, AttemptsAllowed, IsActive, CreatedBy, CreatedDate, QuizType)
                        VALUES (@CourseID, @Title, @Description, @TimeLimit, @AttemptsAllowed, 1, @CreatedBy, GETDATE(), @QuizType);
                        SELECT SCOPE_IDENTITY();";

                    int quizId;
                    using (var cmd = new SqlCommand(quizSql, connection, transaction))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        cmd.Parameters.AddWithValue("@Title", quizData.QuizTitle);
                        cmd.Parameters.AddWithValue("@Description", $"Auto-generated from JSON upload - Subject: {quizData.SubjectCode}");
                        cmd.Parameters.AddWithValue("@TimeLimit", quizData.QuizDurationMinutes);
                        cmd.Parameters.AddWithValue("@AttemptsAllowed", quizData.AttemptsAllowed);
                        cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
                        cmd.Parameters.AddWithValue("@QuizType", quizData.OVERALLTYPE);
                        
                        quizId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // Create questions
                    foreach (var question in quizData.Questions)
                    {
                        CreateQuestionFromJson(question, quizId, connection, transaction);
                    }

                    transaction.Commit();
                    return quizId;
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }
    }

    /// <summary>
    /// Create individual question from JSON data
    /// </summary>
    private static void CreateQuestionFromJson(QuestionJson questionData, int quizId, SqlConnection connection, SqlTransaction transaction)
    {
        string questionSql = @"
            INSERT INTO Questions (QuizID, QuestionText, QuestionType, Points, CorrectAnswer, JsonConfiguration, Explanation, JsonOptions)
            VALUES (@QuizID, @QuestionText, @QuestionType, @Points, @CorrectAnswer, @JsonConfiguration, @Explanation, @JsonOptions);";

        using (var cmd = new SqlCommand(questionSql, connection, transaction))
        {
            cmd.Parameters.AddWithValue("@QuizID", quizId);
            cmd.Parameters.AddWithValue("@QuestionText", questionData.QuestionText);
            cmd.Parameters.AddWithValue("@QuestionType", questionData.TYPE);
            cmd.Parameters.AddWithValue("@Points", questionData.Points);
            cmd.Parameters.AddWithValue("@Explanation", questionData.Explanation ?? "");

            // Handle different question types
            switch (questionData.TYPE.ToUpper())
            {
                case "MCQ":
                    cmd.Parameters.AddWithValue("@CorrectAnswer", questionData.CorrectAnswer);
                    cmd.Parameters.AddWithValue("@JsonOptions", JsonConvert.SerializeObject(questionData.Options));
                    cmd.Parameters.AddWithValue("@JsonConfiguration", DBNull.Value);
                    break;

                case "DROPDOWN":
                    // For dropdown, handle multiple correct answers
                    var correctAnswers = questionData.MultipleCorrectAnswers ?? new List<string> { questionData.CorrectAnswer };
                    cmd.Parameters.AddWithValue("@CorrectAnswer", JsonConvert.SerializeObject(correctAnswers));
                    cmd.Parameters.AddWithValue("@JsonOptions", JsonConvert.SerializeObject(questionData.Options));
                    cmd.Parameters.AddWithValue("@JsonConfiguration", DBNull.Value);
                    break;

                case "DRAGDROP":
                    cmd.Parameters.AddWithValue("@CorrectAnswer", questionData.CorrectAnswer);
                    cmd.Parameters.AddWithValue("@JsonOptions", JsonConvert.SerializeObject(questionData.Options));
                    cmd.Parameters.AddWithValue("@JsonConfiguration", questionData.DragDropConfiguration ?? "{}");
                    break;

                default:
                    throw new ArgumentException($"Unsupported question type: {questionData.TYPE}");
            }

            cmd.ExecuteNonQuery();
        }
    }

    #endregion

    #region Quiz Retrieval and Display

    /// <summary>
    /// Get quiz with questions in JSON format for display
    /// </summary>
    public static QuizDisplayData GetQuizForTaking(int quizId, int studentId)
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();

            // Get quiz details
            string quizSql = @"
                SELECT q.QuizID, q.Title, q.Description, q.TimeLimit, q.AttemptsAllowed, q.QuizType,
                       c.CourseName, c.CourseCode
                FROM Quizzes q
                JOIN Courses c ON q.CourseID = c.CourseID
                WHERE q.QuizID = @QuizID AND q.IsActive = 1";

            QuizDisplayData quiz = null;
            using (var cmd = new SqlCommand(quizSql, connection))
            {
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        quiz = new QuizDisplayData
                        {
                            QuizID = reader.GetInt32(reader.GetOrdinal("QuizID")),
                            Title = reader.GetString(reader.GetOrdinal("Title")),
                            Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? "" : reader.GetString(reader.GetOrdinal("Description")),
                            TimeLimit = reader.GetInt32(reader.GetOrdinal("TimeLimit")),
                            AttemptsAllowed = reader.GetInt32(reader.GetOrdinal("AttemptsAllowed")),
                            QuizType = reader.IsDBNull(reader.GetOrdinal("QuizType")) ? "MIXED" : reader.GetString(reader.GetOrdinal("QuizType")),
                            CourseName = reader.GetString(reader.GetOrdinal("CourseName")),
                            CourseCode = reader.GetString(reader.GetOrdinal("CourseCode"))
                        };
                    }
                }
            }

            if (quiz == null) return null;

            // Get questions
            string questionsSql = @"
                SELECT QuestionID, QuestionText, QuestionType, Points, JsonOptions, JsonConfiguration, Explanation
                FROM Questions
                WHERE QuizID = @QuizID
                ORDER BY QuestionID";

            quiz.Questions = new List<QuestionDisplayData>();
            using (var cmd = new SqlCommand(questionsSql, connection))
            {
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var question = new QuestionDisplayData
                        {
                            QuestionID = reader.GetInt32(reader.GetOrdinal("QuestionID")),
                            QuestionText = reader.GetString(reader.GetOrdinal("QuestionText")),
                            QuestionType = reader.GetString(reader.GetOrdinal("QuestionType")),
                            Points = reader.GetInt32(reader.GetOrdinal("Points")),
                            Explanation = reader.IsDBNull(reader.GetOrdinal("Explanation")) ? "" : reader.GetString(reader.GetOrdinal("Explanation"))
                        };

                        // Parse JSON options
                        string jsonOptions = reader.IsDBNull(reader.GetOrdinal("JsonOptions")) ? "{}" : reader.GetString(reader.GetOrdinal("JsonOptions"));
                        question.Options = JsonConvert.DeserializeObject<Dictionary<string, string>>(jsonOptions) ?? new Dictionary<string, string>();

                        // Parse JSON configuration for drag-drop
                        if (!reader.IsDBNull(reader.GetOrdinal("JsonConfiguration")))
                        {
                            question.JsonConfiguration = reader.GetString(reader.GetOrdinal("JsonConfiguration"));
                        }

                        quiz.Questions.Add(question);
                    }
                }
            }

            return quiz;
        }
    }

    /// <summary>
    /// Generate sample JSON template for quiz creation
    /// </summary>
    public static string GenerateSampleJsonTemplate()
    {
        var sampleQuiz = new QuizJsonStructure
        {
            SubjectCode = "CS101",
            QuizTitle = "Computer Science Fundamentals",
            QuizDurationMinutes = 45,
            AttemptsAllowed = 3,
            OVERALLTYPE = "MIXED",
            Questions = new List<QuestionJson>
            {
                new QuestionJson
                {
                    Q_ID = "Q1",
                    QuestionText = "What is the time complexity of binary search?",
                    TYPE = "MCQ",
                    Options = new Dictionary<string, string>
                    {
                        {"A", "O(n)"},
                        {"B", "O(log n)"},
                        {"C", "O(n²)"},
                        {"D", "O(1)"}
                    },
                    CorrectAnswer = "B",
                    Points = 5,
                    Explanation = "Binary search divides the search space in half with each iteration, resulting in O(log n) complexity."
                },
                new QuestionJson
                {
                    Q_ID = "Q2",
                    QuestionText = "Match the data structure with its primary use case:",
                    TYPE = "DRAGDROP",
                    Options = new Dictionary<string, string>
                    {
                        {"Stack", "LIFO operations"},
                        {"Queue", "FIFO operations"},
                        {"Hash Table", "Fast lookups"},
                        {"Binary Tree", "Hierarchical data"}
                    },
                    CorrectAnswer = "Stack:LIFO operations,Queue:FIFO operations,Hash Table:Fast lookups,Binary Tree:Hierarchical data",
                    Points = 8,
                    Explanation = "Each data structure is optimized for specific operations and use cases.",
                    DragDropConfiguration = "{\"layout\":\"match\",\"randomize\":true}"
                },
                new QuestionJson
                {
                    Q_ID = "Q3",
                    QuestionText = "Select all sorting algorithms with O(n log n) average time complexity:",
                    TYPE = "DROPDOWN",
                    Options = new Dictionary<string, string>
                    {
                        {"A", "Merge Sort"},
                        {"B", "Quick Sort"},
                        {"C", "Bubble Sort"},
                        {"D", "Heap Sort"},
                        {"E", "Selection Sort"}
                    },
                    MultipleCorrectAnswers = new List<string> {"A", "B", "D"},
                    Points = 6,
                    Explanation = "Merge Sort, Quick Sort (average case), and Heap Sort all have O(n log n) time complexity."
                }
            }
        };

        return JsonConvert.SerializeObject(sampleQuiz, Formatting.Indented);
    }

    #endregion

    #region Support Classes

    public class UploadResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int QuizId { get; set; }
    }

    public class QuizDisplayData
    {
        public int QuizID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int TimeLimit { get; set; }
        public int AttemptsAllowed { get; set; }
        public string QuizType { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public List<QuestionDisplayData> Questions { get; set; }
    }

    public class QuestionDisplayData
    {
        public int QuestionID { get; set; }
        public string QuestionText { get; set; }
        public string QuestionType { get; set; }
        public int Points { get; set; }
        public Dictionary<string, string> Options { get; set; }
        public string JsonConfiguration { get; set; }
        public string Explanation { get; set; }
    }

    #endregion
}
