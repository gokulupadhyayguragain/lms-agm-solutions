using System;

namespace AGMSolutions.App_Code.Models
{
    public class Subject
    {
        public int SubjectID { get; set; }
        public string SubjectCode { get; set; }
        public string SubjectName { get; set; }
        public string Description { get; set; }
        public int Credits { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? CreatedBy { get; set; }

        // Navigation properties
        public User Creator { get; set; }

        public Subject()
        {
            IsActive = true;
            Credits = 3;
            CreatedDate = DateTime.Now;
        }
    }

    public class UserType
    {
        public int UserTypeID { get; set; }
        public string RoleName { get; set; }
        public string Description { get; set; }
        public DateTime CreatedDate { get; set; }

        public UserType()
        {
            CreatedDate = DateTime.Now;
        }
    }

    public class Attendance
    {
        public int AttendanceID { get; set; }
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public DateTime AttendanceDate { get; set; }
        public string Status { get; set; } // Present, Absent, Late
        public string Remarks { get; set; }
        public int MarkedBy { get; set; }
        public DateTime MarkedDate { get; set; }

        // Navigation properties
        public User Student { get; set; }
        public Course Course { get; set; }
        public User Marker { get; set; }

        public Attendance()
        {
            Status = "Present";
            MarkedDate = DateTime.Now;
            AttendanceDate = DateTime.Today;
        }
    }

    public class Grade
    {
        public int GradeID { get; set; }
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public string AssessmentType { get; set; } // Quiz, Assignment, Exam, Final
        public string AssessmentName { get; set; }
        public decimal MaxMarks { get; set; }
        public decimal ObtainedMarks { get; set; }
        public decimal Percentage { get; set; }
        public string Grade_ { get; set; } // Grade property (Grade is reserved keyword)
        public DateTime GradeDate { get; set; }
        public int GradedBy { get; set; }

        // Navigation properties
        public User Student { get; set; }
        public Course Course { get; set; }
        public User Grader { get; set; }

        public Grade()
        {
            GradeDate = DateTime.Now;
        }
    }

    public class Event
    {
        public int EventID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime EventDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string EventType { get; set; } // Quiz, Assignment, Class, Exam
        public int? CourseID { get; set; }
        public int CreatedBy { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        // Navigation properties
        public Course Course { get; set; }
        public User Creator { get; set; }

        public Event()
        {
            IsActive = true;
            CreatedDate = DateTime.Now;
        }
    }

    public class Message
    {
        public int MessageID { get; set; }
        public int FromUserID { get; set; }
        public int ToUserID { get; set; }
        public string MessageText { get; set; }
        public string ImagePath { get; set; }
        public bool IsRead { get; set; }
        public DateTime SentDate { get; set; }
        public int? GroupID { get; set; }

        // Navigation properties
        public User FromUser { get; set; }
        public User ToUser { get; set; }
        public Group Group { get; set; }

        public Message()
        {
            IsRead = false;
            SentDate = DateTime.Now;
        }
    }

    public class Group
    {
        public int GroupID { get; set; }
        public string GroupName { get; set; }
        public string Description { get; set; }
        public int CourseID { get; set; }
        public int CreatedBy { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }

        // Navigation properties
        public Course Course { get; set; }
        public User Creator { get; set; }

        public Group()
        {
            IsActive = true;
            CreatedDate = DateTime.Now;
        }
    }

    public class GroupMember
    {
        public int GroupMemberID { get; set; }
        public int GroupID { get; set; }
        public int StudentID { get; set; }
        public DateTime JoinedDate { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public Group Group { get; set; }
        public User Student { get; set; }

        public GroupMember()
        {
            IsActive = true;
            JoinedDate = DateTime.Now;
        }
    }

    public class Certificate
    {
        public int CertificateID { get; set; }
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public string CertificateNumber { get; set; }
        public DateTime IssuedDate { get; set; }
        public string CertificatePath { get; set; }

        // Navigation properties
        public User Student { get; set; }
        public Course Course { get; set; }

        public Certificate()
        {
            IssuedDate = DateTime.Now;
            CertificateNumber = Guid.NewGuid().ToString("N").Substring(0, 12).ToUpper();
        }
    }

    public class LecturerSubject
    {
        public int LecturerSubjectID { get; set; }
        public int LecturerID { get; set; }
        public int SubjectID { get; set; }
        public DateTime AssignedDate { get; set; }
        public bool IsActive { get; set; }

        // Navigation properties
        public User Lecturer { get; set; }
        public Subject Subject { get; set; }

        public LecturerSubject()
        {
            IsActive = true;
            AssignedDate = DateTime.Now;
        }
    }
}
