using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace AGMSolutions.Students
{
    public partial class Collaboration : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCollaborationData();
                LogCollaborationAccess();
            }
        }

        private void LoadCollaborationData()
        {
            try
            {
                // Load recent collaboration sessions, active participants, etc.
                // This would typically connect to your database
                LoadActiveParticipants();
                LoadRecentSessions();
                LoadSharedDocuments();
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Error loading collaboration data: {ex.Message}");
            }
        }

        private void LoadActiveParticipants()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT TOP 10 
                            u.UserID,
                            u.FirstName,
                            u.LastName,
                            u.Email,
                            u.Role,
                            CASE 
                                WHEN DATEDIFF(minute, u.LastLoginDate, GETDATE()) <= 5 THEN 'online'
                                WHEN DATEDIFF(minute, u.LastLoginDate, GETDATE()) <= 30 THEN 'away'
                                ELSE 'offline'
                            END as Status
                        FROM Users u
                        WHERE u.UserID != @CurrentUserID
                        ORDER BY u.LastLoginDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserID", Session["UserID"]);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            // Process participant data
                            // In a real implementation, you might bind this to a repeater or similar control
                            while (reader.Read())
                            {
                                // Process each participant
                                string fullName = $"{reader["FirstName"]} {reader["LastName"]}";
                                string status = reader["Status"].ToString();
                                string role = reader["Role"].ToString();
                                
                                // You could dynamically generate participant HTML here
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading participants: {ex.Message}");
            }
        }

        private void LoadRecentSessions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT TOP 5
                            cs.SessionID,
                            cs.SessionName,
                            cs.StartTime,
                            cs.EndTime,
                            cs.ParticipantCount,
                            cs.SessionType
                        FROM CollaborationSessions cs
                        WHERE cs.CreatedBy = @UserID OR cs.SessionID IN (
                            SELECT csp.SessionID 
                            FROM CollaborationSessionParticipants csp 
                            WHERE csp.UserID = @UserID
                        )
                        ORDER BY cs.StartTime DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            // Process session data
                            while (reader.Read())
                            {
                                // Process each session
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading sessions: {ex.Message}");
            }
        }

        private void LoadSharedDocuments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT TOP 10
                            sd.DocumentID,
                            sd.DocumentName,
                            sd.DocumentType,
                            sd.LastModified,
                            sd.SharedBy,
                            u.FirstName + ' ' + u.LastName as SharedByName
                        FROM SharedDocuments sd
                        INNER JOIN Users u ON sd.SharedBy = u.UserID
                        WHERE sd.IsActive = 1
                        ORDER BY sd.LastModified DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            // Process document data
                            while (reader.Read())
                            {
                                // Process each document
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading documents: {ex.Message}");
            }
        }

        private void LogCollaborationAccess()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO ActivityLog (UserID, ActivityType, ActivityDescription, ActivityDate, IPAddress)
                        VALUES (@UserID, 'Collaboration', 'Accessed Collaboration Hub', GETDATE(), @IPAddress)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error logging collaboration access: {ex.Message}");
            }
        }

        // Web method for AJAX calls (you would need to add [WebMethod] attribute)
        public static string SaveWhiteboardData(string canvasData, string sessionId)
        {
            try
            {
                // Save whiteboard data to database
                // In a real implementation, you would:
                // 1. Decode the base64 canvas data
                // 2. Save it to file system or database
                // 3. Broadcast to other participants via SignalR or similar
                
                return "success";
            }
            catch (Exception ex)
            {
                return $"error: {ex.Message}";
            }
        }

        public static string SendChatMessage(string message, string sessionId, int userId)
        {
            try
            {
                // Save chat message and broadcast to participants
                // Implementation would use SignalR for real-time messaging
                
                return "success";
            }
            catch (Exception ex)
            {
                return $"error: {ex.Message}";
            }
        }

        public static string CreateCollaborationSession(string sessionName, string sessionType)
        {
            try
            {
                // Create new collaboration session
                // Return session ID for participants to join
                
                string sessionId = Guid.NewGuid().ToString();
                return sessionId;
            }
            catch (Exception ex)
            {
                return $"error: {ex.Message}";
            }
        }

        public static string JoinCollaborationSession(string sessionId, int userId)
        {
            try
            {
                // Add user to collaboration session
                // Initialize their view with current session state
                
                return "success";
            }
            catch (Exception ex)
            {
                return $"error: {ex.Message}";
            }
        }

        public static string SaveDocumentChanges(string documentId, string content, int userId)
        {
            try
            {
                // Save document changes and broadcast to other editors
                // This would typically use operational transformation for conflict resolution
                
                return "success";
            }
            catch (Exception ex)
            {
                return $"error: {ex.Message}";
            }
        }

        protected void CreateSession_Click(object sender, EventArgs e)
        {
            // Handle session creation from server-side
            try
            {
                string sessionId = Guid.NewGuid().ToString();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO CollaborationSessions 
                        (SessionID, SessionName, SessionType, CreatedBy, StartTime, IsActive)
                        VALUES (@SessionID, @SessionName, @SessionType, @CreatedBy, GETDATE(), 1)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SessionID", sessionId);
                        cmd.Parameters.AddWithValue("@SessionName", "New Collaboration Session");
                        cmd.Parameters.AddWithValue("@SessionType", "General");
                        cmd.Parameters.AddWithValue("@CreatedBy", Session["UserID"]);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Redirect to the new session or update the current page
                Response.Redirect($"Collaboration.aspx?session={sessionId}");
            }
            catch (Exception ex)
            {
                // Handle error
                System.Diagnostics.Debug.WriteLine($"Error creating session: {ex.Message}");
            }
        }
    }
}
