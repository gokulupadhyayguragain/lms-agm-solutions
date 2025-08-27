<%@ Page Title="My Quizzes" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="AGMSolutions.Students.Quizzes" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <!-- Load Tailwind CSS CDN for utility-first styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Configure Tailwind to use the Inter font family
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                },
            },
        };
    </script>
    <!-- Load Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        /* Ensure the body uses the Inter font */
        body {
            font-family: 'Inter', sans-serif;
        }

        /* Quiz card hover effects */
        .quiz-card {
            transition: all 0.3s ease-in-out;
        }

        .quiz-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        /* Status badge animations */
        .status-badge {
            animation: pulse-subtle 2s infinite;
        }

        @keyframes pulse-subtle {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        /* Empty state illustration */
        .empty-state {
            opacity: 0.7;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto max-w-7xl">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-purple-700 text-white rounded-xl shadow-lg p-8 mb-8 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">
                    <i class="fas fa-brain mr-3"></i>My Quizzes
                </h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Take quizzes from your enrolled courses and track your progress.
                </p>
            </div>

            <!-- Alert Messages -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="mb-6">
                <div id="alertMessage" runat="server" class="p-4 rounded-lg">
                    <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <!-- Main Content Panel -->
            <asp:Panel ID="pnlQuizList" runat="server" Visible="true">
                    <h3 class="text-3xl font-bold text-gray-800 mb-6">Ready to begin?</h3>
                    <p class="text-lg text-gray-600 mb-8">You will be presented with 10 multiple-choice questions. Good luck!</p>
                    <asp:Button ID="btnStartQuiz" runat="server" Text="Start Quiz" OnClick="btnStartQuiz_Click"
                        CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300" />
                </asp:Panel>

                <!-- Quiz Questions Panel (initially hidden) -->
                <asp:Panel ID="pnlQuizQuestions" runat="server" Visible="false">
                    <!-- Question Number Display -->
                    <p class="text-right text-gray-600 text-sm mb-4">Question <asp:Label ID="lblQuestionNumber" runat="server" Text="1"></asp:Label> of 10</p>

                    <asp:Panel ID="questionsContainer" runat="server" CssClass="space-y-6">
                        <%-- Question 1 --%>
                        <asp:Panel ID="pnlQuestion1" runat="server" CssClass="question-panel" Visible="false">
                            <h4 class="text-xl font-semibold text-gray-800 mb-4">1. What is the output of `print(type([]))`?</h4>
                            <asp:RadioButtonList ID="rblQ1" runat="server" CssClass="quiz-options space-y-3" RepeatLayout="Flow">
                                <asp:ListItem Text="<class 'list'>" Value="A"></asp:ListItem>
                                <asp:ListItem Text="<class 'array'>" Value="B"></asp:ListItem>
                                <asp:ListItem Text="<class 'tuple'>" Value="C"></asp:ListItem>
                                <asp:ListItem Text="<class 'object'>" Value="D"></asp:ListItem>
                            </asp:RadioButtonList>
                        </asp:Panel>

                        <%-- Question 2 --%>
                        <asp:Panel ID="pnlQuestion2" runat="server" CssClass="question-panel" Visible="false">
                <!-- Quiz Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                    <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand">
                        <ItemTemplate>
                            <div class="quiz-card bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
                                <!-- Quiz Header -->
                                <div class="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6">
                                    <h3 class="text-xl font-bold mb-2"><%# Eval("QuizTitle") %></h3>
                                    <p class="text-blue-100 text-sm">
                                        <i class="fas fa-book mr-2"></i><%# Eval("CourseCode") %> - <%# Eval("CourseName") %>
                                    </p>
                                </div>

                                <!-- Quiz Body -->
                                <div class="p-6">
                                    <!-- Quiz Details -->
                                    <div class="space-y-3 mb-6">
                                        <div class="flex items-center text-gray-600">
                                            <i class="fas fa-clock w-5 h-5 mr-3 text-blue-500"></i>
                                            <span class="text-sm">Duration: <%# Eval("FormattedDuration") %></span>
                                        </div>
                                        <div class="flex items-center text-gray-600">
                                            <i class="fas fa-star w-5 h-5 mr-3 text-yellow-500"></i>
                                            <span class="text-sm">Total Marks: <%# Eval("TotalMarks") %></span>
                                        </div>
                                        <div class="flex items-center text-gray-600">
                                            <i class="fas fa-user-tie w-5 h-5 mr-3 text-green-500"></i>
                                            <span class="text-sm">By: <%# Eval("LecturerName") %></span>
                                        </div>
                                    </div>

                                    <!-- Status Badge -->
                                    <div class="mb-4">
                                        <span class="<%# Eval("StatusBadgeClass") %> status-badge px-3 py-1 rounded-full text-xs font-medium">
                                            <%# Eval("Status") %>
                                        </span>
                                    </div>

                                    <!-- Description -->
                                    <p class="text-gray-700 text-sm mb-6 line-clamp-3">
                                        <%# Eval("Description") %>
                                    </p>

                                    <!-- Last Attempt Info (if any) -->
                                    <%# Convert.ToBoolean(Eval("HasAttempted")) ? 
                                        "<div class=\"bg-gray-50 p-3 rounded-lg mb-4\">" +
                                        "<p class=\"text-xs text-gray-600 mb-1\">Last Attempt:</p>" +
                                        "<p class=\"text-sm font-medium\">" + 
                                        (Eval("LastAttemptDate") != null ? Convert.ToDateTime(Eval("LastAttemptDate")).ToString("MMM dd, yyyy") : "N/A") + 
                                        "</p>" +
                                        (Eval("LastScore") != null ? "<p class=\"text-sm text-blue-600 font-semibold\">Score: " + Eval("LastScore") + "/" + Eval("TotalMarks") + "</p>" : "") +
                                        "</div>" : "" %>

                                    <!-- Action Button -->
                                    <asp:LinkButton ID="btnTakeQuiz" runat="server" 
                                        CommandName="TakeQuiz" 
                                        CommandArgument='<%# Eval("QuizID") %>'
                                        CssClass="block w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white font-bold py-3 px-4 rounded-lg text-center transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300">
                                        <i class="fas fa-play mr-2"></i>
                                        <%# Convert.ToBoolean(Eval("HasAttempted")) ? "Retake Quiz" : "Start Quiz" %>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Empty State -->
                <asp:Panel ID="pnlEmptyState" runat="server" Visible="false" CssClass="text-center py-16">
                    <div class="empty-state">
                        <i class="fas fa-graduation-cap text-6xl text-gray-300 mb-6"></i>
                        <h3 class="text-2xl font-bold text-gray-600 mb-4">No Quizzes Available</h3>
                        <p class="text-gray-500 mb-6 max-w-md mx-auto">
                            You don't have any quizzes from your enrolled courses yet. Check back later or contact your lecturers.
                        </p>
                        <asp:HyperLink ID="hlEnrollCourses" runat="server" NavigateUrl="~/Students/Courses.aspx"
                            CssClass="inline-flex items-center bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg transition duration-300">
                            <i class="fas fa-book mr-2"></i>
                            View My Courses
                        </asp:HyperLink>
                    </div>
                </asp:Panel>
            </asp:Panel>

            <!-- Quiz Statistics Panel -->
            <asp:Panel ID="pnlStatistics" runat="server" CssClass="bg-white rounded-xl shadow-lg p-8 mb-8">
                <h3 class="text-2xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-chart-bar mr-3 text-blue-600"></i>My Quiz Statistics
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div class="text-center">
                        <div class="bg-blue-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-list text-2xl text-blue-600"></i>
                        </div>
                        <h4 class="text-2xl font-bold text-gray-800">
                            <asp:Literal ID="litTotalQuizzes" runat="server" Text="0"></asp:Literal>
                        </h4>
                        <p class="text-gray-600">Available Quizzes</p>
                    </div>
                    <div class="text-center">
                        <div class="bg-green-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-check-circle text-2xl text-green-600"></i>
                        </div>
                        <h4 class="text-2xl font-bold text-gray-800">
                            <asp:Literal ID="litCompletedQuizzes" runat="server" Text="0"></asp:Literal>
                        </h4>
                        <p class="text-gray-600">Completed</p>
                    </div>
                    <div class="text-center">
                        <div class="bg-yellow-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-star text-2xl text-yellow-600"></i>
                        </div>
                        <h4 class="text-2xl font-bold text-gray-800">
                            <asp:Literal ID="litAverageScore" runat="server" Text="0"></asp:Literal>%
                        </h4>
                        <p class="text-gray-600">Average Score</p>
                    </div>
                    <div class="text-center">
                        <div class="bg-purple-100 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-trophy text-2xl text-purple-600"></i>
                        </div>
                        <h4 class="text-2xl font-bold text-gray-800">
                            <asp:Literal ID="litPassedQuizzes" runat="server" Text="0"></asp:Literal>
                        </h4>
                        <p class="text-gray-600">Passed</p>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
</asp:Content>

