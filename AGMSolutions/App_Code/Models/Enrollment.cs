// App_Code/Models/Enrollment.cs
using System;

namespace AGMSolutions.App_Code.Models
{
    public class Enrollment
    {
        public int EnrollmentID { get; set; }
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public DateTime EnrollmentDate { get; set; }
        public bool IsActive { get; set; }

        // Optional: To display related data in UI
        public string StudentName { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string LecturerName { get; set; }
    }
}
