using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using Newtonsoft.Json;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.DAL;

namespace AGMSolutions.App_Code.BLL
{
    public class QuizManager
    {
        private string connectionString;
        private QuizDAL _quizDAL;

        public QuizManager()
        {
            connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            _quizDAL = new QuizDAL();
        }

        // Legacy method for backward compatibility
        public int CreateQuiz(int courseID, int lecturerID, string quizTitle, string fileName, 
                             string jsonContent, int totalQuestions, int timeLimit, int passingScore, bool enableProctoring)
        {
            Quiz quiz = new Quiz
            {
                CourseID = courseID,
                Title = quizTitle,
                Description = "",
                TimeLimit = timeLimit,
                TotalMarks = passingScore,
                CreatedBy = lecturerID,
                IsActive = true,
                IsProctored = enableProctoring
            };
            return CreateQuiz(quiz);
        }

        public int CreateQuiz(Quiz quiz)
        {
            return _quizDAL.CreateQuiz(quiz);
        }

        // Get quizzes for enrolled courses of a student
        public List<Quiz> GetQuizzesForStudent(int studentId)
        {
            List<Quiz> quizzes = new List<Quiz>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT DISTINCT q.*, c.CourseName, c.CourseCode,
                               l.FirstName + ' ' + l.LastName AS LecturerName
                        FROM Quizzes q
                        INNER JOIN Courses c ON q.CourseID = c.CourseID
                        INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                        LEFT JOIN Users l ON c.LecturerID = l.UserID
                        WHERE e.StudentID = @StudentID 
                        AND e.IsActive = 1 
                        AND q.IsActive = 1
                        ORDER BY q.DateCreated DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        Quiz quiz = new Quiz
                        {
                            QuizID = (int)reader["QuizID"],
                            CourseID = (int)reader["CourseID"],
                            Title = reader["Title"].ToString(),
                            Description = reader["Description"]?.ToString(),
                            TimeLimit = (int)reader["TimeLimit"],
                            AttemptsAllowed = (int)reader["AttemptsAllowed"],
                            TotalMarks = (int)reader["TotalMarks"],
                            PassingMarks = (decimal)(reader["PassingMarks"] as int? ?? 0),
                            QuizType = reader["QuizType"]?.ToString() ?? "MIXED",
                            IsActive = (bool)reader["IsActive"],
                            IsProctored = (bool)reader["IsProctored"],
                            AllowFullScreen = reader["AllowFullScreen"] as bool? ?? true,
                            AllowTabSwitching = reader["AllowTabSwitching"] as bool? ?? false,
                            MaxTabSwitchWarnings = reader["MaxTabSwitchWarnings"] as int? ?? 3,
                            DateCreated = (DateTime)reader["DateCreated"],
                            CourseName = reader["CourseName"].ToString(),
                            CourseCode = reader["CourseCode"].ToString(),
                            LecturerName = reader["LecturerName"]?.ToString()
                        };

                        quizzes.Add(quiz);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(studentId, "Get Quizzes Error", $"Error getting quizzes: {ex.Message}");
                throw new Exception("Error retrieving quizzes. Please try again.");
            }

            return quizzes;
        }

        // Get quiz details with questions
        public Quiz GetQuizWithQuestions(int quizId, int studentId)
        {
            try
            {
                // First verify student has access to this quiz
                if (!HasQuizAccess(quizId, studentId))
                {
                    throw new UnauthorizedAccessException("You don't have access to this quiz.");
                }

                Quiz quiz = GetQuizById(quizId);
                if (quiz != null)
                {
                    quiz.QuizQuestions = GetQuizQuestions(quizId);
                    quiz.StudentAttempts = GetStudentAttempts(quizId, studentId);
                }

                return quiz;
            }
            catch (Exception ex)
            {
                LogActivity(studentId, "Get Quiz Details Error", $"Error getting quiz details: {ex.Message}");
                throw;
            }
        }

