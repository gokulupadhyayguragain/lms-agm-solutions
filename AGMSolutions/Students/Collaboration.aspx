<%@ Page Title="Collaboration Hub" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Collaboration.aspx.cs" Inherits="AGMSolutions.Students.Collaboration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .collaboration-container {
            max-width: 1400px;
            margin: 20px auto;
            padding: 20px;
        }
        .collab-header {
            background: var(--gradient-primary);
            color: white;
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        .tool-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .tool-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 5px solid var(--primary-color);
        }
        .tool-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .tool-icon {
            width: 60px;
            height: 60px;
            background: var(--gradient-secondary);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 15px;
        }
        .whiteboard-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .whiteboard-canvas {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            cursor: crosshair;
            width: 100%;
            height: 500px;
        }
        .whiteboard-tools {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .tool-btn {
            padding: 10px 15px;
            border: none;
            border-radius: 8px;
            background: var(--primary-color);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tool-btn:hover,
        .tool-btn.active {
            background: var(--dark-color);
            transform: translateY(-2px);
        }
        .color-picker {
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        .chat-section {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            height: 600px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            background: #f8f9fa;
        }
        .message {
            margin-bottom: 15px;
            padding: 10px 15px;
            border-radius: 15px;
            max-width: 80%;
        }
        .message.own {
            background: var(--primary-color);
            color: white;
            margin-left: auto;
            text-align: right;
        }
        .message.other {
            background: white;
            border: 1px solid #e9ecef;
        }
        .message-input {
            display: flex;
            gap: 10px;
        }
        .message-input input {
            flex: 1;
            padding: 12px;
            border: 1px solid #e9ecef;
            border-radius: 25px;
            outline: none;
        }
        .send-btn {
            padding: 12px 20px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
        }
        .participants-list {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .participant {
            display: flex;
            align-items: center;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 10px;
            background: #f8f9fa;
        }
        .participant-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 15px;
        }
        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-left: auto;
        }
        .status-online { background: #28a745; }
        .status-away { background: #ffc107; }
        .status-offline { background: #6c757d; }
        .document-editor {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .editor-toolbar {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .editor-content {
            min-height: 400px;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            font-family: 'Times New Roman', serif;
            line-height: 1.6;
            outline: none;
        }
        .screen-share {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        .share-preview {
            width: 100%;
            height: 300px;
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
        .collaboration-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="collaboration-container">
        <div class="collab-header">
            <h1><i class="fas fa-users"></i> Collaboration Hub</h1>
            <p>Real-time tools for seamless teamwork and learning</p>
        </div>

        <!-- Collaboration Stats -->
        <div class="collaboration-stats">
            <div class="stat-card">
                <div class="stat-number">8</div>
                <div>Active Participants</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">3</div>
                <div>Shared Documents</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">24</div>
                <div>Messages Today</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">2h 15m</div>
                <div>Session Time</div>
            </div>
        </div>

        <!-- Tool Grid -->
        <div class="tool-grid">
            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-chalkboard"></i>
                </div>
                <h4>Interactive Whiteboard</h4>
                <p>Draw, annotate, and brainstorm together in real-time with advanced drawing tools.</p>
                <button class="btn btn-primary" onclick="activateTool('whiteboard')">Launch Whiteboard</button>
            </div>

            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h4>Collaborative Documents</h4>
                <p>Edit documents together with live cursor tracking and real-time synchronization.</p>
                <button class="btn btn-primary" onclick="activateTool('document')">Open Editor</button>
            </div>

            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <h4>Group Chat</h4>
                <p>Instant messaging with file sharing, emoji reactions, and message threading.</p>
                <button class="btn btn-primary" onclick="activateTool('chat')">Join Chat</button>
            </div>

            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-desktop"></i>
                </div>
                <h4>Screen Sharing</h4>
                <p>Share your screen or specific applications with annotation capabilities.</p>
                <button class="btn btn-primary" onclick="activateTool('screen')">Start Sharing</button>
            </div>

            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-video"></i>
                </div>
                <h4>Video Conference</h4>
                <p>Face-to-face communication with recording and breakout room features.</p>
                <button class="btn btn-primary" onclick="activateTool('video')">Join Meeting</button>
            </div>

            <div class="tool-card">
                <div class="tool-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h4>Task Board</h4>
                <p>Kanban-style project management with assignments and progress tracking.</p>
                <button class="btn btn-primary" onclick="activateTool('tasks')">Open Board</button>
            </div>
        </div>

        <div class="row">
            <!-- Participants List -->
            <div class="col-lg-3">
                <div class="participants-list">
                    <h5><i class="fas fa-users"></i> Active Participants</h5>
                    <div class="participant">
                        <div class="participant-avatar">JD</div>
                        <div>
                            <strong>John Doe</strong><br>
                            <small>Student</small>
                        </div>
                        <div class="status-indicator status-online"></div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar">SM</div>
                        <div>
                            <strong>Sarah Miller</strong><br>
                            <small>Student</small>
                        </div>
                        <div class="status-indicator status-online"></div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar">MJ</div>
                        <div>
                            <strong>Dr. Michael Johnson</strong><br>
                            <small>Lecturer</small>
                        </div>
                        <div class="status-indicator status-away"></div>
                    </div>
                    <div class="participant">
                        <div class="participant-avatar">EB</div>
                        <div>
                            <strong>Emily Brown</strong><br>
                            <small>Student</small>
                        </div>
                        <div class="status-indicator status-offline"></div>
                    </div>
                </div>

                <!-- Chat Section -->
                <div class="chat-section">
                    <h5><i class="fas fa-comments"></i> Group Chat</h5>
                    <div class="chat-messages" id="chatMessages">
                        <div class="message other">
                            <strong>Sarah:</strong> Hey everyone! Ready for our study session?
                        </div>
                        <div class="message own">
                            <strong>You:</strong> Yes! Let's start with the whiteboard.
                        </div>
                        <div class="message other">
                            <strong>John:</strong> I'll share my notes from the last lecture.
                        </div>
                        <div class="message other">
                            <strong>Dr. Johnson:</strong> Great collaboration! I'm here if you need help.
                        </div>
                    </div>
                    <div class="message-input">
                        <input type="text" id="messageInput" placeholder="Type your message..." onkeypress="handleEnter(event)">
                        <button class="send-btn" onclick="sendMessage()">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Main Collaboration Area -->
            <div class="col-lg-9">
                <!-- Whiteboard Tool -->
                <div id="whiteboardTool" class="whiteboard-container" style="display: block;">
                    <h5><i class="fas fa-chalkboard"></i> Interactive Whiteboard</h5>
                    <div class="whiteboard-tools">
                        <button class="tool-btn active" onclick="selectTool('pen', this)">
                            <i class="fas fa-pen"></i> Pen
                        </button>
                        <button class="tool-btn" onclick="selectTool('eraser', this)">
                            <i class="fas fa-eraser"></i> Eraser
                        </button>
                        <button class="tool-btn" onclick="selectTool('line', this)">
                            <i class="fas fa-minus"></i> Line
                        </button>
                        <button class="tool-btn" onclick="selectTool('rectangle', this)">
                            <i class="fas fa-square"></i> Rectangle
                        </button>
                        <button class="tool-btn" onclick="selectTool('circle', this)">
                            <i class="fas fa-circle"></i> Circle
                        </button>
                        <button class="tool-btn" onclick="selectTool('text', this)">
                            <i class="fas fa-font"></i> Text
                        </button>
                        <input type="color" class="color-picker" id="colorPicker" value="#3498db">
                        <input type="range" min="1" max="20" value="3" id="brushSize" style="margin: 0 10px;">
                        <button class="tool-btn" onclick="clearCanvas()">
                            <i class="fas fa-trash"></i> Clear
                        </button>
                        <button class="tool-btn" onclick="saveCanvas()">
                            <i class="fas fa-save"></i> Save
                        </button>
                    </div>
                    <canvas id="whiteboardCanvas" class="whiteboard-canvas"></canvas>
                </div>

                <!-- Document Editor Tool -->
                <div id="documentTool" class="document-editor" style="display: none;">
                    <h5><i class="fas fa-file-alt"></i> Collaborative Document Editor</h5>
                    <div class="editor-toolbar">
                        <button class="tool-btn" onclick="formatText('bold')">
                            <i class="fas fa-bold"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('italic')">
                            <i class="fas fa-italic"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('underline')">
                            <i class="fas fa-underline"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('justifyLeft')">
                            <i class="fas fa-align-left"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('justifyCenter')">
                            <i class="fas fa-align-center"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('justifyRight')">
                            <i class="fas fa-align-right"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('insertUnorderedList')">
                            <i class="fas fa-list-ul"></i>
                        </button>
                        <button class="tool-btn" onclick="formatText('insertOrderedList')">
                            <i class="fas fa-list-ol"></i>
                        </button>
                    </div>
                    <div class="editor-content" contenteditable="true" id="documentEditor">
                        <h2>Shared Document</h2>
                        <p>This is a collaborative document that multiple users can edit simultaneously. Start typing to see real-time collaboration in action!</p>
                        <ul>
                            <li>Real-time synchronization</li>
                            <li>Multiple cursor tracking</li>
                            <li>Version history</li>
                            <li>Comment system</li>
                        </ul>
                    </div>
                </div>

                <!-- Screen Sharing Tool -->
                <div id="screenTool" class="screen-share" style="display: none;">
                    <h5><i class="fas fa-desktop"></i> Screen Sharing</h5>
                    <div class="share-preview">
                        <div>
                            <i class="fas fa-desktop" style="font-size: 3rem; color: #6c757d; margin-bottom: 20px;"></i>
                            <p>Click "Start Sharing" to share your screen</p>
                            <button class="btn btn-primary btn-lg" onclick="startScreenShare()">
                                <i class="fas fa-play"></i> Start Sharing
                            </button>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <button class="btn btn-outline-primary w-100">
                                <i class="fas fa-desktop"></i><br>Entire Screen
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-outline-primary w-100">
                                <i class="fas fa-window-maximize"></i><br>Application Window
                            </button>
                        </div>
                        <div class="col-md-4">
                            <button class="btn btn-outline-primary w-100">
                                <i class="fas fa-browser"></i><br>Browser Tab
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentTool = 'pen';
        let isDrawing = false;
        let canvas, ctx;

        // Initialize canvas
        document.addEventListener('DOMContentLoaded', function() {
            canvas = document.getElementById('whiteboardCanvas');
            if (canvas) {
                ctx = canvas.getContext('2d');
                setupCanvas();
            }
        });

        function setupCanvas() {
            // Set canvas size
            canvas.width = canvas.offsetWidth;
            canvas.height = canvas.offsetHeight;
            
            // Set default styles
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            ctx.lineWidth = 3;
            ctx.strokeStyle = '#3498db';

            // Mouse events
            canvas.addEventListener('mousedown', startDrawing);
            canvas.addEventListener('mousemove', draw);
            canvas.addEventListener('mouseup', stopDrawing);
            canvas.addEventListener('mouseout', stopDrawing);
        }

        function startDrawing(e) {
            isDrawing = true;
            const rect = canvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            ctx.beginPath();
            ctx.moveTo(x, y);
        }

        function draw(e) {
            if (!isDrawing) return;
            
            const rect = canvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            ctx.lineTo(x, y);
            ctx.stroke();
        }

        function stopDrawing() {
            isDrawing = false;
        }

        function selectTool(tool, button) {
            currentTool = tool;
            document.querySelectorAll('.tool-btn').forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            // Update cursor based on tool
            switch(tool) {
                case 'eraser':
                    canvas.style.cursor = 'grab';
                    break;
                case 'text':
                    canvas.style.cursor = 'text';
                    break;
                default:
                    canvas.style.cursor = 'crosshair';
            }
        }

        function clearCanvas() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

        function saveCanvas() {
            const link = document.createElement('a');
            link.download = 'whiteboard.png';
            link.href = canvas.toDataURL();
            link.click();
        }

        function activateTool(toolName) {
            // Hide all tools
            document.querySelectorAll('[id$="Tool"]').forEach(tool => {
                tool.style.display = 'none';
            });
            
            // Show selected tool
            const toolElement = document.getElementById(toolName + 'Tool');
            if (toolElement) {
                toolElement.style.display = 'block';
            }
        }

        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            
            if (message) {
                const chatMessages = document.getElementById('chatMessages');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message own';
                messageDiv.innerHTML = '<strong>You:</strong> ' + message;
                chatMessages.appendChild(messageDiv);
                
                input.value = '';
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }
        }

        function handleEnter(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        }

        function formatText(command) {
            document.execCommand(command, false, null);
        }

        function startScreenShare() {
            if (navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia) {
                navigator.mediaDevices.getDisplayMedia({ video: true })
                .then(stream => {
                    // Handle screen sharing stream
                    console.log('Screen sharing started');
                    // You would typically send this stream to other participants
                })
                .catch(err => {
                    console.error('Error starting screen share:', err);
                    alert('Screen sharing not supported or permission denied');
                });
            } else {
                alert('Screen sharing not supported in this browser');
            }
        }

        // Update color picker
        document.addEventListener('DOMContentLoaded', function() {
            const colorPicker = document.getElementById('colorPicker');
            if (colorPicker) {
                colorPicker.addEventListener('change', function() {
                    if (ctx) {
                        ctx.strokeStyle = this.value;
                    }
                });
            }

            // Update brush size
            const brushSize = document.getElementById('brushSize');
            if (brushSize) {
                brushSize.addEventListener('input', function() {
                    if (ctx) {
                        ctx.lineWidth = this.value;
                    }
                });
            }
        });

        // Simulate real-time updates
        setInterval(() => {
            // Simulate participant status updates
            const participants = document.querySelectorAll('.status-indicator');
            participants.forEach(indicator => {
                const statuses = ['status-online', 'status-away', 'status-offline'];
                const currentStatus = statuses.find(status => indicator.classList.contains(status));
                if (Math.random() < 0.1) { // 10% chance to change status
                    indicator.classList.remove(currentStatus);
                    const newStatus = statuses[Math.floor(Math.random() * statuses.length)];
                    indicator.classList.add(newStatus);
                }
            });
        }, 5000);
    </script>
</asp:Content>
