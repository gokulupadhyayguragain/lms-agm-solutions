<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="AGMSolutions.Admins.Courses" %>

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

        /* Custom styling for the GridView to match Tailwind's aesthetic */
        .admin-gridview th {
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

        .admin-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 0.875rem; /* text-sm */
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

        /* Styling for alert messages */
        .alert-message {
            padding: 0.75rem 1.25rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d1fae5; /* green-100 */
            color: #065f46; /* green-700 */
        }

        .alert-danger {
            background-color: #fee2e2; /* red-100 */
            color: #991b1b; /* red-700 */
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">Manage Courses</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Add, edit, and remove courses from the system.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Course Management Section -->
            <div class="bg-white rounded-xl shadow-lg p-8 mb-12">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-3xl font-bold text-gray-800 flex items-center">
                        <i class="fas fa-book-open text-teal-600 mr-4 text-2xl"></i>Course List
                    </h3>
                    <asp:Button ID="btnAddCourse" runat="server" Text="Add New Course" OnClick="btnAddCourse_Click"
                        CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-green-300" />
                </div>
                <hr class="border-gray-300 mb-8" />
                <div class="overflow-x-auto rounded-lg shadow-lg">
                    <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False"
                        CssClass="min-w-full divide-y divide-gray-200 admin-gridview"
                        EmptyDataText="No courses found." DataKeyNames="CourseID"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="gvCourses_PageIndexChanging"
                        OnRowCommand="gvCourses_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CourseID" HeaderText="ID" ItemStyle-Width="50px" />
                            <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                            <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                            <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" /> <%-- This will show the actual lecturer's name --%>
                            <asp:BoundField DataField="CreationDate" HeaderText="Created On" DataFormatString="{0:d}" />
                            <asp:CheckBoxField DataField="IsActive" HeaderText="Active" />
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlEdit" runat="server" Text="Edit"
                                        CssClass="inline-flex items-center px-3 py-1.5 bg-blue-500 hover:bg-blue-600 text-white text-xs font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300 mr-2"
                                        NavigateUrl='<%# Eval("CourseID", "~/Admins/AddEditCourse.aspx?CourseID={0}") %>'>
                                        <i class="fas fa-edit mr-1"></i> Edit
                                    </asp:HyperLink>
                                    <asp:LinkButton ID="btnDelete" runat="server" Text="Delete"
                                        CssClass="inline-flex items-center px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white text-xs font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-300"
                                        CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>'
                                        OnClientClick="/* TODO: Replace with custom modal confirmation */ return confirm('Are you sure you want to delete this course? This action cannot be undone.');">
                                        <i class="fas fa-trash-alt mr-1"></i> Delete
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-8 text-gray-500 italic">
                                No courses found.
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

