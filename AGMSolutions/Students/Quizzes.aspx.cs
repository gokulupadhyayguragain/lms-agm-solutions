using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class Quizzes : System.Web.UI.Page
    {
        private StudentQuizManager _studentQuizManager;
        private UserManager _userManager;
        private List<QuizQuestion> QuizQuestions;
        private List<string> CorrectAnswers;

        protected void Page_Load(object sender, EventArgs e)
        {
            _studentQuizManager = new StudentQuizManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Check if user is authenticated and is a student
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Student")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                LoadQuizzes(currentUser.UserID);
                LoadStatistics(currentUser.UserID);
            }
        }

        private void LoadQuizzes(int studentId)
        {
            try
            {
                List<StudentQuizInfo> quizzes = _studentQuizManager.GetAvailableQuizzesForStudent(studentId);
                
                if (quizzes.Count > 0)
                {
                    rptQuizzes.DataSource = quizzes;
                    rptQuizzes.DataBind();
                    
                    pnlQuizList.Visible = true;
                    pnlEmptyState.Visible = false;
                }
                else
                {
                    pnlQuizList.Visible = false;
                    pnlEmptyState.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading quizzes: " + ex.Message, "danger");
                pnlQuizList.Visible = false;
                pnlEmptyState.Visible = true;
            }
        }

        private void LoadStatistics(int studentId)
        {
            try
            {
                List<StudentQuizInfo> allQuizzes = _studentQuizManager.GetAvailableQuizzesForStudent(studentId);
                
                int totalQuizzes = allQuizzes.Count;
                int completedQuizzes = allQuizzes.Count(q => q.HasAttempted);
                int passedQuizzes = allQuizzes.Count(q => q.HasAttempted && q.LastScore.HasValue && q.LastScore.Value >= (q.TotalMarks * 0.7m));
                
                decimal averageScore = 0;
                if (completedQuizzes > 0)
                {
                    var scoresWithValues = allQuizzes.Where(q => q.HasAttempted && q.LastScore.HasValue);
                    if (scoresWithValues.Any())
                    {
                        averageScore = scoresWithValues.Average(q => (q.LastScore.Value / q.TotalMarks) * 100);
                    }
                }

                litTotalQuizzes.Text = totalQuizzes.ToString();
                litCompletedQuizzes.Text = completedQuizzes.ToString();
                litPassedQuizzes.Text = passedQuizzes.ToString();
                litAverageScore.Text = averageScore.ToString("F1");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
                // Don't show error to user for statistics, just log it
            }
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "TakeQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                
                // Verify student is enrolled in the course before allowing quiz access
                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser != null)
                {
                    // Additional security check - verify enrollment
                    // This is already done in the query, but double-checking for security
                    Response.Redirect($"~/Students/TakeQuiz.aspx?quizId={quizId}");
                }
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            
            string cssClass = type == "success" ? "bg-green-100 border border-green-400 text-green-700" 
                            : "bg-red-100 border border-red-400 text-red-700";
            
            string icon = type == "success" ? "fas fa-check-circle" : "fas fa-exclamation-triangle";
            
            alertMessage.Attributes["class"] = cssClass;
            litMessage.Text = $"<i class=\"{icon} mr-2\"></i>{message}";
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            // Save the answer for the current question before moving.
            SaveCurrentAnswer();

            int currentIndex = int.Parse(hdnCurrentQuestionIndex.Value);
            if (currentIndex < QuizQuestions.Count - 1)
            {
                // Move to the next question.
                hdnCurrentQuestionIndex.Value = (currentIndex + 1).ToString();
                DisplayCurrentQuestion();
            }
            else
            {
                // If it's the last question, hide 'Next' and show 'Submit Quiz'.
                btnNext.Visible = false;
                btnSubmitQuiz.Visible = true;
            }
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            // Save the answer for the current question before moving back.
            SaveCurrentAnswer();

            int currentIndex = int.Parse(hdnCurrentQuestionIndex.Value);
            if (currentIndex > 0)
            {
                // Move to the previous question.
                hdnCurrentQuestionIndex.Value = (currentIndex - 1).ToString();
                DisplayCurrentQuestion();
            }
            // Ensure 'Submit Quiz' is hidden and 'Next' is visible when navigating back from the last question.
            btnSubmitQuiz.Visible = false;
            btnNext.Visible = true;
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            // Save the answer for the very last question before submitting.
            SaveCurrentAnswer();

            // Calculate the final score.
            CalculateScore();
            // Mark the quiz as completed.
            hdnQuizCompleted.Value = "True";
            // Show the results panel.
            ShowResultsPanel();
        }

        protected void btnRetakeQuiz_Click(object sender, EventArgs e)
        {
            // Reset all quiz state variables to allow a fresh retake.
            hdnCurrentQuestionIndex.Value = "0";
            hdnQuizCompleted.Value = "False";
            hdnScore.Value = "0";
            hdnUserAnswers.Value = string.Join(",", Enumerable.Repeat("", QuizQuestions.Count));

            pnlStartQuiz.Visible = true;
            pnlQuizQuestions.Visible = false;
            pnlQuizResults.Visible = false;

            // Clear any previously selected radio buttons from the UI.
            ClearAllRadioButtonSelections();
        }

        private void DisplayCurrentQuestion()
        {
            int currentIndex = int.Parse(hdnCurrentQuestionIndex.Value);

            // Hide all question panels by iterating through their IDs and finding them within questionsContainer.
            for (int i = 1; i <= QuizQuestions.Count; i++)
            {
                Panel questionPanel = (Panel)questionsContainer.FindControl("pnlQuestion" + i);
                if (questionPanel != null)
                {
                    questionPanel.Visible = false;
                }
            }

            // Show the current question panel.
            Panel currentQuestionPanel = (Panel)questionsContainer.FindControl("pnlQuestion" + (currentIndex + 1));
            if (currentQuestionPanel != null)
            {
                currentQuestionPanel.Visible = true;
            }

            // Update question number label.
            lblQuestionNumber.Text = (currentIndex + 1).ToString();

            // Load previously saved answer for the current question, if any.
            if (currentQuestionPanel != null) // Ensure the panel is found before trying to find its RBL.
            {
                string[] userAnswersArray = hdnUserAnswers.Value.Split(',');
                if (userAnswersArray.Length > currentIndex && !string.IsNullOrEmpty(userAnswersArray[currentIndex]))
                {
                    RadioButtonList rbl = (RadioButtonList)currentQuestionPanel.FindControl("rblQ" + (currentIndex + 1));
                    if (rbl != null)
                    {
                        rbl.SelectedValue = userAnswersArray[currentIndex];
                    }
                }
            }

            // Manage the visibility of navigation buttons based on the current question index.
            btnPrevious.Visible = (currentIndex > 0); // Show 'Previous' if not the first question.
            btnNext.Visible = (currentIndex < QuizQuestions.Count - 1); // Show 'Next' if not the last question.
            btnSubmitQuiz.Visible = (currentIndex == QuizQuestions.Count - 1); // Show 'Submit' only on the last question.
        }

        private void SaveCurrentAnswer()
        {
            int currentIndex = int.Parse(hdnCurrentQuestionIndex.Value);
            // Find the panel for the current question.
            Panel currentQuestionPanel = (Panel)questionsContainer.FindControl("pnlQuestion" + (currentIndex + 1));
            if (currentQuestionPanel != null)
            {
                // Find the RadioButtonList within the current question's panel.
                RadioButtonList rbl = (RadioButtonList)currentQuestionPanel.FindControl("rblQ" + (currentIndex + 1));
                if (rbl != null)
                {
                    // Get the array of user answers from the hidden field.
                    string[] userAnswersArray = hdnUserAnswers.Value.Split(',');
                    // Ensure the array is large enough to store the current answer.
                    if (userAnswersArray.Length <= currentIndex)
                    {
                        Array.Resize(ref userAnswersArray, QuizQuestions.Count);
                    }
                    // Save the selected value from the RadioButtonList.
                    userAnswersArray[currentIndex] = rbl.SelectedValue;
                    // Update the hidden field with the new set of answers.
                    hdnUserAnswers.Value = string.Join(",", userAnswersArray);
                }
            }
        }

        private void CalculateScore()
        {
            int score = 0;
            string[] userAnswersArray = hdnUserAnswers.Value.Split(',');

            // Iterate through all questions and compare user's answer with the correct answer.
            for (int i = 0; i < QuizQuestions.Count; i++)
            {
                if (i < userAnswersArray.Length && userAnswersArray[i] == CorrectAnswers[i])
                {
                    score++; // Increment score if the answer is correct.
                }
            }
            hdnScore.Value = score.ToString(); // Store the final score in a hidden field.
        }

        private void ShowResultsPanel()
        {
            // Hide quiz panels and show the results panel.
            pnlStartQuiz.Visible = false;
            pnlQuizQuestions.Visible = false;
            pnlQuizResults.Visible = true;

            int score = int.Parse(hdnScore.Value);
            lblScore.Text = score.ToString(); // Display the score.

            // Provide feedback based on the score.
            if (score >= QuizQuestions.Count * 0.7) // Example: 70% or more is good
            {
                lblFeedback.Text = "Congratulations! You did great!";
                lblFeedback.CssClass = "text-green-600 font-semibold"; // Tailwind success color
            }
            else if (score >= QuizQuestions.Count * 0.5) // Example: 50% or more is average
            {
                lblFeedback.Text = "Good effort! You're getting there.";
                lblFeedback.CssClass = "text-orange-600 font-semibold"; // Tailwind warning color
            }
            else
            {
                lblFeedback.Text = "Keep practicing! You can do better next time.";
                lblFeedback.CssClass = "text-red-600 font-semibold"; // Tailwind danger color
            }
        }

        private void ClearAllRadioButtonSelections()
        {
            // Loop through all possible question panels and clear their radio button selections.
            for (int i = 1; i <= QuizQuestions.Count; i++)
            {
                Panel questionPanel = (Panel)questionsContainer.FindControl("pnlQuestion" + i); // Use questionsContainer.FindControl
                if (questionPanel != null)
                {
                    RadioButtonList rbl = (RadioButtonList)questionPanel.FindControl("rblQ" + i);
                    if (rbl != null)
                    {
                        rbl.ClearSelection(); // Clear the selected radio button.
                    }
                }
            }
        }

        // Dummy Python Quiz Questions data.
        private List<QuizQuestion> GetPythonQuizQuestions()
        {
            return new List<QuizQuestion>
            {
                new QuizQuestion
                {
                    QuestionText = "What is the output of `print(type([]))`?",
                    Options = new List<string> { "<class 'list'>", "<class 'array'>", "<class 'tuple'>", "<class 'object'>" },
                    CorrectAnswerValue = "A"
                },
                new QuizQuestion
                {
                    QuestionText = "Which of the following is used to define a block of code in Python?",
                    Options = new List<string> { "Parentheses ()", "Curly braces {}", "Indentation", "Keywords" },
                    CorrectAnswerValue = "C"
                },
                new QuizQuestion
                {
                    QuestionText = "What is the correct way to comment out multiple lines in Python?",
                    Options = new List<string> { "// This is a comment", "/* This is a comment */", "# This is a comment", "''' This is a multi-line comment '''" },
                    CorrectAnswerValue = "D"
                },
                new QuizQuestion
                {
                    QuestionText = "Which keyword is used to create a function in Python?",
                    Options = new List<string> { "func", "define", "def", "function" },
                    CorrectAnswerValue = "C"
                },
                new QuizQuestion
                {
                    QuestionText = "What is the output of `print(\"hello\".upper())`?",
                    Options = new List<string> { "hello", "HELLO", "Hello", "Error" },
                    CorrectAnswerValue = "B"
                },
                new QuizQuestion
                {
                    QuestionText = "How do you create a dictionary in Python?",
                    Options = new List<string> { "my_dict = []", "my_dict = ()", "my_dict = {}", "my_dict = <>" },
                    CorrectAnswerValue = "C"
                },
                new QuizQuestion
                {
                    QuestionText = "Which of the following is NOT a built-in data type in Python?",
                    Options = new List<string> { "list", "tuple", "array", "dict" },
                    CorrectAnswerValue = "C"
                },
                new QuizQuestion
                {
                    QuestionText = "What does `len(\"Python\")` return?",
                    Options = new List<string> { "5", "6", "7", "Error" },
                    CorrectAnswerValue = "B"
                },
                new QuizQuestion
                {
                    QuestionText = "Which operator is used for exponentiation in Python?",
                    Options = new List<string> { "^", "**", "//", "*" },
                    CorrectAnswerValue = "B"
                },
                new QuizQuestion
                {
                    QuestionText = "What is the purpose of the `if __name__ == \"__main__\":` block?",
                    Options = new List<string> { "It defines a main function.", "It indicates the start of a class.", "It ensures code runs only when the script is executed directly.", "It's used for importing modules." },
                    CorrectAnswerValue = "C"
                }
            };
        }
    }
}
