using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;

/// <summary>
/// Real-Time Chat Manager with 200-word limit as per system requirements
/// Handles direct messaging, group chat, and file sharing capabilities
/// </summary>
public class RealTimeChatManager
{
    private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
    private const int MAX_WORD_COUNT = 200;
    private const int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static readonly string[] ALLOWED_FILE_TYPES = { ".jpg", ".jpeg", ".png", ".gif", ".pdf", ".doc", ".docx" };

    #region Message Management

    /// <summary>
    /// Send a chat message with word count validation
    /// </summary>
    public static ChatResult SendMessage(int senderId, int receiverId, string message, int? courseId = null, string messageType = "text")
    {
        try
        {
            // Validate message content
            var validation = ValidateMessage(message);
            if (!validation.IsValid)
                return new ChatResult { Success = false, Message = validation.ErrorMessage };

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                string sql = @"
                    INSERT INTO ChatMessages (SenderID, ReceiverID, Message, MessageType, CourseID, SentDate, IsRead, WordCount)
                    VALUES (@SenderID, @ReceiverID, @Message, @MessageType, @CourseID, GETDATE(), 0, @WordCount);
                    SELECT SCOPE_IDENTITY();";

                using (var cmd = new SqlCommand(sql, connection))
                {
                    cmd.Parameters.AddWithValue("@SenderID", senderId);
                    cmd.Parameters.AddWithValue("@ReceiverID", receiverId);
                    cmd.Parameters.AddWithValue("@Message", message);
                    cmd.Parameters.AddWithValue("@MessageType", messageType);
                    cmd.Parameters.AddWithValue("@CourseID", (object)courseId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@WordCount", validation.WordCount);

                    int messageId = Convert.ToInt32(cmd.ExecuteScalar());

                    return new ChatResult 
                    { 
                        Success = true, 
                        Message = "Message sent successfully", 
                        MessageId = messageId,
                        WordCount = validation.WordCount
                    };
                }
            }
        }
        catch (Exception ex)
        {
            return new ChatResult { Success = false, Message = $"Failed to send message: {ex.Message}" };
        }
    }

