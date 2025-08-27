using System;
using System.Collections.Generic;

namespace AGMSolutions.App_Code.Models
{
    public class Quiz
    {
        public int QuizID { get; set; }
        public string QuizTitle { get; set; }
        public string Title { get; set; } // Writable property for compatibility
        public string SubjectCode { get; set; }
        public int CourseID { get; set; }
        public string Description { get; set; }
        public int DurationMinutes { get; set; }
        public int TimeLimit { get; set; } // Alternative property name for DurationMinutes
        public int AttemptsAllowed { get; set; }
        public decimal TotalMarks { get; set; }
        public decimal PassingMarks { get; set; }
        public string QuizType { get; set; } // MCQ, MIXED, etc.
        public bool IsActive { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool IsProctored { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }

        // Additional properties for display and functionality
        public bool AllowFullScreen { get; set; }
        public bool AllowTabSwitching { get; set; }
        public int MaxTabSwitchWarnings { get; set; }
        public DateTime DateCreated { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string LecturerName { get; set; }

        // Navigation properties
        public Course Course { get; set; }
        public User Creator { get; set; }
        public List<Question> Questions { get; set; }
        public List<QuizQuestion> QuizQuestions { get; set; } // Alternative property for QuizQuestion type
        public List<QuizAttempt> StudentAttempts { get; set; }

        public Quiz()
        {
            Questions = new List<Question>();
            StudentAttempts = new List<QuizAttempt>();
            IsActive = true;
            DurationMinutes = 30;
            TimeLimit = 30;
            AttemptsAllowed = 1;
            QuizType = "MIXED";
            CreatedDate = DateTime.Now;
            DateCreated = DateTime.Now;
            AllowFullScreen = true;
            AllowTabSwitching = false;
            MaxTabSwitchWarnings = 3;
        }
    }

    public class Question
    {
        public int QuestionID { get; set; }
        public int QuizID { get; set; }
        public string QuestionText { get; set; }
        public string QuestionType { get; set; } // MCQ, DRAGDROP, DROPDOWN
        public string Options { get; set; } // JSON format
        public string CorrectAnswer { get; set; } // JSON for multiple answers
        public decimal Points { get; set; }
        public int QuestionOrder { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public Quiz Quiz { get; set; }
        
        public Question()
        {
            IsActive = true;
            Points = 1;
        }
    }

    public class QuizAttempt
    {
        public int AttemptID { get; set; }
        public int QuizID { get; set; }
        public int StudentID { get; set; }
        public int AttemptNumber { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public decimal TotalMarks { get; set; }
        public decimal ObtainedMarks { get; set; }
        public decimal Percentage { get; set; }
        public string Status { get; set; } // In Progress, Completed, Timed Out
        public bool IsSubmitted { get; set; }
        public decimal Score { get; set; } // Alternative property for ObtainedMarks
        public DateTime? SubmissionDate { get; set; } // When quiz was submitted
        public int TabSwitchCount { get; set; } // Count of tab switches during quiz
        public bool IsCompleted { get; set; } // Whether quiz is completed
        public int TimeSpent { get; set; } // Time spent in minutes
        public int WarningCount { get; set; } // Count of warnings given

        // Navigation properties for reporting
        public string StudentName { get; set; } // Student name for reports
        public string StudentEmail { get; set; } // Student email for reports
        public string QuizTitle { get; set; } // Quiz title for reports
        public string AnswersJson { get; set; } // JSON format of answers
        public int QuizTotalMarks { get; set; } // Total marks for the quiz

        // Navigation properties
        public Quiz Quiz { get; set; }
        public User Student { get; set; }
        public List<QuizAnswer> Answers { get; set; }

        public QuizAttempt()
        {
            Answers = new List<QuizAnswer>();
            AttemptNumber = 1;
            Status = "In Progress";
            IsSubmitted = false;
            IsCompleted = false;
            StartTime = DateTime.Now;
            TabSwitchCount = 0;
            Score = 0;
            TimeSpent = 0;
            WarningCount = 0;
        }
    }

    public class QuizAnswer
    {
        public int AnswerID { get; set; }
        public int AttemptID { get; set; }
        public int QuestionID { get; set; }
        public string StudentAnswer { get; set; }
        public bool IsCorrect { get; set; }
        public decimal MarksAwarded { get; set; }
        public DateTime AnsweredAt { get; set; }

        // Navigation properties
        public QuizAttempt Attempt { get; set; }
        public Question Question { get; set; }

        public QuizAnswer()
        {
            AnsweredAt = DateTime.Now;
        }
    }
}
