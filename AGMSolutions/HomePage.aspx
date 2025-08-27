<%@ Page Title="About AGM Solutions" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="AGMSolutions.HomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .navbar-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 0;
            margin-bottom: 0;
        }
        .navbar-custom .navbar-nav .nav-link {
            color: white !important;
            font-weight: 500;
            margin: 0 10px;
            padding: 10px 20px !important;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .navbar-custom .navbar-nav .nav-link:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        .btn-login {
            background: #28a745;
            border: none;
            color: white;
        }
        .btn-signup {
            background: transparent;
            border: 2px solid white;
            color: white;
        }
        .btn-signup:hover {
            background: white;
            color: #667eea;
        }
        .about-section {
            padding: 80px 0;
            background: #f8f9fa;
        }
        .feature-card {
            transition: transform 0.3s ease;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand text-white fw-bold fs-3" href="/">AGM Solutions</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <asp:LinkButton ID="btnLogin" runat="server" 
                            Text="Login" 
                            CssClass="nav-link btn-login" 
                            OnClick="btnLogin_Click" />
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnSignup" runat="server" 
                            Text="Sign Up" 
                            CssClass="nav-link btn-signup" 
                            OnClick="btnSignup_Click" />
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="about-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h1 class="display-4 mb-4">About AGM Solutions</h1>
                    <p class="lead mb-4">
                        AGM Solutions is a comprehensive Learning Management System designed to bridge the gap between 
                        traditional education and modern technology. Our platform empowers educational institutions 
                        to deliver exceptional learning experiences.
                    </p>
                    <p class="mb-4">
                        Whether you're a student seeking knowledge, a lecturer sharing expertise, or an administrator 
                        managing educational processes, AGM Solutions provides intuitive tools tailored to your needs.
                    </p>
                    <div class="d-flex gap-3">
                        <asp:Button ID="btnGetStartedHome" runat="server" 
                            Text="Get Started Today" 
                            CssClass="btn btn-primary btn-lg" 
                            OnClick="btnGetStartedHome_Click" />
                        <asp:Button ID="btnBackToHome" runat="server" 
                            Text="Back to Home" 
                            CssClass="btn btn-outline-secondary btn-lg" 
                            OnClick="btnBackToHome_Click" />
                    </div>
                </div>
                <div class="col-lg-6">
                    <img src="/Images/learning-illustration.jpg" alt="Learning Illustration" class="img-fluid rounded shadow" />
                </div>
            </div>
        </div>
    </div>

    <!-- Features Section -->
    <div class="container py-5">
        <div class="text-center mb-5">
            <h2 class="display-5">Why Choose AGM Solutions?</h2>
            <p class="lead text-muted">Discover the features that make learning and teaching more effective</p>
        </div>
        
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-laptop-code fa-3x text-primary mb-3"></i>
                        <h5 class="card-title">Interactive Learning</h5>
                        <p class="card-text">
                            Engage with interactive quizzes, assignments, and multimedia content designed 
                            to enhance learning outcomes.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-chart-line fa-3x text-success mb-3"></i>
                        <h5 class="card-title">Progress Tracking</h5>
                        <p class="card-text">
                            Monitor your learning journey with detailed analytics, grades, and attendance tracking 
                            all in one place.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-users fa-3x text-warning mb-3"></i>
                        <h5 class="card-title">Collaborative Environment</h5>
                        <p class="card-text">
                            Connect with peers and instructors through integrated chat, group projects, 
                            and discussion forums.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-mobile-alt fa-3x text-info mb-3"></i>
                        <h5 class="card-title">Mobile Responsive</h5>
                        <p class="card-text">
                            Access your courses and materials anytime, anywhere with our fully responsive 
                            design across all devices.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-shield-alt fa-3x text-danger mb-3"></i>
                        <h5 class="card-title">Secure & Reliable</h5>
                        <p class="card-text">
                            Your data is protected with enterprise-level security measures and reliable 
                            cloud infrastructure.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card feature-card h-100">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-award fa-3x text-purple mb-3"></i>
                        <h5 class="card-title">Certifications</h5>
                        <p class="card-text">
                            Earn certificates upon course completion and showcase your achievements 
                            to employers and peers.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Call to Action -->
    <div class="bg-primary text-white py-5">
        <div class="container text-center">
            <h3 class="mb-4">Ready to Transform Your Learning Experience?</h3>
            <p class="lead mb-4">Join thousands of students and educators who are already using AGM Solutions</p>
            <asp:Button ID="btnJoinNow" runat="server" 
                Text="Join Now - It's Free!" 
                CssClass="btn btn-light btn-lg" 
                OnClick="btnJoinNow_Click" />
        </div>
    </div>
</asp:Content>
