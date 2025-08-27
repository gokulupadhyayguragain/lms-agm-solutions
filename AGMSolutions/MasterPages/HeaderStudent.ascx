<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HeaderStudent.ascx.cs" Inherits="AGMSolutions.MasterPages.HeaderStudent" %>

<nav class="navbar navbar-expand-lg navbar-student">
    <a class="navbar-brand" href="/Students/Dashboard.aspx">AGM Student Portal</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavStudent" aria-controls="navbarNavStudent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavStudent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="/Students/Dashboard.aspx">Dashboard</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Students/Courses.aspx">Courses</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Students/Quizzes.aspx">Quizzes</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Students/Assignments.aspx">Assignments</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Students/Grades.aspx">Grades</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/Students/Profile.aspx">Profile</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click" CssClass="nav-link">Logout</asp:LinkButton>
            </li>
        </ul>
    </div>
</nav>
