using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.DAL;
namespace AGMSolutions.App_Code.BLL
{
    public class CommunicationManager
    {
        private string connectionString;

        public CommunicationManager()
        {
            connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        // Send chat message
        public int SendChatMessage(ChatMessage message)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ChatMessages (SenderID, ReceiverID, GroupID, Message, 
                                                MessageType, IsRead, SentDate)
                        VALUES (@SenderID, @ReceiverID, @GroupID, @Message, 
                                @MessageType, @IsRead, @SentDate);
                        SELECT SCOPE_IDENTITY();";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SenderID", message.SenderID);
                    cmd.Parameters.AddWithValue("@ReceiverID", (object)message.ReceiverID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@GroupID", (object)message.GroupID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Message", message.Message);
                    cmd.Parameters.AddWithValue("@MessageType", message.MessageType ?? "TEXT");
                    cmd.Parameters.AddWithValue("@IsRead", false);
                    cmd.Parameters.AddWithValue("@SentDate", DateTime.Now);

                    conn.Open();
                    int messageId = Convert.ToInt32(cmd.ExecuteScalar());

                    LogActivity(message.SenderID, "Message Sent", 
                        $"Sent message to {(message.ReceiverID.HasValue ? "User ID: " + message.ReceiverID : "Group ID: " + message.GroupID)}");

