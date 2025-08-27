<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AGMSolutions.Students.Dashboard" %>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" xintegrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0V4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        /* Ensure the body uses the Inter font */
        body {
            font-family: 'Inter', sans-serif;
        }

        /* Custom styling for the GridView to match Tailwind's aesthetic */
        .dashboard-gridview th {
            padding: 0.75rem 1.5rem; /* py-3 px-6 */
            text-align: left;
            font-size: 0.875rem; /* text-xs */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* gray-700 */
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background-color: #f3f4f6; /* gray-100 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .dashboard-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 0.875rem; /* text-sm */
            color: #6b7280; /* gray-600 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .dashboard-gridview tr:nth-child(odd) {
            background-color: #f9fafb; /* gray-50 for striped effect */
        }

        .dashboard-gridview tr:hover {
            background-color: #f3f4f6; /* gray-100 on hover */
            transition: background-color 0.2s ease-in-out;
        }

        /* Styling for empty data text */
        .dashboard-gridview .empty-data-row td {
            text-align: center;
            padding: 2rem;
            color: #9ca3af; /* gray-400 */
            font-style: italic;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto">
            <!-- Welcome Section -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">
                    <asp:Label ID="lblWelcome" runat="server" Text="Welcome, Student!"></asp:Label>
                </h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Here you can view your courses, assignments, progress, and upcoming events. Stay organized and on track with your learning journey.
                </p>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-12">
                <!-- My Enrolled Courses Card -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div>
                        <div class="flex items-center mb-4">
                            <i class="fas fa-book-open text-blue-600 text-3xl mr-4"></i>
                            <h5 class="text-2xl font-semibold text-gray-800">My Enrolled Courses</h5>
                        </div>
                        <p class="text-gray-600 mb-6">View and manage the courses you are currently enrolled in. Access course materials, lectures, and discussions.</p>
                    </div>
                    <asp:HyperLink ID="hlMyCourses" runat="server" NavigateUrl="~/Students/MyCourses.aspx"
                        CssClass="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-blue-300 text-center">
                        Go to My Courses
                    </asp:HyperLink>
                </div>

                <!-- Course Progress Overview Card -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div>
                        <div class="flex items-center mb-4">
                            <i class="fas fa-chart-line text-green-600 text-3xl mr-4"></i>
                            <h5 class="text-2xl font-semibold text-gray-800">Course Progress Overview</h5>
                        </div>
                        <p class="text-gray-600 mb-4">Overall course completion progress:</p>
                        <div class="w-full bg-gray-200 rounded-full h-2.5 mb-4">
                            <div class="bg-green-500 h-2.5 rounded-full text-xs flex items-center justify-center text-white" style="width: 75%;">
                                <span class="sr-only">75% Complete</span>
                                <span class="text-white font-bold">75% Complete</span>
                            </div>
                        </div>
                    </div>
                    <a href="Courses.aspx" class="inline-block bg-transparent border-2 border-green-600 text-green-600 hover:bg-green-600 hover:text-white font-bold py-2 px-6 rounded-full transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-green-300 text-center">
                        View My Courses
                    </a>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-12">
                <!-- Upcoming Events Card -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div>
                        <div class="flex items-center mb-4">
                            <i class="fas fa-calendar-alt text-purple-600 text-3xl mr-4"></i>
                            <h5 class="text-2xl font-semibold text-gray-800">Upcoming Events</h5>
                        </div>
                        <ul class="divide-y divide-gray-200 text-gray-700 mb-6">
                            <li class="py-3 flex items-center justify-between">
                                <span><i class="fas fa-clipboard-list text-purple-500 mr-2"></i>Quiz: Algebra Basics</span>
                                <span class="font-semibold text-red-500">Due Tomorrow!</span>
                            </li>
                            <li class="py-3 flex items-center justify-between">
                                <span><i class="fas fa-pencil-alt text-purple-500 mr-2"></i>Assignment: Essay on Calculus</span>
                                <span class="font-semibold text-orange-500">Due Friday</span>
                            </li>
                            <li class="py-3 flex items-center justify-between">
                                <span><i class="fas fa-users text-purple-500 mr-2"></i>Class: Data Structures</span>
                                <span class="font-semibold text-blue-500">Monday 10:00 AM</span>
                            </li>
                        </ul>
                    </div>
                    <a href="Timetable.aspx" class="inline-block bg-transparent border-2 border-purple-600 text-purple-600 hover:bg-purple-600 hover:text-white font-bold py-2 px-6 rounded-full transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-purple-300 text-center">
                        View Full Calendar
                    </a>
                </div>

                <!-- Quick Links Card -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div>
                        <div class="flex items-center mb-4">
                            <i class="fas fa-link text-teal-600 text-3xl mr-4"></i>
                            <h5 class="text-2xl font-semibold text-gray-800">Quick Links</h5>
                        </div>
                        <div class="flex flex-wrap gap-3 mb-6">
                            <a href="Assignments.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Assignments</a>
                            <a href="Quizzes.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Quizzes</a>
                            <a href="Grades.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Grades</a>
                            <a href="Profile.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Profile</a>
                            <a href="Chat.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Chat</a>
                            <a href="Certificates.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Certificates</a>
                            <a href="LiveClasses.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Live Classes</a>
                            <a href="Analytics.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Analytics</a>
                            <a href="MobileApp.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Mobile App</a>
                            <a href="Search.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Search</a>
                            <a href="ApiDocs.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">API Docs</a>
                            <a href="Collaboration.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Collaboration</a>
                            <a href="Notifications.aspx" class="bg-teal-500 hover:bg-teal-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300">Notifications</a>
                        </div>
                    </div>
                    <!-- No specific button for Quick Links, as the links themselves serve the purpose -->
                </div>
            </div>

            <!-- Recent Courses GridView -->
            <h3 class="text-3xl font-bold text-gray-800 mb-6 mt-12">Recent Courses</h3>
            <hr class="border-gray-300 mb-8" />
            <div class="overflow-x-auto rounded-lg shadow-lg">
                <asp:GridView ID="gvRecentCourses" runat="server" AutoGenerateColumns="False"
                    CssClass="min-w-full divide-y divide-gray-200 dashboard-gridview"
                    EmptyDataText="No recent courses found. Enroll in a course to see it here!">
                    <Columns>
                        <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                        <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                        <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center py-8 text-gray-500 italic">
                            No recent courses found. Enroll in a course to see it here!
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Footer (consistent with other pages) -->
    <footer class="bg-gray-800 text-white py-8 px-4 mt-12">
        <div class="container mx-auto text-center text-gray-400">
            <p>&copy; <%= DateTime.Now.Year %> AGM Solutions. All rights reserved.</p>
            <div class="flex justify-center space-x-6 mt-4">
                <a href="#" class="hover:text-white transition-colors duration-300"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300"><i class="fab fa-twitter"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
</asp:Content>

