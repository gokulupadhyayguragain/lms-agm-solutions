<%@ Page Title="Manage Assignments" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ManageAssignments.aspx.cs" Inherits="AGMSolutions.Lecturers.ManageAssignments" %>

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

        /* Custom styling for ASP.NET Validators to ensure consistent display */
        .validator-error {
            color: #ef4444; /* Tailwind red-500 */
            font-size: 1rem; /* text-base */
            margin-top: 0.25rem; /* mt-1 */
            display: block; /* Ensure it takes its own line */
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
        <div class="container mx-auto max-w-6xl"> <%-- Increased max-w to 6xl for more content space --%>
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">Manage Assignments</h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    Create, edit, and review assignments for your courses.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6 alert-message">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Select Course Card -->
            <div class="bg-white rounded-xl shadow-lg mb-8">
                <div class="bg-blue-600 text-white font-bold py-3 px-6 rounded-t-xl text-2xl flex items-center">
                    <i class="fas fa-book-reader mr-3"></i>Select Course
                </div>
                <div class="p-6">
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= ddlCourses.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Choose Course:</label>
                        <div class="sm:col-span-2">
                            <asp:DropDownList ID="ddlCourses" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"
                                AutoPostBack="True" OnSelectedIndexChanged="ddlCourses_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlAssignments" runat="server" Visible="False">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-tasks text-purple-600 mr-4 text-2xl"></i>Assignments for <asp:Literal ID="litSelectedCourseName" runat="server" />
                </h3>
                <hr class="border-gray-300 mb-8" />

                <!-- Add New Assignment Form Card -->
                <div class="bg-white rounded-xl shadow-lg mb-8">
                    <div class="bg-indigo-600 text-white font-bold py-3 px-6 rounded-t-xl text-2xl flex items-center">
                        <i class="fas fa-plus-circle mr-3"></i>Add New Assignment
                    </div>
                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Title -->
                            <div class="md:col-span-1">
                                <label for="<%= txtTitle.ClientID %>" class="block text-gray-700 text-lg font-bold mb-2">Title:</label>
                                <asp:TextBox ID="txtTitle" runat="server"
                                    CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" CssClass="validator-error" ErrorMessage="Title is required." Display="Dynamic" />
                            </div>
                            <!-- Due Date -->
                            <div class="md:col-span-1">
                                <label for="<%= txtDueDate.ClientID %>" class="block text-gray-700 text-lg font-bold mb-2">Due Date:</label>
                                <asp:TextBox ID="txtDueDate" runat="server" TextMode="Date"
                                    CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDueDate" CssClass="validator-error" ErrorMessage="Due Date is required." Display="Dynamic" />
                                <%-- TODO: Implement server-side validation for Due Date not in the past --%>
                                <%-- <asp:CompareValidator runat="server" ControlToValidate="txtDueDate" Type="Date" Operator="GreaterThanEqual" ValueToCompare='<%# DateTime.Now.ToString("yyyy-MM-dd") %>' CssClass="validator-error" ErrorMessage="Due Date cannot be in the past." Display="Dynamic" /> --%>
                            </div>
                            <!-- Description -->
                            <div class="col-span-full">
                                <label for="<%= txtDescription.ClientID %>" class="block text-gray-700 text-lg font-bold mb-2">Description:</label>
                                <%-- Increased rows from 3 to 4 --%>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4"
                                    CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                            </div>
                            <!-- Max Marks -->
                            <div class="md:col-span-1">
                                <label for="<%= txtMaxMarks.ClientID %>" class="block text-gray-700 text-lg font-bold mb-2">Max Marks (Optional):</label>
                                <asp:TextBox ID="txtMaxMarks" runat="server" TextMode="Number"
                                    CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                                <asp:RangeValidator runat="server" ControlToValidate="txtMaxMarks" Type="Double" MinimumValue="0" MaximumValue="1000" CssClass="validator-error" ErrorMessage="Max Marks must be between 0 and 1000." Display="Dynamic" />
                            </div>
                            <div class="col-span-full flex justify-end mt-4">
                                <asp:Button ID="btnAddAssignment" runat="server" OnClick="btnAddAssignment_Click"
                                    CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-4 px-10 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-green-300 text-xl flex items-center justify-center"
                                    Text="Add Assignment">
                                </asp:Button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Assignments List (GridView) Card -->
                <div class="bg-white rounded-xl shadow-lg">
                    <div class="bg-purple-600 text-white font-bold py-3 px-6 rounded-t-xl text-2xl flex items-center">
                        <i class="fas fa-list-alt mr-3"></i>Existing Assignments
                    </div>
                    <div class="p-6 overflow-x-auto"> <%-- Added overflow-x-auto for responsiveness --%>
                        <asp:GridView ID="gvAssignments" runat="server" AutoGenerateColumns="False"
                            CssClass="min-w-full divide-y divide-gray-200 admin-gridview"
                            EmptyDataText="No assignments found for this course."
                            AllowPaging="True" PageSize="10" DataKeyNames="AssignmentID"
                            OnPageIndexChanging="gvAssignments_PageIndexChanging"
                            OnRowEditing="gvAssignments_RowEditing"
                            OnRowUpdating="gvAssignments_RowUpdating"
                            OnRowCancelingEdit="gvAssignments_RowCancelingEdit"
                            OnRowDeleting="gvAssignments_RowDeleting"
                            OnRowDataBound="gvAssignments_RowDataBound">
                            <Columns>
                                <asp:BoundField DataField="Title" HeaderText="Title" />
                                <asp:TemplateField HeaderText="Description">
                                    <ItemTemplate>
                                        <%# Eval("Description") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditDescription" runat="server" TextMode="MultiLine" Rows="4"
                                            CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"
                                            Text='<%# Eval("Description") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Due Date">
                                    <ItemTemplate>
                                        <%# Eval("DueDate", "{0:yyyy-MM-dd}") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditDueDate" runat="server" TextMode="Date"
                                            CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"
                                            Text='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Max Marks">
                                    <ItemTemplate>
                                        <%-- Handle DBNull.Value for MaxMarks --%>
                                        <%# Eval("MaxMarks") != DBNull.Value ? Eval("MaxMarks") : "N/A" %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditMaxMarks" runat="server" TextMode="Number"
                                            CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"
                                            Text='<%# Eval("MaxMarks") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Active">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkIsActive" runat="server" Checked='<%# Eval("IsActive") %>' Enabled="false"
                                            CssClass="h-6 w-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:CheckBox ID="chkEditIsActive" runat="server" Checked='<%# Eval("IsActive") %>'
                                            CssClass="h-6 w-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <div class="flex items-center space-x-2"> <%-- Use flex for button alignment --%>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                                CssClass="inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300">
                                                <i class="fas fa-edit mr-1"></i>Edit
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                                CssClass="inline-flex items-center px-4 py-2 bg-red-500 hover:bg-red-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-300"
                                                OnClientClick="/* TODO: Replace with custom modal confirmation */ return confirm('Are you sure you want to delete this assignment?');">
                                                <i class="fas fa-trash-alt mr-1"></i>Delete
                                            </asp:LinkButton>
                                            <asp:HyperLink ID="hlViewSubmissions" runat="server"
                                                CssClass="inline-flex items-center px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-300"
                                                NavigateUrl='<%# Eval("AssignmentID", "~/Lecturers/ViewSubmissions.aspx?assignmentId={0}") %>'>
                                                <i class="fas fa-eye mr-1"></i>View Submissions
                                            </asp:HyperLink>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="flex items-center space-x-2">
                                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update"
                                                CssClass="inline-flex items-center px-4 py-2 bg-green-500 hover:bg-green-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-green-300">
                                                <i class="fas fa-save mr-1"></i>Update
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel"
                                                CssClass="inline-flex items-center px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-300">
                                                <i class="fas fa-times-circle mr-1"></i>Cancel
                                            </asp:LinkButton>
                                        </div>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-container" />
                            <EmptyDataTemplate>
                                <div class="text-center py-8 text-gray-500 italic text-lg">
                                    No assignments found for this course.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
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

