using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class Search : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                // Check for search query in URL
                string query = Request.QueryString["q"];
                if (!string.IsNullOrEmpty(query))
                {
                    PerformSearch(query);
                }
            }
        }

        private void PerformSearch(string searchQuery)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                // Log search activity
                LogSearchActivity(userId, searchQuery);
                
                // In a real implementation, you would:
                // 1. Parse and clean the search query
                // 2. Search across multiple tables (courses, assignments, materials, etc.)
                // 3. Apply relevance scoring
                // 4. Return paginated results
                
                // For demo purposes, we'll just log the search
                string script = $"searchFor('{searchQuery.Replace("'", "\\'")}');";
                ClientScript.RegisterStartupScript(this.GetType(), "PerformSearch", script, true);
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Search error: {ex.Message}');</script>");
            }
        }

        private void LogSearchActivity(int userId, string searchQuery)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ActivityLog (UserID, Activity, ActivityDate)
                        VALUES (@UserID, @Activity, @ActivityDate)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Activity", $"Searched for: {searchQuery}");
                        cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error logging search activity: {ex.Message}");
            }
        }

        protected DataTable SearchContent(string searchQuery, string contentType = "", string courseFilter = "", string dateFilter = "")
        {
            DataTable results = new DataTable();
            
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Complex search query that searches across multiple tables
                    string query = @"
                        SELECT 
                            'Course' as ContentType,
                            c.CourseName as Title,
                            c.Description,
                            c.CourseName as SubInfo,
                            c.CreatedDate as DateInfo,
                            'course' as TagType
                        FROM Courses c
                        WHERE (@SearchQuery = '' OR c.CourseName LIKE '%' + @SearchQuery + '%' OR c.Description LIKE '%' + @SearchQuery + '%')
                            AND (@ContentType = '' OR @ContentType = 'course')
                        
                        UNION ALL
                        
                        SELECT 
                            'Assignment' as ContentType,
                            a.Title,
                            a.Description,
                            c.CourseName as SubInfo,
                            a.DueDate as DateInfo,
                            'assignment' as TagType
                        FROM Assignments a
                        INNER JOIN Courses c ON a.CourseID = c.CourseID
                        WHERE (@SearchQuery = '' OR a.Title LIKE '%' + @SearchQuery + '%' OR a.Description LIKE '%' + @SearchQuery + '%')
                            AND (@ContentType = '' OR @ContentType = 'assignment')
                        
                        UNION ALL
                        
                        SELECT 
                            'Quiz' as ContentType,
                            q.Title,
                            q.Description,
                            c.CourseName as SubInfo,
                            q.CreatedDate as DateInfo,
                            'quiz' as TagType
                        FROM Quizzes q
                        INNER JOIN Courses c ON q.CourseID = c.CourseID
                        WHERE (@SearchQuery = '' OR q.Title LIKE '%' + @SearchQuery + '%' OR q.Description LIKE '%' + @SearchQuery + '%')
                            AND (@ContentType = '' OR @ContentType = 'quiz')
                        
                        ORDER BY DateInfo DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SearchQuery", searchQuery ?? "");
                        cmd.Parameters.AddWithValue("@ContentType", contentType ?? "");
                        
                        conn.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.Fill(results);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error searching content: {ex.Message}");
            }
            
            return results;
        }
    }
}
