<%@ Page Title="Timetable" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Timetable.aspx.cs" Inherits="AGMSolutions.Students.Timetable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .timetable-container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .timetable-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        .week-navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .timetable-grid {
            display: grid;
            grid-template-columns: 100px repeat(7, 1fr);
            gap: 1px;
            background: #dee2e6;
            border-radius: 10px;
            overflow: hidden;
        }
        .time-slot, .day-header, .class-cell {
            background: white;
            padding: 15px;
            text-align: center;
            position: relative;
        }
        .day-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
            font-size: 14px;
        }
        .time-slot {
            background: #f8f9fa;
            font-weight: 600;
            font-size: 12px;
            color: #495057;
        }
        .class-cell {
            min-height: 80px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .class-cell:hover {
            background: #f0f8ff;
        }
        .class-item {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 8px;
            border-radius: 8px;
            font-size: 12px;
            text-align: left;
            margin: 2px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .class-item.lecture {
            background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%);
        }
        .class-item.lab {
            background: linear-gradient(135deg, #fd7e14 0%, #e83e8c 100%);
        }
        .class-item.tutorial {
            background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
        }
        .class-title {
            font-weight: bold;
            margin-bottom: 2px;
        }
        .class-details {
            font-size: 10px;
            opacity: 0.9;
        }
        .legend {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        .legend-color {
            width: 16px;
            height: 16px;
            border-radius: 4px;
        }
        .current-time-indicator {
            position: absolute;
            width: 100%;
            height: 2px;
            background: #dc3545;
            z-index: 10;
            box-shadow: 0 0 5px rgba(220, 53, 69, 0.5);
        }
        .today-column {
            background: rgba(40, 167, 69, 0.1) !important;
        }
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="timetable-container">
        <div class="timetable-header">
            <h1><i class="fas fa-calendar-alt"></i> Weekly Timetable</h1>
            <p class="text-muted">Your class schedule and important events</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-value">16</div>
                <div class="stat-label">Classes This Week</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">4</div>
                <div class="stat-label">Total Courses</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">87%</div>
                <div class="stat-label">Attendance Rate</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">2</div>
                <div class="stat-label">Upcoming Exams</div>
            </div>
        </div>

        <!-- Week Navigation -->
        <div class="week-navigation">
            <button class="btn btn-outline-primary" onclick="previousWeek()">
                <i class="fas fa-chevron-left"></i> Previous Week
            </button>
            <h4 id="currentWeek">
                Week of <span id="weekDate">August 5 - August 11, 2024</span>
            </h4>
            <button class="btn btn-outline-primary" onclick="nextWeek()">
                Next Week <i class="fas fa-chevron-right"></i>
            </button>
        </div>

        <!-- Timetable Grid -->
        <div class="timetable-grid">
            <!-- Header Row -->
            <div class="time-slot">Time</div>
            <div class="day-header">Monday</div>
            <div class="day-header">Tuesday</div>
            <div class="day-header today-column">Wednesday</div>
            <div class="day-header">Thursday</div>
            <div class="day-header">Friday</div>
            <div class="day-header">Saturday</div>
            <div class="day-header">Sunday</div>

            <!-- 8:00 AM Row -->
            <div class="time-slot">8:00 AM</div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">Computer Science 101</div>
                    <div class="class-details">Room: CS-101 | Dr. Smith</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">Mathematics 201</div>
                    <div class="class-details">Room: M-205 | Prof. Johnson</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">Computer Science 101</div>
                    <div class="class-details">Room: CS-101 | Dr. Smith</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>

            <!-- 10:00 AM Row -->
            <div class="time-slot">10:00 AM</div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item lab">
                    <div class="class-title">Programming Lab</div>
                    <div class="class-details">Lab: CS-201 | TA: Mike</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item lab">
                    <div class="class-title">Programming Lab</div>
                    <div class="class-details">Lab: CS-201 | TA: Mike</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item tutorial">
                    <div class="class-title">Math Tutorial</div>
                    <div class="class-details">Room: M-101 | TA: Sarah</div>
                </div>
            </div>
            <div class="class-cell"></div>

            <!-- 12:00 PM Row -->
            <div class="time-slot">12:00 PM</div>
            <div class="class-cell">
                <div style="background: #ffc107; color: #212529; padding: 8px; border-radius: 8px; font-size: 12px;">
                    <div class="class-title">LUNCH BREAK</div>
                </div>
            </div>
            <div class="class-cell">
                <div style="background: #ffc107; color: #212529; padding: 8px; border-radius: 8px; font-size: 12px;">
                    <div class="class-title">LUNCH BREAK</div>
                </div>
            </div>
            <div class="class-cell">
                <div style="background: #ffc107; color: #212529; padding: 8px; border-radius: 8px; font-size: 12px;">
                    <div class="class-title">LUNCH BREAK</div>
                </div>
            </div>
            <div class="class-cell">
                <div style="background: #ffc107; color: #212529; padding: 8px; border-radius: 8px; font-size: 12px;">
                    <div class="class-title">LUNCH BREAK</div>
                </div>
            </div>
            <div class="class-cell">
                <div style="background: #ffc107; color: #212529; padding: 8px; border-radius: 8px; font-size: 12px;">
                    <div class="class-title">LUNCH BREAK</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>

            <!-- 2:00 PM Row -->
            <div class="time-slot">2:00 PM</div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">English 101</div>
                    <div class="class-details">Room: E-102 | Prof. Davis</div>
                </div>
            </div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">Mathematics 201</div>
                    <div class="class-details">Room: M-205 | Prof. Johnson</div>
                </div>
            </div>
            <div class="class-cell">
                <div class="class-item lecture">
                    <div class="class-title">English 101</div>
                    <div class="class-details">Room: E-102 | Prof. Davis</div>
                </div>
                <div class="current-time-indicator" style="top: 50%;"></div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>

            <!-- 4:00 PM Row -->
            <div class="time-slot">4:00 PM</div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
            <div class="class-cell">
                <div class="class-item tutorial">
                    <div class="class-title">Study Group</div>
                    <div class="class-details">Library | Self-Study</div>
                </div>
            </div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
            <div class="class-cell"></div>
        </div>

        <!-- Legend -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #007bff 0%, #6f42c1 100%);"></div>
                <span>Lecture</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #fd7e14 0%, #e83e8c 100%);"></div>
                <span>Lab</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);"></div>
                <span>Tutorial</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: #ffc107;"></div>
                <span>Break</span>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="text-center mt-4">
            <button class="btn btn-primary me-2" onclick="exportTimetable()">
                <i class="fas fa-download"></i> Export to PDF
            </button>
            <button class="btn btn-success me-2" onclick="addToCalendar()">
                <i class="fas fa-calendar-plus"></i> Add to Calendar
            </button>
            <button class="btn btn-info" onclick="shareTimetable()">
                <i class="fas fa-share-alt"></i> Share Timetable
            </button>
        </div>
    </div>

    <script>
        // Current week tracking
        let currentWeekOffset = 0;

        function previousWeek() {
            currentWeekOffset--;
            updateWeekDisplay();
        }

        function nextWeek() {
            currentWeekOffset++;
            updateWeekDisplay();
        }

        function updateWeekDisplay() {
            const baseDate = new Date();
            baseDate.setDate(baseDate.getDate() + (currentWeekOffset * 7));
            
            const startOfWeek = new Date(baseDate);
            startOfWeek.setDate(baseDate.getDate() - baseDate.getDay() + 1); // Monday
            
            const endOfWeek = new Date(startOfWeek);
            endOfWeek.setDate(startOfWeek.getDate() + 6); // Sunday
            
            const formatOptions = { month: 'long', day: 'numeric' };
            const weekString = `${startOfWeek.toLocaleDateString('en-US', formatOptions)} - ${endOfWeek.toLocaleDateString('en-US', formatOptions)}, ${endOfWeek.getFullYear()}`;
            
            document.getElementById('weekDate').textContent = weekString;
            
            // Update today highlight
            highlightToday();
        }

        function highlightToday() {
            // Remove existing today highlight
            document.querySelectorAll('.today-column').forEach(col => {
                col.classList.remove('today-column');
            });
            
            // Add today highlight if current week
            if (currentWeekOffset === 0) {
                const today = new Date().getDay();
                const dayHeaders = document.querySelectorAll('.day-header');
                const classCells = document.querySelectorAll('.class-cell');
                
                if (today >= 1 && today <= 7) { // Monday to Sunday
                    const todayIndex = today === 0 ? 7 : today; // Sunday = 7, Monday = 1
                    if (dayHeaders[todayIndex]) {
                        dayHeaders[todayIndex].classList.add('today-column');
                    }
                }
            }
        }

        function exportTimetable() {
            alert('Exporting timetable to PDF... (Feature in development)');
        }

        function addToCalendar() {
            alert('Adding classes to calendar... (Feature in development)');
        }

        function shareTimetable() {
            if (navigator.share) {
                navigator.share({
                    title: 'My AGM Solutions Timetable',
                    text: 'Check out my weekly class schedule!',
                    url: window.location.href
                });
            } else {
                alert('Share feature not supported on this browser');
            }
        }

        // Initialize current time indicator
        function updateCurrentTimeIndicator() {
            const now = new Date();
            const currentHour = now.getHours();
            const currentMinute = now.getMinutes();
            
            // Remove existing indicators
            document.querySelectorAll('.current-time-indicator').forEach(indicator => {
                indicator.remove();
            });
            
            // Only show during class hours (8 AM to 6 PM) and if it's today
            if (currentHour >= 8 && currentHour < 18 && currentWeekOffset === 0) {
                const today = new Date().getDay();
                if (today >= 1 && today <= 5) { // Monday to Friday
                    // Calculate position and add indicator (simplified)
                    // This would need more complex logic for exact positioning
                }
            }
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            updateWeekDisplay();
            updateCurrentTimeIndicator();
            
            // Update current time indicator every minute
            setInterval(updateCurrentTimeIndicator, 60000);
        });
    </script>
</asp:Content>