        // Start a new quiz attempt
        public QuizAttempt StartQuizAttempt(int quizId, int studentId)
        {
            try
            {
                // Verify student can start attempt
                if (!CanStartNewAttempt(quizId, studentId))
                {
                    throw new InvalidOperationException("You have reached the maximum number of attempts for this quiz.");
                }

                QuizAttempt attempt = new QuizAttempt
                {
                    QuizID = quizId,
                    StudentID = studentId,
                    AttemptNumber = GetNextAttemptNumber(quizId, studentId),
                    StartTime = DateTime.Now,
                    IsCompleted = false,
                    TabSwitchCount = 0,
                    WarningCount = 0
                };

                // Save attempt to database
                int attemptId = SaveQuizAttempt(attempt);
                attempt.AttemptID = attemptId;

                LogActivity(studentId, "Quiz Attempt Started", $"Started quiz attempt for QuizID: {quizId}");
                return attempt;
            }
            catch (Exception ex)
            {
                LogActivity(studentId, "Start Quiz Error", $"Error starting quiz: {ex.Message}");
                throw;
            }
        }

        // Submit quiz attempt
        public QuizAttempt SubmitQuizAttempt(int attemptId, string answersJson, int tabSwitchCount = 0)
        {
            try
            {
                QuizAttempt attempt = GetQuizAttemptById(attemptId);
                if (attempt == null)
                {
                    throw new ArgumentException("Quiz attempt not found.");
                }

                // Calculate score
                Quiz quiz = GetQuizById(attempt.QuizID);
                var scoreResult = CalculateScore(quiz, answersJson);

                // Update attempt
                attempt.EndTime = DateTime.Now;
                attempt.AnswersJson = answersJson;
                attempt.Score = scoreResult.Score;
                attempt.TotalMarks = scoreResult.TotalMarks;
                attempt.Percentage = scoreResult.Percentage;
                attempt.IsCompleted = true;
                attempt.IsSubmitted = true;
                attempt.SubmissionDate = DateTime.Now;
                attempt.TabSwitchCount = tabSwitchCount;
                attempt.TimeSpent = (int)((attempt.EndTime ?? DateTime.Now) - attempt.StartTime).TotalMinutes;

                // Update in database
                UpdateQuizAttempt(attempt);

                // Save grade
                SaveQuizGrade(attempt);

                LogActivity(attempt.StudentID, "Quiz Submitted", 
                    $"Quiz submitted - Score: {attempt.Score}/{attempt.TotalMarks} ({attempt.Percentage:F1}%)");

                return attempt;
            }
            catch (Exception ex)
            {
                LogActivity(null, "Submit Quiz Error", $"Error submitting quiz: {ex.Message}");
                throw;
            }
        }

