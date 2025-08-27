<%@ Page Title="Analytics" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="AGMSolutions.Students.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .analytics-container {
            max-width: 1400px;
            margin: 20px auto;
            padding: 20px;
        }
        .analytics-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #333;
        }
        .stat-label {
            font-size: 1rem;
            color: #666;
            margin-top: 5px;
        }
        .stat-change {
            font-size: 0.9rem;
            margin-top: 10px;
        }
        .stat-change.positive {
            color: #28a745;
        }
        .stat-change.negative {
            color: #dc3545;
        }
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .chart-wrapper {
            position: relative;
            height: 400px;
        }
        .progress-ring {
            width: 120px;
            height: 120px;
            margin: 0 auto;
        }
        .progress-ring-circle {
            stroke: #007bff;
            stroke-width: 4;
            fill: transparent;
            stroke-dasharray: 283;
            stroke-dashoffset: 283;
            transition: stroke-dashoffset 0.5s;
        }
        .progress-ring-bg {
            stroke: #e9ecef;
            stroke-width: 4;
            fill: transparent;
        }
        .activity-timeline {
            max-height: 400px;
            overflow-y: auto;
        }
        .timeline-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .timeline-item:last-child {
            border-bottom: none;
        }
        .timeline-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
        }
        .timeline-content {
            flex: 1;
        }
        .timeline-time {
            font-size: 0.8rem;
            color: #666;
        }
        .grade-breakdown {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .grade-item {
            background: linear-gradient(135deg, #007bff, #28a745);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        .grade-subject {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .grade-score {
            font-size: 2rem;
            font-weight: bold;
        }
        .grade-change {
            font-size: 0.9rem;
            margin-top: 5px;
            opacity: 0.9;
        }
        .learning-path {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .path-step {
            display: flex;
            align-items: center;
            padding: 15px 0;
            position: relative;
        }
        .path-step:not(:last-child)::after {
            content: '';
            position: absolute;
            left: 20px;
            top: 50px;
            bottom: -15px;
            width: 2px;
            background: #dee2e6;
        }
        .path-step.completed::after {
            background: #28a745;
        }
        .path-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-weight: bold;
            color: white;
            z-index: 1;
            position: relative;
        }
        .path-step.completed .path-number {
            background: #28a745;
        }
        .path-step.current .path-number {
            background: #007bff;
        }
        .path-step.upcoming .path-number {
            background: #6c757d;
        }
        .recommendations {
            background: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 20px;
            border-radius: 0 10px 10px 0;
            margin: 20px 0;
        }
        .recommendation-item {
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .recommendation-item:last-child {
            border-bottom: none;
        }
        .filter-controls {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="analytics-container">
        <!-- Header -->
        <div class="analytics-header">
            <h1><i class="fas fa-chart-line"></i> Learning Analytics Dashboard</h1>
            <p>Track your progress, analyze performance, and optimize your learning journey</p>
        </div>

        <!-- Filter Controls -->
        <div class="filter-controls">
            <div class="row align-items-center">
                <div class="col-md-3">
                    <label>Time Period:</label>
                    <select class="form-select" onchange="updateAnalytics()">
                        <option value="week">This Week</option>
                        <option value="month" selected>This Month</option>
                        <option value="semester">This Semester</option>
                        <option value="year">This Year</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label>Subject Filter:</label>
                    <select class="form-select" onchange="updateAnalytics()">
                        <option value="all">All Subjects</option>
                        <option value="cs">Computer Science</option>
                        <option value="math">Mathematics</option>
                        <option value="eng">English</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label>Metric Type:</label>
                    <select class="form-select" onchange="updateAnalytics()">
                        <option value="performance">Performance</option>
                        <option value="engagement">Engagement</option>
                        <option value="time">Time Spent</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button class="btn btn-primary w-100 mt-3" onclick="exportAnalytics()">
                        <i class="fas fa-download"></i> Export Report
                    </button>
                </div>
            </div>
        </div>

        <!-- Key Metrics -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-number">87.5%</div>
                            <div class="stat-label">Average Grade</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-up"></i> +5.2% from last month
                            </div>
                        </div>
                        <div class="text-primary" style="font-size: 2.5rem;">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-number">42</div>
                            <div class="stat-label">Study Hours</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-up"></i> +8 hours this week
                            </div>
                        </div>
                        <div class="text-success" style="font-size: 2.5rem;">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-number">12</div>
                            <div class="stat-label">Assignments Completed</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-up"></i> 3 this week
                            </div>
                        </div>
                        <div class="text-info" style="font-size: 2.5rem;">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stat-number">96%</div>
                            <div class="stat-label">Attendance Rate</div>
                            <div class="stat-change negative">
                                <i class="fas fa-arrow-down"></i> -2% from last month
                            </div>
                        </div>
                        <div class="text-warning" style="font-size: 2.5rem;">
                            <i class="fas fa-user-check"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row mb-4">
            <div class="col-lg-8">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-area"></i> Performance Trends</h5>
                    <div class="chart-wrapper">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-pie"></i> Study Time Distribution</h5>
                    <div class="chart-wrapper">
                        <canvas id="studyTimeChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Subject Performance and Progress -->
        <div class="row mb-4">
            <div class="col-lg-6">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-bar"></i> Subject Performance</h5>
                    <div class="grade-breakdown">
                        <div class="grade-item" style="background: linear-gradient(135deg, #007bff, #0056b3);">
                            <div class="grade-subject">Computer Science</div>
                            <div class="grade-score">95%</div>
                            <div class="grade-change">+3% this month</div>
                        </div>
                        <div class="grade-item" style="background: linear-gradient(135deg, #28a745, #1e7e34);">
                            <div class="grade-subject">Mathematics</div>
                            <div class="grade-score">88%</div>
                            <div class="grade-change">+1% this month</div>
                        </div>
                        <div class="grade-item" style="background: linear-gradient(135deg, #ffc107, #e0a800);">
                            <div class="grade-subject">English</div>
                            <div class="grade-score">92%</div>
                            <div class="grade-change">+5% this month</div>
                        </div>
                        <div class="grade-item" style="background: linear-gradient(135deg, #dc3545, #c82333);">
                            <div class="grade-subject">Physics</div>
                            <div class="grade-score">75%</div>
                            <div class="grade-change">-2% this month</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-line"></i> Weekly Activity</h5>
                    <div class="chart-wrapper">
                        <canvas id="weeklyActivityChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Learning Path and Recommendations -->
        <div class="row mb-4">
            <div class="col-lg-8">
                <div class="learning-path">
                    <h5><i class="fas fa-route"></i> Learning Path Progress</h5>
                    <div class="path-step completed">
                        <div class="path-number">1</div>
                        <div>
                            <h6>Programming Fundamentals</h6>
                            <p class="text-muted mb-0">Variables, Data Types, Control Structures</p>
                            <small class="text-success">Completed on July 15, 2024</small>
                        </div>
                    </div>
                    <div class="path-step completed">
                        <div class="path-number">2</div>
                        <div>
                            <h6>Object-Oriented Programming</h6>
                            <p class="text-muted mb-0">Classes, Objects, Inheritance, Polymorphism</p>
                            <small class="text-success">Completed on August 5, 2024</small>
                        </div>
                    </div>
                    <div class="path-step current">
                        <div class="path-number">3</div>
                        <div>
                            <h6>Data Structures & Algorithms</h6>
                            <p class="text-muted mb-0">Arrays, Linked Lists, Trees, Sorting</p>
                            <small class="text-primary">In Progress - 65% Complete</small>
                        </div>
                    </div>
                    <div class="path-step upcoming">
                        <div class="path-number">4</div>
                        <div>
                            <h6>Database Management</h6>
                            <p class="text-muted mb-0">SQL, Database Design, Normalization</p>
                            <small class="text-muted">Starts September 1, 2024</small>
                        </div>
                    </div>
                    <div class="path-step upcoming">
                        <div class="path-number">5</div>
                        <div>
                            <h6>Web Development</h6>
                            <p class="text-muted mb-0">HTML, CSS, JavaScript, Frameworks</p>
                            <small class="text-muted">Starts October 1, 2024</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="chart-container">
                    <h5><i class="fas fa-lightbulb"></i> AI-Powered Recommendations</h5>
                    <div class="recommendations">
                        <div class="recommendation-item">
                            <h6><i class="fas fa-star text-warning"></i> Focus Area</h6>
                            <p class="mb-1">Spend more time on Physics problems to improve your grade.</p>
                            <small class="text-muted">Based on recent quiz performance</small>
                        </div>
                        <div class="recommendation-item">
                            <h6><i class="fas fa-clock text-info"></i> Study Schedule</h6>
                            <p class="mb-1">Your most productive time is 9-11 AM. Schedule important topics then.</p>
                            <small class="text-muted">Based on activity analysis</small>
                        </div>
                        <div class="recommendation-item">
                            <h6><i class="fas fa-users text-success"></i> Study Group</h6>
                            <p class="mb-1">Join study groups for Data Structures. Your performance improves with collaboration.</p>
                            <small class="text-muted">Based on learning patterns</small>
                        </div>
                    </div>
                    
                    <h6 class="mt-4"><i class="fas fa-trophy"></i> Achievement Progress</h6>
                    <div class="text-center">
                        <svg class="progress-ring" width="120" height="120">
                            <circle class="progress-ring-bg" cx="60" cy="60" r="45"/>
                            <circle class="progress-ring-circle" cx="60" cy="60" r="45" 
                                    style="stroke-dashoffset: calc(283 - (283 * 75) / 100);"/>
                        </svg>
                        <div class="mt-2">
                            <strong>75%</strong> to next achievement<br>
                            <small class="text-muted">"Data Master" Badge</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity Timeline -->
        <div class="chart-container">
            <h5><i class="fas fa-history"></i> Recent Learning Activity</h5>
            <div class="activity-timeline">
                <div class="timeline-item">
                    <div class="timeline-icon" style="background: #28a745;">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="timeline-content">
                        <h6>Completed Assignment: Binary Search Implementation</h6>
                        <p class="mb-1">Scored 95% on your binary search algorithm assignment</p>
                        <div class="timeline-time">2 hours ago</div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-icon" style="background: #007bff;">
                        <i class="fas fa-video"></i>
                    </div>
                    <div class="timeline-content">
                        <h6>Attended Live Class: Advanced Sorting Algorithms</h6>
                        <p class="mb-1">Participated in live discussion about QuickSort optimization</p>
                        <div class="timeline-time">1 day ago</div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-icon" style="background: #ffc107;">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="timeline-content">
                        <h6>Achievement Unlocked: Problem Solver</h6>
                        <p class="mb-1">Solved 10 coding challenges in a row</p>
                        <div class="timeline-time">2 days ago</div>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-icon" style="background: #dc3545;">
                        <i class="fas fa-exclamation"></i>
                    </div>
                    <div class="timeline-content">
                        <h6>Quiz Reminder: Physics Chapter 5</h6>
                        <p class="mb-1">Don't forget your quiz tomorrow at 2 PM</p>
                        <div class="timeline-time">3 days ago</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Performance Trends Chart
        const performanceCtx = document.getElementById('performanceChart').getContext('2d');
        new Chart(performanceCtx, {
            type: 'line',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Week 7', 'Week 8'],
                datasets: [{
                    label: 'Overall Grade %',
                    data: [75, 78, 82, 85, 83, 87, 89, 87.5],
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Assignment Scores %',
                    data: [80, 82, 85, 88, 86, 90, 92, 90],
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Quiz Scores %',
                    data: [70, 74, 79, 82, 80, 84, 86, 85],
                    borderColor: '#ffc107',
                    backgroundColor: 'rgba(255, 193, 7, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: false,
                        min: 60,
                        max: 100
                    }
                }
            }
        });

        // Study Time Distribution Chart
        const studyTimeCtx = document.getElementById('studyTimeChart').getContext('2d');
        new Chart(studyTimeCtx, {
            type: 'doughnut',
            data: {
                labels: ['Computer Science', 'Mathematics', 'English', 'Physics'],
                datasets: [{
                    data: [35, 25, 20, 20],
                    backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Weekly Activity Chart
        const weeklyActivityCtx = document.getElementById('weeklyActivityChart').getContext('2d');
        new Chart(weeklyActivityCtx, {
            type: 'bar',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Hours Studied',
                    data: [6, 8, 5, 7, 9, 4, 3],
                    backgroundColor: 'rgba(0, 123, 255, 0.8)',
                    borderColor: '#007bff',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 10
                    }
                }
            }
        });

        function updateAnalytics() {
            // In a real implementation, this would fetch new data based on filters
            alert('Analytics updated based on your filter selection!');
        }

        function exportAnalytics() {
            // In a real implementation, this would generate and download a report
            alert('Analytics report exported successfully!');
        }
    </script>
</asp:Content>
