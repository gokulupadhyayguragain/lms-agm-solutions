// App_Code/Models/Course.cs
using System;

namespace AGMSolutions.App_Code.Models
{
    public class Course
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string Description { get; set; }
        public int? LecturerID { get; set; } // Nullable FK
        public DateTime CreationDate { get; set; }
        public bool IsActive { get; set; }

        // Optional: To display lecturer's name on course listing
        public string LecturerName { get; set; }
    }
}