        // Record tab switch for proctored quizzes
        public void RecordTabSwitch(int attemptId, int studentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE QuizAttempts 
                        SET TabSwitchCount = ISNULL(TabSwitchCount, 0) + 1
                        WHERE AttemptID = @AttemptID AND StudentID = @StudentID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AttemptID", attemptId);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LogActivity(studentId, "Tab Switch", $"Tab switch recorded for attempt: {attemptId}");
            }
            catch (Exception ex)
            {
                LogActivity(studentId, "Tab Switch Error", $"Error recording tab switch: {ex.Message}");
            }
        }

        // Legacy method for backward compatibility
        public DataTable GetQuizzesByLecturer(int lecturerID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT q.QuizID, q.CourseID, q.Title, q.Description, q.TimeLimit, q.TotalMarks, q.DateCreated,
                               c.CourseName, c.CourseCode,
                               COUNT(qa.AttemptID) as TotalAttempts
                        FROM Quizzes q
                        INNER JOIN Courses c ON q.CourseID = c.CourseID
                        LEFT JOIN QuizAttempts qa ON q.QuizID = qa.QuizID
                        WHERE c.LecturerID = @LecturerID AND q.IsActive = 1
                        GROUP BY q.QuizID, q.CourseID, q.Title, q.Description, q.TimeLimit, q.TotalMarks, q.DateCreated,
                                 c.CourseName, c.CourseCode
                        ORDER BY q.DateCreated DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerID);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    return dt;
                }
            }
            catch (Exception ex)
            {
                LogActivity(lecturerID, "Get Lecturer Quizzes Error", $"Error getting quizzes: {ex.Message}");
                throw new Exception("Error retrieving quizzes. Please try again.");
            }
        }

        // Get student performance for a quiz
        public List<QuizAttempt> GetQuizPerformance(int quizId, int? studentId = null)
        {
            List<QuizAttempt> attempts = new List<QuizAttempt>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT qa.*, u.FirstName, u.LastName, u.Email,
                               q.Title as QuizTitle, q.TotalMarks as QuizTotalMarks
                        FROM QuizAttempts qa
                        INNER JOIN Users u ON qa.StudentID = u.UserID
                        INNER JOIN Quizzes q ON qa.QuizID = q.QuizID
                        WHERE qa.QuizID = @QuizID AND qa.IsCompleted = 1";

                    if (studentId.HasValue)
                    {
                        query += " AND qa.StudentID = @StudentID";
                    }

                    query += " ORDER BY qa.SubmissionDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    if (studentId.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId.Value);
                    }

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        QuizAttempt attempt = new QuizAttempt
                        {
                            AttemptID = (int)reader["AttemptID"],
                            QuizID = (int)reader["QuizID"],
                            StudentID = (int)reader["StudentID"],
                            AttemptNumber = (int)reader["AttemptNumber"],
                            StartTime = (DateTime)reader["StartTime"],
                            EndTime = reader["EndTime"] as DateTime?,
                            Score = reader["Score"] as int? ?? 0,
                            TotalMarks = (decimal)(reader["TotalMarks"] as int? ?? 0),
                            Percentage = reader["Percentage"] as decimal? ?? 0,
                            IsCompleted = (bool)reader["IsCompleted"],
                            IsSubmitted = reader["IsSubmitted"] as bool? ?? false,
                            TimeSpent = reader["TimeSpent"] as int? ?? 0,
                            TabSwitchCount = reader["TabSwitchCount"] as int? ?? 0,
                            WarningCount = reader["WarningCount"] as int? ?? 0,
                            StudentName = $"{reader["FirstName"]} {reader["LastName"]}",
                            StudentEmail = reader["Email"].ToString(),
                            QuizTitle = reader["QuizTitle"].ToString(),
                            QuizTotalMarks = reader["QuizTotalMarks"] as int? ?? 0
                        };

                        attempts.Add(attempt);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(null, "Get Quiz Performance Error", $"Error getting quiz performance: {ex.Message}");
                throw new Exception("Error retrieving quiz performance. Please try again.");
            }

            return attempts;
        }

        // Private helper methods
        private Quiz GetQuizById(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT q.*, c.CourseName, c.CourseCode
                    FROM Quizzes q
                    INNER JOIN Courses c ON q.CourseID = c.CourseID
                    WHERE q.QuizID = @QuizID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    return new Quiz
                    {
                        QuizID = (int)reader["QuizID"],
                        CourseID = (int)reader["CourseID"],
                        Title = reader["Title"].ToString(),
                        Description = reader["Description"]?.ToString(),
                        TimeLimit = (int)reader["TimeLimit"],
                        AttemptsAllowed = (int)reader["AttemptsAllowed"],
                        TotalMarks = (int)reader["TotalMarks"],
                        PassingMarks = (decimal)(reader["PassingMarks"] as int? ?? 0),
                        QuizType = reader["QuizType"]?.ToString() ?? "MIXED",
                        IsActive = (bool)reader["IsActive"],
                        IsProctored = (bool)reader["IsProctored"],
                        AllowFullScreen = reader["AllowFullScreen"] as bool? ?? true,
                        AllowTabSwitching = reader["AllowTabSwitching"] as bool? ?? false,
                        MaxTabSwitchWarnings = reader["MaxTabSwitchWarnings"] as int? ?? 3,
                        DateCreated = (DateTime)reader["DateCreated"],
                        CourseName = reader["CourseName"].ToString(),
                        CourseCode = reader["CourseCode"].ToString()
                    };
                }
            }

            return null;
        }

        private List<QuizQuestion> GetQuizQuestions(int quizId)
        {
            List<QuizQuestion> questions = new List<QuizQuestion>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT * FROM QuizQuestions 
                    WHERE QuizID = @QuizID AND IsActive = 1
                    ORDER BY QuestionOrder, QuestionID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    QuizQuestion question = new QuizQuestion
                    {
                        QuestionID = (int)reader["QuestionID"],
                        QuizID = (int)reader["QuizID"],
                        QuestionText = reader["QuestionText"].ToString(),
                        QuestionType = reader["QuestionType"].ToString(),
                        OptionsJson = reader["OptionsJson"]?.ToString(),
                        CorrectAnswer = reader["CorrectAnswer"]?.ToString(),
                        Points = (int)reader["Points"],
                        QuestionOrder = reader["QuestionOrder"] as int? ?? 1,
                        IsActive = (bool)reader["IsActive"]
                    };

                    questions.Add(question);
                }
            }

            return questions;
        }

        private bool HasQuizAccess(int quizId, int studentId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM Quizzes q
                    INNER JOIN Enrollments e ON q.CourseID = e.CourseID
                    WHERE q.QuizID = @QuizID 
                    AND e.StudentID = @StudentID 
                    AND e.IsActive = 1 
                    AND q.IsActive = 1";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private List<QuizAttempt> GetStudentAttempts(int quizId, int studentId)
        {
            List<QuizAttempt> attempts = new List<QuizAttempt>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT * FROM QuizAttempts
                    WHERE QuizID = @QuizID AND StudentID = @StudentID
                    ORDER BY AttemptNumber DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    QuizAttempt attempt = new QuizAttempt
                    {
                        AttemptID = (int)reader["AttemptID"],
                        QuizID = (int)reader["QuizID"],
                        StudentID = (int)reader["StudentID"],
                        AttemptNumber = (int)reader["AttemptNumber"],
                        StartTime = (DateTime)reader["StartTime"],
                        EndTime = reader["EndTime"] as DateTime?,
                        Score = (decimal)(reader["Score"] as int? ?? 0),
                        TotalMarks = (decimal)(reader["TotalMarks"] as int? ?? 0),
                        Percentage = reader["Percentage"] as decimal? ?? 0,
                        IsCompleted = (bool)reader["IsCompleted"],
                        IsSubmitted = reader["IsSubmitted"] as bool? ?? false,
                        TimeSpent = reader["TimeSpent"] as int? ?? 0,
                        TabSwitchCount = reader["TabSwitchCount"] as int? ?? 0,
                        WarningCount = reader["WarningCount"] as int? ?? 0
                    };

                    attempts.Add(attempt);
                }
            }

            return attempts;
        }

        private bool CanStartNewAttempt(int quizId, int studentId)
        {
            Quiz quiz = GetQuizById(quizId);
            if (quiz == null) return false;

            List<QuizAttempt> attempts = GetStudentAttempts(quizId, studentId);
            return attempts.Count < quiz.AttemptsAllowed;
        }

        private int GetNextAttemptNumber(int quizId, int studentId)
        {
            List<QuizAttempt> attempts = GetStudentAttempts(quizId, studentId);
            return attempts.Count + 1;
        }

        private int SaveQuizAttempt(QuizAttempt attempt)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    INSERT INTO QuizAttempts (QuizID, StudentID, AttemptNumber, StartTime, IsCompleted, TabSwitchCount, WarningCount)
                    VALUES (@QuizID, @StudentID, @AttemptNumber, @StartTime, @IsCompleted, @TabSwitchCount, @WarningCount);
                    SELECT SCOPE_IDENTITY();";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", attempt.QuizID);
                cmd.Parameters.AddWithValue("@StudentID", attempt.StudentID);
                cmd.Parameters.AddWithValue("@AttemptNumber", attempt.AttemptNumber);
                cmd.Parameters.AddWithValue("@StartTime", attempt.StartTime);
                cmd.Parameters.AddWithValue("@IsCompleted", attempt.IsCompleted);
                cmd.Parameters.AddWithValue("@TabSwitchCount", attempt.TabSwitchCount);
                cmd.Parameters.AddWithValue("@WarningCount", attempt.WarningCount);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private QuizAttempt GetQuizAttemptById(int attemptId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM QuizAttempts WHERE AttemptID = @AttemptID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AttemptID", attemptId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    return new QuizAttempt
                    {
                        AttemptID = (int)reader["AttemptID"],
                        QuizID = (int)reader["QuizID"],
                        StudentID = (int)reader["StudentID"],
                        AttemptNumber = (int)reader["AttemptNumber"],
                        StartTime = (DateTime)reader["StartTime"],
                        EndTime = reader["EndTime"] as DateTime?,
                        AnswersJson = reader["AnswersJson"]?.ToString(),
                        Score = (decimal)(reader["Score"] as int? ?? 0),
                        TotalMarks = (decimal)(reader["TotalMarks"] as int? ?? 0),
                        Percentage = reader["Percentage"] as decimal? ?? 0,
                        IsCompleted = (bool)reader["IsCompleted"],
                        IsSubmitted = reader["IsSubmitted"] as bool? ?? false,
                        TimeSpent = reader["TimeSpent"] as int? ?? 0,
                        TabSwitchCount = reader["TabSwitchCount"] as int? ?? 0,
                        WarningCount = reader["WarningCount"] as int? ?? 0
                    };
                }
            }

            return null;
        }

        private (int Score, int TotalMarks, decimal Percentage) CalculateScore(Quiz quiz, string answersJson)
        {
            if (string.IsNullOrEmpty(answersJson))
                return (0, (int)quiz.TotalMarks, 0);

            try
            {
                var studentAnswers = JsonConvert.DeserializeObject<Dictionary<string, object>>(answersJson);
                List<QuizQuestion> questions = GetQuizQuestions(quiz.QuizID);

                int totalScore = 0;
                int totalMarks = 0;

                foreach (var question in questions)
                {
                    totalMarks += question.Points;

                    if (studentAnswers.ContainsKey(question.QuestionID.ToString()))
                    {
                        var studentAnswer = studentAnswers[question.QuestionID.ToString()];
                        
                        if (IsAnswerCorrect(question, studentAnswer))
                        {
                            totalScore += question.Points;
                        }
                    }
                }

                decimal percentage = totalMarks > 0 ? (decimal)totalScore / totalMarks * 100 : 0;
                return (totalScore, totalMarks, percentage);
            }
            catch (Exception ex)
            {
                LogActivity(null, "Score Calculation Error", $"Error calculating score: {ex.Message}");
                return (0, (int)quiz.TotalMarks, 0);
            }
        }

        private bool IsAnswerCorrect(QuizQuestion question, object studentAnswer)
        {
            try
            {
                string correctAnswer = question.CorrectAnswer?.Trim();
                string studentAnswerStr = studentAnswer?.ToString()?.Trim();

                if (string.IsNullOrEmpty(correctAnswer) || string.IsNullOrEmpty(studentAnswerStr))
                    return false;

                switch (question.QuestionType?.ToUpper())
                {
                    case "MCQ":
                    case "SINGLE_CHOICE":
                        return string.Equals(correctAnswer, studentAnswerStr, StringComparison.OrdinalIgnoreCase);

                    case "MULTIPLE_CHOICE":
                        try
                        {
                            var correctAnswers = JsonConvert.DeserializeObject<string[]>(correctAnswer);
                            var studentAnswers = JsonConvert.DeserializeObject<string[]>(studentAnswerStr);
                            
                            if (correctAnswers == null || studentAnswers == null)
                                return false;

                            return correctAnswers.Length == studentAnswers.Length &&
                                   correctAnswers.All(ca => studentAnswers.Contains(ca, StringComparer.OrdinalIgnoreCase));
                        }
                        catch
                        {
                            return false;
                        }

                    case "DRAG_DROP":
                        try
                        {
                            var correctObj = JsonConvert.DeserializeObject(correctAnswer);
                            var studentObj = JsonConvert.DeserializeObject(studentAnswerStr);
                            return JsonConvert.SerializeObject(correctObj) == JsonConvert.SerializeObject(studentObj);
                        }
                        catch
                        {
                            return false;
                        }

                    case "TEXT":
                    case "SHORT_ANSWER":
                        return string.Equals(correctAnswer, studentAnswerStr, StringComparison.OrdinalIgnoreCase);

                    case "DROPDOWN":
                        return string.Equals(correctAnswer, studentAnswerStr, StringComparison.OrdinalIgnoreCase);

                    default:
                        return string.Equals(correctAnswer, studentAnswerStr, StringComparison.OrdinalIgnoreCase);
                }
            }
            catch (Exception ex)
            {
                LogActivity(null, "Answer Validation Error", $"Error validating answer: {ex.Message}");
                return false;
            }
        }

        private void UpdateQuizAttempt(QuizAttempt attempt)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    UPDATE QuizAttempts SET
                        EndTime = @EndTime,
                        AnswersJson = @AnswersJson,
                        Score = @Score,
                        TotalMarks = @TotalMarks,
                        Percentage = @Percentage,
                        IsCompleted = @IsCompleted,
                        IsSubmitted = @IsSubmitted,
                        SubmissionDate = @SubmissionDate,
                        TimeSpent = @TimeSpent,
                        TabSwitchCount = @TabSwitchCount
                    WHERE AttemptID = @AttemptID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@EndTime", (object)attempt.EndTime ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@AnswersJson", (object)attempt.AnswersJson ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Score", (object)attempt.Score ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@TotalMarks", (object)attempt.TotalMarks ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Percentage", (object)attempt.Percentage ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@IsCompleted", attempt.IsCompleted);
                cmd.Parameters.AddWithValue("@IsSubmitted", attempt.IsSubmitted);
                cmd.Parameters.AddWithValue("@SubmissionDate", (object)attempt.SubmissionDate ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@TimeSpent", attempt.TimeSpent);
                cmd.Parameters.AddWithValue("@TabSwitchCount", attempt.TabSwitchCount);
                cmd.Parameters.AddWithValue("@AttemptID", attempt.AttemptID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void SaveQuizGrade(QuizAttempt attempt)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string checkQuery = @"
                    SELECT GradeID FROM Grades 
                    WHERE StudentID = @StudentID AND QuizID = @QuizID AND AttemptID = @AttemptID";

                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@StudentID", attempt.StudentID);
                checkCmd.Parameters.AddWithValue("@QuizID", attempt.QuizID);
                checkCmd.Parameters.AddWithValue("@AttemptID", attempt.AttemptID);

                conn.Open();
                object existingGrade = checkCmd.ExecuteScalar();

                if (existingGrade == null)
                {
                    string insertQuery = @"
                        INSERT INTO Grades (StudentID, QuizID, AttemptID, Grade, Percentage, GradeDate, CreatedBy)
                        VALUES (@StudentID, @QuizID, @AttemptID, @Grade, @Percentage, @GradeDate, @CreatedBy)";

                    SqlCommand insertCmd = new SqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@StudentID", attempt.StudentID);
                    insertCmd.Parameters.AddWithValue("@QuizID", attempt.QuizID);
                    insertCmd.Parameters.AddWithValue("@AttemptID", attempt.AttemptID);
                    insertCmd.Parameters.AddWithValue("@Grade", (int)(attempt.Score));
                    insertCmd.Parameters.AddWithValue("@Percentage", attempt.Percentage);
                    insertCmd.Parameters.AddWithValue("@GradeDate", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@CreatedBy", 1);

                    insertCmd.ExecuteNonQuery();
                }
            }
        }

        private void LogActivity(int? userId, string activity, string details)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ActivityLogs (UserID, Activity, Details, IPAddress, UserAgent, ActivityDate)
                        VALUES (@UserID, @Activity, @Details, @IPAddress, @UserAgent, @ActivityDate)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", (object)userId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    cmd.Parameters.AddWithValue("@Details", details);
                    cmd.Parameters.AddWithValue("@IPAddress", GetClientIP());
                    cmd.Parameters.AddWithValue("@UserAgent", GetUserAgent());
                    cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch { }
        }

        private string GetClientIP()
        {
            try
            {
                return HttpContext.Current?.Request?.UserHostAddress ?? "Unknown";
            }
            catch { return "Unknown"; }
        }

        private string GetUserAgent()
        {
            try
            {
                return HttpContext.Current?.Request?.UserAgent ?? "Unknown";
            }
            catch { return "Unknown"; }
        }
    }
}
