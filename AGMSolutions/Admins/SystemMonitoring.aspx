<%@ Page Title="System Monitoring" Language="C#" MasterPageFile="~/MasterPages/Admin.master" AutoEventWireup="true" CodeFile="SystemMonitoring.aspx.cs" Inherits="Admins_SystemMonitoring" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .monitoring-dashboard {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }
        
        .metric-card {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #007bff;
        }
        
        .metric-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        .metric-value {
            font-size: 2.5rem;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 0.5rem;
        }
        
        .metric-label {
            color: #6c757d;
            font-weight: 500;
            font-size: 1.1rem;
        }
        
        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 0.5rem;
            animation: pulse 2s infinite;
        }
        
        .status-online { background: #28a745; }
        .status-warning { background: #ffc107; }
        .status-offline { background: #dc3545; }
        
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .chart-container {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            height: 400px;
        }
        
        .system-log {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-height: 400px;
            overflow-y: auto;
        }
        
        .log-entry {
            padding: 0.75rem;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            transition: background 0.3s ease;
        }
        
        .log-entry:hover {
            background: #f8f9fa;
        }
        
        .log-timestamp {
            color: #6c757d;
            font-size: 0.875rem;
            margin-right: 1rem;
            min-width: 120px;
        }
        
        .log-level {
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.75rem;
            font-weight: bold;
            margin-right: 1rem;
            min-width: 60px;
            text-align: center;
        }
        
        .log-level.info { background: #d1ecf1; color: #0c5460; }
        .log-level.warning { background: #fff3cd; color: #856404; }
        .log-level.error { background: #f8d7da; color: #721c24; }
        .log-level.success { background: #d4edda; color: #155724; }
        
        .performance-gauge {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 0 auto;
        }
        
        .refresh-controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .auto-refresh {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 0.75rem;
            text-align: center;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(40,167,69,0.3);
            color: white;
            text-decoration: none;
        }
        
        .alert-banner {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            animation: slideDown 0.5s ease;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container-fluid">
        <!-- Header -->
        <div class="monitoring-dashboard">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-0"><i class="fas fa-chart-line me-3"></i>System Monitoring Dashboard</h1>
                    <p class="mb-0 mt-2 opacity-75">Real-time system performance and health monitoring</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex align-items-center justify-content-end">
                        <span class="status-indicator status-online"></span>
                        <span class="me-3">System Online</span>
                        <strong id="currentTime"></strong>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Banner (Hidden by default) -->
        <div id="alertBanner" class="alert-banner" style="display: none;">
            <div class="d-flex align-items-center">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <span id="alertMessage">System Alert</span>
            </div>
            <button type="button" class="btn-close btn-close-white" onclick="dismissAlert()"></button>
        </div>

        <!-- Refresh Controls -->
        <div class="refresh-controls">
            <div class="auto-refresh">
                <label class="form-label mb-0">Auto Refresh:</label>
                <select id="refreshInterval" class="form-select" style="width: auto;">
                    <option value="0">Off</option>
                    <option value="5000">5 seconds</option>
                    <option value="10000" selected>10 seconds</option>
                    <option value="30000">30 seconds</option>
                    <option value="60000">1 minute</option>
                </select>
                <span id="lastRefresh" class="text-muted"></span>
            </div>
            <div>
                <asp:Button ID="btnRefresh" runat="server" Text="Refresh Now" 
                    CssClass="btn btn-primary me-2" OnClick="RefreshData" />
                <asp:Button ID="btnExport" runat="server" Text="Export Report" 
                    CssClass="btn btn-outline-primary" OnClick="ExportReport" />
            </div>
        </div>

        <!-- Key Metrics -->
        <div class="row">
            <div class="col-lg-3 col-md-6">
                <div class="metric-card">
                    <div class="metric-value" id="totalUsers">
                        <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="metric-label">
                        <i class="fas fa-users text-primary me-2"></i>Total Users Online
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="metric-card">
                    <div class="metric-value" id="systemLoad">
                        <asp:Label ID="lblSystemLoad" runat="server" Text="0%"></asp:Label>
                    </div>
                    <div class="metric-label">
                        <i class="fas fa-microchip text-warning me-2"></i>CPU Usage
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="metric-card">
                    <div class="metric-value" id="memoryUsage">
                        <asp:Label ID="lblMemoryUsage" runat="server" Text="0%"></asp:Label>
                    </div>
                    <div class="metric-label">
                        <i class="fas fa-memory text-info me-2"></i>Memory Usage
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="metric-card">
                    <div class="metric-value" id="responseTime">
                        <asp:Label ID="lblResponseTime" runat="server" Text="0ms"></asp:Label>
                    </div>
                    <div class="metric-label">
                        <i class="fas fa-clock text-success me-2"></i>Avg Response Time
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="row">
            <div class="col-lg-8">
                <div class="chart-container">
                    <h5 class="mb-3"><i class="fas fa-chart-area me-2"></i>Performance Trends (Last 24 Hours)</h5>
                    <canvas id="performanceChart"></canvas>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="chart-container">
                    <h5 class="mb-3"><i class="fas fa-chart-pie me-2"></i>Resource Distribution</h5>
                    <canvas id="resourceChart"></canvas>
                </div>
            </div>
        </div>

        <!-- System Status & Logs -->
        <div class="row">
            <div class="col-lg-6">
                <div class="system-log">
                    <h5 class="mb-3"><i class="fas fa-list-ul me-2"></i>System Status</h5>
                    <div class="log-entry">
                        <span class="status-indicator status-online"></span>
                        <div>
                            <strong>Database Server</strong>
                            <small class="d-block text-muted">Connected - Response time: 45ms</small>
                        </div>
                    </div>
                    <div class="log-entry">
                        <span class="status-indicator status-online"></span>
                        <div>
                            <strong>Web Server</strong>
                            <small class="d-block text-muted">Running - Uptime: 15 days, 4 hours</small>
                        </div>
                    </div>
                    <div class="log-entry">
                        <span class="status-indicator status-warning"></span>
                        <div>
                            <strong>Email Service</strong>
                            <small class="d-block text-muted">Warning - Queue: 23 pending</small>
                        </div>
                    </div>
                    <div class="log-entry">
                        <span class="status-indicator status-online"></span>
                        <div>
                            <strong>File Storage</strong>
                            <small class="d-block text-muted">Available - 78% capacity used</small>
                        </div>
                    </div>
                    <div class="log-entry">
                        <span class="status-indicator status-online"></span>
                        <div>
                            <strong>Backup System</strong>
                            <small class="d-block text-muted">Last backup: 2 hours ago</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="system-log">
                    <h5 class="mb-3"><i class="fas fa-file-alt me-2"></i>Recent System Logs</h5>
                    <asp:Repeater ID="rptSystemLogs" runat="server">
                        <ItemTemplate>
                            <div class="log-entry">
                                <span class="log-timestamp"><%# Eval("Timestamp", "{0:HH:mm:ss}") %></span>
                                <span class="log-level <%# Eval("Level").ToString().ToLower() %>"><%# Eval("Level") %></span>
                                <span><%# Eval("Message") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="SystemSettings.aspx" class="action-btn">
                <i class="fas fa-cogs"></i>
                System Settings
            </a>
            <a href="BackupManagement.aspx" class="action-btn">
                <i class="fas fa-database"></i>
                Backup Management
            </a>
            <a href="UserSessions.aspx" class="action-btn">
                <i class="fas fa-users-cog"></i>
                Active Sessions
            </a>
            <a href="SecurityAudit.aspx" class="action-btn">
                <i class="fas fa-shield-alt"></i>
                Security Audit
            </a>
            <a href="PerformanceOptimization.aspx" class="action-btn">
                <i class="fas fa-tachometer-alt"></i>
                Performance Optimization
            </a>
            <a href="MaintenanceMode.aspx" class="action-btn">
                <i class="fas fa-tools"></i>
                Maintenance Mode
            </a>
        </div>
    </div>

    <script>
        // Initialize real-time monitoring
        let refreshInterval;
        let performanceChart;
        let resourceChart;

        document.addEventListener('DOMContentLoaded', function() {
            updateCurrentTime();
            initializeCharts();
            setupAutoRefresh();
            simulateRealTimeData();
            
            setInterval(updateCurrentTime, 1000);
        });

        function updateCurrentTime() {
            const now = new Date();
            document.getElementById('currentTime').textContent = now.toLocaleTimeString();
        }

        function initializeCharts() {
            // Performance Trends Chart
            const ctx1 = document.getElementById('performanceChart').getContext('2d');
            performanceChart = new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: generateTimeLabels(),
                    datasets: [{
                        label: 'CPU Usage (%)',
                        data: generateRandomData(24, 20, 80),
                        borderColor: '#007bff',
                        backgroundColor: 'rgba(0,123,255,0.1)',
                        tension: 0.4
                    }, {
                        label: 'Memory Usage (%)',
                        data: generateRandomData(24, 30, 90),
                        borderColor: '#28a745',
                        backgroundColor: 'rgba(40,167,69,0.1)',
                        tension: 0.4
                    }, {
                        label: 'Response Time (ms)',
                        data: generateRandomData(24, 50, 200),
                        borderColor: '#ffc107',
                        backgroundColor: 'rgba(255,193,7,0.1)',
                        tension: 0.4,
                        yAxisID: 'y1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },
                    scales: {
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            max: 100
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            max: 500,
                            grid: {
                                drawOnChartArea: false,
                            },
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    }
                }
            });

            // Resource Distribution Chart
            const ctx2 = document.getElementById('resourceChart').getContext('2d');
            resourceChart = new Chart(ctx2, {
                type: 'doughnut',
                data: {
                    labels: ['Database', 'Web Server', 'File Storage', 'Cache', 'Other'],
                    datasets: [{
                        data: [35, 25, 20, 15, 5],
                        backgroundColor: [
                            '#007bff',
                            '#28a745',
                            '#ffc107',
                            '#17a2b8',
                            '#6c757d'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff'
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
        }

        function generateTimeLabels() {
            const labels = [];
            for (let i = 23; i >= 0; i--) {
                const time = new Date();
                time.setHours(time.getHours() - i);
                labels.push(time.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }));
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

        function setupAutoRefresh() {
            const select = document.getElementById('refreshInterval');
            
            select.addEventListener('change', function() {
                if (refreshInterval) {
                    clearInterval(refreshInterval);
                }
                
                const interval = parseInt(this.value);
                if (interval > 0) {
                    refreshInterval = setInterval(() => {
                        refreshMetrics();
                        updateLastRefreshTime();
                    }, interval);
                }
            });
            
            // Trigger initial setup
            select.dispatchEvent(new Event('change'));
        }

        function refreshMetrics() {
            // Simulate metric updates
            document.getElementById('totalUsers').querySelector('span').textContent = Math.floor(Math.random() * 500) + 100;
            document.getElementById('systemLoad').querySelector('span').textContent = Math.floor(Math.random() * 40) + 30 + '%';
            document.getElementById('memoryUsage').querySelector('span').textContent = Math.floor(Math.random() * 30) + 50 + '%';
            document.getElementById('responseTime').querySelector('span').textContent = Math.floor(Math.random() * 100) + 50 + 'ms';
            
            // Update charts with new data
            updateChartsData();
        }

        function updateChartsData() {
            // Add new data point and remove oldest
            const newCpuData = Math.floor(Math.random() * 60) + 20;
            const newMemoryData = Math.floor(Math.random() * 60) + 30;
            const newResponseData = Math.floor(Math.random() * 150) + 50;
            
            performanceChart.data.datasets[0].data.shift();
            performanceChart.data.datasets[0].data.push(newCpuData);
            
            performanceChart.data.datasets[1].data.shift();
            performanceChart.data.datasets[1].data.push(newMemoryData);
            
            performanceChart.data.datasets[2].data.shift();
            performanceChart.data.datasets[2].data.push(newResponseData);
            
            performanceChart.data.labels.shift();
            performanceChart.data.labels.push(new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }));
            
            performanceChart.update('none');
        }

        function updateLastRefreshTime() {
            document.getElementById('lastRefresh').textContent = 'Last updated: ' + new Date().toLocaleTimeString();
        }

        function simulateRealTimeData() {
            // Simulate occasional alerts
            setTimeout(() => {
                if (Math.random() > 0.7) {
                    showAlert('High CPU usage detected - 85%', 'warning');
                }
            }, Math.random() * 30000 + 10000);
        }

        function showAlert(message, type = 'error') {
            const banner = document.getElementById('alertBanner');
            const messageEl = document.getElementById('alertMessage');
            
            messageEl.textContent = message;
            banner.style.display = 'flex';
            
            if (type === 'warning') {
                banner.style.background = 'linear-gradient(135deg, #ffc107 0%, #e0a800 100%)';
            }
        }

        function dismissAlert() {
            document.getElementById('alertBanner').style.display = 'none';
        }

        // Export functionality
        function exportReport() {
            // Simulate export process
            const btn = event.target;
            const originalText = btn.textContent;
            
            btn.textContent = 'Exporting...';
            btn.disabled = true;
            
            setTimeout(() => {
                btn.textContent = originalText;
                btn.disabled = false;
                alert('System monitoring report exported successfully!');
            }, 2000);
        }
    </script>
</asp:Content>
