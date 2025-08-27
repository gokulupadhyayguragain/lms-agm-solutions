using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.IO;
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL
{
    public class AssignmentManager
    {
        private string connectionString;
        private AssignmentDAL _assignmentDAL;
        private CourseManager _courseManager;
        private UserManager _userManager;

        public AssignmentManager()
        {
            connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            _assignmentDAL = new AssignmentDAL();
            _courseManager = new CourseManager();
            _userManager = new UserManager();
        }

        public bool AddAssignment(Assignment assignment)
        {
            if (assignment == null || string.IsNullOrWhiteSpace(assignment.Title))
            {
                throw new ArgumentException("Assignment title is required.");
            }

            if (assignment.CourseID <= 0)
            {
                throw new ArgumentException("Valid Course ID is required.");
            }

            if (assignment.LecturerID <= 0)
            {
                throw new ArgumentException("Valid Lecturer ID is required.");
            }

            assignment.UploadDate = DateTime.Now;
            assignment.IsActive = true;

            return _assignmentDAL.AddAssignment(assignment);
        }

        public bool UpdateAssignment(Assignment assignment)
        {
            if (assignment == null || string.IsNullOrWhiteSpace(assignment.Title) || assignment.AssignmentID <= 0)
            {
                throw new ArgumentException("Assignment ID and title are required for update.");
            }

            return _assignmentDAL.UpdateAssignment(assignment);
        }

        public bool DeleteAssignment(int assignmentId)
        {
            if (assignmentId <= 0)
            {
                throw new ArgumentException("Invalid Assignment ID.");
            }

            return _assignmentDAL.DeleteAssignment(assignmentId);
        }

        public Assignment GetAssignmentById(int assignmentId)
        {
            if (assignmentId <= 0)
            {
                throw new ArgumentException("Invalid Assignment ID.");
            }

            return _assignmentDAL.GetAssignmentById(assignmentId);
        }

        public List<Assignment> GetAssignmentsByCourseId(int courseId)
        {
            if (courseId <= 0)
            {
                throw new ArgumentException("Invalid Course ID.");
            }

            return _assignmentDAL.GetAssignmentsByCourseId(courseId);
        }

        public List<Assignment> GetAssignmentsByLecturerId(int lecturerId)
        {
            if (lecturerId <= 0)
            {
                throw new ArgumentException("Invalid Lecturer ID.");
            }

            return _assignmentDAL.GetAssignmentsByLecturerId(lecturerId);
        }

        // Get all assignments for a student
        public List<Assignment> GetStudentAssignments(int studentId)
        {
            if (studentId <= 0)
            {
                throw new ArgumentException("Invalid Student ID.");
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT DISTINCT a.AssignmentID, a.CourseID, a.LecturerID, a.Title, 
                               a.Description, a.DueDate, a.MaxMarks, a.UploadDate, a.IsActive,
                               c.CourseName, c.CourseCode
                        FROM Assignments a
                        INNER JOIN Courses c ON a.CourseID = c.CourseID
                        INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                        WHERE e.StudentID = @StudentID AND e.IsActive = 1 AND a.IsActive = 1
                        ORDER BY a.DueDate";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    List<Assignment> assignments = new List<Assignment>();
                    while (reader.Read())
                    {
                        Assignment assignment = new Assignment
                        {
                            AssignmentID = (int)reader["AssignmentID"],
                            CourseID = (int)reader["CourseID"],
                            LecturerID = (int)reader["LecturerID"],
                            Title = reader["Title"].ToString(),
                            Description = reader["Description"]?.ToString(),
                            DueDate = (DateTime)reader["DueDate"],
                            MaxMarks = reader["MaxMarks"] as decimal?,
                            UploadDate = (DateTime)reader["UploadDate"],
                            IsActive = (bool)reader["IsActive"],
                            CourseName = reader["CourseName"].ToString(),
                            CourseCode = reader["CourseCode"].ToString()
                        };
                        assignments.Add(assignment);
                    }

                    return assignments;
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving student assignments: {ex.Message}");
            }
        }

        // Check if assignment belongs to lecturer
        public bool IsAssignmentOwnedByLecturer(int assignmentId, int lecturerId)
        {
            Assignment assignment = GetAssignmentById(assignmentId);
            return assignment != null && assignment.LecturerID == lecturerId;
        }

        // Get assignments with submission count
        public List<Assignment> GetAssignmentsWithSubmissionCount(int lecturerId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT a.AssignmentID, a.CourseID, a.LecturerID, a.Title, 
                               a.Description, a.DueDate, a.MaxMarks, a.UploadDate, a.IsActive,
                               c.CourseName, c.CourseCode,
                               COUNT(s.SubmissionID) as SubmissionCount
                        FROM Assignments a
                        INNER JOIN Courses c ON a.CourseID = c.CourseID
                        LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID
                        WHERE a.LecturerID = @LecturerID AND a.IsActive = 1
                        GROUP BY a.AssignmentID, a.CourseID, a.LecturerID, a.Title, 
                                 a.Description, a.DueDate, a.MaxMarks, a.UploadDate, a.IsActive,
                                 c.CourseName, c.CourseCode
                        ORDER BY a.DueDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    List<Assignment> assignments = new List<Assignment>();
                    while (reader.Read())
                    {
                        Assignment assignment = new Assignment
                        {
                            AssignmentID = (int)reader["AssignmentID"],
                            CourseID = (int)reader["CourseID"],
                            LecturerID = (int)reader["LecturerID"],
                            Title = reader["Title"].ToString(),
                            Description = reader["Description"]?.ToString(),
                            DueDate = (DateTime)reader["DueDate"],
                            MaxMarks = reader["MaxMarks"] as decimal?,
                            UploadDate = (DateTime)reader["UploadDate"],
                            IsActive = (bool)reader["IsActive"],
                            CourseName = reader["CourseName"].ToString(),
                            CourseCode = reader["CourseCode"].ToString()
                        };
                        assignments.Add(assignment);
                    }

                    return assignments;
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error retrieving assignments with submission count: {ex.Message}");
            }
        }
    }
}
