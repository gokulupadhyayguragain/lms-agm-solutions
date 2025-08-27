// App_Code/DAL/AssignmentDAL.cs
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;
using System.Data; // Added for DBNull.Value

namespace AGMSolutions.App_Code.DAL
{
    public class AssignmentDAL : BaseDAL
    {
        public bool AddAssignment(Assignment assignment)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"INSERT INTO Assignments (CourseID, LecturerID, Title, Description, DueDate, MaxMarks, UploadDate, IsActive)
                                     VALUES (@CourseID, @LecturerID, @Title, @Description, @DueDate, @MaxMarks, GETDATE(), @IsActive)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", assignment.CourseID);
                        cmd.Parameters.AddWithValue("@LecturerID", assignment.LecturerID);
                        cmd.Parameters.AddWithValue("@Title", assignment.Title);
                        cmd.Parameters.AddWithValue("@Description", (object)assignment.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DueDate", assignment.DueDate);
                        cmd.Parameters.AddWithValue("@MaxMarks", (object)assignment.MaxMarks ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", assignment.IsActive);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error adding assignment: {ex.Message}");
                return false;
            }
        }

        public bool UpdateAssignment(Assignment assignment)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"UPDATE Assignments SET CourseID = @CourseID, LecturerID = @LecturerID, Title = @Title,
                                     Description = @Description, DueDate = @DueDate, MaxMarks = @MaxMarks,
                                     IsActive = @IsActive WHERE AssignmentID = @AssignmentID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", assignment.CourseID);
                        cmd.Parameters.AddWithValue("@LecturerID", assignment.LecturerID);
                        cmd.Parameters.AddWithValue("@Title", assignment.Title);
                        cmd.Parameters.AddWithValue("@Description", (object)assignment.Description ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DueDate", assignment.DueDate);
                        cmd.Parameters.AddWithValue("@MaxMarks", (object)assignment.MaxMarks ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsActive", assignment.IsActive);
                        cmd.Parameters.AddWithValue("@AssignmentID", assignment.AssignmentID);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating assignment: {ex.Message}");
                return false;
            }
        }

        public bool DeleteAssignment(int assignmentId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "DELETE FROM Assignments WHERE AssignmentID = @AssignmentID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting assignment: {ex.Message}");
                return false;
            }
        }

        public Assignment GetAssignmentById(int assignmentId)
        {
            Assignment assignment = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT A.*, C.CourseName, C.CourseCode, U.FirstName, U.LastName 
                                 FROM Assignments A
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON A.LecturerID = U.UserID
                                 WHERE A.AssignmentID = @AssignmentID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            assignment = new Assignment
                            {
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                LecturerID = Convert.ToInt32(reader["LecturerID"]),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                DueDate = Convert.ToDateTime(reader["DueDate"]),
                                // Safely handle DBNull for MaxMarks
                                MaxMarks = reader["MaxMarks"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MaxMarks"]),
                                UploadDate = Convert.ToDateTime(reader["UploadDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                LecturerName = $"{reader["FirstName"]} {reader["LastName"]}"
                            };
                        }
                    }
                }
            }
            return assignment;
        }

        // Get all assignments for a specific course
        public List<Assignment> GetAssignmentsByCourseId(int courseId)
        {
            List<Assignment> assignments = new List<Assignment>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT A.*, C.CourseName, C.CourseCode, U.FirstName, U.LastName 
                                 FROM Assignments A
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON A.LecturerID = U.UserID
                                 WHERE A.CourseID = @CourseID
                                 ORDER BY A.DueDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            assignments.Add(new Assignment
                            {
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                LecturerID = Convert.ToInt32(reader["LecturerID"]),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                DueDate = Convert.ToDateTime(reader["DueDate"]),
                                // Safely handle DBNull for MaxMarks
                                MaxMarks = reader["MaxMarks"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MaxMarks"]),
                                UploadDate = Convert.ToDateTime(reader["UploadDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                LecturerName = $"{reader["FirstName"]} {reader["LastName"]}"
                            });
                        }
                    }
                }
            }
            return assignments;
        }

        // Get all assignments uploaded by a specific lecturer
        public List<Assignment> GetAssignmentsByLecturerId(int lecturerId)
        {
            List<Assignment> assignments = new List<Assignment>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT A.*, C.CourseName, C.CourseCode, U.FirstName, U.LastName 
                                 FROM Assignments A
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON A.LecturerID = U.UserID
                                 WHERE A.LecturerID = @LecturerID
                                 ORDER BY A.DueDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            assignments.Add(new Assignment
                            {
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                CourseID = Convert.ToInt32(reader["CourseID"]),
                                LecturerID = Convert.ToInt32(reader["LecturerID"]),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                DueDate = Convert.ToDateTime(reader["DueDate"]),
                                // Safely handle DBNull for MaxMarks
                                MaxMarks = reader["MaxMarks"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(reader["MaxMarks"]),
                                UploadDate = Convert.ToDateTime(reader["UploadDate"]),
                                IsActive = Convert.ToBoolean(reader["IsActive"]),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                LecturerName = $"{reader["FirstName"]} {reader["LastName"]}"
                            });
                        }
                    }
                }
            }
            return assignments;
        }
    }
}