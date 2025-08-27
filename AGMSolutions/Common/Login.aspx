<%@ Page Title="Login" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="AGMSolutions.Common.Login" %>

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
    <!-- Load Font Awesome for icons (if needed for future enhancements like password visibility toggles) -->
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

        /* Custom background for the entire page */
        .login-background {
            background-image: url('https://th.bing.com/th/id/R.4979efecfa4d687f3f03d238875c00db?rik=KVPPVyLnwhySKg&pid=ImgRaw&r=0'); /* Educational placeholder image */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Main container for centering the login form with a background image -->
    <div class="min-h-screen flex items-center justify-center login-background relative">
        <!-- Overlay for better text readability on the background image -->
        <div class="absolute inset-0 bg-black opacity-50"></div>

        <!-- Login Form Container -->
        <!-- Adjusted max-w to max-w-md for a narrower form, creating the "width less than height" effect -->
        <div class="relative z-10 w-full max-w-md p-8 bg-white rounded-xl shadow-2xl space-y-6">
            <h2 class="text-3xl font-bold text-center text-gray-800 mb-8">Login to Your Account</h2>

            <!-- Alert Placeholder for server-side messages -->
            <div id="alertPlaceholder" runat="server" class="alert-placeholder">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Email Input Group -->
            <div class="space-y-2">
                <label for="<%= txtEmail.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email address"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Password Input Group -->
            <div class="space-y-2">
                <label for="<%= txtPassword.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Login Button -->
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click"
                CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300 mt-6" />

            <!-- Links Section -->
            <div class="text-center mt-6 text-gray-600">
                <a href="ResendConfirmation.aspx" class="block text-blue-600 hover:text-blue-800 transition-colors duration-200 mt-2">Resend Confirmation Email</a>
                <a href="ForgotPassword.aspx" class="block text-blue-600 hover:text-blue-800 transition-colors duration-200 mt-2">Forgot Password?</a>
                <hr class="my-4 border-gray-300" />
                <p>Don't have an account? <a href="Signup.aspx" class="text-blue-600 hover:text-blue-800 font-semibold transition-colors duration-200">Sign Up here</a>.</p>
            </div>
        </div>
    </div>

    <!-- Footer (consistent with other pages) -->
    <footer class="bg-gray-800 text-white py-8 px-4">
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


