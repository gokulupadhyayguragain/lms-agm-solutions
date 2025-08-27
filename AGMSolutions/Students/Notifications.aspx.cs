using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class Notifications : System.Web.UI.Page
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

                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                // In a real implementation, you would load notifications from database
                // This would include assignment reminders, grade notifications, system alerts, etc.
                
                LogNotificationAccess(userId);
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error loading notifications: {ex.Message}');</script>");
            }
        }

        private void LogNotificationAccess(int userId)
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
                        cmd.Parameters.AddWithValue("@Activity", "Accessed notifications dashboard");
                        cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error logging notification access: {ex.Message}");
            }
        }

        protected void MarkNotificationAsRead(int notificationId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Notifications 
                        SET IsRead = 1, ReadDate = @ReadDate
                        WHERE NotificationID = @NotificationID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@NotificationID", notificationId);
                        cmd.Parameters.AddWithValue("@ReadDate", DateTime.Now);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error marking notification as read: {ex.Message}");
            }
        }

        protected void UpdateNotificationSettings(string settingName, bool isEnabled)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE UserNotificationSettings 
                        SET " + settingName + @" = @IsEnabled
                        WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@IsEnabled", isEnabled);
                        
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating notification settings: {ex.Message}");
            }
        }
    }
}
