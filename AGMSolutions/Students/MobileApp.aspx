<%@ Page Title="Mobile App" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="MobileApp.aspx.cs" Inherits="AGMSolutions.Students.MobileApp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <style>
        .mobile-container {
            max-width: 400px;
            margin: 20px auto;
            background: #000;
            border-radius: 25px;
            padding: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            position: relative;
            overflow: hidden;
        }
        .mobile-screen {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 30px 20px;
            color: white;
            min-height: 600px;
            position: relative;
        }
        .mobile-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 0 10px;
        }
        .status-bar {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
        }
        .app-title {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .home-indicator {
            width: 40px;
            height: 4px;
            background: rgba(255,255,255,0.3);
            border-radius: 2px;
            margin: 20px auto 0;
        }
        .app-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .app-icon {
            background: rgba(255,255,255,0.2);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }
        .app-icon:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-5px);
        }
        .app-icon i {
            font-size: 2rem;
            margin-bottom: 10px;
            display: block;
        }
        .app-name {
            font-size: 0.8rem;
            font-weight: 500;
        }
        .notification-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ff4757;
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
        .quick-actions {
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .quick-action {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            cursor: pointer;
        }
        .quick-action:last-child {
            border-bottom: none;
        }
        .quick-action i {
            margin-right: 15px;
            width: 20px;
        }
        .bottom-nav {
            position: absolute;
            bottom: 20px;
            left: 20px;
            right: 20px;
            background: rgba(255,255,255,0.2);
            border-radius: 25px;
            padding: 15px;
            display: flex;
            justify-content: space-around;
            backdrop-filter: blur(10px);
        }
        .nav-item {
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nav-item.active {
            color: #ffd700;
        }
        .nav-item i {
            font-size: 1.2rem;
            margin-bottom: 5px;
            display: block;
        }
        .nav-label {
            font-size: 0.7rem;
        }
        .download-section {
            text-align: center;
            margin-top: 30px;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .download-btn {
            display: inline-flex;
            align-items: center;
            background: #000;
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            margin: 10px;
            transition: all 0.3s ease;
        }
        .download-btn:hover {
            background: #333;
            transform: translateY(-2px);
        }
        .download-btn img {
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        .features-list {
            text-align: left;
            margin: 30px 0;
        }
        .feature-item {
            display: flex;
            align-items: center;
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .feature-icon {
            background: #007bff;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }
        .pwa-install {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
        }
        .install-btn {
            background: white;
            color: #667eea;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 15px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="text-center mb-5">
            <h1><i class="fas fa-mobile-alt"></i> AGM Solutions Mobile App</h1>
            <p class="lead">Take your learning everywhere with our mobile application</p>
        </div>

        <!-- Mobile App Preview -->
        <div class="mobile-container">
            <div class="mobile-screen">
                <!-- Status Bar -->
                <div class="mobile-header">
                    <div class="status-bar">
                        <span>9:41</span>
                    </div>
                    <div class="app-title">AGM Solutions</div>
                    <div class="status-bar">
                        <i class="fas fa-signal"></i>
                        <i class="fas fa-wifi"></i>
                        <i class="fas fa-battery-three-quarters"></i>
                    </div>
                </div>

                <!-- Welcome Message -->
                <div class="text-center mb-4">
                    <h3>Welcome back, John!</h3>
                    <p style="opacity: 0.9;">Ready to continue learning?</p>
                </div>

                <!-- App Grid -->
                <div class="app-grid">
                    <div class="app-icon" onclick="openApp('courses')">
                        <i class="fas fa-book-open"></i>
                        <div class="app-name">Courses</div>
                        <div class="notification-badge">3</div>
                    </div>
                    <div class="app-icon" onclick="openApp('assignments')">
                        <i class="fas fa-tasks"></i>
                        <div class="app-name">Assignments</div>
                        <div class="notification-badge">2</div>
                    </div>
                    <div class="app-icon" onclick="openApp('grades')">
                        <i class="fas fa-chart-bar"></i>
                        <div class="app-name">Grades</div>
                    </div>
                    <div class="app-icon" onclick="openApp('schedule')">
                        <i class="fas fa-calendar"></i>
                        <div class="app-name">Schedule</div>
                    </div>
                    <div class="app-icon" onclick="openApp('chat')">
                        <i class="fas fa-comments"></i>
                        <div class="app-name">Chat</div>
                        <div class="notification-badge">5</div>
                    </div>
                    <div class="app-icon" onclick="openApp('live')">
                        <i class="fas fa-video"></i>
                        <div class="app-name">Live Classes</div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <h6 style="margin-bottom: 15px;">Quick Actions</h6>
                    <div class="quick-action" onclick="quickAction('quiz')">
                        <i class="fas fa-play-circle"></i>
                        <span>Continue Quiz: Data Structures</span>
                    </div>
                    <div class="quick-action" onclick="quickAction('assignment')">
                        <i class="fas fa-file-alt"></i>
                        <span>Submit Assignment: Algorithm Analysis</span>
                    </div>
                    <div class="quick-action" onclick="quickAction('join')">
                        <i class="fas fa-video"></i>
                        <span>Join Live Class (Starting in 10 min)</span>
                    </div>
                </div>

                <!-- Bottom Navigation -->
                <div class="bottom-nav">
                    <div class="nav-item active">
                        <i class="fas fa-home"></i>
                        <div class="nav-label">Home</div>
                    </div>
                    <div class="nav-item">
                        <i class="fas fa-search"></i>
                        <div class="nav-label">Search</div>
                    </div>
                    <div class="nav-item">
                        <i class="fas fa-bookmark"></i>
                        <div class="nav-label">Saved</div>
                    </div>
                    <div class="nav-item">
                        <i class="fas fa-user"></i>
                        <div class="nav-label">Profile</div>
                    </div>
                </div>

                <!-- Home Indicator -->
                <div class="home-indicator"></div>
            </div>
        </div>

        <!-- PWA Install Section -->
        <div class="pwa-install">
            <h4><i class="fas fa-download"></i> Install as Progressive Web App</h4>
            <p>Get the full app experience on your device. No app store required!</p>
            <button class="install-btn" onclick="installPWA()">
                <i class="fas fa-plus"></i> Add to Home Screen
            </button>
        </div>

        <!-- App Features -->
        <div class="features-list">
            <h3 class="text-center mb-4">Mobile App Features</h3>
            
            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-wifi"></i>
                </div>
                <div>
                    <h6>Offline Access</h6>
                    <p class="mb-0">Download courses and materials for offline study</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-bell"></i>
                </div>
                <div>
                    <h6>Push Notifications</h6>
                    <p class="mb-0">Get instant alerts for assignments, deadlines, and updates</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-sync"></i>
                </div>
                <div>
                    <h6>Real-time Sync</h6>
                    <p class="mb-0">Your progress syncs across all devices automatically</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-camera"></i>
                </div>
                <div>
                    <h6>Photo Uploads</h6>
                    <p class="mb-0">Take photos and upload assignments directly from your camera</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-microphone"></i>
                </div>
                <div>
                    <h6>Voice Notes</h6>
                    <p class="mb-0">Record voice notes and audio submissions on the go</p>
                </div>
            </div>

            <div class="feature-item">
                <div class="feature-icon">
                    <i class="fas fa-map-marked-alt"></i>
                </div>
                <div>
                    <h6>Campus Map</h6>
                    <p class="mb-0">Navigate campus with our interactive map and room finder</p>
                </div>
            </div>
        </div>

        <!-- Download Section -->
        <div class="download-section">
            <h3>Download the Mobile App</h3>
            <p>Available for iOS and Android devices</p>
            
            <div>
                <a href="#" class="download-btn">
                    <i class="fab fa-apple"></i>
                    <div>
                        <div style="font-size: 0.8rem;">Download on the</div>
                        <div style="font-weight: bold;">App Store</div>
                    </div>
                </a>
                
                <a href="#" class="download-btn">
                    <i class="fab fa-google-play"></i>
                    <div>
                        <div style="font-size: 0.8rem;">Get it on</div>
                        <div style="font-weight: bold;">Google Play</div>
                    </div>
                </a>
            </div>

            <div class="mt-4">
                <p class="text-muted">Or scan the QR code with your phone camera</p>
                <div style="width: 150px; height: 150px; background: #f0f0f0; margin: 20px auto; display: flex; align-items: center; justify-content: center; border-radius: 10px;">
                    <i class="fas fa-qrcode" style="font-size: 3rem; color: #666;"></i>
                </div>
            </div>
        </div>
    </div>

    <script>
        let deferredPrompt;

        function openApp(appName) {
            alert(`Opening ${appName} in mobile app...`);
        }

        function quickAction(action) {
            alert(`Performing quick action: ${action}`);
        }

        function installPWA() {
            if (deferredPrompt) {
                deferredPrompt.prompt();
                deferredPrompt.userChoice.then((choiceResult) => {
                    if (choiceResult.outcome === 'accepted') {
                        alert('App installed successfully!');
                    }
                    deferredPrompt = null;
                });
            } else {
                // Fallback for browsers that don't support PWA
                alert('To install this app:\n\n1. Open this page in Chrome/Safari\n2. Click the menu button\n3. Select "Add to Home Screen"');
            }
        }

        // PWA Installation Event
        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
        });

        // Simulate mobile app interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Add touch/click effects
            const appIcons = document.querySelectorAll('.app-icon');
            appIcons.forEach(icon => {
                icon.addEventListener('click', function() {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });

            // Navigation simulation
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                item.addEventListener('click', function() {
                    navItems.forEach(nav => nav.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        });
    </script>
</asp:Content>
