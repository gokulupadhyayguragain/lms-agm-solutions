// App_Code/Models/Submission.cs
using System;

namespace AGMSolutions.App_Code.Models
{
    public class Submission
    {
        public int SubmissionID { get; set; }
        public int AssignmentID { get; set; }
        public int StudentID { get; set; }
        public DateTime SubmissionDate { get; set; }
        public string FilePath { get; set; } // Path to the uploaded file
        public string SubmissionText { get; set; }
        public decimal? Grade { get; set; } // Nullable decimal
        public string Feedback { get; set; }
        public bool IsGraded { get; set; }

        // Optional: To display related data in UI
        public string AssignmentTitle { get; set; }
        public string CourseName { get; set; }
        public string StudentName { get; set; }
        public decimal? AssignmentMaxMarks { get; set; }
        public DateTime AssignmentDueDate { get; set; }
    }
}