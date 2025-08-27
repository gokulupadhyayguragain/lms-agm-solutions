<%@ Page Title="Advanced Analytics" Language="C#" MasterPageFile="~/MasterPages/Admin.master" AutoEventWireup="true" CodeFile="Analytics.aspx.cs" Inherits="Admins_Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/date-fns@2.29.3/index.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .analytics-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .analytics-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }
        
        .analytics-hero h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }
        
        .analytics-hero p {
            font-size: 1.2rem;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }
        
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .kpi-card {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border-left: 4px solid #007bff;
        }
        
        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(0,123,255,0.1) 0%, rgba(0,123,255,0.05) 100%);
            border-radius: 0 1rem 0 50%;
        }
        
        .kpi-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .kpi-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: #007bff;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }
        
        .kpi-label {
            color: #6c757d;
            font-weight: 500;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .kpi-trend {
            display: flex;
            align-items: center;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .trend-up {
            color: #28a745;
        }
        
        .trend-down {
            color: #dc3545;
        }
        
        .trend-neutral {
            color: #6c757d;
        }
        
        .chart-section {
            background: white;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .chart-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #343a40;
            margin: 0;
        }
        
        .chart-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .date-range-selector {
            display: flex;
            gap: 0.5rem;
        }
        
        .date-btn {
            padding: 0.5rem 1rem;
            border: 2px solid #e9ecef;
            background: white;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .date-btn.active,
        .date-btn:hover {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        
        .chart-container {
            position: relative;
            height: 400px;
            margin-bottom: 1rem;
        }
        
        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .insights-panel {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .insight-item {
            background: white;
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-left: 4px solid #28a745;
        }
        
        .insight-item:last-child {
            margin-bottom: 0;
        }
        
        .insight-title {
            font-weight: 600;
            color: #343a40;
            margin-bottom: 0.5rem;
        }
        
        .insight-description {
            color: #6c757d;
            line-height: 1.6;
        }
        
        .filter-panel {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        
        .export-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 1rem;
            z-index: 10;
        }
        
        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @media (max-width: 768px) {
            .chart-grid {
                grid-template-columns: 1fr;
            }
            
            .chart-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
            
            .analytics-hero h1 {
                font-size: 2rem;
            }
            
            .kpi-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <!-- Hero Section -->
    <div class="analytics-hero">
        <div class="container">
            <h1><i class="fas fa-chart-bar me-3"></i>Advanced Analytics Dashboard</h1>
            <p>Comprehensive insights and data visualization for informed decision making</p>
        </div>
    </div>

    <div class="container-fluid">
        <!-- Export Actions -->
        <div class="export-actions">
            <asp:Button ID="btnExportPDF" runat="server" Text="Export PDF" 
                CssClass="btn btn-outline-danger" OnClick="ExportToPDF" />
            <asp:Button ID="btnExportExcel" runat="server" Text="Export Excel" 
                CssClass="btn btn-outline-success" OnClick="ExportToExcel" />
            <asp:Button ID="btnScheduleReport" runat="server" Text="Schedule Report" 
                CssClass="btn btn-outline-info" OnClick="ScheduleReport" />
        </div>

        <!-- Filters Panel -->
        <div class="filter-panel">
            <h5 class="mb-3"><i class="fas fa-filter me-2"></i>Analytics Filters</h5>
            <div class="filter-row">
                <div class="form-group">
                    <label class="form-label">Date Range</label>
                    <select id="dateRange" class="form-select" onchange="updateDateRange()">
                        <option value="7">Last 7 Days</option>
                        <option value="30" selected>Last 30 Days</option>
                        <option value="90">Last 3 Months</option>
                        <option value="365">Last Year</option>
                        <option value="custom">Custom Range</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">User Type</label>
                    <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="all" Text="All Users" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="students" Text="Students Only"></asp:ListItem>
                        <asp:ListItem Value="lecturers" Text="Lecturers Only"></asp:ListItem>
                        <asp:ListItem Value="admins" Text="Admins Only"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label class="form-label">Department</label>
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Value="all" Text="All Departments" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" 
                        CssClass="btn btn-primary" OnClick="ApplyFilters" />
                </div>
            </div>
        </div>

        <!-- KPI Grid -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-value" id="totalUsers">
                    <asp:Label ID="lblTotalUsers" runat="server" Text="1,247"></asp:Label>
                </div>
                <div class="kpi-label">Total Active Users</div>
                <div class="kpi-trend trend-up">
                    <i class="fas fa-arrow-up me-1"></i>
                    <span>+12.5% from last month</span>
                </div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-value" id="courseEnrollments">
                    <asp:Label ID="lblCourseEnrollments" runat="server" Text="3,891"></asp:Label>
                </div>
                <div class="kpi-label">Course Enrollments</div>
                <div class="kpi-trend trend-up">
                    <i class="fas fa-arrow-up me-1"></i>
                    <span>+8.3% from last month</span>
                </div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-value" id="completionRate">
                    <asp:Label ID="lblCompletionRate" runat="server" Text="87.2%"></asp:Label>
                </div>
                <div class="kpi-label">Average Completion Rate</div>
                <div class="kpi-trend trend-up">
                    <i class="fas fa-arrow-up me-1"></i>
                    <span>+5.1% from last month</span>
                </div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-value" id="avgGrade">
                    <asp:Label ID="lblAverageGrade" runat="server" Text="84.6"></asp:Label>
                </div>
                <div class="kpi-label">Average Grade</div>
                <div class="kpi-trend trend-up">
                    <i class="fas fa-arrow-up me-1"></i>
                    <span>+2.8% from last month</span>
                </div>
            </div>
        </div>

        <!-- Main Charts -->
        <div class="chart-section">
            <div class="chart-header">
                <h3 class="chart-title">User Engagement Trends</h3>
                <div class="chart-controls">
                    <div class="date-range-selector">
                        <button class="date-btn" onclick="setDateRange(7)">7D</button>
                        <button class="date-btn active" onclick="setDateRange(30)">30D</button>
                        <button class="date-btn" onclick="setDateRange(90)">3M</button>
                        <button class="date-btn" onclick="setDateRange(365)">1Y</button>
                    </div>
                </div>
            </div>
            <div class="chart-container">
                <canvas id="engagementChart"></canvas>
            </div>
        </div>

        <!-- Chart Grid -->
        <div class="chart-grid">
            <div class="chart-section">
                <div class="chart-header">
                    <h4 class="chart-title">Course Performance</h4>
                </div>
                <div class="chart-container">
                    <canvas id="coursePerformanceChart"></canvas>
                </div>
            </div>
            
            <div class="chart-section">
                <div class="chart-header">
                    <h4 class="chart-title">User Distribution</h4>
                </div>
                <div class="chart-container">
                    <canvas id="userDistributionChart"></canvas>
                </div>
            </div>
        </div>

        <div class="chart-grid">
            <div class="chart-section">
                <div class="chart-header">
                    <h4 class="chart-title">Learning Progress</h4>
                </div>
                <div class="chart-container">
                    <canvas id="learningProgressChart"></canvas>
                </div>
            </div>
            
            <div class="chart-section">
                <div class="chart-header">
                    <h4 class="chart-title">Activity Heatmap</h4>
                </div>
                <div class="chart-container">
                    <canvas id="activityHeatmapChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Insights Panel -->
        <div class="insights-panel">
            <h4 class="mb-3"><i class="fas fa-lightbulb me-2"></i>AI-Powered Insights</h4>
            
            <div class="insight-item">
                <div class="insight-title">Peak Learning Hours</div>
                <div class="insight-description">
                    Students are most active between 2:00 PM - 6:00 PM and 8:00 PM - 10:00 PM. 
                    Consider scheduling live sessions during these peak hours for maximum engagement.
                </div>
            </div>
            
            <div class="insight-item">
                <div class="insight-title">Course Completion Trends</div>
                <div class="insight-description">
                    Courses with video content have a 23% higher completion rate compared to text-only courses. 
                    Consider adding more multimedia content to improve engagement.
                </div>
            </div>
            
            <div class="insight-item">
                <div class="insight-title">Performance Correlation</div>
                <div class="insight-description">
                    Students who complete assignments within the first 3 days score 15% higher on average. 
                    Early submission reminders could improve overall performance.
                </div>
            </div>
            
            <div class="insight-item">
                <div class="insight-title">Resource Utilization</div>
                <div class="insight-description">
                    Discussion forums have low engagement (12% participation rate). 
                    Implementing gamification or incentives could boost student interaction.
                </div>
            </div>
        </div>
    </div>

    <script>
        let engagementChart, coursePerformanceChart, userDistributionChart, learningProgressChart, activityHeatmapChart;
        let currentDateRange = 30;

        document.addEventListener('DOMContentLoaded', function() {
            initializeCharts();
            updateKPIs();
        });

        function initializeCharts() {
            // User Engagement Trends Chart
            const ctx1 = document.getElementById('engagementChart').getContext('2d');
            engagementChart = new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: generateDateLabels(currentDateRange),
                    datasets: [{
                        label: 'Daily Active Users',
                        data: generateRandomData(currentDateRange, 800, 1200),
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0,123,255,0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Course Interactions',
                        data: generateRandomData(currentDateRange, 400, 800),
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40,167,69,0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Assignment Submissions',
                        data: generateRandomData(currentDateRange, 100, 300),
                        borderColor: '#ffc107',
                        backgroundColor: 'rgba(255,193,7,0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0,0,0,0.1)'
                            }
                        },
                        x: {
                            grid: {
                                color: 'rgba(0,0,0,0.05)'
                            }
                        }
                    }
                }
            });

            // Course Performance Chart
            const ctx2 = document.getElementById('coursePerformanceChart').getContext('2d');
            coursePerformanceChart = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: ['Computer Science', 'Mathematics', 'Physics', 'Chemistry', 'Biology', 'English'],
                    datasets: [{
                        label: 'Average Score',
                        data: [88, 82, 79, 85, 87, 90],
                        backgroundColor: [
                            '#007bff',
                            '#28a745',
                            '#ffc107',
                            '#dc3545',
                            '#17a2b8',
                            '#6f42c1'
                        ],
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100,
                            grid: {
                                color: 'rgba(0,0,0,0.1)'
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            // User Distribution Chart
            const ctx3 = document.getElementById('userDistributionChart').getContext('2d');
            userDistributionChart = new Chart(ctx3, {
                type: 'doughnut',
                data: {
                    labels: ['Students', 'Lecturers', 'Admins', 'Guest Users'],
                    datasets: [{
                        data: [1156, 78, 13, 45],
                        backgroundColor: ['#007bff', '#28a745', '#ffc107', '#6c757d'],
                        borderWidth: 0,
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });

            // Learning Progress Chart
            const ctx4 = document.getElementById('learningProgressChart').getContext('2d');
            learningProgressChart = new Chart(ctx4, {
                type: 'radar',
                data: {
                    labels: ['Assignments', 'Quizzes', 'Projects', 'Discussions', 'Readings', 'Videos'],
                    datasets: [{
                        label: 'Current Semester',
                        data: [85, 78, 90, 65, 88, 92],
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0,123,255,0.1)',
                        pointBackgroundColor: '#007bff',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }, {
                        label: 'Previous Semester',
                        data: [78, 72, 85, 58, 82, 87],
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40,167,69,0.1)',
                        pointBackgroundColor: '#28a745',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        r: {
                            beginAtZero: true,
                            max: 100,
                            grid: {
                                color: 'rgba(0,0,0,0.1)'
                            },
                            angleLines: {
                                color: 'rgba(0,0,0,0.1)'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    }
                }
            });

            // Activity Heatmap Chart (simplified version using bar chart)
            const ctx5 = document.getElementById('activityHeatmapChart').getContext('2d');
            activityHeatmapChart = new Chart(ctx5, {
                type: 'bar',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Morning (6-12)',
                        data: [120, 150, 140, 180, 160, 80, 60],
                        backgroundColor: '#e3f2fd'
                    }, {
                        label: 'Afternoon (12-18)',
                        data: [280, 320, 310, 350, 340, 180, 120],
                        backgroundColor: '#2196f3'
                    }, {
                        label: 'Evening (18-24)',
                        data: [220, 250, 240, 280, 270, 200, 150],
                        backgroundColor: '#0d47a1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            stacked: true,
                            grid: {
                                display: false
                            }
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0,0,0,0.1)'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    }
                }
            });
        }

        function generateDateLabels(days) {
            const labels = [];
            for (let i = days - 1; i >= 0; i--) {
                const date = new Date();
                date.setDate(date.getDate() - i);
                labels.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }));
            }
            return labels;
        }

        function generateRandomData(count, min, max) {
            const data = [];
            for (let i = 0; i < count; i++) {
                data.push(Math.floor(Math.random() * (max - min + 1)) + min);
            }
            return data;
        }

        function setDateRange(days) {
            currentDateRange = days;
            
            // Update active button
            document.querySelectorAll('.date-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Update chart data
            engagementChart.data.labels = generateDateLabels(days);
            engagementChart.data.datasets[0].data = generateRandomData(days, 800, 1200);
            engagementChart.data.datasets[1].data = generateRandomData(days, 400, 800);
            engagementChart.data.datasets[2].data = generateRandomData(days, 100, 300);
            engagementChart.update();
            
            updateKPIs();
        }

        function updateDateRange() {
            const select = document.getElementById('dateRange');
            const days = parseInt(select.value);
            
            if (days !== currentDateRange && !isNaN(days)) {
                setDateRange(days);
            }
        }

        function updateKPIs() {
            // Simulate KPI updates with realistic variations
            const baseUsers = 1247;
            const baseEnrollments = 3891;
            const baseCompletion = 87.2;
            const baseGrade = 84.6;
            
            const variation = (Math.random() - 0.5) * 0.1; // ±5% variation
            
            document.getElementById('totalUsers').querySelector('span').textContent = 
                Math.floor(baseUsers * (1 + variation)).toLocaleString();
            document.getElementById('courseEnrollments').querySelector('span').textContent = 
                Math.floor(baseEnrollments * (1 + variation)).toLocaleString();
            document.getElementById('completionRate').querySelector('span').textContent = 
                (baseCompletion * (1 + variation)).toFixed(1) + '%';
            document.getElementById('avgGrade').querySelector('span').textContent = 
                (baseGrade * (1 + variation)).toFixed(1);
        }

        // Auto-refresh data every 5 minutes
        setInterval(function() {
            updateKPIs();
            
            // Update first chart with new data point
            const newData = Math.floor(Math.random() * 400) + 800;
            engagementChart.data.datasets[0].data.shift();
            engagementChart.data.datasets[0].data.push(newData);
            engagementChart.update('none');
        }, 300000); // 5 minutes
    </script>
</asp:Content>
