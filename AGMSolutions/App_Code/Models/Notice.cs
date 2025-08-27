namespace AGMSolutions.App_Code.Models
{
    public class Notice
    {
        public int NoticeID { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime DateCreated { get; set; }
        public System.DateTime? ExpiryDate { get; set; }
        public string Priority { get; set; }
        public string TargetAudience { get; set; }
        public bool IsActive { get; set; }
        public int? CourseID { get; set; }
        public string CreatedByName { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
    }
}
