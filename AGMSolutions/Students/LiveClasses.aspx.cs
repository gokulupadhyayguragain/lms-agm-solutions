using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class LiveClasses : System.Web.UI.Page
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

                LoadLiveClasses();
            }
        }

        private void LoadLiveClasses()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                // In a real implementation, you would load live class data from database
                // For now, we'll use the static content in the ASPX page
                
                // Log the access
                LogClassAccess(userId, "Live Class - Computer Science 101");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error loading live classes: {ex.Message}');</script>");
            }
        }

        private void LogClassAccess(int userId, string className)
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
                        cmd.Parameters.AddWithValue("@Activity", $"Joined live class: {className}");
                        cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't interrupt the user experience
                System.Diagnostics.Debug.WriteLine($"Error logging activity: {ex.Message}");
            }
        }

        protected void SaveChatMessage(string message)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ChatMessages (UserID, Message, Timestamp, ClassSession)
                        VALUES (@UserID, @Message, @Timestamp, @ClassSession)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.Parameters.AddWithValue("@Timestamp", DateTime.Now);
                        cmd.Parameters.AddWithValue("@ClassSession", "CS101_Live_" + DateTime.Now.ToString("yyyyMMdd"));
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Error saving chat message: {ex.Message}");
            }
        }

        protected void RecordAttendance()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Attendance (UserID, CourseID, AttendanceDate, Status)
                        SELECT @UserID, c.CourseID, @AttendanceDate, 'Present'
                        FROM Courses c
                        WHERE c.CourseName = 'Computer Science 101'";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@AttendanceDate", DateTime.Now.Date);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error recording attendance: {ex.Message}");
            }
        }
    }
}
