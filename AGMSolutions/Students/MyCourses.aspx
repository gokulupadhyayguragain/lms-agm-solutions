<%@ Page Title="My Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="AGMSolutions.Students.MyCourses" %>

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
        .courses-gridview th {
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

        .courses-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 0.875rem; /* text-sm */
            color: #6b7280; /* gray-600 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .courses-gridview tr:nth-child(odd) {
            background-color: #f9fafb; /* gray-50 for striped effect */
        }

        .courses-gridview tr:hover {
            background-color: #f3f4f6; /* gray-100 on hover */
            transition: background-color 0.2s ease-in-out;
        }

        /* Styling for empty data text */
        .courses-gridview .empty-data-row td {
            text-align: center;
            padding: 2rem;
            color: #9ca3af; /* gray-400 */
            font-style: italic;
        }

        /* Custom styling for pagination */
        .pagination-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 1.5rem; /* mt-6 */
        }

        .pagination-container a,
        .pagination-container span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 2.5rem; /* w-10 */
            height: 2.5rem; /* h-10 */
            padding: 0.5rem 0.75rem; /* px-3 py-2 */
            margin-left: 0.25rem; /* ml-1 */
            border-radius: 0.375rem; /* rounded-md */
            font-size: 0.875rem; /* text-sm */
            font-weight: 500; /* font-medium */
            line-height: 1.25rem;
            text-decoration: none;
            transition: all 0.2s ease-in-out;
        }

        .pagination-container a {
            color: #4b5563; /* gray-700 */
            background-color: #ffffff; /* white */
            border: 1px solid #d1d5db; /* gray-300 */
        }

        .pagination-container a:hover {
            background-color: #f3f4f6; /* gray-100 */
            border-color: #9ca3af; /* gray-400 */
        }

        .pagination-container span {
            color: #ffffff; /* white */
            background-color: #2563eb; /* blue-600 */
            border: 1px solid #2563eb; /* blue-600 */
            cursor: default;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">My Enrolled Courses</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    A comprehensive overview of your current learning journey.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Featured Enrolled Courses (Dummy Data with Icons) -->
            <h3 class="text-3xl font-bold text-gray-800 mb-6">Your Learning Path</h3>
            <p class="text-gray-600 mb-8 max-w-2xl mx-auto text-center">
                Here are some of the courses you are currently enrolled in. Click to dive deeper into your studies.
            </p>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
                <!-- Dummy Course 1: Python Programming -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div class="flex items-center mb-4">
                        <i class="fab fa-python text-blue-500 text-4xl mr-4"></i>
                        <div>
                            <h4 class="text-xl font-semibold text-gray-800">Python Programming Basics</h4>
                            <p class="text-gray-600 text-sm">Course Code: PY101</p>
                        </div>
                    </div>
                    <p class="text-gray-700 mb-4">Learn the fundamentals of Python, from variables to functions. Perfect for beginners.</p>
                    <p class="text-gray-500 text-sm mb-4">Lecturer: Dr. Alex Johnson</p>
                    <a href="#" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out text-center">
                        Go to Course
                    </a>
                </div>

                <!-- Dummy Course 2: Advanced Mathematics -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div class="flex items-center mb-4">
                        <i class="fas fa-calculator text-green-500 text-4xl mr-4"></i>
                        <div>
                            <h4 class="text-xl font-semibold text-gray-800">Advanced Calculus</h4>
                            <p class="text-gray-600 text-sm">Course Code: MA301</p>
                        </div>
                    </div>
                    <p class="text-gray-700 mb-4">Explore advanced topics in differential and integral calculus.</p>
                    <p class="text-gray-500 text-sm mb-4">Lecturer: Prof. Sarah Lee</p>
                    <a href="#" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out text-center">
                        Go to Course
                    </a>
                </div>

                <!-- Dummy Course 3: Introduction to Biology -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div class="flex items-center mb-4">
                        <i class="fas fa-flask text-purple-500 text-4xl mr-4"></i>
                        <div>
                            <h4 class="text-xl font-semibold text-gray-800">Introduction to Biology</h4>
                            <p class="text-gray-600 text-sm">Course Code: BI101</p>
                        </div>
                    </div>
                    <p class="text-gray-700 mb-4">Discover the fundamental principles of life sciences.</p>
                    <p class="text-gray-500 text-sm mb-4">Lecturer: Dr. David Kim</p>
                    <a href="#" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out text-center">
                        Go to Course
                    </a>
                </div>

                <!-- Dummy Course 4: World History -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div class="flex items-center mb-4">
                        <i class="fas fa-landmark text-yellow-600 text-4xl mr-4"></i>
                        <div>
                            <h4 class="text-xl font-semibold text-gray-800">Ancient Civilizations</h4>
                            <p class="text-gray-600 text-sm">Course Code: HI201</p>
                        </div>
                    </div>
                    <p class="text-gray-700 mb-4">Journey through the rise and fall of ancient empires.</p>
                    <p class="text-gray-500 text-sm mb-4">Lecturer: Prof. Emily White</p>
                    <a href="#" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out text-center">
                        Go to Course
                    </a>
                </div>

                <!-- Dummy Course 5: Digital Art Fundamentals -->
                <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col justify-between hover:shadow-xl transition-shadow duration-300 transform hover:scale-[1.01]">
                    <div class="flex items-center mb-4">
                        <i class="fas fa-paint-brush text-red-500 text-4xl mr-4"></i>
                        <div>
                            <h4 class="text-xl font-semibold text-gray-800">Digital Art & Design</h4>
                            <p class="text-gray-600 text-sm">Course Code: AR105</p>
                        </div>
                    </div>
                    <p class="text-gray-700 mb-4">Master the basics of digital painting and graphic design.</p>
                    <p class="text-gray-500 text-sm mb-4">Lecturer: Ms. Olivia Green</p>
                    <a href="#" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out text-center">
                        Go to Course
                    </a>
                </div>
            </div>

            <!-- My Enrolled Courses GridView -->
            <h3 class="text-3xl font-bold text-gray-800 mb-6 mt-12">All Enrolled Courses</h3>
            <hr class="border-gray-300 mb-8" />
            <div class="overflow-x-auto rounded-lg shadow-lg">
                <asp:GridView ID="gvMyCourses" runat="server" AutoGenerateColumns="False"
                    CssClass="min-w-full divide-y divide-gray-200 courses-gridview"
                    EmptyDataText="You are not currently enrolled in any courses."
                    AllowPaging="True" PageSize="10" DataKeyNames="CourseID"
                    OnPageIndexChanging="gvMyCourses_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="CourseCode" HeaderText="Course Code" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="30%" />
                        <asp:TemplateField HeaderText="Lecturer">
                            <ItemTemplate>
                                <%# GetLecturerName(Convert.ToInt32(Eval("LecturerID"))) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrolled On" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:HyperLink ID="hlViewAssignments" runat="server"
                                    CssClass="inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-sm font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300"
                                    Text="View Assignments"
                                    NavigateUrl='<%# Eval("CourseID", "~/Students/ViewAssignments.aspx?courseId={0}") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-container" />
                    <EmptyDataTemplate>
                        <div class="text-center py-8 text-gray-500 italic">
                            You are not currently enrolled in any courses.
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