                    return messageId;
                }
            }
            catch (Exception ex)
            {
                LogActivity(message.SenderID, "Send Message Error", $"Error sending message: {ex.Message}");
                throw new Exception("Error sending message. Please try again.");
            }
        }

        // Get chat messages between two users
        public List<ChatMessage> GetChatMessages(int userID1, int userID2, int page = 1, int pageSize = 50)
        {
            List<ChatMessage> messages = new List<ChatMessage>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT cm.*, 
                               s.FirstName + ' ' + s.LastName AS SenderName,
                               r.FirstName + ' ' + r.LastName AS ReceiverName
                        FROM ChatMessages cm
                        INNER JOIN Users s ON cm.SenderID = s.UserID
                        LEFT JOIN Users r ON cm.ReceiverID = r.UserID
                        WHERE ((cm.SenderID = @UserID1 AND cm.ReceiverID = @UserID2) 
                               OR (cm.SenderID = @UserID2 AND cm.ReceiverID = @UserID1))
                        ORDER BY cm.SentDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID1", userID1);
                    cmd.Parameters.AddWithValue("@UserID2", userID2);
                    cmd.Parameters.AddWithValue("@Offset", (page - 1) * pageSize);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        ChatMessage message = new ChatMessage
                        {
                            MessageID = (int)reader["MessageID"],
                            SenderID = (int)reader["SenderID"],
                            ReceiverID = reader["ReceiverID"] as int?,
                            GroupID = reader["GroupID"] as int?,
                            Message = reader["Message"].ToString(),
                            MessageType = reader["MessageType"]?.ToString(),
                            IsRead = (bool)reader["IsRead"],
                            SentDate = (DateTime)reader["SentDate"],
                            SenderName = reader["SenderName"].ToString(),
                            ReceiverName = reader["ReceiverName"]?.ToString()
                        };

                        messages.Add(message);
                    }
                }

                // Reverse to show oldest first
                messages.Reverse();
            }
            catch (Exception ex)
            {
                LogActivity(userID1, "Get Chat Messages Error", $"Error getting chat messages: {ex.Message}");
                throw new Exception("Error retrieving messages. Please try again.");
            }

            return messages;
        }

        // Get group chat messages
        public List<ChatMessage> GetGroupChatMessages(int groupId, int page = 1, int pageSize = 50)
        {
            List<ChatMessage> messages = new List<ChatMessage>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT cm.*, 
                               s.FirstName + ' ' + s.LastName AS SenderName
                        FROM ChatMessages cm
                        INNER JOIN Users s ON cm.SenderID = s.UserID
                        WHERE cm.GroupID = @GroupID
                        ORDER BY cm.SentDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@GroupID", groupId);
                    cmd.Parameters.AddWithValue("@Offset", (page - 1) * pageSize);
                    cmd.Parameters.AddWithValue("@PageSize", pageSize);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        ChatMessage message = new ChatMessage
                        {
                            MessageID = (int)reader["MessageID"],
                            SenderID = (int)reader["SenderID"],
                            ReceiverID = reader["ReceiverID"] as int?,
                            GroupID = reader["GroupID"] as int?,
                            Message = reader["Message"].ToString(),
                            MessageType = reader["MessageType"]?.ToString(),
                            IsRead = (bool)reader["IsRead"],
                            SentDate = (DateTime)reader["SentDate"],
                            SenderName = reader["SenderName"].ToString()
                        };

                        messages.Add(message);
                    }
                }

                // Reverse to show oldest first
                messages.Reverse();
            }
            catch (Exception ex)
            {
                LogActivity(null, "Get Group Messages Error", $"Error getting group messages: {ex.Message}");
                throw new Exception("Error retrieving group messages. Please try again.");
            }

            return messages;
        }

        // Mark messages as read
        public void MarkMessagesAsRead(int receiverID, int senderID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE ChatMessages 
                        SET IsRead = 1 
                        WHERE ReceiverID = @ReceiverID AND SenderID = @SenderID AND IsRead = 0";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ReceiverID", receiverID);
                    cmd.Parameters.AddWithValue("@SenderID", senderID);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                LogActivity(receiverID, "Mark Messages Read Error", $"Error marking messages as read: {ex.Message}");
            }
        }

        // Get unread message count
        public int GetUnreadMessageCount(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT COUNT(*) 
                        FROM ChatMessages 
                        WHERE ReceiverID = @UserID AND IsRead = 0";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    conn.Open();
                    return (int)cmd.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                LogActivity(userID, "Get Unread Count Error", $"Error getting unread count: {ex.Message}");
                return 0;
            }
        }

        // Create notice
        public int CreateNotice(Notice notice)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Notices (Title, Content, CreatedBy, DateCreated, ExpiryDate, 
                                           Priority, TargetAudience, IsActive, CourseID)
                        VALUES (@Title, @Content, @CreatedBy, @DateCreated, @ExpiryDate, 
                                @Priority, @TargetAudience, @IsActive, @CourseID);
                        SELECT SCOPE_IDENTITY();";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Title", notice.Title);
                    cmd.Parameters.AddWithValue("@Content", notice.Content);
                    cmd.Parameters.AddWithValue("@CreatedBy", notice.CreatedBy);
                    cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                    cmd.Parameters.AddWithValue("@ExpiryDate", (object)notice.ExpiryDate ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Priority", notice.Priority ?? "NORMAL");
                    cmd.Parameters.AddWithValue("@TargetAudience", notice.TargetAudience ?? "ALL");
                    cmd.Parameters.AddWithValue("@IsActive", notice.IsActive);
                    cmd.Parameters.AddWithValue("@CourseID", (object)notice.CourseID ?? DBNull.Value);

                    conn.Open();
                    int noticeId = Convert.ToInt32(cmd.ExecuteScalar());

                    LogActivity(notice.CreatedBy, "Notice Created", 
                        $"Created notice: {notice.Title} for audience: {notice.TargetAudience}");

                    return noticeId;
                }
            }
            catch (Exception ex)
            {
                LogActivity(notice.CreatedBy, "Notice Creation Error", $"Error creating notice: {ex.Message}");
                throw new Exception("Error creating notice. Please try again.");
            }
        }

        // Get notices for user
        public List<Notice> GetNoticesForUser(int userID, string userRole, int? courseID = null)
        {
            List<Notice> notices = new List<Notice>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT n.*, 
                               u.FirstName + ' ' + u.LastName AS CreatedByName,
                               c.CourseName, c.CourseCode
                        FROM Notices n
                        INNER JOIN Users u ON n.CreatedBy = u.UserID
                        LEFT JOIN Courses c ON n.CourseID = c.CourseID
                        WHERE n.IsActive = 1 
                        AND (n.ExpiryDate IS NULL OR n.ExpiryDate >= @CurrentDate)
                        AND (n.TargetAudience = 'ALL' OR n.TargetAudience = @UserRole)";

                    // For students, only show notices for their enrolled courses or general notices
                    if (userRole == "Student")
                    {
                        query += @" AND (n.CourseID IS NULL OR n.CourseID IN 
                                        (SELECT CourseID FROM Enrollments 
                                         WHERE StudentID = @UserID AND IsActive = 1))";
                    }
                    // For lecturers, show notices for their courses or general notices
                    else if (userRole == "Lecturer")
                    {
                        query += @" AND (n.CourseID IS NULL OR n.CourseID IN 
                                        (SELECT CourseID FROM Courses 
                                         WHERE LecturerID = @UserID))";
                    }

                    if (courseID.HasValue)
                    {
                        query += " AND (n.CourseID = @CourseID OR n.CourseID IS NULL)";
                    }

                    query += " ORDER BY n.Priority DESC, n.DateCreated DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@UserRole", userRole.ToUpper());
                    cmd.Parameters.AddWithValue("@CurrentDate", DateTime.Now);
                    if (courseID.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseID.Value);
                    }

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        Notice notice = new Notice
                        {
                            NoticeID = (int)reader["NoticeID"],
                            Title = reader["Title"].ToString(),
                            Content = reader["Content"].ToString(),
                            CreatedBy = (int)reader["CreatedBy"],
                            DateCreated = (DateTime)reader["DateCreated"],
                            ExpiryDate = reader["ExpiryDate"] as DateTime?,
                            Priority = reader["Priority"]?.ToString(),
                            TargetAudience = reader["TargetAudience"]?.ToString(),
                            IsActive = (bool)reader["IsActive"],
                            CourseID = reader["CourseID"] as int?,
                            CreatedByName = reader["CreatedByName"].ToString(),
                            CourseName = reader["CourseName"]?.ToString(),
                            CourseCode = reader["CourseCode"]?.ToString()
                        };

                        notices.Add(notice);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(userID, "Get Notices Error", $"Error getting notices: {ex.Message}");
                throw new Exception("Error retrieving notices. Please try again.");
            }

            return notices;
        }

        // Update notice
        public void UpdateNotice(Notice notice)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Notices SET
                            Title = @Title,
                            Content = @Content,
                            ExpiryDate = @ExpiryDate,
                            Priority = @Priority,
                            TargetAudience = @TargetAudience,
                            CourseID = @CourseID
                        WHERE NoticeID = @NoticeID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Title", notice.Title);
                    cmd.Parameters.AddWithValue("@Content", notice.Content);
                    cmd.Parameters.AddWithValue("@ExpiryDate", (object)notice.ExpiryDate ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Priority", notice.Priority ?? "NORMAL");
                    cmd.Parameters.AddWithValue("@TargetAudience", notice.TargetAudience ?? "ALL");
                    cmd.Parameters.AddWithValue("@CourseID", (object)notice.CourseID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@NoticeID", notice.NoticeID);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    LogActivity(notice.CreatedBy, "Notice Updated", 
                        $"Updated notice: {notice.Title} (ID: {notice.NoticeID})");
                }
            }
            catch (Exception ex)
            {
                LogActivity(notice.CreatedBy, "Notice Update Error", $"Error updating notice: {ex.Message}");
                throw new Exception("Error updating notice. Please try again.");
            }
        }

        // Delete notice (soft delete)
        public void DeleteNotice(int noticeID, int deletedBy)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Notices SET IsActive = 0 WHERE NoticeID = @NoticeID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@NoticeID", noticeID);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    LogActivity(deletedBy, "Notice Deleted", $"Deleted notice ID: {noticeID}");
                }
            }
            catch (Exception ex)
            {
                LogActivity(deletedBy, "Notice Deletion Error", $"Error deleting notice: {ex.Message}");
                throw new Exception("Error deleting notice. Please try again.");
            }
        }

        // Get chat contacts for a user
        public List<ChatContact> GetChatContacts(int userID, string userRole)
        {
            List<ChatContact> contacts = new List<ChatContact>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "";

                    if (userRole == "Student")
                    {
                        // Students can chat with lecturers of their enrolled courses and admins
                        query = @"
                            SELECT DISTINCT u.UserID, u.FirstName + ' ' + u.LastName AS Name, 
                                   u.Email, ut.RoleName,
                                   (SELECT COUNT(*) FROM ChatMessages 
                                    WHERE SenderID = u.UserID AND ReceiverID = @UserID AND IsRead = 0) AS UnreadCount,
                                   (SELECT TOP 1 Message FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessage,
                                   (SELECT TOP 1 SentDate FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessageDate
                            FROM Users u
                            INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                            WHERE (u.UserTypeID IN (SELECT UserTypeID FROM UserTypes WHERE RoleName IN ('Lecturer', 'Admin'))
                                   OR u.UserID IN (SELECT c.LecturerID FROM Courses c 
                                                   INNER JOIN Enrollments e ON c.CourseID = e.CourseID 
                                                   WHERE e.StudentID = @UserID AND e.IsActive = 1))
                            AND u.UserID != @UserID AND u.IsActive = 1";
                    }
                    else if (userRole == "Lecturer")
                    {
                        // Lecturers can chat with students in their courses and admins
                        query = @"
                            SELECT DISTINCT u.UserID, u.FirstName + ' ' + u.LastName AS Name, 
                                   u.Email, ut.RoleName,
                                   (SELECT COUNT(*) FROM ChatMessages 
                                    WHERE SenderID = u.UserID AND ReceiverID = @UserID AND IsRead = 0) AS UnreadCount,
                                   (SELECT TOP 1 Message FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessage,
                                   (SELECT TOP 1 SentDate FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessageDate
                            FROM Users u
                            INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                            WHERE (u.UserTypeID IN (SELECT UserTypeID FROM UserTypes WHERE RoleName IN ('Student', 'Admin'))
                                   OR u.UserID IN (SELECT e.StudentID FROM Enrollments e 
                                                   INNER JOIN Courses c ON e.CourseID = c.CourseID 
                                                   WHERE c.LecturerID = @UserID AND e.IsActive = 1))
                            AND u.UserID != @UserID AND u.IsActive = 1";
                    }
                    else // Admin
                    {
                        // Admins can chat with everyone
                        query = @"
                            SELECT DISTINCT u.UserID, u.FirstName + ' ' + u.LastName AS Name, 
                                   u.Email, ut.RoleName,
                                   (SELECT COUNT(*) FROM ChatMessages 
                                    WHERE SenderID = u.UserID AND ReceiverID = @UserID AND IsRead = 0) AS UnreadCount,
                                   (SELECT TOP 1 Message FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessage,
                                   (SELECT TOP 1 SentDate FROM ChatMessages 
                                    WHERE (SenderID = u.UserID AND ReceiverID = @UserID) 
                                       OR (SenderID = @UserID AND ReceiverID = u.UserID)
                                    ORDER BY SentDate DESC) AS LastMessageDate
                            FROM Users u
                            INNER JOIN UserTypes ut ON u.UserTypeID = ut.UserTypeID
                            WHERE u.UserID != @UserID AND u.IsActive = 1";
                    }

                    query += " ORDER BY LastMessageDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        ChatContact contact = new ChatContact
                        {
                            UserID = (int)reader["UserID"],
                            Name = reader["Name"].ToString(),
                            Email = reader["Email"].ToString(),
                            Role = reader["RoleName"].ToString(),
                            UnreadCount = reader["UnreadCount"] as int? ?? 0,
                            LastMessage = reader["LastMessage"]?.ToString(),
                            LastMessageDate = reader["LastMessageDate"] as DateTime?
                        };

                        contacts.Add(contact);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(userID, "Get Chat Contacts Error", $"Error getting chat contacts: {ex.Message}");
                throw new Exception("Error retrieving chat contacts. Please try again.");
            }

            return contacts;
        }

        // Create discussion forum
        public int CreateDiscussionForum(DiscussionForum forum)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO DiscussionForums (Title, Description, CourseID, CreatedBy, 
                                                     DateCreated, IsActive, ForumType)
                        VALUES (@Title, @Description, @CourseID, @CreatedBy, 
                                @DateCreated, @IsActive, @ForumType);
                        SELECT SCOPE_IDENTITY();";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Title", forum.Title);
                    cmd.Parameters.AddWithValue("@Description", forum.Description ?? "");
                    cmd.Parameters.AddWithValue("@CourseID", (object)forum.CourseID ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CreatedBy", forum.CreatedBy);
                    cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                    cmd.Parameters.AddWithValue("@IsActive", true);
                    cmd.Parameters.AddWithValue("@ForumType", forum.ForumType ?? "GENERAL");

                    conn.Open();
                    int forumId = Convert.ToInt32(cmd.ExecuteScalar());

                    LogActivity(forum.CreatedBy, "Forum Created", 
                        $"Created discussion forum: {forum.Title}");

                    return forumId;
                }
            }
            catch (Exception ex)
            {
                LogActivity(forum.CreatedBy, "Forum Creation Error", $"Error creating forum: {ex.Message}");
                throw new Exception("Error creating forum. Please try again.");
            }
        }

        // Get discussion forums
        public List<DiscussionForum> GetDiscussionForums(int? courseID = null, int? userID = null, string userRole = null)
        {
            List<DiscussionForum> forums = new List<DiscussionForum>();

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT df.*, 
                               u.FirstName + ' ' + u.LastName AS CreatedByName,
                               c.CourseName, c.CourseCode,
                               (SELECT COUNT(*) FROM DiscussionPosts WHERE ForumID = df.ForumID) AS PostCount
                        FROM DiscussionForums df
                        INNER JOIN Users u ON df.CreatedBy = u.UserID
                        LEFT JOIN Courses c ON df.CourseID = c.CourseID
                        WHERE df.IsActive = 1";

                    if (courseID.HasValue)
                    {
                        query += " AND (df.CourseID = @CourseID OR df.CourseID IS NULL)";
                    }

                    // For students, only show forums for their enrolled courses
                    if (userRole == "Student" && userID.HasValue)
                    {
                        query += @" AND (df.CourseID IS NULL OR df.CourseID IN 
                                        (SELECT CourseID FROM Enrollments 
                                         WHERE StudentID = @UserID AND IsActive = 1))";
                    }

                    query += " ORDER BY df.DateCreated DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    if (courseID.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseID.Value);
                    }
                    if (userID.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID.Value);
                    }

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        DiscussionForum forum = new DiscussionForum
                        {
                            ForumID = (int)reader["ForumID"],
                            Title = reader["Title"].ToString(),
                            Description = reader["Description"]?.ToString(),
                            CourseID = reader["CourseID"] as int?,
                            CreatedBy = (int)reader["CreatedBy"],
                            DateCreated = (DateTime)reader["DateCreated"],
                            IsActive = (bool)reader["IsActive"],
                            ForumType = reader["ForumType"]?.ToString(),
                            CreatedByName = reader["CreatedByName"].ToString(),
                            CourseName = reader["CourseName"]?.ToString(),
                            CourseCode = reader["CourseCode"]?.ToString(),
                            PostCount = reader["PostCount"] as int? ?? 0
                        };

                        forums.Add(forum);
                    }
                }
            }
            catch (Exception ex)
            {
                LogActivity(userID, "Get Forums Error", $"Error getting forums: {ex.Message}");
                throw new Exception("Error retrieving forums. Please try again.");
            }

            return forums;
        }

        // Private helper methods
        private void LogActivity(int? userId, string activity, string details)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ActivityLogs (UserID, Activity, Details, IPAddress, UserAgent, ActivityDate)
                        VALUES (@UserID, @Activity, @Details, @IPAddress, @UserAgent, @ActivityDate)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", (object)userId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Activity", activity);
                    cmd.Parameters.AddWithValue("@Details", details);
                    cmd.Parameters.AddWithValue("@IPAddress", GetClientIP());
                    cmd.Parameters.AddWithValue("@UserAgent", GetUserAgent());
                    cmd.Parameters.AddWithValue("@ActivityDate", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Silent fail for logging
            }
        }

        private string GetClientIP()
        {
            try
            {
                return HttpContext.Current?.Request?.UserHostAddress ?? "Unknown";
            }
            catch { return "Unknown"; }
        }

        private string GetUserAgent()
        {
            try
            {
                return HttpContext.Current?.Request?.UserAgent ?? "Unknown";
            }
            catch { return "Unknown"; }
        }
    }
}
