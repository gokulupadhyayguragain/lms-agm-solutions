// App_Code/DAL/EnrollmentDAL.cs
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.DAL
{
    public class EnrollmentDAL : BaseDAL
    {
        public bool EnrollStudentInCourse(Enrollment enrollment)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, IsActive)
                                     VALUES (@StudentID, @CourseID, @EnrollmentDate, @IsActive)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", enrollment.StudentID);
                        cmd.Parameters.AddWithValue("@CourseID", enrollment.CourseID);
                        cmd.Parameters.AddWithValue("@EnrollmentDate", enrollment.EnrollmentDate);
                        cmd.Parameters.AddWithValue("@IsActive", enrollment.IsActive);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException ex)
            {
                // Unique constraint violation (Student already enrolled in this course)
                if (ex.Number == 2627 || ex.Number == 2601)
                {
                    throw new Exception("Student is already enrolled in this course.", ex);
                }
                System.Diagnostics.Debug.WriteLine($"SQL Error enrolling student: {ex.Message}");
                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error enrolling student: {ex.Message}");
                return false;
            }
        }

        public bool UnenrollStudentFromCourse(int enrollmentId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "DELETE FROM Enrollments WHERE EnrollmentID = @EnrollmentID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error unenrolling student: {ex.Message}");
                return false;
            }
        }

        // This method can be used to "soft delete" an enrollment or mark as inactive
        public bool UpdateEnrollmentStatus(int enrollmentId, bool isActive)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "UPDATE Enrollments SET IsActive = @IsActive WHERE EnrollmentID = @EnrollmentID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@IsActive", isActive);
                        cmd.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating enrollment status: {ex.Message}");
                return false;
            }
        }

        public Enrollment GetEnrollmentById(int enrollmentId)
        {
            Enrollment enrollment = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT E.*, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName,
                                 C.CourseName, C.CourseCode,
                                 L.FirstName AS LecturerFirstName, L.LastName AS LecturerLastName
                                 FROM Enrollments E
                                 JOIN Users U ON E.StudentID = U.UserID
                                 JOIN Courses C ON E.CourseID = C.CourseID
                                 LEFT JOIN Users L ON C.LecturerID = L.UserID
                                 WHERE E.EnrollmentID = @EnrollmentID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            enrollment = new Enrollment
                            {
                                EnrollmentID = Convert.ToInt32(reader["EnrollmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                EnrollmentDate = Convert.ToDateTime(reader["EnrollmentDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}",
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                LecturerName = $"{reader["LecturerFirstName"]} {reader["LecturerLastName"]}"
                            };
                        }
                    }
                }
            }
            return enrollment;
        }

        // Get enrollments for a specific student
        public List<Enrollment> GetEnrollmentsByStudentId(int studentId)
        {
            List<Enrollment> enrollments = new List<Enrollment>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT E.*, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName,
                                 C.CourseName, C.CourseCode,
                                 L.FirstName AS LecturerFirstName, L.LastName AS LecturerLastName
                                 FROM Enrollments E
                                 JOIN Users U ON E.StudentID = U.UserID
                                 JOIN Courses C ON E.CourseID = C.CourseID
                                 LEFT JOIN Users L ON C.LecturerID = L.UserID
                                 WHERE E.StudentID = @StudentID ORDER BY C.CourseName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            enrollments.Add(new Enrollment
                            {
                                EnrollmentID = Convert.ToInt32(reader["EnrollmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                EnrollmentDate = Convert.ToDateTime(reader["EnrollmentDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}",
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                LecturerName = $"{reader["LecturerFirstName"]} {reader["LecturerLastName"]}"
                            });
                        }
                    }
                }
            }
            return enrollments;
        }

        // Check if a student is already enrolled in a specific course
        public bool IsStudentEnrolled(int studentId, int courseId)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = @StudentID AND CourseID = @CourseID AND IsActive = 1";
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
    }
}



