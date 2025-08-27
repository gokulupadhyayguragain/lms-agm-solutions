using System;

namespace AGMSolutions.App_Code.Models
{
    /// <summary>
    /// Model for displaying quiz information to students
    /// </summary>
    public class StudentQuizInfo
    {
        public int QuizID { get; set; }
        public int CourseID { get; set; }
        public string QuizTitle { get; set; }
        public string Description { get; set; }
        public int TimeLimit { get; set; }
        public decimal TotalMarks { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string LecturerName { get; set; }
        public bool HasAttempted { get; set; }
        public decimal? LastScore { get; set; }
        public DateTime? LastAttemptDate { get; set; }
        public DateTime DateCreated { get; set; }

        // Computed properties for display
        public string Status
        {
            get
            {
                if (HasAttempted)
                {
                    return LastScore.HasValue ? $"Completed (Score: {LastScore.Value:F1})" : "Attempted";
                }
                return "Available";
            }
        }

        public string StatusBadgeClass
        {
            get
            {
                if (HasAttempted)
                {
                    if (LastScore.HasValue && LastScore.Value >= TotalMarks * 0.7m) // Assuming 70% is passing
                        return "badge bg-success";
                    else if (LastScore.HasValue)
                        return "badge bg-warning";
                    else
                        return "badge bg-info";
                }
                return "badge bg-primary";
            }
        }

        public string FormattedDuration
        {
            get
            {
                if (TimeLimit >= 60)
                {
                    int hours = TimeLimit / 60;
                    int minutes = TimeLimit % 60;
                    return minutes > 0 ? $"{hours}h {minutes}m" : $"{hours}h";
                }
                return $"{TimeLimit}m";
            }
        }
    }
}
