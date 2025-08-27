<%@ Page Title="Chat" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Chat.aspx.cs" Inherits="AGMSolutions.Students.Chat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .chat-container {
            max-width: 900px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            height: 600px;
            display: flex;
            flex-direction: column;
        }
        .chat-header {
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-title {
            font-size: 24px;
            font-weight: 600;
        }
        .chat-body {
            display: flex;
            flex: 1;
            height: 520px;
        }
        .users-sidebar {
            width: 280px;
            background: #f8f9fa;
            border-right: 1px solid #dee2e6;
            padding: 15px;
            overflow-y: auto;
        }
        .user-item {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .user-item:hover {
            background: #e9ecef;
        }
        .user-item.active {
            background: #007bff;
            color: white;
        }
        .chat-main {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .messages-area {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #ffffff;
        }
        .message {
            margin-bottom: 15px;
            padding: 10px 15px;
            border-radius: 18px;
            max-width: 70%;
            word-wrap: break-word;
        }
        .message.sent {
            background: #007bff;
            color: white;
            margin-left: auto;
            text-align: right;
        }
        .message.received {
            background: #f1f3f4;
            color: #333;
        }
        .message-input {
            padding: 20px;
            border-top: 1px solid #dee2e6;
            display: flex;
            gap: 10px;
        }
        .message-input input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid #ced4da;
            border-radius: 25px;
            outline: none;
        }
        .send-btn {
            padding: 12px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .send-btn:hover {
            background: #0056b3;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="chat-container">
        <div class="chat-header">
            <div class="chat-title">
                <i class="fas fa-comments"></i> Student Chat
            </div>
            <div>
                <i class="fas fa-users"></i> <span id="onlineCount">3</span> Online
            </div>
        </div>
        
        <div class="chat-body">
            <div class="users-sidebar">
                <h5 style="margin-bottom: 15px; color: #6c757d;">Online Students</h5>
                <div id="usersList">
                    <div class="user-item active" onclick="selectUser('1', 'John Doe')">
                        <div style="font-weight: 600;">John Doe</div>
                        <div style="font-size: 12px; color: #666;">john.doe@agm.com</div>
                        <div style="font-size: 10px; color: #28a745;">
                            <i class="fas fa-circle"></i> Online
                        </div>
                    </div>
                    <div class="user-item" onclick="selectUser('2', 'Jane Smith')">
                        <div style="font-weight: 600;">Jane Smith</div>
                        <div style="font-size: 12px; color: #666;">jane.smith@agm.com</div>
                        <div style="font-size: 10px; color: #28a745;">
                            <i class="fas fa-circle"></i> Online
                        </div>
                    </div>
                    <div class="user-item" onclick="selectUser('3', 'Mike Johnson')">
                        <div style="font-weight: 600;">Mike Johnson</div>
                        <div style="font-size: 12px; color: #666;">mike.johnson@agm.com</div>
                        <div style="font-size: 10px; color: #28a745;">
                            <i class="fas fa-circle"></i> Online
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="chat-main">
                <div class="messages-area" id="messagesArea">
                    <div class="message received">
                        <strong>John Doe:</strong> Hey everyone! How's the assignment going?
                        <div style="font-size: 11px; color: #999; margin-top: 5px;">2 minutes ago</div>
                    </div>
                    <div class="message sent">
                        <strong>You:</strong> Going well! Just finished question 3.
                        <div style="font-size: 11px; color: rgba(255,255,255,0.7); margin-top: 5px;">1 minute ago</div>
                    </div>
                    <div class="message received">
                        <strong>Jane Smith:</strong> Need help with the database connection part
                        <div style="font-size: 11px; color: #999; margin-top: 5px;">30 seconds ago</div>
                    </div>
                </div>
                
                <div class="message-input">
                    <input type="text" id="messageInput" placeholder="Type your message..." onkeypress="handleKeyPress(event)">
                    <button class="send-btn" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i> Send
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden fields for data -->
    <asp:HiddenField ID="hdnCurrentUserId" runat="server" />
    <asp:HiddenField ID="hdnSelectedUserId" runat="server" />

    <script type="text/javascript">
        let selectedUserId = null;
        let selectedUserName = '';

        function selectUser(userId, userName) {
            selectedUserId = userId;
            selectedUserName = userName;
            
            // Update UI
            document.querySelectorAll('.user-item').forEach(item => {
                item.classList.remove('active');
            });
            event.currentTarget.classList.add('active');
            
            // Load chat history for selected user
            loadChatHistory(userId);
        }

        function loadChatHistory(userId) {
            // In a real implementation, this would load chat history from the server
            const messagesArea = document.getElementById('messagesArea');
            messagesArea.innerHTML = `
                <div class="message received">
                    <strong>${selectedUserName}:</strong> Hi there! How are you doing?
                    <div style="font-size: 11px; color: #999; margin-top: 5px;">5 minutes ago</div>
                </div>
                <div class="message sent">
                    <strong>You:</strong> I'm doing great, thanks for asking!
                    <div style="font-size: 11px; color: rgba(255,255,255,0.7); margin-top: 5px;">3 minutes ago</div>
                </div>
            `;
            messagesArea.scrollTop = messagesArea.scrollHeight;
        }

        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            
            if (message && selectedUserId) {
                // Add message to UI
                const messagesArea = document.getElementById('messagesArea');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message sent';
                messageDiv.innerHTML = `
                    <strong>You:</strong> ${message}
                    <div style="font-size: 11px; color: rgba(255,255,255,0.7); margin-top: 5px;">Just now</div>
                `;
                messagesArea.appendChild(messageDiv);
                messagesArea.scrollTop = messagesArea.scrollHeight;
                
                // Clear input
                input.value = '';
                
                // In a real implementation, send to server here
            }
        }

        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }

        // Initialize with first user selected
        document.addEventListener('DOMContentLoaded', function() {
            selectUser('1', 'John Doe');
        });
    </script>
</asp:Content>
