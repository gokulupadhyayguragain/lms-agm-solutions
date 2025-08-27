<%@ Page Title="Test - AGM Solutions" Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="AGMSolutions.Test" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>AGM Solutions - Quick Test</title>
    <link href="/Content/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { padding: 20px; font-family: Arial, sans-serif; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .success { background-color: #d4edda; border-color: #c3e6cb; color: #155724; }
        .error { background-color: #f8d7da; border-color: #f5c6cb; color: #721c24; }
        .info { background-color: #d1ecf1; border-color: #bee5eb; color: #0c5460; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1>AGM Solutions - System Test</h1>
            <p class="lead">Quick test to verify all components are working</p>

            <!-- Database Connection Test -->
            <div class="test-section" id="dbTestSection" runat="server">
                <h3>1. Database Connection</h3>
                <asp:Label ID="lblDbTest" runat="server" Text="Testing..."></asp:Label>
            </div>

            <!-- User Authentication Test -->
            <div class="test-section" id="authTestSection" runat="server">
                <h3>2. User Authentication System</h3>
                <asp:Label ID="lblAuthTest" runat="server" Text="Testing..."></asp:Label>
            </div>

            <!-- Master Pages Test -->
            <div class="test-section" id="masterTestSection" runat="server">
                <h3>3. Master Pages & Theming</h3>
                <asp:Label ID="lblMasterTest" runat="server" Text="Testing..."></asp:Label>
            </div>

            <!-- Email Service Test -->
            <div class="test-section" id="emailTestSection" runat="server">
                <h3>4. Email Service</h3>
                <asp:Label ID="lblEmailTest" runat="server" Text="Testing..."></asp:Label>
            </div>

            <!-- Course Management Test -->
            <div class="test-section" id="courseTestSection" runat="server">
                <h3>5. Course Management</h3>
                <asp:Label ID="lblCourseTest" runat="server" Text="Testing..."></asp:Label>
            </div>

            <!-- Overall Status -->
            <div class="test-section" id="overallSection" runat="server">
                <h3>Overall System Status</h3>
                <asp:Label ID="lblOverallStatus" runat="server" Text="Running tests..." CssClass="badge badge-warning"></asp:Label>
            </div>

            <!-- Feature Showcase -->
            <div class="test-section">
                <h3>🎉 AGM Solutions LMS - All Features Completed!</h3>
                <div class="row">
                    <div class="col-md-6">
                        <h5>✅ Student Features:</h5>
                        <ul>
                            <li>📊 <a href="Students/Dashboard.aspx">Interactive Dashboard</a></li>
                            <li>📚 <a href="Students/Courses.aspx">Course Management</a></li>
                            <li>📝 <a href="Students/Quizzes.aspx">Interactive Quizzes</a> (MCQ, Drag & Drop, Dropdown)</li>
                            <li>📄 <a href="Students/Assignments.aspx">Assignment Submission</a></li>
                            <li>💬 <a href="Students/Chat.aspx">Real-time Chat</a> (Text + Images, 200 words limit)</li>
                            <li>📅 <a href="Students/Timetable.aspx">Weekly Timetable</a></li>
                            <li>📈 <a href="Students/GenerateReport.aspx">PDF Report Generation</a></li>
                            <li>👤 <a href="Students/Profile.aspx">Profile Management</a> (Picture upload/crop)</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <h5>✅ Lecturer Features:</h5>
                        <ul>
                            <li>📊 <a href="Lecturers/Dashboard.aspx">Lecturer Dashboard</a></li>
                            <li>👥 <a href="Lecturers/Students.aspx">Student Management</a></li>
                            <li>📝 Quiz Creation (JSON Upload + Manual)</li>
                            <li>📄 Assignment Management</li>
                            <li>📅 Calendar Management</li>
                            <li>💬 Student Communication</li>
                            <li>👥 Group Management</li>
                            <li>📈 Grade Management</li>
                        </ul>
                        
                        <h5>✅ Admin Features:</h5>
                        <ul>
                            <li>📊 <a href="Admins/Dashboard.aspx">Admin Dashboard</a></li>
                            <li>👥 User Management (CRUD)</li>
                            <li>📚 Course Management</li>
                            <li>🔧 System Configuration</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Technical Features -->
            <div class="test-section">
                <h3>🛠️ Technical Features Implemented:</h3>
                <div class="row">
                    <div class="col-md-6">
                        <h5>Security & Authentication:</h5>
                        <ul>
                            <li>✅ Role-based Authentication</li>
                            <li>✅ Email Confirmation (SMTP)</li>
                            <li>✅ Password Hashing & Salt</li>
                            <li>✅ Session Management</li>
                            <li>✅ Input Validation</li>
                        </ul>
                        
                        <h5>UI/UX:</h5>
                        <ul>
                            <li>✅ Responsive Design (Bootstrap)</li>
                            <li>✅ Role-based Theming</li>
                            <li>✅ Dynamic Master Pages</li>
                            <li>✅ FontAwesome Icons</li>
                            <li>✅ Custom CSS Animations</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <h5>Database & Backend:</h5>
                        <ul>
                            <li>✅ SQL Server Integration</li>
                            <li>✅ Data Access Layer (DAL)</li>
                            <li>✅ Business Logic Layer (BLL)</li>
                            <li>✅ Entity Models</li>
                            <li>✅ CRUD Operations</li>
                        </ul>
                        
                        <h5>Advanced Features:</h5>
                        <ul>
                            <li>✅ JSON Quiz System</li>
                            <li>✅ File Upload/Management</li>
                            <li>✅ Real-time Chat</li>
                            <li>✅ PDF Generation</li>
                            <li>✅ Email Services</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="test-section">
                <h3>Quick Actions</h3>
                <asp:Button ID="btnRunTests" runat="server" Text="Run All Tests" CssClass="btn btn-primary" OnClick="btnRunTests_Click" />
                <a href="Default.aspx" class="btn btn-secondary">Go to Landing Page</a>
                <a href="Common/Login.aspx" class="btn btn-info">Go to Login</a>
                <a href="Common/Signup.aspx" class="btn btn-success">Go to Signup</a>
                <a href="HomePage.aspx" class="btn btn-warning">Learn More</a>
            </div>

        </div>
    </form>
</body>
</html>
