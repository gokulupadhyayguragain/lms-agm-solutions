// App_Code/Models/Assignment.cs
using System;

namespace AGMSolutions.App_Code.Models
{
    public class Assignment
    {
        public int AssignmentID { get; set; }
        public int CourseID { get; set; }
        public int LecturerID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DueDate { get; set; }
        public decimal? MaxMarks { get; set; } // Nullable decimal
        public DateTime UploadDate { get; set; }
        public bool IsActive { get; set; }

        // Optional: To display related data in UI
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string LecturerName { get; set; }
    }
}