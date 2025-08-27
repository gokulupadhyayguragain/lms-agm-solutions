<%@ Page Title="View Submissions" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ViewSubmissions.aspx.cs" Inherits="AGMSolutions.Lecturers.ViewSubmissions" %>

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
            justify-content: flex-end; /* Align to end for consistency with ManageAssignments */
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

        /* Styling for edit row */
        .admin-gridview .edit-row {
            background-color: #fffbeb; /* yellow-100 for edit mode */
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto max-w-6xl"> <%-- Increased max-w to 6xl for more content space --%>
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">
                    <i class="fas fa-file-alt mr-3"></i>Submissions for Assignment: <asp:Literal ID="litAssignmentTitle" runat="server" />
                </h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    Course: <asp:Literal ID="litCourseName" runat="server" />
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6 alert-message">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Student Submissions Card -->
            <div class="bg-white rounded-xl shadow-lg">
                <div class="bg-purple-600 text-white font-bold py-3 px-6 rounded-t-xl text-2xl flex items-center">
                    <i class="fas fa-users mr-3"></i>Student Submissions
                </div>
                <div class="p-6 overflow-x-auto"> <%-- Added overflow-x-auto for responsiveness --%>
                    <asp:GridView ID="gvSubmissions" runat="server" AutoGenerateColumns="False"
                        CssClass="min-w-full divide-y divide-gray-200 admin-gridview"
                        EmptyDataText="No submissions yet for this assignment."
                        AllowPaging="True" PageSize="10" DataKeyNames="SubmissionID"
                        OnPageIndexChanging="gvSubmissions_PageIndexChanging"
                        OnRowEditing="gvSubmissions_RowEditing"
                        OnRowUpdating="gvSubmissions_RowUpdating"
                        OnRowCancelingEdit="gvSubmissions_RowCancelingEdit"
                        OnRowDataBound="gvSubmissions_RowDataBound"
                        OnRowCommand="gvSubmissions_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="StudentID" HeaderText="Student ID" Visible="False" />
                            <asp:BoundField DataField="SubmissionDate" HeaderText="Submitted On" DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                            <asp:TemplateField HeaderText="Student Name">
                                <ItemTemplate>
                                    <%# GetStudentName(Convert.ToInt32(Eval("StudentID"))) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Submission File">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkDownload" runat="server" CommandName="DownloadFile" CommandArgument='<%# Eval("FilePath") %>'
                                        CssClass="inline-flex items-center text-blue-600 hover:text-blue-800 font-medium transition duration-200"
                                        Visible='<%# !string.IsNullOrEmpty(Eval("FilePath") as string) %>'>
                                        <i class="fas fa-download mr-1"></i>Download File
                                    </asp:LinkButton>
                                    <span class="text-gray-500 italic" Visible='<%# string.IsNullOrEmpty(Eval("FilePath") as string) %>'>No File</span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Grade">
                                <ItemTemplate>
                                    <%# Eval("Grade") != DBNull.Value ? string.Format("{0:N2}%", Eval("Grade")) : "N/A" %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditGrade" runat="server" Text='<%# Bind("Grade") %>'
                                        CssClass="block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"
                                        MaxLength="5"></asp:TextBox>
                                    <asp:RangeValidator runat="server" ControlToValidate="txtEditGrade" Type="Double" MinimumValue="0" MaximumValue="100"
                                        CssClass="validator-error" ErrorMessage="Grade must be 0-100." Display="Dynamic" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <div class="flex items-center space-x-2">
                                        <asp:LinkButton ID="btnEditGrade" runat="server" CommandName="Edit"
                                            CssClass="inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300">
                                            <i class="fas fa-edit mr-1"></i>Edit
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="flex items-center space-x-2">
                                        <asp:LinkButton ID="btnUpdateGrade" runat="server" CommandName="Update"
                                            CssClass="inline-flex items-center px-4 py-2 bg-green-500 hover:bg-green-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-green-300">
                                            <i class="fas fa-save mr-1"></i>Update
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancelEdit" runat="server" CommandName="Cancel"
                                            CssClass="inline-flex items-center px-4 py-2 bg-gray-500 hover:bg-gray-600 text-white text-base font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-300">
                                            <i class="fas fa-times-circle mr-1"></i>Cancel
                                        </asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination-container" />
                        <EditRowStyle CssClass="admin-gridview edit-row" /> <%-- Apply custom class for edit row --%>
                        <EmptyDataTemplate>
                            <div class="text-center py-8 text-gray-500 italic text-lg">
                                No submissions yet for this assignment.
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