    /// <summary>
    /// Send group message to course participants
    /// </summary>
    public static ChatResult SendGroupMessage(int senderId, int courseId, string message, string messageType = "text")
    {
        try
        {
            var validation = ValidateMessage(message);
            if (!validation.IsValid)
                return new ChatResult { Success = false, Message = validation.ErrorMessage };

            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Open();

                // Get all enrolled students and lecturers for the course
                string recipientsSql = @"
                    SELECT DISTINCT u.UserID
                    FROM Users u
                    WHERE u.UserID IN (
                        SELECT StudentID FROM Enrollments WHERE CourseID = @CourseID
                        UNION
                        SELECT LecturerID FROM Courses WHERE CourseID = @CourseID
                    ) AND u.UserID != @SenderID";

                List<int> recipients = new List<int>();
                using (var cmd = new SqlCommand(recipientsSql, connection))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@SenderID", senderId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            recipients.Add(reader.GetInt32(reader.GetOrdinal("UserID")));
                        }
                    }
                }

                // Send message to all recipients
                int messagesSent = 0;
                foreach (int recipientId in recipients)
                {
                    string insertSql = @"
                        INSERT INTO ChatMessages (SenderID, ReceiverID, Message, MessageType, CourseID, SentDate, IsRead, WordCount, IsGroupMessage)
                        VALUES (@SenderID, @ReceiverID, @Message, @MessageType, @CourseID, GETDATE(), 0, @WordCount, 1)";

                    using (var cmd = new SqlCommand(insertSql, connection))
                    {
                        cmd.Parameters.AddWithValue("@SenderID", senderId);
                        cmd.Parameters.AddWithValue("@ReceiverID", recipientId);
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.Parameters.AddWithValue("@MessageType", messageType);
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        cmd.Parameters.AddWithValue("@WordCount", validation.WordCount);

                        cmd.ExecuteNonQuery();
                        messagesSent++;
                    }
                }

                return new ChatResult 
                { 
                    Success = true, 
                    Message = $"Group message sent to {messagesSent} recipients", 
                    WordCount = validation.WordCount
                };
            }
        }
        catch (Exception ex)
        {
            return new ChatResult { Success = false, Message = $"Failed to send group message: {ex.Message}" };
        }
    }

    /// <summary>
    /// Get chat messages between two users
    /// </summary>
    public static List<ChatMessageData> GetChatMessages(int userId1, int userId2, int pageSize = 50, int pageNumber = 1)
    {
        var messages = new List<ChatMessageData>();

        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            string sql = @"
                SELECT cm.MessageID, cm.SenderID, cm.ReceiverID, cm.Message, cm.MessageType, 
                       cm.SentDate, cm.IsRead, cm.WordCount, cm.CourseID, cm.IsGroupMessage,
                       u.FirstName + ' ' + u.LastName AS SenderName,
                       u.ProfilePicture AS SenderAvatar
                FROM ChatMessages cm
                JOIN Users u ON cm.SenderID = u.UserID
                WHERE ((cm.SenderID = @UserId1 AND cm.ReceiverID = @UserId2) 
                    OR (cm.SenderID = @UserId2 AND cm.ReceiverID = @UserId1))
                    AND cm.IsGroupMessage = 0
                ORDER BY cm.SentDate DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            using (var cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@UserId1", userId1);
                cmd.Parameters.AddWithValue("@UserId2", userId2);
                cmd.Parameters.AddWithValue("@Offset", (pageNumber - 1) * pageSize);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        messages.Add(new ChatMessageData
                        {
                            MessageID = reader.GetInt32(reader.GetOrdinal("MessageID")),
                            SenderID = reader.GetInt32(reader.GetOrdinal("SenderID")),
                            ReceiverID = reader.GetInt32(reader.GetOrdinal("ReceiverID")),
                            Message = reader.GetString(reader.GetOrdinal("Message")),
                            MessageType = reader.IsDBNull(reader.GetOrdinal("MessageType")) ? "text" : reader.GetString(reader.GetOrdinal("MessageType")),
                            SentDate = reader.GetDateTime(reader.GetOrdinal("SentDate")),
                            IsRead = reader.GetBoolean(reader.GetOrdinal("IsRead")),
                            WordCount = reader.IsDBNull(reader.GetOrdinal("WordCount")) ? 0 : reader.GetInt32(reader.GetOrdinal("WordCount")),
                            SenderName = reader.GetString(reader.GetOrdinal("SenderName")),
                            SenderAvatar = reader.IsDBNull(reader.GetOrdinal("SenderAvatar")) ? null : reader.GetString(reader.GetOrdinal("SenderAvatar")),
                            IsGroupMessage = reader.IsDBNull(reader.GetOrdinal("IsGroupMessage")) ? false : reader.GetBoolean(reader.GetOrdinal("IsGroupMessage"))
                        });
                    }
                }
            }
        }

        return messages.OrderBy(m => m.SentDate).ToList();
    }

    /// <summary>
    /// Get chat messages between two users (overload that accepts string parameters)
    /// </summary>
    public static List<ChatMessageData> GetChatMessages(string userId1, string userId2, int pageSize = 50, int pageNumber = 1)
    {
        if (int.TryParse(userId1, out int user1Id) && int.TryParse(userId2, out int user2Id))
        {
            return GetChatMessages(user1Id, user2Id, pageSize, pageNumber);
        }
        return new List<ChatMessageData>();
    }

    /// <summary>
    /// Get chat messages between two users (overload that accepts string and int parameters)
    /// </summary>
    public static List<ChatMessageData> GetChatMessages(string userId1, int userId2, int pageSize = 50, int pageNumber = 1)
    {
        if (int.TryParse(userId1, out int user1Id))
        {
            return GetChatMessages(user1Id, userId2, pageSize, pageNumber);
        }
        return new List<ChatMessageData>();
    }

    /// <summary>
    /// Get chat messages between two users (overload that accepts int and string parameters)
    /// </summary>
    public static List<ChatMessageData> GetChatMessages(int userId1, string userId2, int pageSize = 50, int pageNumber = 1)
    {
        if (int.TryParse(userId2, out int user2Id))
        {
            return GetChatMessages(userId1, user2Id, pageSize, pageNumber);
        }
        return new List<ChatMessageData>();
    }

    /// <summary>
    /// Get group chat messages for a course
    /// </summary>
    public static List<ChatMessageData> GetGroupChatMessages(int courseId, int pageSize = 50, int pageNumber = 1)
    {
        var messages = new List<ChatMessageData>();

        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            string sql = @"
                SELECT cm.MessageID, cm.SenderID, cm.ReceiverID, cm.Message, cm.MessageType, 
                       cm.SentDate, cm.IsRead, cm.WordCount, cm.CourseID, cm.IsGroupMessage,
                       u.FirstName + ' ' + u.LastName AS SenderName,
                       u.ProfilePicture AS SenderAvatar,
                       u.Role AS SenderRole
                FROM ChatMessages cm
                JOIN Users u ON cm.SenderID = u.UserID
                WHERE cm.CourseID = @CourseID AND cm.IsGroupMessage = 1
                ORDER BY cm.SentDate DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            using (var cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@Offset", (pageNumber - 1) * pageSize);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        messages.Add(new ChatMessageData
                        {
                            MessageID = reader.GetInt32(reader.GetOrdinal("MessageID")),
                            SenderID = reader.GetInt32(reader.GetOrdinal("SenderID")),
                            ReceiverID = reader.GetInt32(reader.GetOrdinal("ReceiverID")),
                            Message = reader.GetString(reader.GetOrdinal("Message")),
                            MessageType = reader.IsDBNull(reader.GetOrdinal("MessageType")) ? "text" : reader.GetString(reader.GetOrdinal("MessageType")),
                            SentDate = reader.GetDateTime(reader.GetOrdinal("SentDate")),
                            IsRead = reader.GetBoolean(reader.GetOrdinal("IsRead")),
                            WordCount = reader.IsDBNull(reader.GetOrdinal("WordCount")) ? 0 : reader.GetInt32(reader.GetOrdinal("WordCount")),
                            SenderName = reader.GetString(reader.GetOrdinal("SenderName")),
                            SenderAvatar = reader.IsDBNull(reader.GetOrdinal("SenderAvatar")) ? null : reader.GetString(reader.GetOrdinal("SenderAvatar")),
                            SenderRole = reader.IsDBNull(reader.GetOrdinal("SenderRole")) ? "Student" : reader.GetString(reader.GetOrdinal("SenderRole")),
                            IsGroupMessage = true,
                            CourseID = courseId
                        });
                    }
                }
            }
        }

        return messages.OrderBy(m => m.SentDate).ToList();
    }

    #endregion

    #region Message Validation

    /// <summary>
    /// Validate message content and word count
    /// </summary>
    private static MessageValidation ValidateMessage(string message)
    {
        if (string.IsNullOrWhiteSpace(message))
        {
            return new MessageValidation 
            { 
                IsValid = false, 
                ErrorMessage = "Message cannot be empty.",
                WordCount = 0
            };
        }

        // Clean and count words
        string cleanMessage = Regex.Replace(message.Trim(), @"\s+", " ");
        string[] words = cleanMessage.Split(new char[] { ' ', '\t', '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
        int wordCount = words.Length;

        if (wordCount > MAX_WORD_COUNT)
        {
            return new MessageValidation 
            { 
                IsValid = false, 
                ErrorMessage = $"Message exceeds the {MAX_WORD_COUNT}-word limit. Current count: {wordCount} words.",
                WordCount = wordCount
            };
        }

        // Check for inappropriate content (basic filter)
        if (ContainsInappropriateContent(cleanMessage))
        {
            return new MessageValidation 
            { 
                IsValid = false, 
                ErrorMessage = "Message contains inappropriate content.",
                WordCount = wordCount
            };
        }

        return new MessageValidation 
        { 
            IsValid = true, 
            WordCount = wordCount
        };
    }

    /// <summary>
    /// Basic content filter for inappropriate content
    /// </summary>
    private static bool ContainsInappropriateContent(string message)
    {
        // Basic implementation - in production, use more sophisticated filtering
        string[] inappropriateWords = { "spam", "abuse", "inappropriate" }; // Add more as needed
        string lowerMessage = message.ToLower();
        
        return inappropriateWords.Any(word => lowerMessage.Contains(word.ToLower()));
    }

    #endregion

    #region File Sharing

    /// <summary>
    /// Handle file upload for chat
    /// </summary>
    public static FileUploadResult UploadChatFile(HttpPostedFile file, int senderId, string uploadPath)
    {
        try
        {
            if (file == null || file.ContentLength == 0)
                return new FileUploadResult { Success = false, Message = "No file selected." };

            if (file.ContentLength > MAX_FILE_SIZE)
                return new FileUploadResult { Success = false, Message = "File size exceeds 5MB limit." };

            string fileExtension = System.IO.Path.GetExtension(file.FileName).ToLower();
            if (!ALLOWED_FILE_TYPES.Contains(fileExtension))
                return new FileUploadResult { Success = false, Message = "File type not allowed." };

            // Generate unique filename
            string fileName = $"chat_{senderId}_{DateTime.Now:yyyyMMdd_HHmmss}_{Guid.NewGuid().ToString("N").Substring(0, 8)}{fileExtension}";
            string filePath = System.IO.Path.Combine(uploadPath, fileName);

            // Save file
            file.SaveAs(filePath);

            return new FileUploadResult 
            { 
                Success = true, 
                Message = "File uploaded successfully.",
                FileName = fileName,
                FilePath = filePath,
                FileSize = file.ContentLength
            };
        }
        catch (Exception ex)
        {
            return new FileUploadResult { Success = false, Message = $"Upload failed: {ex.Message}" };
        }
    }

    #endregion

    #region User Status and Contacts

    /// <summary>
    /// Get chat contacts for a user
    /// </summary>
    public static List<ChatContact> GetChatContacts(int userId)
    {
        var contacts = new List<ChatContact>();

        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            string sql = @"
                SELECT DISTINCT 
                    CASE 
                        WHEN cm.SenderID = @UserID THEN cm.ReceiverID 
                        ELSE cm.SenderID 
                    END AS ContactID,
                    u.FirstName + ' ' + u.LastName AS ContactName,
                    u.Role AS ContactRole,
                    u.ProfilePicture AS ContactAvatar,
                    u.IsOnline,
                    u.LastSeen,
                    (SELECT TOP 1 Message FROM ChatMessages cm2 
                     WHERE ((cm2.SenderID = @UserID AND cm2.ReceiverID = ContactID) 
                         OR (cm2.SenderID = ContactID AND cm2.ReceiverID = @UserID))
                         AND cm2.IsGroupMessage = 0
                     ORDER BY cm2.SentDate DESC) AS LastMessage,
                    (SELECT TOP 1 SentDate FROM ChatMessages cm2 
                     WHERE ((cm2.SenderID = @UserID AND cm2.ReceiverID = ContactID) 
                         OR (cm2.SenderID = ContactID AND cm2.ReceiverID = @UserID))
                         AND cm2.IsGroupMessage = 0
                     ORDER BY cm2.SentDate DESC) AS LastMessageDate,
                    (SELECT COUNT(*) FROM ChatMessages cm2 
                     WHERE cm2.SenderID = ContactID AND cm2.ReceiverID = @UserID 
                         AND cm2.IsRead = 0) AS UnreadCount
                FROM ChatMessages cm
                JOIN Users u ON u.UserID = CASE 
                    WHEN cm.SenderID = @UserID THEN cm.ReceiverID 
                    ELSE cm.SenderID 
                END
                WHERE (cm.SenderID = @UserID OR cm.ReceiverID = @UserID) 
                    AND cm.IsGroupMessage = 0
                ORDER BY LastMessageDate DESC";

            using (var cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@UserID", userId);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        contacts.Add(new ChatContact
                        {
                            ContactID = reader.GetInt32(reader.GetOrdinal("ContactID")),
                            ContactName = reader.GetString(reader.GetOrdinal("ContactName")),
                            ContactRole = reader.IsDBNull(reader.GetOrdinal("ContactRole")) ? "Student" : reader.GetString(reader.GetOrdinal("ContactRole")),
                            ContactAvatar = reader.IsDBNull(reader.GetOrdinal("ContactAvatar")) ? null : reader.GetString(reader.GetOrdinal("ContactAvatar")),
                            IsOnline = reader.IsDBNull(reader.GetOrdinal("IsOnline")) ? false : reader.GetBoolean(reader.GetOrdinal("IsOnline")),
                            LastSeen = reader.IsDBNull(reader.GetOrdinal("LastSeen")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("LastSeen")),
                            LastMessage = reader.IsDBNull(reader.GetOrdinal("LastMessage")) ? "" : reader.GetString(reader.GetOrdinal("LastMessage")),
                            LastMessageDate = reader.IsDBNull(reader.GetOrdinal("LastMessageDate")) ? (DateTime?)null : reader.GetDateTime(reader.GetOrdinal("LastMessageDate")),
                            UnreadCount = reader.GetInt32(reader.GetOrdinal("UnreadCount"))
                        });
                    }
                }
            }
        }

        return contacts;
    }

    /// <summary>
    /// Mark messages as read
    /// </summary>
    public static void MarkMessagesAsRead(int senderId, int receiverId)
    {
        using (var connection = new SqlConnection(ConnectionString))
        {
            connection.Open();
            string sql = @"
                UPDATE ChatMessages 
                SET IsRead = 1, ReadDate = GETDATE() 
                WHERE SenderID = @SenderID AND ReceiverID = @ReceiverID AND IsRead = 0";

            using (var cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@SenderID", senderId);
                cmd.Parameters.AddWithValue("@ReceiverID", receiverId);
                cmd.ExecuteNonQuery();
            }
        }
    }

    #endregion

    #region Support Classes

    public class ChatResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int MessageId { get; set; }
        public int WordCount { get; set; }
    }

    public class MessageValidation
    {
        public bool IsValid { get; set; }
        public string ErrorMessage { get; set; }
        public int WordCount { get; set; }
    }

    public class ChatMessageData
    {
        public int MessageID { get; set; }
        public int SenderID { get; set; }
        public int ReceiverID { get; set; }
        public string Message { get; set; }
        public string MessageType { get; set; }
        public DateTime SentDate { get; set; }
        public bool IsRead { get; set; }
        public int WordCount { get; set; }
        public string SenderName { get; set; }
        public string SenderAvatar { get; set; }
        public string SenderRole { get; set; }
        public bool IsGroupMessage { get; set; }
        public int? CourseID { get; set; }
    }

    public class ChatContact
    {
        public int ContactID { get; set; }
        public string ContactName { get; set; }
        public string ContactRole { get; set; }
        public string ContactAvatar { get; set; }
        public bool IsOnline { get; set; }
        public DateTime? LastSeen { get; set; }
        public string LastMessage { get; set; }
        public DateTime? LastMessageDate { get; set; }
        public int UnreadCount { get; set; }
    }

    public class FileUploadResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public int FileSize { get; set; }
    }

    #endregion
}
