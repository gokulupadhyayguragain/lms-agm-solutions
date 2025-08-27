// App_Code/DAL/CourseDAL.cs
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.DAL
{
    public class CourseDAL : BaseDAL // Inherit from BaseDAL if you have one for GetConnection()
    {
        // Constructor (no _dataAccess needed here if using BaseDAL.GetConnection())
        public CourseDAL()
        {
            // No explicit DataAccess initialization if using BaseDAL.GetConnection()
        }

        // CRUD operations for Course
        public bool AddCourse(Course course)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"INSERT INTO Courses (CourseName, CourseCode, Description, LecturerID, IsActive)
                                     VALUES (@CourseName, @CourseCode, @Description, @LecturerID, @IsActive)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseName", course.CourseName);
                        cmd.Parameters.AddWithValue("@CourseCode", course.CourseCode);
                        cmd.Parameters.AddWithValue("@Description", (object)course.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@LecturerID", (object)course.LecturerID ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", course.IsActive);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627 || ex.Number == 2601) // Unique constraint violation
                {
                    throw new Exception("Course Code must be unique. A course with this code already exists.", ex);
                }
                System.Diagnostics.Debug.WriteLine($"SQL Error adding course: {ex.Message}");
                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error adding course: {ex.Message}");
                return false;
            }
        }

        public bool UpdateCourse(Course course)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"UPDATE Courses SET 
                                     CourseName = @CourseName, 
                                     CourseCode = @CourseCode, 
                                     Description = @Description, 
                                     LecturerID = @LecturerID, 
                                     IsActive = @IsActive
                                     WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", course.CourseID);
                        cmd.Parameters.AddWithValue("@CourseName", course.CourseName);
                        cmd.Parameters.AddWithValue("@CourseCode", course.CourseCode);
                        cmd.Parameters.AddWithValue("@Description", (object)course.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@LecturerID", (object)course.LecturerID ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", course.IsActive);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627 || ex.Number == 2601) // Unique constraint violation
                {
                    throw new Exception("Course Code must be unique. A course with this code already exists.", ex);
                }
                System.Diagnostics.Debug.WriteLine($"SQL Error updating course: {ex.Message}");
                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating course: {ex.Message}");
                return false;
            }
        }

        public bool DeleteCourse(int courseId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "DELETE FROM Courses WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting course: {ex.Message}");
                return false;
            }
        }

        public List<Course> GetAllCourses()
        {
            List<Course> courses = new List<Course>();
            using (SqlConnection con = GetConnection())
            {
                // Join with Users to get LecturerName
                string query = @"SELECT C.*, U.FirstName, U.LastName
                                 FROM Courses C
                                 LEFT JOIN Users U ON C.LecturerID = U.UserID
                                 ORDER BY C.CourseName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new Course
                            {
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(), // Check for DBNull
                                LecturerID = reader["LecturerID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["LecturerID"]), // Check for DBNull
                                CreationDate = Convert.ToDateTime(reader["CreationDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                // Check for DBNull for FirstName/LastName as well for robustness if U.UserID is NULL
                                LecturerName = reader["FirstName"] == DBNull.Value || reader["LastName"] == DBNull.Value
                                                ? "Unassigned"
                                                : $"{reader["FirstName"]} {reader["LastName"]}"
                            });
                        }
                    }
                }
            }
            return courses;
        }

        public Course GetCourseById(int courseId)
        {
            Course course = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT C.*, U.FirstName, U.LastName
                                 FROM Courses C
                                 LEFT JOIN Users U ON C.LecturerID = U.UserID
                                 WHERE C.CourseID = @CourseID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            course = new Course
                            {
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(),
                                LecturerID = reader["LecturerID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["LecturerID"]),
                                CreationDate = Convert.ToDateTime(reader["CreationDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                LecturerName = reader["FirstName"] == DBNull.Value || reader["LastName"] == DBNull.Value
                                                ? "Unassigned"
                                                : $"{reader["FirstName"]} {reader["LastName"]}"
                            };
                        }
                    }
                }
            }
            return course;
        }

        public List<Course> GetCoursesByLecturerId(int lecturerId)
        {
            List<Course> courses = new List<Course>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT C.*, U.FirstName, U.LastName
                                 FROM Courses C
                                 LEFT JOIN Users U ON C.LecturerID = U.UserID
                                 WHERE C.LecturerID = @LecturerID AND C.IsActive = 1
                                 ORDER BY C.CourseName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new Course
                            {
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(),
                                LecturerID = reader["LecturerID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["LecturerID"]),
                                CreationDate = Convert.ToDateTime(reader["CreationDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                LecturerName = reader["FirstName"] == DBNull.Value || reader["LastName"] == DBNull.Value
                                                ? "Unassigned"
                                                : $"{reader["FirstName"]} {reader["LastName"]}"
                            });
                        }
                    }
                }
            }
            return courses;
        }

        // --- CORRECTED/ADDED METHOD FOR STUDENT COURSES (Uses SqlDataReader) ---
        public List<Course> GetCoursesByStudentId(int studentId)
        {
            List<Course> courses = new List<Course>();
            using (SqlConnection con = GetConnection()) // Use GetConnection from BaseDAL
            {
                string sql = @"
                    SELECT c.CourseID, c.CourseName, c.CourseCode, c.Description, c.LecturerID, c.CreationDate, c.IsActive,
                           u_lecturer.FirstName AS LecturerFirstName, u_lecturer.LastName AS LecturerLastName
                    FROM Courses c
                    INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                    LEFT JOIN Users u_lecturer ON c.LecturerID = u_lecturer.UserID
                    WHERE e.StudentID = @StudentID AND e.IsActive = 1
                    ORDER BY c.CourseName";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Course course = new Course
                            {
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Description = reader["Description"] == DBNull.Value ? null : reader["Description"].ToString(),
                                LecturerID = reader["LecturerID"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["LecturerID"]),
                                CreationDate = Convert.ToDateTime(reader["CreationDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                LecturerName = reader["LecturerFirstName"] == DBNull.Value || reader["LecturerLastName"] == DBNull.Value
                                                ? "Unassigned"
                                                : $"{reader["LecturerFirstName"]} {reader["LecturerLastName"]}"
                            };
                            courses.Add(course);
                        }
                    }
                }
            }
            return courses;
        }
        // ----------------------------------------------------------------------
    }
}


