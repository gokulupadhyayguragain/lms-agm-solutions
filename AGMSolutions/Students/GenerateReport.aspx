<%@ Page Title="Generate Report" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="GenerateReport.aspx.cs" Inherits="AGMSolutions.Students.GenerateReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .report-container {
            max-width: 900px;
            margin: 20px auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .report-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .info-section {
            margin: 30px 0;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 5px solid #007bff;
        }
        .generate-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            color: white;
            font-weight: bold;
            font-size: 16px;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            transition: all 0.3s ease;
        }
        .generate-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.4);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="report-container">
        <div class="report-header">
            <h1><i class="fas fa-file-alt"></i> Academic Report Generator</h1>
            <p class="text-muted">Generate comprehensive academic performance reports</p>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="alert" Visible="false"></asp:Label>

        <!-- Student Information -->
        <div class="info-section">
            <h3><i class="fas fa-user"></i> Student Information</h3>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Name:</strong> <asp:Label ID="lblStudentName" runat="server"></asp:Label></p>
                    <p><strong>Email:</strong> <asp:Label ID="lblStudentEmail" runat="server"></asp:Label></p>
                </div>
                <div class="col-md-6">
                    <p><strong>Student ID:</strong> <asp:Label ID="lblStudentID" runat="server"></asp:Label></p>
                    <p><strong>Report Date:</strong> <%= DateTime.Now.ToString("MMMM dd, yyyy") %></p>
                </div>
            </div>
        </div>

        <!-- Performance Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblOverallGPA" runat="server">0.00</asp:Label></div>
                <div class="stat-label">Overall GPA</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalCourses" runat="server">0</asp:Label></div>
                <div class="stat-label">Total Courses</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblOverallAttendance" runat="server">0%</asp:Label></div>
                <div class="stat-label">Attendance Rate</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblCompletedAssignments" runat="server">0</asp:Label></div>
                <div class="stat-label">Assignments Done</div>
            </div>
        </div>

        <!-- Course Enrollments -->
        <div class="info-section">
            <h3><i class="fas fa-graduation-cap"></i> Course Enrollments</h3>
            <asp:GridView ID="gvEnrollments" runat="server" CssClass="table table-striped table-hover" 
                AutoGenerateColumns="false" EmptyDataText="No enrollments found.">
                <Columns>
                    <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                    <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                    <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrollment Date" DataFormatString="{0:MM/dd/yyyy}" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Performance Details -->
        <div class="info-section">
            <h3><i class="fas fa-chart-bar"></i> Performance Details</h3>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Completed Assignments:</strong> <asp:Label ID="lblCompletedAssignments" runat="server">0</asp:Label></p>
                    <p><strong>Pending Assignments:</strong> <asp:Label ID="lblPendingAssignments" runat="server">0</asp:Label></p>
                </div>
                <div class="col-md-6">
                    <p><strong>Classes Attended:</strong> <asp:Label ID="lblClassesAttended" runat="server">0</asp:Label></p>
                    <p><strong>Total Classes:</strong> <asp:Label ID="lblTotalClasses" runat="server">0</asp:Label></p>
                </div>
            </div>
        </div>

        <!-- Generate Report Button -->
        <div class="text-center">
            <asp:Button ID="btnGeneratePDF" runat="server" Text="📄 Generate PDF Report" 
                CssClass="generate-btn" OnClick="btnGeneratePDF_Click" />
            <p class="text-muted mt-3">
                <i class="fas fa-info-circle"></i> 
                Your comprehensive academic report will be generated and downloaded automatically.
            </p>
        </div>
    </div>
</asp:Content>
