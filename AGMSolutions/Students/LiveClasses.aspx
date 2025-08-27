<%@ Page Title="Live Classes" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="LiveClasses.aspx.cs" Inherits="AGMSolutions.Students.LiveClasses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .live-container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .live-header {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .live-indicator {
            display: inline-flex;
            align-items: center;
            background: rgba(255,255,255,0.2);
            padding: 8px 15px;
            border-radius: 25px;
            margin-left: 10px;
        }
        .live-dot {
            width: 10px;
            height: 10px;
            background: #ff0000;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .video-main {
            position: relative;
            background: #000;
            aspect-ratio: 16/9;
        }
        .video-player {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .video-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(0,123,255,0.8), rgba(40,167,69,0.8));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .video-controls {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .control-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 10px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .control-btn:hover {
            background: rgba(255,255,255,0.4);
            transform: scale(1.1);
        }
        .volume-slider, .progress-bar {
            flex: 1;
            margin: 0 10px;
        }
        .live-sidebar {
            background: #f8f9fa;
            padding: 20px;
            height: 600px;
            overflow-y: auto;
        }
        .chat-container {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            height: 300px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
        }
        .chat-message {
            margin-bottom: 10px;
            padding: 8px 12px;
            border-radius: 15px;
            max-width: 80%;
        }
        .chat-message.own {
            background: #007bff;
            color: white;
            margin-left: auto;
        }
        .chat-message.other {
            background: #e9ecef;
            color: #333;
        }
        .chat-input-group {
            display: flex;
            gap: 10px;
        }
        .participants-list {
            background: white;
            border-radius: 10px;
            padding: 15px;
        }
        .participant {
            display: flex;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .participant:last-child {
            border-bottom: none;
        }
        .participant-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(45deg, #007bff, #28a745);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 10px;
        }
        .participant-info {
            flex: 1;
        }
        .participant-name {
            font-weight: bold;
            margin-bottom: 2px;
        }
        .participant-status {
            font-size: 12px;
            color: #666;
        }
        .class-info {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .quality-selector {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(0,0,0,0.7);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
        }
        .screen-share-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            margin: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .screen-share-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        .notification-banner {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 10px 20px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="live-container">
        <!-- Live Header -->
        <div class="live-header">
            <h2>
                <i class="fas fa-video"></i> Computer Science 101 - Live Class
                <span class="live-indicator">
                    <div class="live-dot"></div>
                    LIVE
                </span>
            </h2>
            <p>Dr. John Smith • Introduction to Programming • Session 12</p>
        </div>

        <div class="notification-banner">
            <i class="fas fa-info-circle"></i> This is a live class. Please mute your microphone when not speaking.
        </div>

        <div class="row g-0">
            <!-- Main Video Area -->
            <div class="col-md-8">
                <div class="video-main">
                    <select class="quality-selector">
                        <option value="720p">720p HD</option>
                        <option value="1080p">1080p Full HD</option>
                        <option value="480p">480p</option>
                        <option value="360p">360p</option>
                    </select>

                    <!-- Video Player (In a real implementation, this would be a video element) -->
                    <div class="video-overlay">
                        <div>
                            <i class="fas fa-play-circle" style="font-size: 4rem; margin-bottom: 20px;"></i>
                            <h3>Live Stream Starting Soon...</h3>
                            <p>The instructor will begin the session shortly. Please wait.</p>
                            <div class="mt-3">
                                <button class="screen-share-btn" onclick="requestCameraAccess()">
                                    <i class="fas fa-camera"></i> Enable Camera
                                </button>
                                <button class="screen-share-btn" onclick="requestMicrophoneAccess()">
                                    <i class="fas fa-microphone"></i> Enable Microphone
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Video Controls -->
                    <div class="video-controls">
                        <button class="control-btn" onclick="togglePlay()">
                            <i class="fas fa-play" id="playIcon"></i>
                        </button>
                        <button class="control-btn" onclick="toggleMute()">
                            <i class="fas fa-volume-up" id="volumeIcon"></i>
                        </button>
                        <input type="range" class="volume-slider" min="0" max="100" value="50" onchange="setVolume(this.value)">
                        <input type="range" class="progress-bar" min="0" max="100" value="0">
                        <span class="text-white" id="timeDisplay">00:00 / 00:00</span>
                        <button class="control-btn" onclick="toggleFullscreen()">
                            <i class="fas fa-expand"></i>
                        </button>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="p-3" style="background: #f8f9fa;">
                    <div class="d-flex gap-2 flex-wrap">
                        <button class="btn btn-primary" onclick="raiseHand()">
                            <i class="fas fa-hand-paper"></i> Raise Hand
                        </button>
                        <button class="btn btn-success" onclick="shareScreen()">
                            <i class="fas fa-desktop"></i> Share Screen
                        </button>
                        <button class="btn btn-info" onclick="openWhiteboard()">
                            <i class="fas fa-chalkboard"></i> Whiteboard
                        </button>
                        <button class="btn btn-warning" onclick="recordSession()">
                            <i class="fas fa-record-vinyl"></i> Record
                        </button>
                        <button class="btn btn-danger" onclick="leaveClass()">
                            <i class="fas fa-sign-out-alt"></i> Leave Class
                        </button>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-md-4 live-sidebar">
                <!-- Class Information -->
                <div class="class-info">
                    <h5><i class="fas fa-info-circle"></i> Class Details</h5>
                    <div class="info-item">
                        <span><strong>Duration:</strong></span>
                        <span>1 hour 30 minutes</span>
                    </div>
                    <div class="info-item">
                        <span><strong>Started:</strong></span>
                        <span id="classStartTime">10:00 AM</span>
                    </div>
                    <div class="info-item">
                        <span><strong>Participants:</strong></span>
                        <span id="participantCount">24</span>
                    </div>
                    <div class="info-item">
                        <span><strong>Recording:</strong></span>
                        <span class="text-danger">● Recording</span>
                    </div>
                </div>

                <!-- Live Chat -->
                <div class="chat-container">
                    <h6><i class="fas fa-comments"></i> Live Chat</h6>
                    <div class="chat-messages" id="chatMessages">
                        <div class="chat-message other">
                            <strong>Sarah:</strong> Good morning everyone!
                        </div>
                        <div class="chat-message other">
                            <strong>Mike:</strong> Can you repeat the last part about loops?
                        </div>
                        <div class="chat-message own">
                            <strong>You:</strong> Thank you for the explanation, very clear!
                        </div>
                        <div class="chat-message other">
                            <strong>Dr. Smith:</strong> I'll share the slides after the class.
                        </div>
                    </div>
                    <div class="chat-input-group">
                        <input type="text" id="chatInput" class="form-control" placeholder="Type your message..." onkeypress="handleChatKeyPress(event)">
                        <button class="btn btn-primary" onclick="sendChatMessage()">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>

                <!-- Participants List -->
                <div class="participants-list">
                    <h6><i class="fas fa-users"></i> Participants (24)</h6>
                    <div class="participant">
                        <div class="participant-avatar">DS</div>
                        <div class="participant-info">
                            <div class="participant-name">Dr. John Smith</div>
                            <div class="participant-status">
                                <i class="fas fa-microphone text-success"></i>
                                <i class="fas fa-video text-success"></i>
                                Instructor
                            </div>
                        </div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar" style="background: linear-gradient(45deg, #dc3545, #fd7e14);">SM</div>
                        <div class="participant-info">
                            <div class="participant-name">Sarah Miller</div>
                            <div class="participant-status">
                                <i class="fas fa-microphone-slash text-muted"></i>
                                <i class="fas fa-video text-success"></i>
                                Student
                            </div>
                        </div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar" style="background: linear-gradient(45deg, #28a745, #20c997);">MJ</div>
                        <div class="participant-info">
                            <div class="participant-name">Mike Johnson</div>
                            <div class="participant-status">
                                <i class="fas fa-microphone-slash text-muted"></i>
                                <i class="fas fa-video-slash text-muted"></i>
                                Student
                            </div>
                        </div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar" style="background: linear-gradient(45deg, #6f42c1, #e83e8c);">EB</div>
                        <div class="participant-info">
                            <div class="participant-name">Emily Brown</div>
                            <div class="participant-status">
                                <i class="fas fa-hand-paper text-warning"></i>
                                <i class="fas fa-microphone-slash text-muted"></i>
                                <i class="fas fa-video text-success"></i>
                                Student
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-3">
                        <small class="text-muted">And 20 more participants...</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let isPlaying = false;
        let isMuted = false;
        let isFullscreen = false;
        let sessionStartTime = new Date();

        function togglePlay() {
            isPlaying = !isPlaying;
            const icon = document.getElementById('playIcon');
            icon.className = isPlaying ? 'fas fa-pause' : 'fas fa-play';
        }

        function toggleMute() {
            isMuted = !isMuted;
            const icon = document.getElementById('volumeIcon');
            icon.className = isMuted ? 'fas fa-volume-mute' : 'fas fa-volume-up';
        }

        function setVolume(value) {
            // Set video volume (in real implementation)
            console.log('Volume set to:', value);
        }

        function toggleFullscreen() {
            if (!isFullscreen) {
                document.querySelector('.video-main').requestFullscreen();
            } else {
                document.exitFullscreen();
            }
            isFullscreen = !isFullscreen;
        }

        function raiseHand() {
            alert('Hand raised! The instructor will be notified.');
        }

        function shareScreen() {
            if (navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia) {
                navigator.mediaDevices.getDisplayMedia({ video: true })
                    .then(stream => {
                        alert('Screen sharing started!');
                        // In real implementation, share the stream
                    })
                    .catch(err => {
                        alert('Screen sharing permission denied.');
                    });
            } else {
                alert('Screen sharing not supported in this browser.');
            }
        }

        function openWhiteboard() {
            alert('Opening collaborative whiteboard...');
        }

        function recordSession() {
            alert('Recording session... This will be available after the class.');
        }

        function leaveClass() {
            if (confirm('Are you sure you want to leave the class?')) {
                window.location.href = '../Students/Dashboard.aspx';
            }
        }

        function sendChatMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            
            if (message) {
                const messagesContainer = document.getElementById('chatMessages');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'chat-message own';
                messageDiv.innerHTML = `<strong>You:</strong> ${message}`;
                messagesContainer.appendChild(messageDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
                input.value = '';
            }
        }

        function handleChatKeyPress(event) {
            if (event.key === 'Enter') {
                sendChatMessage();
            }
        }

        function requestCameraAccess() {
            if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({ video: true })
                    .then(stream => {
                        alert('Camera access granted!');
                        // In real implementation, show user's video
                    })
                    .catch(err => {
                        alert('Camera access denied.');
                    });
            } else {
                alert('Camera not supported in this browser.');
            }
        }

        function requestMicrophoneAccess() {
            if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
                navigator.mediaDevices.getUserMedia({ audio: true })
                    .then(stream => {
                        alert('Microphone access granted!');
                        // In real implementation, enable audio
                    })
                    .catch(err => {
                        alert('Microphone access denied.');
                    });
            } else {
                alert('Microphone not supported in this browser.');
            }
        }

        // Update time display
        function updateTimeDisplay() {
            const now = new Date();
            const elapsed = Math.floor((now - sessionStartTime) / 1000);
            const minutes = Math.floor(elapsed / 60);
            const seconds = elapsed % 60;
            const timeString = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')} / 90:00`;
            document.getElementById('timeDisplay').textContent = timeString;
        }

        // Simulate live chat messages
        function simulateIncomingMessages() {
            const messages = [
                "Alex: Great explanation of variables!",
                "Lisa: Can we have a quick break?",
                "Dr. Smith: We'll take a 5-minute break after this topic.",
                "Tom: The code example is very helpful.",
                "Nina: I have a question about the assignment."
            ];

            let messageIndex = 0;
            setInterval(() => {
                if (messageIndex < messages.length) {
                    const messagesContainer = document.getElementById('chatMessages');
                    const messageDiv = document.createElement('div');
                    messageDiv.className = 'chat-message other';
                    messageDiv.innerHTML = `<strong>${messages[messageIndex].split(':')[0]}:</strong> ${messages[messageIndex].split(':')[1]}`;
                    messagesContainer.appendChild(messageDiv);
                    messagesContainer.scrollTop = messagesContainer.scrollHeight;
                    messageIndex++;
                }
            }, 15000); // New message every 15 seconds
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            setInterval(updateTimeDisplay, 1000);
            simulateIncomingMessages();
            
            // Update start time
            document.getElementById('classStartTime').textContent = sessionStartTime.toLocaleTimeString();
        });
    </script>
</asp:Content>
