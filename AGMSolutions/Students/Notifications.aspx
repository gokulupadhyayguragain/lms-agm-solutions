<%@ Page Title="Notifications" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="AGMSolutions.Students.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .notifications-container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 20px;
        }
        .notifications-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
        }
        .notification-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }
        .stat-label {
            color: #666;
            margin-top: 5px;
        }
        .notification-filters {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter-btn {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            color: #495057;
            padding: 8px 16px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .filter-btn.active, .filter-btn:hover {
            background: #007bff;
            border-color: #007bff;
            color: white;
        }
        .notifications-list {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .notification-item {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }
        .notification-item:hover {
            background: #f8f9fa;
        }
        .notification-item.unread {
            background: #e7f3ff;
            border-left: 4px solid #007bff;
        }
        .notification-item.urgent {
            border-left: 4px solid #dc3545;
        }
        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 1.2rem;
        }
        .notification-content {
            flex: 1;
        }
        .notification-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .notification-message {
            color: #666;
            margin-bottom: 5px;
        }
        .notification-time {
            font-size: 0.8rem;
            color: #999;
        }
        .notification-actions {
            display: flex;
            gap: 10px;
        }
        .action-btn {
            background: transparent;
            border: 1px solid #dee2e6;
            color: #666;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .action-btn:hover {
            background: #007bff;
            border-color: #007bff;
            color: white;
        }
        .mark-all-read {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .notification-settings {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-top: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .setting-item:last-child {
            border-bottom: none;
        }
        .toggle-switch {
            position: relative;
            width: 50px;
            height: 25px;
            background: #ccc;
            border-radius: 25px;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        .toggle-switch.active {
            background: #007bff;
        }
        .toggle-switch::after {
            content: '';
            position: absolute;
            top: 2px;
            left: 2px;
            width: 21px;
            height: 21px;
            background: white;
            border-radius: 50%;
            transition: transform 0.3s ease;
        }
        .toggle-switch.active::after {
            transform: translateX(25px);
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .notification-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="notifications-container">
        <!-- Header -->
        <div class="notifications-header">
            <h1><i class="fas fa-bell"></i> Notifications</h1>
            <p>Stay updated with your courses, assignments, and important announcements</p>
        </div>

        <!-- Statistics -->
        <div class="notification-stats">
            <div class="stat-card">
                <div class="stat-number" id="unreadCount">5</div>
                <div class="stat-label">Unread</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="todayCount">8</div>
                <div class="stat-label">Today</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="urgentCount">2</div>
                <div class="stat-label">Urgent</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="totalCount">23</div>
                <div class="stat-label">Total</div>
            </div>
        </div>

        <!-- Filters -->
        <div class="notification-filters">
            <h6><i class="fas fa-filter"></i> Filter Notifications</h6>
            <div class="filter-buttons">
                <div class="filter-btn active" data-filter="all" onclick="filterNotifications('all')">
                    <i class="fas fa-list"></i> All
                </div>
                <div class="filter-btn" data-filter="unread" onclick="filterNotifications('unread')">
                    <i class="fas fa-circle"></i> Unread
                </div>
                <div class="filter-btn" data-filter="urgent" onclick="filterNotifications('urgent')">
                    <i class="fas fa-exclamation"></i> Urgent
                </div>
                <div class="filter-btn" data-filter="assignments" onclick="filterNotifications('assignments')">
                    <i class="fas fa-tasks"></i> Assignments
                </div>
                <div class="filter-btn" data-filter="grades" onclick="filterNotifications('grades')">
                    <i class="fas fa-chart-bar"></i> Grades
                </div>
                <div class="filter-btn" data-filter="courses" onclick="filterNotifications('courses')">
                    <i class="fas fa-book"></i> Courses
                </div>
                <div class="filter-btn" data-filter="system" onclick="filterNotifications('system')">
                    <i class="fas fa-cog"></i> System
                </div>
            </div>
            <button class="mark-all-read" onclick="markAllAsRead()">
                <i class="fas fa-check-double"></i> Mark All as Read
            </button>
        </div>

        <!-- Notifications List -->
        <div class="notifications-list">
            <!-- Urgent Assignment Notification -->
            <div class="notification-item unread urgent" data-category="assignments" data-id="1">
                <div class="notification-icon" style="background: #dc3545;">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Assignment Due Tomorrow!</div>
                    <div class="notification-message">Binary Search Algorithm Implementation is due tomorrow at 11:59 PM</div>
                    <div class="notification-time">2 hours ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewAssignment(1)">
                        <i class="fas fa-eye"></i> View
                    </button>
                    <button class="action-btn" onclick="markAsRead(1)">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
                <div class="notification-badge">!</div>
            </div>

            <!-- Grade Posted Notification -->
            <div class="notification-item unread" data-category="grades" data-id="2">
                <div class="notification-icon" style="background: #28a745;">
                    <i class="fas fa-star"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Grade Posted: Data Structures Quiz</div>
                    <div class="notification-message">You scored 87% on the Data Structures Quiz. Great work!</div>
                    <div class="notification-time">4 hours ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewGrade(2)">
                        <i class="fas fa-chart-bar"></i> View Grade
                    </button>
                    <button class="action-btn" onclick="markAsRead(2)">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
            </div>

            <!-- New Course Material -->
            <div class="notification-item unread" data-category="courses" data-id="3">
                <div class="notification-icon" style="background: #007bff;">
                    <i class="fas fa-book-open"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">New Material Added: Advanced Algorithms</div>
                    <div class="notification-message">Dr. Smith has uploaded new lecture notes and video materials</div>
                    <div class="notification-time">6 hours ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewCourse(3)">
                        <i class="fas fa-play"></i> View Material
                    </button>
                    <button class="action-btn" onclick="markAsRead(3)">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
            </div>

            <!-- Live Class Reminder -->
            <div class="notification-item unread urgent" data-category="courses" data-id="4">
                <div class="notification-icon" style="background: #ff6b35;">
                    <i class="fas fa-video"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Live Class Starting Soon</div>
                    <div class="notification-message">Computer Science 101 live session starts in 30 minutes</div>
                    <div class="notification-time">30 minutes ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="joinClass(4)">
                        <i class="fas fa-video"></i> Join Class
                    </button>
                    <button class="action-btn" onclick="markAsRead(4)">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
                <div class="notification-badge">Live</div>
            </div>

            <!-- Assignment Feedback -->
            <div class="notification-item unread" data-category="assignments" data-id="5">
                <div class="notification-icon" style="background: #6f42c1;">
                    <i class="fas fa-comment"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Feedback Available: Python Project</div>
                    <div class="notification-message">Your instructor has provided detailed feedback on your Python project</div>
                    <div class="notification-time">8 hours ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewFeedback(5)">
                        <i class="fas fa-comments"></i> View Feedback
                    </button>
                    <button class="action-btn" onclick="markAsRead(5)">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
            </div>

            <!-- System Maintenance -->
            <div class="notification-item" data-category="system" data-id="6">
                <div class="notification-icon" style="background: #ffc107;">
                    <i class="fas fa-wrench"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Scheduled Maintenance</div>
                    <div class="notification-message">System maintenance scheduled for tonight 2:00 AM - 4:00 AM EST</div>
                    <div class="notification-time">1 day ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewDetails(6)">
                        <i class="fas fa-info"></i> Details
                    </button>
                </div>
            </div>

            <!-- Course Enrollment Confirmation -->
            <div class="notification-item" data-category="courses" data-id="7">
                <div class="notification-icon" style="background: #17a2b8;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">Course Enrollment Confirmed</div>
                    <div class="notification-message">Successfully enrolled in Advanced Database Management</div>
                    <div class="notification-time">2 days ago</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="viewCourse(7)">
                        <i class="fas fa-book"></i> View Course
                    </button>
                </div>
            </div>
        </div>

        <!-- Notification Settings -->
        <div class="notification-settings">
            <h5><i class="fas fa-cog"></i> Notification Preferences</h5>
            <div class="setting-item">
                <div>
                    <strong>Email Notifications</strong>
                    <div class="text-muted">Receive notifications via email</div>
                </div>
                <div class="toggle-switch active" onclick="toggleSetting(this)"></div>
            </div>
            <div class="setting-item">
                <div>
                    <strong>Assignment Reminders</strong>
                    <div class="text-muted">Get reminders before assignment due dates</div>
                </div>
                <div class="toggle-switch active" onclick="toggleSetting(this)"></div>
            </div>
            <div class="setting-item">
                <div>
                    <strong>Grade Notifications</strong>
                    <div class="text-muted">Be notified when grades are posted</div>
                </div>
                <div class="toggle-switch active" onclick="toggleSetting(this)"></div>
            </div>
            <div class="setting-item">
                <div>
                    <strong>Course Updates</strong>
                    <div class="text-muted">Notifications for new course materials</div>
                </div>
                <div class="toggle-switch active" onclick="toggleSetting(this)"></div>
            </div>
            <div class="setting-item">
                <div>
                    <strong>Live Class Reminders</strong>
                    <div class="text-muted">Reminders before live classes start</div>
                </div>
                <div class="toggle-switch active" onclick="toggleSetting(this)"></div>
            </div>
            <div class="setting-item">
                <div>
                    <strong>System Announcements</strong>
                    <div class="text-muted">Important system updates and maintenance</div>
                </div>
                <div class="toggle-switch" onclick="toggleSetting(this)"></div>
            </div>
        </div>
    </div>

    <script>
        function filterNotifications(category) {
            // Update active filter button
            document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelector(`[data-filter="${category}"]`).classList.add('active');

            // Show/hide notifications based on filter
            document.querySelectorAll('.notification-item').forEach(item => {
                if (category === 'all' || 
                    (category === 'unread' && item.classList.contains('unread')) ||
                    (category === 'urgent' && item.classList.contains('urgent')) ||
                    item.dataset.category === category) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }

        function markAsRead(id) {
            const notification = document.querySelector(`[data-id="${id}"]`);
            notification.classList.remove('unread');
            
            // Update unread count
            const unreadCount = document.getElementById('unreadCount');
            unreadCount.textContent = parseInt(unreadCount.textContent) - 1;
        }

        function markAllAsRead() {
            document.querySelectorAll('.notification-item.unread').forEach(item => {
                item.classList.remove('unread');
            });
            
            // Reset unread count
            document.getElementById('unreadCount').textContent = '0';
            
            alert('All notifications marked as read!');
        }

        function toggleSetting(toggle) {
            toggle.classList.toggle('active');
        }

        function viewAssignment(id) {
            window.location.href = 'Assignments.aspx';
        }

        function viewGrade(id) {
            window.location.href = 'Grades.aspx';
        }

        function viewCourse(id) {
            window.location.href = 'MyCourses.aspx';
        }

        function joinClass(id) {
            window.location.href = 'LiveClasses.aspx';
        }

        function viewFeedback(id) {
            alert('Opening assignment feedback...');
        }

        function viewDetails(id) {
            alert('Showing maintenance details...');
        }

        // Simulate real-time notifications
        function simulateNewNotification() {
            const notifications = [
                {
                    title: 'New Message from Instructor',
                    message: 'Dr. Johnson sent you a message about your project',
                    icon: 'fas fa-envelope',
                    color: '#28a745'
                },
                {
                    title: 'Quiz Available',
                    message: 'New quiz available: JavaScript Fundamentals',
                    icon: 'fas fa-question-circle',
                    color: '#ffc107'
                }
            ];

            const notification = notifications[Math.floor(Math.random() * notifications.length)];
            
            // Create notification element
            const notificationElement = document.createElement('div');
            notificationElement.className = 'notification-item unread';
            notificationElement.dataset.category = 'system';
            notificationElement.dataset.id = Date.now();
            
            notificationElement.innerHTML = `
                <div class="notification-icon" style="background: ${notification.color};">
                    <i class="${notification.icon}"></i>
                </div>
                <div class="notification-content">
                    <div class="notification-title">${notification.title}</div>
                    <div class="notification-message">${notification.message}</div>
                    <div class="notification-time">Just now</div>
                </div>
                <div class="notification-actions">
                    <button class="action-btn" onclick="markAsRead(${Date.now()})">
                        <i class="fas fa-check"></i> Mark Read
                    </button>
                </div>
            `;

            // Add to top of notifications list
            const notificationsList = document.querySelector('.notifications-list');
            notificationsList.insertBefore(notificationElement, notificationsList.firstChild);

            // Update counts
            const unreadCount = document.getElementById('unreadCount');
            unreadCount.textContent = parseInt(unreadCount.textContent) + 1;

            const totalCount = document.getElementById('totalCount');
            totalCount.textContent = parseInt(totalCount.textContent) + 1;

            // Show browser notification if supported
            if ('Notification' in window && Notification.permission === 'granted') {
                new Notification(notification.title, {
                    body: notification.message,
                    icon: '/Images/logo.png'
                });
            }
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Request notification permission
            if ('Notification' in window && Notification.permission === 'default') {
                Notification.requestPermission();
            }

            // Simulate new notifications every 30 seconds
            setInterval(simulateNewNotification, 30000);
        });
    </script>
</asp:Content>
