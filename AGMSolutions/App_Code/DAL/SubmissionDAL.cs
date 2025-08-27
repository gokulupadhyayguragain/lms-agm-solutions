// App_Code/DAL/SubmissionDAL.cs
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.DAL
{
    public class SubmissionDAL : BaseDAL
    {
        public bool AddSubmission(Submission submission)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"INSERT INTO Submissions (AssignmentID, StudentID, SubmissionDate, FilePath, SubmissionText, IsGraded)
                                     VALUES (@AssignmentID, @StudentID, GETDATE(), @FilePath, @SubmissionText, @IsGraded)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@AssignmentID", submission.AssignmentID);
                        cmd.Parameters.AddWithValue("@StudentID", submission.StudentID);
                        cmd.Parameters.AddWithValue("@FilePath", (object)submission.FilePath ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@SubmissionText", (object)submission.SubmissionText ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsGraded", submission.IsGraded);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException ex)
            {
                // Unique constraint violation (Student already submitted for this assignment)
                if (ex.Number == 2627 || ex.Number == 2601)
                {
                    throw new Exception("You have already submitted for this assignment.", ex);
                }
                System.Diagnostics.Debug.WriteLine($"SQL Error adding submission: {ex.Message}");
                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error adding submission: {ex.Message}");
                return false;
            }
        }

        public bool UpdateSubmission(Submission submission)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    // This method could be used for re-submission (updating FilePath/SubmissionText) or for grading.
                    string query = @"UPDATE Submissions SET FilePath = @FilePath, SubmissionText = @SubmissionText,
                                     Grade = @Grade, Feedback = @Feedback, IsGraded = @IsGraded
                                     WHERE SubmissionID = @SubmissionID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FilePath", (object)submission.FilePath ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@SubmissionText", (object)submission.SubmissionText ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Grade", (object)submission.Grade ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Feedback", (object)submission.Feedback ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsGraded", submission.IsGraded);
                        cmd.Parameters.AddWithValue("@SubmissionID", submission.SubmissionID);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating submission: {ex.Message}");
                return false;
            }
        }

        public bool DeleteSubmission(int submissionId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "DELETE FROM Submissions WHERE SubmissionID = @SubmissionID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting submission: {ex.Message}");
                return false;
            }
        }

        public Submission GetSubmissionById(int submissionId)
        {
            Submission submission = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT S.*, A.Title AS AssignmentTitle, A.MaxMarks AS AssignmentMaxMarks, A.DueDate AS AssignmentDueDate,
                                 C.CourseName, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName
                                 FROM Submissions S
                                 JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON S.StudentID = U.UserID
                                 WHERE S.SubmissionID = @SubmissionID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            submission = new Submission
                            {
                                SubmissionID = Convert.ToInt32(reader["SubmissionID"]),
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                SubmissionDate = Convert.ToDateTime(reader["SubmissionDate"]),
                                FilePath = reader["FilePath"].ToString(),
                                SubmissionText = reader["SubmissionText"].ToString(),
                                Grade = Convert.ToDecimal(reader["Grade"]),
                                Feedback = reader["Feedback"].ToString(),
                                IsGraded = Convert.ToBoolean(reader["IsGraded"]),
                                AssignmentTitle = reader["AssignmentTitle"].ToString(),
                                AssignmentMaxMarks = Convert.ToDecimal(reader["AssignmentMaxMarks"]),
                                AssignmentDueDate = Convert.ToDateTime(reader["AssignmentDueDate"]),
                                CourseName = reader["CourseName"].ToString(),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}"
                            };
                        }
                    }
                }
            }
            return submission;
        }

        // Get submissions for a specific assignment
        public List<Submission> GetSubmissionsByAssignmentId(int assignmentId)
        {
            List<Submission> submissions = new List<Submission>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT S.*, A.Title AS AssignmentTitle, A.MaxMarks AS AssignmentMaxMarks, A.DueDate AS AssignmentDueDate,
                                 C.CourseName, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName
                                 FROM Submissions S
                                 JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON S.StudentID = U.UserID
                                 WHERE S.AssignmentID = @AssignmentID
                                 ORDER BY S.SubmissionDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            submissions.Add(new Submission
                            {
                                SubmissionID = Convert.ToInt32(reader["SubmissionID"]),
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                SubmissionDate = Convert.ToDateTime(reader["SubmissionDate"]),
                                FilePath = reader["FilePath"].ToString(),
                                SubmissionText = reader["SubmissionText"].ToString(),
                                Grade = Convert.ToDecimal(reader["Grade"]),
                                Feedback = reader["Feedback"].ToString(),
                                IsGraded = Convert.ToBoolean(reader["IsGraded"]),
                                AssignmentTitle = reader["AssignmentTitle"].ToString(),
                                AssignmentMaxMarks = Convert.ToDecimal(reader["AssignmentMaxMarks"]),
                                AssignmentDueDate = Convert.ToDateTime(reader["AssignmentDueDate"]),
                                CourseName = reader["CourseName"].ToString(),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}"
                            });
                        }
                    }
                }
            }
            return submissions;
        }

        // Get submissions by a specific student
        public List<Submission> GetSubmissionsByStudentId(int studentId)
        {
            List<Submission> submissions = new List<Submission>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT S.*, A.Title AS AssignmentTitle, A.MaxMarks AS AssignmentMaxMarks, A.DueDate AS AssignmentDueDate,
                                 C.CourseName, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName
                                 FROM Submissions S
                                 JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON S.StudentID = U.UserID
                                 WHERE S.StudentID = @StudentID
                                 ORDER BY S.SubmissionDate DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            submissions.Add(new Submission
                            {
                                SubmissionID = Convert.ToInt32(reader["SubmissionID"]),
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                SubmissionDate = Convert.ToDateTime(reader["SubmissionDate"]),
                                FilePath = reader["FilePath"].ToString(),
                                SubmissionText = reader["SubmissionText"].ToString(),
                                Grade = Convert.ToDecimal(reader["Grade"]),
                                Feedback = reader["Feedback"].ToString(),
                                IsGraded = Convert.ToBoolean(reader["IsGraded"]),
                                AssignmentTitle = reader["AssignmentTitle"].ToString(),
                                AssignmentMaxMarks = Convert.ToDecimal(reader["AssignmentMaxMarks"]),
                                AssignmentDueDate = Convert.ToDateTime(reader["AssignmentDueDate"]),
                                CourseName = reader["CourseName"].ToString(),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}"
                            });
                        }
                    }
                }
            }
            return submissions;
        }

        // Get a specific submission by student and assignment
        public Submission GetSubmissionByStudentAndAssignment(int studentId, int assignmentId)
        {
            Submission submission = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT S.*, A.Title AS AssignmentTitle, A.MaxMarks AS AssignmentMaxMarks, A.DueDate AS AssignmentDueDate,
                                 C.CourseName, U.FirstName AS StudentFirstName, U.LastName AS StudentLastName
                                 FROM Submissions S
                                 JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                                 JOIN Courses C ON A.CourseID = C.CourseID
                                 JOIN Users U ON S.StudentID = U.UserID
                                 WHERE S.StudentID = @StudentID AND S.AssignmentID = @AssignmentID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            submission = new Submission
                            {
                                SubmissionID = Convert.ToInt32(reader["SubmissionID"]),
                                AssignmentID = Convert.ToInt32(reader["AssignmentID"]),
                                StudentID = Convert.ToInt32(reader["StudentID"]),
                                SubmissionDate = Convert.ToDateTime(reader["SubmissionDate"]),
                                FilePath = reader["FilePath"].ToString(),
                                SubmissionText =  reader["SubmissionText"].ToString(),
                                Grade = Convert.ToDecimal(reader["Grade"]),
                                Feedback = reader["Feedback"].ToString(),
                                IsGraded = Convert.ToBoolean(reader["IsGraded"]),
                                AssignmentTitle = reader["AssignmentTitle"].ToString(),
                                AssignmentMaxMarks = Convert.ToDecimal(reader["AssignmentMaxMarks"]),
                                AssignmentDueDate = Convert.ToDateTime(reader["AssignmentDueDate"]),
                                CourseName = reader["CourseName"].ToString(),
                                StudentName = $"{reader["StudentFirstName"]} {reader["StudentLastName"]}"
                            };
                        }
                    }
                }
            }
            return submission;
        }
    }
}

