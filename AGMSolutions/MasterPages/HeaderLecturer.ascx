<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HeaderLecturer.ascx.cs" Inherits="AGMSolutions.MasterPages.HeaderLecturer" %>

<nav class="navbar navbar-expand-lg navbar-lecturer">
    <a class="navbar-brand" href="/Lecturers/Dashboard.aspx">AGM Lecturer Portal</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavLecturer" aria-controls="navbarNavLecturer" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavLecturer">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Dashboard.aspx">Dashboard</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Subjects.aspx">Subjects</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Students.aspx">Students</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Assignments.aspx">Assignments</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Quizzes.aspx">Quizzes</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Grades.aspx">Grades</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Lecturers/Profile.aspx">Profile</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click" CssClass="nav-link">Logout</asp:LinkButton>
            </li>
        </ul>
    </div>
</nav>
