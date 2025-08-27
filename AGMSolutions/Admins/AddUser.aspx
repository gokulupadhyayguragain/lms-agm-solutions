<%@ Page Title="Add New User" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="AddUser.aspx.cs" Inherits="AGMSolutions.Admins.AddUser" %>

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
            font-size: 0.875rem; /* text-sm - Kept small for less visual clutter */
            margin-top: 0.25rem; /* mt-1 */
            display: block; /* Ensure it takes its own line */
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
        <div class="container mx-auto max-w-3xl"> <%-- Added max-w-3xl for consistent form width --%>
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">Add New User</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-2xl mx-auto">
                    Enter details to create a new user account in the system.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- New User Details Card -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <h5 class="text-2xl font-bold text-gray-800 mb-6">New User Details</h5>

                <div class="space-y-6"> <%-- Replaced form-group rows with Tailwind spacing --%>
                    <!-- First Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtFirstName.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">First Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtFirstName" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                                ErrorMessage="First Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Middle Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtMiddleName.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Middle Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtMiddleName" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                        </div>
                    </div>

                    <!-- Last Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtLastName.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Last Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtLastName" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                                ErrorMessage="Last Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtEmail.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Email:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                ErrorMessage="Invalid email format." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:CustomValidator ID="cvEmailUnique" runat="server" OnServerValidate="cvEmailUnique_ServerValidate"
                                ErrorMessage="This email is already registered." CssClass="validator-error" Display="Dynamic"></asp:CustomValidator>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtPassword.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Password:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                                ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                                ErrorMessage="Password must be at least 8 characters, include uppercase, lowercase, number, and special character." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtConfirmPassword.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Confirm Password:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                                ErrorMessage="Confirm Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cmpPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                                ErrorMessage="Passwords do not match." CssClass="validator-error" Display="Dynamic"></asp:CompareValidator>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtPhoneNo.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Phone Number:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtPhoneNo" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revPhoneNo" runat="server" ControlToValidate="txtPhoneNo"
                                ValidationExpression="^\+?[0-9]{10,15}$" ErrorMessage="Invalid Phone Number. Use format +CountryCodeNumber." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <!-- Country -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= ddlCountry.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Country:</label>
                        <div class="sm:col-span-2">
                            <asp:DropDownList ID="ddlCountry" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry" InitialValue=""
                                ErrorMessage="Country is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- User Type -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= ddlUserType.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">User Type:</label>
                        <div class="sm:col-span-2">
                            <asp:DropDownList ID="ddlUserType" runat="server"
                                CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-base"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvUserType" runat="server" ControlToValidate="ddlUserType" InitialValue=""
                                ErrorMessage="User Type is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Email Confirmed Checkbox -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= chkIsEmailConfirmed.ClientID %>" class="block text-gray-700 text-base font-bold sm:text-right">Email Confirmed:</label>
                        <div class="sm:col-span-2">
                            <div class="flex items-center mt-2"> <%-- Use flex for checkbox alignment --%>
                                <asp:CheckBox ID="chkIsEmailConfirmed" runat="server"
                                    CssClass="h-5 w-5 text-blue-600 rounded border-gray-300 focus:ring-blue-500" Checked="true" />
                                <label for="<%= chkIsEmailConfirmed.ClientID %>" class="ml-2 block text-gray-700 text-base">
                                    Automatically confirm email (recommended for admin-added users)
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end mt-8 space-x-4"> <%-- Use flex and space-x for button spacing --%>
                    <asp:Button ID="btnAddUser" runat="server" Text="Add User" OnClick="btnAddUser_Click"
                        CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300 text-lg" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false"
                        CssClass="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-gray-300 text-lg" />
                </div>
            </div>
        </div>
    </div>

    <!-- Footer (consistent with other pages) -->
    <footer class="bg-gray-800 text-white py-8 px-4 mt-12">
        <div class="container mx-auto text-center text-gray-400">
            <p class="text-base">&copy; <%= DateTime.Now.Year %> AGM Solutions. All rights reserved.</p>
            <div class="flex justify-center space-x-6 mt-4">
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-twitter"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-linkedin-in"></i></a>
                <a href="#" class="hover:text-white transition-colors duration-300 text-xl"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </footer>
</asp:Content>


