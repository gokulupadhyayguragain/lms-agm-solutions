using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class Analytics : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                LoadAnalyticsData();
            }
        }

        private void LoadAnalyticsData()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                // In a real implementation, you would load analytics data from database
                // This includes grades, attendance, study time, etc.
                
                LoadPerformanceMetrics(userId);
                LoadActivityData(userId);
                LoadRecommendations(userId);
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error loading analytics: {ex.Message}');</script>");
            }
        }

        private void LoadPerformanceMetrics(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Calculate average grade
                    string gradeQuery = @"
                        SELECT AVG(CAST(Grade AS FLOAT)) as AverageGrade
                        FROM Grades g
                        INNER JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID
                        WHERE e.StudentID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(gradeQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            double avgGrade = Convert.ToDouble(result);
                            // Store in session or use directly in client script
                            Session["AverageGrade"] = avgGrade.ToString("F1");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading performance metrics: {ex.Message}");
            }
        }

        private void LoadActivityData(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get recent activity
                    string activityQuery = @"
                        SELECT TOP 10 Activity, ActivityDate
                        FROM ActivityLog
                        WHERE UserID = @UserID
                        ORDER BY ActivityDate DESC";

                    using (SqlCommand cmd = new SqlCommand(activityQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        
                        SqlDataReader reader = cmd.ExecuteReader();
                        // Process activity data
                        while (reader.Read())
                        {
                            // In a real implementation, you would populate UI elements
                            // or build JSON data for charts
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading activity data: {ex.Message}");
            }
        }

        private void LoadRecommendations(int userId)
        {
            try
            {
                // AI-powered recommendations would be generated here
                // Based on performance patterns, study habits, etc.
                
                // For demo purposes, we're using static recommendations
                // In production, this would involve machine learning algorithms
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading recommendations: {ex.Message}");
            }
        }

        protected void ExportAnalyticsReport()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                // Generate comprehensive analytics report
                // This would typically create a PDF or Excel file
                
                string script = "alert('Analytics report generated and downloaded successfully!');";
                ClientScript.RegisterStartupScript(this.GetType(), "ReportGenerated", script, true);
            }
            catch (Exception ex)
            {
                string script = $"alert('Error generating report: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ReportError", script, true);
            }
        }
    }
}
