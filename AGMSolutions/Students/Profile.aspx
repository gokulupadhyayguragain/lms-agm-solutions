<%@ Page Title="Student Profile" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="AGMSolutions.Students.Profile" %>

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

        /* Custom styling for ASP.NET Validators to ensure consistent display */
        .validator-error {
            color: #ef4444; /* Tailwind red-500 */
            font-size: 0.75rem; /* Tailwind text-xs */
            margin-top: 0.25rem; /* Tailwind mt-1 */
            display: block; /* Ensure it takes its own line */
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
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">My Profile</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Manage your personal information and account settings.
                </p>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                <!-- Profile Picture Section (left column on larger screens) -->
                <div class="lg:col-span-1 flex flex-col items-center justify-start bg-white rounded-xl shadow-lg p-6 h-fit">
                    <div class="profile-picture-container mb-6 text-center">
                        <asp:Image ID="imgProfilePicture" runat="server"
                            CssClass="w-36 h-36 object-cover rounded-full border-4 border-blue-300 shadow-md mb-4"
                            ImageUrl="~/Images/default-profile.png" />
                        <asp:FileUpload ID="fuProfilePicture" runat="server"
                            CssClass="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100" />
                        <asp:Button ID="btnUploadPicture" runat="server" Text="Upload New Picture" OnClick="btnUploadPicture_Click"
                            CssClass="mt-4 w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-full shadow-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300" />
                        <asp:Label ID="lblPictureMessage" runat="server" CssClass="text-red-500 text-sm mt-2 block"></asp:Label>
                    </div>
                </div>

                <!-- Personal Details and Change Password Sections (right columns on larger screens) -->
                <div class="lg:col-span-3 space-y-8">
                    <!-- Personal Details Card -->
                    <div class="bg-white rounded-xl shadow-lg p-8">
                        <h5 class="text-2xl font-bold text-gray-800 mb-6">Personal Details</h5>
                        <div class="space-y-4">
                            <!-- First Name -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtFirstName.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">First Name:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtFirstName" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                                        ErrorMessage="First Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- Middle Name -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtMiddleName.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Middle Name:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtMiddleName" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                </div>
                            </div>
                            <!-- Last Name -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtLastName.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Last Name:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtLastName" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                                        ErrorMessage="Last Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- Gender -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= ddlGender.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Gender:</label>
                                <div class="sm:col-span-2">
                                    <asp:DropDownList ID="ddlGender" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
                                        <asp:ListItem Value="">-- Select Gender --</asp:ListItem>
                                        <asp:ListItem Value="Male">Male</asp:ListItem>
                                        <asp:ListItem Value="Female">Female</asp:ListItem>
                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvGender" runat="server" ControlToValidate="ddlGender" InitialValue=""
                                        ErrorMessage="Gender is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- Date of Birth -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtDateOfBirth.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Date of Birth:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvDateOfBirth" runat="server" ControlToValidate="txtDateOfBirth"
                                        ErrorMessage="Date of Birth is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- Email -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtEmail.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Email:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed" ReadOnly="true"></asp:TextBox>
                                    <small class="block text-gray-500 text-xs mt-1">Email cannot be changed directly here. Use "Change Email" option.</small>
                                </div>
                            </div>
                            <!-- Phone Number -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtPhoneNo.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Phone Number:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtPhoneNo" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="revPhoneNo" runat="server" ControlToValidate="txtPhoneNo" ValidationExpression="^\+?[0-9]{10,15}$"
                                        ErrorMessage="Invalid Phone Number. Use format +CountryCodeNumber." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <!-- Country -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtCountry.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Country:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtCountry" runat="server"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCountry" runat="server" ControlToValidate="txtCountry"
                                        ErrorMessage="Country is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </div>

                        <div class="text-right mt-8">
                            <asp:Button ID="btnUpdateProfile" runat="server" Text="Update Profile" OnClick="btnUpdateProfile_Click"
                                CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300" />
                        </div>
                        <asp:Label ID="lblProfileMessage" runat="server" CssClass="alert-message mt-4 block"></asp:Label>
                    </div>

                    <!-- Change Password Card -->
                    <div class="bg-white rounded-xl shadow-lg p-8">
                        <h5 class="text-2xl font-bold text-gray-800 mb-6">Change Password</h5>
                        <div class="space-y-4">
                            <!-- Current Password -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtCurrentPassword.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Current Password:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" ControlToValidate="txtCurrentPassword"
                                        ErrorMessage="Current Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <!-- New Password -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtNewPassword.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">New Password:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword"
                                        ErrorMessage="New Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revNewPassword" runat="server" ControlToValidate="txtNewPassword"
                                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                                        ErrorMessage="Min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <!-- Confirm New Password -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 items-center gap-4">
                                <label for="<%= txtConfirmNewPassword.ClientID %>" class="block text-gray-700 text-sm font-bold sm:text-right">Confirm New Password:</label>
                                <div class="sm:col-span-2">
                                    <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password"
                                        CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                                    <asp:CompareValidator ID="cvConfirmNewPassword" runat="server" ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmNewPassword"
                                        ErrorMessage="Passwords do not match." CssClass="validator-error" Display="Dynamic"></asp:CompareValidator>
                                </div>
                            </div>
                        </div>
                        <div class="text-right mt-8">
                            <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" OnClick="btnChangePassword_Click"
                                CssClass="bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-orange-300" />
                        </div>
                        <asp:Label ID="lblPasswordMessage" runat="server" CssClass="alert-message mt-4 block"></asp:Label>
                    </div>
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
