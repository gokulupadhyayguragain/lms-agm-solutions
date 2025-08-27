<%@ Page Title="Edit User" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="EditUser.aspx.cs" Inherits="AGMSolutions.Admins.EditUser" %>

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
            font-size: 1rem; /* text-base - Increased from text-sm for better visibility */
            margin-top: 0.25rem; /* mt-1 */
            display: block; /* Ensure it takes its own line */
        }

        /* Styling for alert messages */
        .alert-message {
            padding: 0.75rem 1.25rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            font-weight: 500;
            font-size: 1.25rem; /* text-xl - Increased for better visibility */
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
        <div class="container mx-auto max-w-3xl"> <%-- Max width for consistent form layout --%>
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">Edit User Details</h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-2xl mx-auto">
                    Update user information, roles, and account settings.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>
            
            <%-- Hidden field to store the user's email for postbacks --%>
            <asp:HiddenField ID="hdnUserEmail" runat="server" />

            <!-- User Information Card -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <h5 class="text-3xl font-bold text-gray-800 mb-6">User Information</h5>
                
                <div class="space-y-8"> <%-- Increased spacing from space-y-6 --%>
                    <!-- User ID -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label class="block text-gray-700 text-lg font-bold sm:text-right">User ID:</label>
                        <div class="sm:col-span-2">
                            <asp:Label ID="lblUserIDValue" runat="server" CssClass="block w-full px-4 py-3 text-gray-800 font-semibold text-lg"></asp:Label> <%-- Styled as plaintext with larger text --%>
                        </div>
                    </div>

                    <!-- First Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtFirstName.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">First Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtFirstName" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                                ErrorMessage="First Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Middle Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtMiddleName.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Middle Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtMiddleName" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                        </div>
                    </div>

                    <!-- Last Name -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtLastName.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Last Name:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtLastName" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                                ErrorMessage="Last Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtEmail.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Email:</label>
                        <div class="sm:col-span-2">
                            <%-- Make email read-only as it's now the primary lookup key --%>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" ReadOnly="true"
                                CssClass="block w-full px-4 py-3 bg-gray-100 border border-gray-300 rounded-md cursor-not-allowed text-lg"></asp:TextBox> <%-- Added bg-gray-100 and cursor-not-allowed --%>
                            <small class="block text-gray-500 text-base mt-1">Email is the primary identifier and cannot be changed here.</small> <%-- Increased from text-sm --%>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= txtPhoneNo.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Phone Number:</label>
                        <div class="sm:col-span-2">
                            <asp:TextBox ID="txtPhoneNo" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="revPhoneNo" runat="server" ControlToValidate="txtPhoneNo"
                                ValidationExpression="^\+?[0-9]{10,15}$" ErrorMessage="Invalid Phone Number. Use format +CountryCodeNumber." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <!-- Country -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= ddlCountry.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Country:</label>
                        <div class="sm:col-span-2">
                            <asp:DropDownList ID="ddlCountry" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="ddlCountry" InitialValue=""
                                ErrorMessage="Country is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- User Type -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= ddlUserType.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">User Type:</label>
                        <div class="sm:col-span-2">
                            <asp:DropDownList ID="ddlUserType" runat="server"
                                CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvUserType" runat="server" ControlToValidate="ddlUserType" InitialValue=""
                                ErrorMessage="User Type is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Email Confirmed Checkbox -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                        <label for="<%= chkIsEmailConfirmed.ClientID %>" class="block text-gray-700 text-lg font-bold sm:text-right">Email Confirmed:</label>
                        <div class="sm:col-span-2">
                            <div class="flex items-center mt-2">
                                <asp:CheckBox ID="chkIsEmailConfirmed" runat="server"
                                    CssClass="h-6 w-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500" />
                                <label for="<%= chkIsEmailConfirmed.ClientID %>" class="ml-2 block text-gray-700 text-lg">
                                    Email is confirmed
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end mt-10 space-x-6">
                    <asp:Button ID="btnUpdate" runat="server" Text="Update User" OnClick="btnUpdate_Click"
                        CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-10 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300 text-xl" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CausesValidation="false"
                        CssClass="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-4 px-10 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-gray-300 text-xl" />
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
