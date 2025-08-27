<%@ Page Title="Welcome to AGM Solutions LMS" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AGMSolutions.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Advanced Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('/Images/education-pattern.png') repeat;
            opacity: 0.1;
            z-index: 1;
        }
        
        .hero-content {
            z-index: 2;
            position: relative;
        }
        
        .hero-banner {
            max-width: 100%;
            height: auto;
            margin-bottom: 30px;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            transition: transform 0.3s ease;
        }
        
        .hero-banner:hover {
            transform: scale(1.02);
        }
        
        .text-gradient {
            background: linear-gradient(45deg, #fff, #f8f9fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* Enhanced Button Styles */
        .btn-custom {
            padding: 15px 30px;
            font-size: 18px;
            margin: 10px;
            border-radius: 50px;
            text-transform: uppercase;
            font-weight: bold;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .btn-get-started {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-get-started:hover {
            background: linear-gradient(45deg, #20c997, #17a2b8);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
            color: white;
        }
        
        .btn-learn-more {
            background: transparent;
            border: 2px solid white !important;
            color: white;
        }
        
        .btn-learn-more:hover {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 255, 255, 0.3);
        }
        
        .btn-project-summary {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
        }
        
        .btn-project-summary:hover {
            background: linear-gradient(45deg, #fd7e14, #dc3545);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
            color: white;
        }
        
        /* Enhanced Feature Cards */
        .feature-card {
            border: none;
            border-radius: 15px;
            transition: all 0.3s ease;
            height: 100%;
            background: white;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            transition: transform 0.3s ease;
        }
        
        .feature-card:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
        }
        
        /* Statistics Section */
        .stats-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 80px 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 30px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            margin-bottom: 30px;
        }
        
        .stat-item:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: #667eea;
            display: block;
        }
        
        .stat-label {
            color: #6c757d;
            font-weight: 500;
            margin-top: 10px;
        }
        
        /* Benefits Section */
        .benefits-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 0;
        }
        
        .benefit-item {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            transition: background 0.3s ease;
        }
        
        .benefit-item:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .benefit-icon {
            font-size: 2.5rem;
            margin-right: 20px;
            color: #ffc107;
        }
        
        /* CTA Section */
        .cta-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 80px 0;
            text-align: center;
        }
        
        /* Animation Classes */
        .animate-fade-in {
            animation: fadeIn 1s ease-in;
        }
        
        .animate-slide-up {
            animation: slideUp 1s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideUp {
            from { 
                opacity: 0;
                transform: translateY(30px);
            }
            to { 
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-section {
                min-height: auto;
                padding: 60px 0;
            }
            
            .display-4 {
                font-size: 2.5rem;
            }
            
            .btn-custom {
                display: block;
                width: 100%;
                margin: 10px 0;
            }
            
            .stat-number {
                font-size: 2rem;
            }
            
            .benefit-item {
                flex-direction: column;
                text-align: center;
            }
            
            .benefit-icon {
                margin-right: 0;
                margin-bottom: 15px;
            }
        }
        
        /* Loading Animation */
        .btn-loading {
            position: relative;
            pointer-events: none;
        }
        
        .btn-loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin-left: -10px;
            margin-top: -10px;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Enhanced Hero Section -->
    <div class="hero-section">
        <div class="container hero-content">
            <div class="row justify-content-center align-items-center">
                <div class="col-lg-6 text-center text-lg-start">
                    <h1 class="display-3 fw-bold mb-4 text-gradient animate-fade-in">
                        <i class="fas fa-graduation-cap me-3"></i>
                        AGM Solutions
                    </h1>
                    <h2 class="display-6 mb-4 animate-slide-up">Learning Management System</h2>
                    <p class="lead mb-5 fs-4 animate-slide-up">
                        Empowering Education Through Technology. Experience seamless learning, 
                        advanced assessment tools, and comprehensive course management in one unified platform.
                    </p>
                    
                    <!-- Enhanced Action Buttons -->
                    <div class="action-buttons animate-slide-up">
                        <asp:Button ID="btnGetStarted" runat="server" 
                            Text="🚀 Get Started" 
                            CssClass="btn btn-custom btn-get-started" 
                            OnClick="btnGetStarted_Click" />
                        <asp:Button ID="btnLearnMore" runat="server" 
                            Text="📖 Learn More" 
                            CssClass="btn btn-custom btn-learn-more" 
                            OnClick="btnLearnMore_Click" />
                        <asp:Button ID="btnProjectSummary" runat="server" 
                            Text="📋 Project Summary" 
                            CssClass="btn btn-custom btn-project-summary" 
                            OnClick="btnProjectSummary_Click" />
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <!-- Enhanced Banner Image -->
                    <img src="/Images/landing-banner.png" 
                         alt="AGM Solutions LMS Platform" 
                         class="hero-banner img-fluid animate-fade-in"
                         onerror="this.src='/Images/default-hero.png'" />
                    
                    <!-- Demo Video Button -->
                    <div class="mt-4">
                        <button class="btn btn-outline-light btn-lg rounded-circle p-3" onclick="playDemoVideo()">
                            <i class="fas fa-play fa-2x"></i>
                        </button>
                        <p class="mt-2 small">Watch Demo Video</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics Section -->
    <div class="stats-section">
        <div class="container">
            <div class="row text-center mb-5">
                <div class="col-12">
                    <h2 class="display-5 fw-bold text-dark mb-3">Trusted by Thousands</h2>
                    <p class="lead text-muted">Join our growing community of learners and educators</p>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <span class="stat-number">25+</span>
                        <div class="stat-label">Enterprise Features</div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <span class="stat-number">1,000+</span>
                        <div class="stat-label">Active Users</div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <div class="stat-label">Courses Available</div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item">
                        <span class="stat-number">24/7</span>
                        <div class="stat-label">Support Available</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Enhanced Features Section -->
    <div class="container py-5">
        <div class="row text-center mb-5">
            <div class="col-12">
                <h2 class="display-5 fw-bold mb-3">Comprehensive Learning Solutions</h2>
                <p class="lead text-muted">Everything you need for modern education</p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="fas fa-graduation-cap fa-4x text-primary mb-3"></i>
                        </div>
                        <h5 class="card-title fw-bold">For Students</h5>
                        <p class="card-text">
                            Access courses, take interactive quizzes with proctoring, 
                            submit assignments, track progress, and communicate with peers.
                        </p>
                        <ul class="list-unstyled text-start">
                            <li><i class="fas fa-check text-success me-2"></i>Course Enrollment</li>
                            <li><i class="fas fa-check text-success me-2"></i>Interactive Quizzes</li>
                            <li><i class="fas fa-check text-success me-2"></i>Progress Tracking</li>
                            <li><i class="fas fa-check text-success me-2"></i>Real-time Chat</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="fas fa-chalkboard-teacher fa-4x text-success mb-3"></i>
                        </div>
                        <h5 class="card-title fw-bold">For Lecturers</h5>
                        <p class="card-text">
                            Create comprehensive courses, design advanced quizzes, 
                            manage students, grade assignments, and monitor performance.
                        </p>
                        <ul class="list-unstyled text-start">
                            <li><i class="fas fa-check text-success me-2"></i>Course Creation</li>
                            <li><i class="fas fa-check text-success me-2"></i>Quiz Designer</li>
                            <li><i class="fas fa-check text-success me-2"></i>Student Management</li>
                            <li><i class="fas fa-check text-success me-2"></i>Analytics Dashboard</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <div class="feature-icon">
                            <i class="fas fa-users-cog fa-4x text-warning mb-3"></i>
                        </div>
                        <h5 class="card-title fw-bold">For Administrators</h5>
                        <p class="card-text">
                            Manage users, oversee courses, maintain system settings, 
                            generate reports, and ensure platform security.
                        </p>
                        <ul class="list-unstyled text-start">
                            <li><i class="fas fa-check text-success me-2"></i>User Management</li>
                            <li><i class="fas fa-check text-success me-2"></i>System Configuration</li>
                            <li><i class="fas fa-check text-success me-2"></i>Comprehensive Reports</li>
                            <li><i class="fas fa-check text-success me-2"></i>Security Controls</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Benefits Section -->
    <div class="benefits-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h2 class="display-5 fw-bold mb-5">Why Choose AGM Solutions?</h2>
                    
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold">Enterprise Security</h5>
                            <p class="mb-0">SHA256 encryption, email verification, and comprehensive audit trails</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold">Mobile Responsive</h5>
                            <p class="mb-0">Fully optimized for desktop, tablet, and mobile devices</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold">Advanced Analytics</h5>
                            <p class="mb-0">Comprehensive reporting and performance tracking</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <div>
                            <h5 class="fw-bold">Real-time Communication</h5>
                            <p class="mb-0">Integrated chat, forums, and collaboration tools</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <img src="/Images/benefits-illustration.png" 
                         alt="AGM Solutions Benefits" 
                         class="img-fluid"
                         onerror="this.style.display='none'" />
                </div>
            </div>
        </div>
    </div>

    <!-- Call to Action Section -->
    <div class="cta-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h2 class="display-5 fw-bold mb-4">Ready to Transform Your Learning Experience?</h2>
                    <p class="lead mb-5">
                        Join thousands of educators and students who trust AGM Solutions 
                        for their educational journey. Start your free trial today!
                    </p>
                    <div class="d-flex flex-column flex-md-row gap-3 justify-content-center">
                        <a href="/Common/Signup.aspx" class="btn btn-light btn-lg px-5 py-3 fw-bold">
                            <i class="fas fa-user-plus me-2"></i>Sign Up Free
                        </a>
                        <a href="/Common/Login.aspx" class="btn btn-outline-light btn-lg px-5 py-3 fw-bold">
                            <i class="fas fa-sign-in-alt me-2"></i>Login
                        </a>
                        <a href="/Common/ContactUs.aspx" class="btn btn-outline-light btn-lg px-5 py-3 fw-bold">
                            <i class="fas fa-envelope me-2"></i>Contact Us
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Enhanced Functionality -->
    <script>
        // Demo video function
        function playDemoVideo() {
            alert('Demo Video Features:\n\n' +
                  '🎥 System Overview\n' +
                  '📚 Course Management\n' +
                  '🧪 Quiz System with Proctoring\n' +
                  '📝 Assignment Submission\n' +
                  '💬 Real-time Communication\n' +
                  '📊 Analytics Dashboard\n' +
                  '🔐 Security Features\n' +
                  '📱 Mobile Responsiveness\n\n' +
                  'Contact us for a live demo!');
        }
        
        // Button loading animation
        function addLoadingState(button) {
            button.classList.add('btn-loading');
            button.disabled = true;
            const originalText = button.innerHTML;
            button.innerHTML = '';
            
            setTimeout(() => {
                button.classList.remove('btn-loading');
                button.disabled = false;
                button.innerHTML = originalText;
            }, 2000);
        }
        
        // Add loading to action buttons
        document.addEventListener('DOMContentLoaded', function() {
            const actionButtons = document.querySelectorAll('.btn-custom');
            actionButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!this.classList.contains('btn-loading')) {
                        addLoadingState(this);
                    }
                });
            });
        });
        
        // Smooth scroll for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
        
        // Animate elements on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.animation = entry.target.dataset.animation || 'fadeIn 1s ease-in';
                }
            });
        }, observerOptions);
        
        // Observe elements for animation
        document.querySelectorAll('.stat-item, .feature-card, .benefit-item').forEach(el => {
            observer.observe(el);
        });
    </script>
</asp:Content>


