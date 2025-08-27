namespace AGMSolutions.App_Code.Models
{
    public class DiscussionForum
    {
        public int ForumID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime DateCreated { get; set; }
        public int? CourseID { get; set; }
        public bool IsActive { get; set; }
        public string ForumType { get; set; }
        public string CreatedByName { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public int PostCount { get; set; }
    }
}
