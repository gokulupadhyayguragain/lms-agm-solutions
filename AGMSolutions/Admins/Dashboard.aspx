<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="AGMSolutions.Admins.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            font-size: 1.125rem; /* text-lg - Increased for better visibility */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* gray-700 */
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background-color: #f3f4f6; /* gray-100 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .admin-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 1rem; /* text-base - Increased for better visibility */
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
            font-size: 1.125rem; /* text-lg - Increased for better visibility */
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
            font-size: 1rem; /* text-base - Increased for better visibility */
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
            font-size: 1.125rem; /* text-lg - Increased for better visibility */
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
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">Admin Dashboard</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Centralized control for managing users, courses, and system settings.
                </p>
            </div>

            <!-- Welcome Alert -->
            <div class="bg-blue-100 border border-blue-300 text-blue-800 px-4 py-3 rounded-lg relative mb-8" role="alert">
                <strong class="font-bold text-xl"><i class="fas fa-info-circle mr-2"></i>Welcome!</strong> <%-- Increased text size --%>
                <span class="block sm:inline text-lg">Here you can manage users, roles, and system settings.</span> <%-- Increased text size --%>
            </div>

            <!-- User Management Section -->
            <div class="bg-white rounded-xl shadow-lg p-8 mb-12">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-3xl font-bold text-gray-800 flex items-center">
                        <i class="fas fa-users-cog text-purple-600 mr-4 text-2xl"></i>User Management
                    </h3>
                    <asp:Button ID="btnAddUser" runat="server" Text="Add New User" OnClick="btnAddUser_Click"
                        CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-green-300 text-lg" /> <%-- Increased text size --%>
                </div>
                <hr class="border-gray-300 mb-8" />
                <div class="overflow-x-auto rounded-lg shadow-lg">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False"
                        CssClass="min-w-full divide-y divide-gray-200 admin-gridview"
                        EmptyDataText="No users found." DataKeyNames="UserID"
                        AllowPaging="True" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging"
                        OnRowCommand="gvUsers_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="UserID" HeaderText="ID" ItemStyle-Width="50px" />
                            <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                            <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="PhoneNo" HeaderText="Phone" />
                            <asp:BoundField DataField="Country" HeaderText="Country" />
                            <asp:TemplateField HeaderText="Role">
                                <ItemTemplate>
                                    <asp:Label ID="lblRoleName" runat="server" Text='<%# Eval("UserType.RoleName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:CheckBoxField DataField="IsEmailConfirmed" HeaderText="Confirmed" ItemStyle-Width="80px" />
                            <asp:BoundField DataField="RegistrationDate" HeaderText="Reg. Date" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="LastLoginDate" HeaderText="Last Login" DataFormatString="{0:d}" />
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hlEdit" runat="server" Text="Edit"
                                        CssClass="inline-flex items-center px-3 py-1.5 bg-blue-500 hover:bg-blue-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300 mr-2"
                                        NavigateUrl='<%# Eval("Email", "~/Admins/EditUser.aspx?Email={0}") %>'>
                                        <i class="fas fa-edit mr-1"></i> Edit
                                    </asp:HyperLink>
                                    <asp:LinkButton ID="btnDelete" runat="server" Text="Delete"
                                        CssClass="inline-flex items-center px-3 py-1.5 bg-red-500 hover:bg-red-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-300"
                                        CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>'
                                        OnClientClick="/* TODO: Replace with custom modal confirmation */ return confirm('Are you sure you want to delete this user? This action cannot be undone.');">
                                        <i class="fas fa-trash-alt mr-1"></i> Delete
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EmptyDataTemplate>
                            <div class="text-center py-8 text-gray-500 italic">
                                No users found.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

            <!-- Course Management Section -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-3xl font-bold text-gray-800 flex items-center">
                        <i class="fas fa-book-open text-teal-600 mr-4 text-2xl"></i>Course Management
                    </h3>
                    <asp:Button ID="btnManageCourses" runat="server" Text="Manage Courses" OnClick="btnManageCourses_Click"
                        CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-blue-300 text-lg" /> <%-- Increased text size --%>
                </div>
                <hr class="border-gray-300 mb-8" />
                <p class="text-gray-600 text-lg">
                    Click "Manage Courses" to add, edit, or remove courses from the system.
                </p>
            </div>
        </div>
    </div>

    <!-- Footer (consistent with other pages) -->
    <footer class="bg-gray-800 text-white py-8 px-4 mt-12">
        <div class="container mx-auto text-center text-gray-400">
            <p class="text-base">&copy; <%= DateTime.Now.Year %> AGM Solutions. All rights reserved.</p> <%-- Increased text size --%>
            <div class="flex justify-center space-x-6 mt-4">
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-facebook-f"></i></a> <%-- Increased icon size --%>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-twitter"></i></a> <%-- Increased icon size --%>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-linkedin-in"></i></a> <%-- Increased icon size --%>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-instagram"></i></a> <%-- Increased icon size --%>
            </div>
        </div>
    </footer>
</asp:Content>


