<%@ Page Title="My Grades" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Grades.aspx.cs" Inherits="AGMSolutions.Students.Grades" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .grade-card {
            transition: transform 0.2s ease-in-out;
        }
        .grade-card:hover {
            transform: translateY(-2px);
        }
        .grade-a { background: linear-gradient(135deg, #10B981, #34D399); }
        .grade-b { background: linear-gradient(135deg, #3B82F6, #60A5FA); }
        .grade-c { background: linear-gradient(135deg, #F59E0B, #FBBF24); }
        .grade-d { background: linear-gradient(135deg, #EF4444, #F87171); }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto max-w-6xl">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">
                    <i class="fas fa-chart-line mr-3"></i>My Grades
                </h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    Track your academic performance across all courses.
                </p>
            </div>

            <!-- Grade Summary Cards -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                <div class="grade-card bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="text-3xl font-bold text-gray-800 mb-2">3.75</div>
                    <div class="text-gray-600 font-medium">Overall GPA</div>
                    <div class="text-sm text-green-600 mt-1">▲ 0.15 from last semester</div>
                </div>
                <div class="grade-card bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="text-3xl font-bold text-gray-800 mb-2">85.2%</div>
                    <div class="text-gray-600 font-medium">Average Score</div>
                    <div class="text-sm text-green-600 mt-1">▲ 2.3% improvement</div>
                </div>
                <div class="grade-card bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="text-3xl font-bold text-gray-800 mb-2">12</div>
                    <div class="text-gray-600 font-medium">Courses Completed</div>
                    <div class="text-sm text-blue-600 mt-1">3 in progress</div>
                </div>
                <div class="grade-card bg-white rounded-xl shadow-lg p-6 text-center">
                    <div class="text-3xl font-bold text-gray-800 mb-2">98%</div>
                    <div class="text-gray-600 font-medium">Completion Rate</div>
                    <div class="text-sm text-green-600 mt-1">Excellent performance</div>
                </div>
            </div>

            <!-- Current Semester Grades -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-graduation-cap text-indigo-600 mr-3"></i>Current Semester Grades
                </h3>

                <asp:GridView ID="gvCurrentGrades" runat="server" AutoGenerateColumns="false" 
                    CssClass="w-full" HeaderStyle-CssClass="bg-gray-100">
                    <Columns>
                        <asp:BoundField DataField="CourseCode" HeaderText="Course Code" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course Name" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="AssignmentName" HeaderText="Assignment" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="Score" HeaderText="Score" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="MaxScore" HeaderText="Max Score" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" 
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                        <asp:BoundField DataField="DateGraded" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}"
                            HeaderStyle-CssClass="px-4 py-3 text-left text-sm font-medium text-gray-700"
                            ItemStyle-CssClass="px-4 py-3 text-sm text-gray-900" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center py-12">
                            <i class="fas fa-chart-line text-6xl text-gray-300 mb-4"></i>
                            <h3 class="text-2xl font-semibold text-gray-600 mb-2">No Grades Yet</h3>
                            <p class="text-gray-500">Your grades will appear here once assignments are graded.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Grade History Chart -->
            <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-chart-area text-indigo-600 mr-3"></i>Performance Trend
                </h3>
                <div class="h-64 bg-gray-100 rounded-lg flex items-center justify-center">
                    <div class="text-center">
                        <i class="fas fa-chart-line text-4xl text-gray-400 mb-2"></i>
                        <p class="text-gray-600">Performance chart will be displayed here</p>
                        <p class="text-sm text-gray-500">Chart functionality can be implemented with Chart.js or similar library</p>
                    </div>
                </div>
            </div>

            <!-- Course Performance Breakdown -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-books text-indigo-600 mr-3"></i>Course Performance
                </h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <!-- Sample Course Cards -->
                    <div class="border border-gray-200 rounded-lg p-4">
                        <div class="flex justify-between items-start mb-3">
                            <h4 class="font-semibold text-gray-900">Computer Science 101</h4>
                            <span class="grade-a text-white text-sm px-2 py-1 rounded font-medium">A</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-2">CS101</p>
                        <div class="text-2xl font-bold text-gray-800 mb-1">92.5%</div>
                        <div class="text-sm text-green-600">Excellent Performance</div>
                    </div>

                    <div class="border border-gray-200 rounded-lg p-4">
                        <div class="flex justify-between items-start mb-3">
                            <h4 class="font-semibold text-gray-900">Mathematics 101</h4>
                            <span class="grade-b text-white text-sm px-2 py-1 rounded font-medium">B+</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-2">MATH101</p>
                        <div class="text-2xl font-bold text-gray-800 mb-1">87.3%</div>
                        <div class="text-sm text-blue-600">Good Performance</div>
                    </div>

                    <div class="border border-gray-200 rounded-lg p-4">
                        <div class="flex justify-between items-start mb-3">
                            <h4 class="font-semibold text-gray-900">Web Development</h4>
                            <span class="grade-a text-white text-sm px-2 py-1 rounded font-medium">A-</span>
                        </div>
                        <p class="text-sm text-gray-600 mb-2">WEB101</p>
                        <div class="text-2xl font-bold text-gray-800 mb-1">89.7%</div>
                        <div class="text-sm text-green-600">Very Good Performance</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
