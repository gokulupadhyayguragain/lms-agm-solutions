using System;
using System.Web.UI;
using System.Collections.Generic;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using Newtonsoft.Json;
using System.IO;

namespace AGMSolutions.Students
{
    public partial class TakeQuiz : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizData();
            }
        }

        private void LoadQuizData()
        {
            // Get quiz ID from query string
            int quizId;
            if (!int.TryParse(Request.QueryString["quizId"], out quizId))
            {
                Response.Redirect("Quizzes.aspx");
                return;
            }

            try
            {
                // Load quiz from database or JSON file
                string quizJson = LoadQuizFromDatabase(quizId);
                if (string.IsNullOrEmpty(quizJson))
                {
                    // Fallback to sample JSON for demonstration
                    quizJson = GetSampleQuizJson();
                }

                hdnQuizData.Value = quizJson;
            }
            catch (Exception ex)
            {
                // Log error and redirect
                System.Diagnostics.Debug.WriteLine($"Error loading quiz: {ex.Message}");
                Response.Redirect("Quizzes.aspx?error=loadfailed");
            }
        }

        private string LoadQuizFromDatabase(int quizId)
        {
            try
            {
                // This would typically load from your Quiz table
                // For now, returning sample JSON
                return GetSampleQuizJson();
            }
            catch
            {
                return null;
            }
        }

        private string GetSampleQuizJson()
        {
            var sampleQuiz = new
            {
                SubjectCode = "MATH001",
                QuizTitle = "Mathematics Basic Quiz",
                QuizDurationMinutes = 30,
                AttemptsAllowed = 2,
                OVERALLTYPE = "MIXED",
                Questions = new object[]
                {
                    new {
                        Q_ID = "Q1",
                        QuestionText = "What is 2 + 2?",
                        TYPE = "MCQ",
                        Options = new {
                            O1 = "3",
                            O2 = "4", 
                            O3 = "5",
                            O4 = "6"
                        },
                        CorrectAnswer = "O2",
                        Points = 5
                    },
                    new {
                        Q_ID = "Q2", 
                        QuestionText = "The result of 5 × 3 is _______.",
                        TYPE = "DRAGDROP",
                        Options = new {
                            O1 = "15",
                            O2 = "20",
                            O3 = "25", 
                            O4 = "30"
                        },
                        CorrectAnswer = "O1",
                        Points = 10
                    },
                    new {
                        Q_ID = "Q3",
                        QuestionText = "Select all prime numbers:",
                        TYPE = "DROPDOWN", 
                        Options = new {
                            O1 = "2",
                            O2 = "3",
                            O3 = "4",
                            O4 = "5"
                        },
                        CorrectAnswers = new[] { "O1", "O2", "O4" },
                        Points = 8
                    }
                }
            };

            return JsonConvert.SerializeObject(sampleQuiz);
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            try
            {
                // Get answers from hidden field
                string answersJson = hdnAnswers.Value;
                if (string.IsNullOrEmpty(answersJson))
                {
                    ShowMessage("No answers were recorded. Please try again.", "danger");
                    return;
                }

                // Parse answers
                var answers = JsonConvert.DeserializeObject<Dictionary<string, object>>(answersJson);
                
                // Calculate score
                int totalScore = CalculateScore(answers);
                
                // Save quiz attempt to database
                SaveQuizAttempt(totalScore, answers);
                
                // Redirect to results
                Response.Redirect($"QuizResults.aspx?score={totalScore}");
            }
            catch (Exception ex)
            {
                ShowMessage("Error submitting quiz: " + ex.Message, "danger");
            }
        }

        private int CalculateScore(Dictionary<string, object> answers)
        {
            try
            {
                // Parse quiz data to get correct answers
                var quizData = JsonConvert.DeserializeObject<dynamic>(hdnQuizData.Value);
                int totalScore = 0;

                foreach (var question in quizData.Questions)
                {
                    string questionId = question.Q_ID;
                    if (!answers.ContainsKey(questionId)) continue;

                    if (question.TYPE == "MCQ" || question.TYPE == "DRAGDROP")
                    {
                        string userAnswer = answers[questionId].ToString();
                        string correctAnswer = question.CorrectAnswer;
                        
                        if (userAnswer == correctAnswer)
                        {
                            totalScore += (int)question.Points;
                        }
                    }
                    else if (question.TYPE == "DROPDOWN")
                    {
                        var userAnswers = JsonConvert.DeserializeObject<List<string>>(answers[questionId].ToString());
                        var correctAnswers = JsonConvert.DeserializeObject<List<string>>(question.CorrectAnswers.ToString());
                        
                        // Check if all correct answers are selected and no incorrect ones
                        bool isCorrect = userAnswers.Count == correctAnswers.Count &&
                                       userAnswers.TrueForAll(ua => correctAnswers.Contains(ua));
                        
                        if (isCorrect)
                        {
                            totalScore += (int)question.Points;
                        }
                    }
                }

                return totalScore;
            }
            catch
            {
                return 0;
            }
        }

        private void SaveQuizAttempt(int score, Dictionary<string, object> answers)
        {
            try
            {
                // This would save to your QuizAttempts table
                // For now, just logging the attempt
                
                // You would typically:
                // 1. Get current user ID
                // 2. Get quiz ID
                // 3. Save to QuizAttempts table
                // 4. Save individual answers to QuizAnswers table
                
                // QuizManager quizManager = new QuizManager();
                // quizManager.SaveQuizAttempt(userId, quizId, score, answersJson);
            }
            catch (Exception ex)
            {
                // Log error
                throw new Exception("Failed to save quiz attempt: " + ex.Message);
            }
        }

        private void ShowMessage(string message, string type)
        {
            // This would show a message to the user
            // You could implement this using a label or alert
            ClientScript.RegisterStartupScript(GetType(), "alert", $"alert('{message}');", true);
        }
    }
}
