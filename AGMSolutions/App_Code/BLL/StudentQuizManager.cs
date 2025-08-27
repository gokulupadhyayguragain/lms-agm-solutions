using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.DAL;

namespace AGMSolutions.App_Code.BLL
{
    public class StudentQuizManager : BaseDAL
    {
        private QuizDAL _quizDAL;
        private EnrollmentDAL _enrollmentDAL;

        public StudentQuizManager()
        {
            _quizDAL = new QuizDAL();
            _enrollmentDAL = new EnrollmentDAL();
        }

        /// <summary>
        /// Gets all available quizzes for a student from their enrolled courses
        /// </summary>
        /// <param name="studentId">The student's UserID</param>
        /// <returns>List of available quizzes</returns>
        public List<StudentQuizInfo> GetAvailableQuizzesForStudent(int studentId)
        {
            List<StudentQuizInfo> quizzes = new List<StudentQuizInfo>();
            
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        SELECT DISTINCT 
                            q.QuizID,
                            q.CourseID, 
                            q.Title AS QuizTitle,
                            q.Description,
                            q.TimeLimit,
                            q.TotalMarks,
                            q.IsActive,
                            q.DateCreated,
                            c.CourseName,
                            c.CourseCode,
                            u.FirstName + ' ' + u.LastName AS LecturerName,
                            CASE 
                                WHEN qa.AttemptID IS NOT NULL THEN 1 
                                ELSE 0 
                            END AS HasAttempted,
                            qa.Score AS LastScore,
                            qa.AttemptDate AS LastAttemptDate
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        INNER JOIN Quizzes q ON c.CourseID = q.CourseID
                        LEFT JOIN Users u ON c.LecturerID = u.UserID
                        LEFT JOIN QuizAttempts qa ON q.QuizID = qa.QuizID AND qa.StudentID = @StudentID
                        WHERE e.StudentID = @StudentID 
                            AND e.IsActive = 1 
                            AND q.IsActive = 1
                        ORDER BY q.DateCreated DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        con.Open();
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                StudentQuizInfo quiz = new StudentQuizInfo
                                {
                                    QuizID = Convert.ToInt32(reader["QuizID"]),
                                    CourseID = Convert.ToInt32(reader["CourseID"]),
                                    QuizTitle = reader["QuizTitle"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    TimeLimit = Convert.ToInt32(reader["TimeLimit"]),
                                    TotalMarks = Convert.ToDecimal(reader["TotalMarks"]),
                                    CourseName = reader["CourseName"].ToString(),
                                    CourseCode = reader["CourseCode"].ToString(),
                                    LecturerName = reader["LecturerName"].ToString(),
                                    HasAttempted = Convert.ToBoolean(reader["HasAttempted"]),
                                    LastScore = reader["LastScore"] != DBNull.Value ? Convert.ToDecimal(reader["LastScore"]) : (decimal?)null,
                                    LastAttemptDate = reader["LastAttemptDate"] != DBNull.Value ? Convert.ToDateTime(reader["LastAttemptDate"]) : (DateTime?)null,
                                    DateCreated = Convert.ToDateTime(reader["DateCreated"])
                                };
                                quizzes.Add(quiz);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting student quizzes: {ex.Message}");
                throw;
            }
            
            return quizzes;
        }

        /// <summary>
        /// Gets enrollment information for a student
        /// </summary>
        /// <param name="studentId">The student's UserID</param>
        /// <returns>List of enrollments</returns>
        public List<Enrollment> GetStudentEnrollments(int studentId)
        {
            return _enrollmentDAL.GetEnrollmentsByStudentId(studentId);
        }

        /// <summary>
        /// Checks if a student is enrolled in a specific course
        /// </summary>
        /// <param name="studentId">The student's UserID</param>
        /// <param name="courseId">The course ID</param>
        /// <returns>True if enrolled, false otherwise</returns>
        public bool IsStudentEnrolledInCourse(int studentId, int courseId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"SELECT COUNT(*) FROM Enrollments 
                                   WHERE StudentID = @StudentID AND CourseID = @CourseID AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();
                        
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error checking enrollment: {ex.Message}");
                return false;
            }
        }
    }
}