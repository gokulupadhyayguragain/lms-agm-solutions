<%@ Page Title="My Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="AGMSolutions.Lecturers.MyCourses" %>

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

        /* Styling for alert messages */
        .alert-message {
            padding: 0.75rem 1.25rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            font-weight: 500;
            font-size: 1.25rem; /* text-xl */
        }

        .alert-success {
            background-color: #d1fae5; /* green-100 */
            color: #065f46; /* green-700 */
        }

        .alert-danger {
            background-color: #fee2e2; /* red-100 */
            color: #991b1b; /* red-700 */
        }

        /* Custom styling for the GridView to match Tailwind's aesthetic */
        .admin-gridview th {
            padding: 0.75rem 1.5rem; /* py-3 px-6 */
            text-align: left;
            font-size: 1.125rem; /* text-lg */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* gray-700 */
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background-color: #f3f4f6; /* gray-100 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .admin-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 1rem; /* text-base */
            color: #6b7280; /* gray-600 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .admin-gridview tr:nth-child(odd) {
            background-color: #f9fafb; /* gray-50 for striped effect */
        }

        .admin-gridview tr:hover {
            background-color: #f3f4f6; /* gray-100 on hover */
            transition: background-color 0.2s ease-in-out;
        }

        /* Styling for empty data text */
        .admin-gridview .empty-data-row td {
            text-align: center;
            padding: 2rem;
            color: #9ca3af; /* gray-400 */
            font-style: italic;
            font-size: 1.125rem; /* text-lg */
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
            font-size: 1rem; /* text-base */
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
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">My Assigned Courses</h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    View the courses you are currently assigned to teach.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6 alert-message">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Courses List (GridView) -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-book-open text-teal-600 mr-4 text-2xl"></i>Assigned Courses Overview
                </h3>
                <hr class="border-gray-300 mb-8" />
                <div class="overflow-x-auto rounded-lg shadow-lg">
                    <asp:GridView ID="gvMyCourses" runat="server" AutoGenerateColumns="False"
                        CssClass="min-w-full divide-y divide-gray-200 admin-gridview"
                        EmptyDataText="You are not currently assigned to any courses."
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="gvMyCourses_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                            <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                            <asp:BoundField DataField="Description" HeaderText="Description">
                                <ItemStyle Width="35%" Wrap="True" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CreationDate" HeaderText="Created On" DataFormatString="{0:yyyy-MM-dd}" />
                            
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="flex items-center space-x-2">
                                        <asp:HyperLink ID="hlManageCourse" runat="server"
                                            CssClass="inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300"
                                            Text="Manage Course"
                                            NavigateUrl='<%# Eval("CourseID", "~/Lecturers/ManageCourse.aspx?courseId={0}") %>'>
                                            <i class="fas fa-cogs mr-1"></i>Manage Course
                                        </asp:HyperLink>
                                        
                                        <asp:HyperLink ID="hlManageAssignments" runat="server"
                                            CssClass="inline-flex items-center px-4 py-2 bg-purple-500 hover:bg-purple-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-purple-300"
                                            Text="Assignments"
                                            NavigateUrl='<%# Eval("CourseID", "~/Lecturers/ManageAssignments.aspx?courseId={0}") %>'>
                                            <i class="fas fa-tasks mr-1"></i>Assignments
                                        </asp:HyperLink>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-8 text-gray-500 italic text-lg">
                                No courses assigned to you yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer (consistent with other pages) -->
    <footer class="bg-gray-800 text-white py-8 px-4 mt-12">
        <div class="container mx-auto text-center text-gray-400">
            <p class="text-lg">&copy; <%= DateTime.Now.Year %> AGM Solutions. All rights reserved.</p>
            <div class="flex justify-center space-x-8 mt-4">
                <a href="#" class="hover:text-white transition-colors duration-300 text-2xl"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-2xl"><i class="fab fa-twitter"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-2xl"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-2xl"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
</asp:Content>
