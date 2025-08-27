// App_Code/DAL/QuizDAL.cs
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.DAL
{
    public class QuizDAL : BaseDAL
    {
        public int CreateQuiz(Quiz quiz)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        INSERT INTO Quizzes (CourseID, Title, Description, TimeLimit, TotalMarks, IsActive, DateCreated)
                        VALUES (@CourseID, @Title, @Description, @TimeLimit, @TotalMarks, @IsActive, GETDATE());
                        SELECT SCOPE_IDENTITY();";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", quiz.CourseID);
                        cmd.Parameters.AddWithValue("@Title", quiz.QuizTitle ?? "");
                        cmd.Parameters.AddWithValue("@Description", quiz.Description ?? "");
                        cmd.Parameters.AddWithValue("@TimeLimit", quiz.DurationMinutes);
                        cmd.Parameters.AddWithValue("@TotalMarks", quiz.TotalMarks);
                        cmd.Parameters.AddWithValue("@IsActive", quiz.IsActive);

                        con.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error creating quiz: {ex.Message}");
                return 0;
            }
        }

        public DataTable ExecuteQuery(string query, SqlParameter[] parameters)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        con.Open();
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error executing query: {ex.Message}");
            }
            return dataTable;
        }

        public int ExecuteNonQuery(string query, SqlParameter[] parameters)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        con.Open();
                        return cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error executing non-query: {ex.Message}");
                return 0;
            }
        }

        public object ExecuteScalar(string query, SqlParameter[] parameters)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        con.Open();
                        return cmd.ExecuteScalar();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error executing scalar: {ex.Message}");
                return null;
            }
        }

        public List<Quiz> GetQuizzesByCourseId(int courseId)
        {
            List<Quiz> quizzes = new List<Quiz>();
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"SELECT QuizID, CourseID, Title, Description, TimeLimit, TotalMarks, IsActive, DateCreated
                                   FROM Quizzes 
                                   WHERE CourseID = @CourseID AND IsActive = 1
                                   ORDER BY DateCreated DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Quiz quiz = new Quiz
                                {
                                    QuizID = Convert.ToInt32(reader["QuizID"]),
                                    CourseID = Convert.ToInt32(reader["CourseID"]),
                                    QuizTitle = reader["Title"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    DurationMinutes = Convert.ToInt32(reader["TimeLimit"]),
                                    TotalMarks = Convert.ToDecimal(reader["TotalMarks"]),
                                    IsActive = Convert.ToBoolean(reader["IsActive"]),
                                    CreatedDate = Convert.ToDateTime(reader["DateCreated"])
                                };
                                quizzes.Add(quiz);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting quizzes by course: {ex.Message}");
            }
            return quizzes;
        }

        public Quiz GetQuizById(int quizId)
        {
            Quiz quiz = null;
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"SELECT QuizID, CourseID, Title, Description, TimeLimit, TotalMarks, IsActive, DateCreated
                                   FROM Quizzes 
                                   WHERE QuizID = @QuizID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@QuizID", quizId);
                        con.Open();
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                quiz = new Quiz
                                {
                                    QuizID = Convert.ToInt32(reader["QuizID"]),
                                    CourseID = Convert.ToInt32(reader["CourseID"]),
                                    QuizTitle = reader["Title"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    DurationMinutes = Convert.ToInt32(reader["TimeLimit"]),
                                    TotalMarks = Convert.ToDecimal(reader["TotalMarks"]),
                                    IsActive = Convert.ToBoolean(reader["IsActive"]),
                                    CreatedDate = Convert.ToDateTime(reader["DateCreated"])
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting quiz by ID: {ex.Message}");
            }
            return quiz;
        }

        public bool UpdateQuiz(Quiz quiz)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"UPDATE Quizzes SET 
                                   Title = @Title,
                                   Description = @Description,
                                   TimeLimit = @TimeLimit,
                                   TotalMarks = @TotalMarks,
                                   IsActive = @IsActive
                                   WHERE QuizID = @QuizID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Title", quiz.QuizTitle ?? "");
                        cmd.Parameters.AddWithValue("@Description", quiz.Description ?? "");
                        cmd.Parameters.AddWithValue("@TimeLimit", quiz.DurationMinutes);
                        cmd.Parameters.AddWithValue("@TotalMarks", quiz.TotalMarks);
                        cmd.Parameters.AddWithValue("@IsActive", quiz.IsActive);
                        cmd.Parameters.AddWithValue("@QuizID", quiz.QuizID);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating quiz: {ex.Message}");
                return false;
            }
        }

        public bool DeleteQuiz(int quizId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = "UPDATE Quizzes SET IsActive = 0 WHERE QuizID = @QuizID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@QuizID", quizId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting quiz: {ex.Message}");
                return false;
            }
        }
    }
}
