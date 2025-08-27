<%@ Page Title="Sign Up" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="AGMSolutions.Common.Signup" %>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" xintegrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0V4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Load jQuery for client-side scripts like phone number auto-fill -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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

        /* Custom background for the entire page, matching the login page theme */
        .signup-background {
            background-image: url('https://th.bing.com/th/id/R.22e293c286917d158ffe25e2b9c0b72e?rik=%2bOLI%2f%2bGYznU4dg&pid=ImgRaw&r=0'); /* Educational placeholder image */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        /* Custom styling for the User Type Radio Buttons to match the theme */
        .user-type-selection .user-type-radio label {
            /* Flex-grow for equal width, text alignment, padding, border, rounded, cursor, transition, margin */
            flex-grow: 1;
            text-align: center;
            padding: 0.75rem 1rem; /* py-3 px-4 */
            border: 1px solid #d1d5db; /* gray-300 */
            border-radius: 0.5rem; /* rounded-lg */
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 0 0.25rem; /* mx-1 */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* gray-700 */
        }
        .user-type-selection .user-type-radio input[type="radio"] {
            display: none; /* Hide default radio button */
        }
        /* Style for checked state */
        .user-type-selection .user-type-radio input[type="radio"]:checked + label {
            background-color: #2563eb; /* blue-600 */
            color: white;
            border-color: #2563eb; /* blue-600 */
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); /* shadow-md */
        }
        /* Style for hover state */
        .user-type-selection .user-type-radio input[type="radio"]:hover + label {
            background-color: #eff6ff; /* blue-50 */
        }

        /* Alert placeholder styling */
        .alert-placeholder .alert {
            color: #1f2937; /* gray-800 */
            background-color: #e0f2fe; /* blue-100 */
            border-color: #93c5fd; /* blue-300 */
            padding: 0.75rem 1.25rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
        }
        .alert-success {
            color: #065f46; /* green-700 */
            background-color: #d1fae5; /* green-100 */
            border-color: #6ee7b7; /* green-300 */
        }
        .alert-warning {
            color: #92400e; /* orange-700 */
            background-color: #fff7ed; /* orange-50 */
            border-color: #fdba74; /* orange-300 */
        }
        .alert-danger {
            color: #991b1b; /* red-700 */
            background-color: #fee2e2; /* red-100 */
            border-color: #fca5a5; /* red-300 */
        }
        .alert-info {
            color: #1e40af; /* blue-800 */
            background-color: #dbeafe; /* blue-100 */
            border-color: #93c5fd; /* blue-300 */
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Main container for centering the signup form with a background image -->
    <div class="min-h-screen flex items-center justify-center signup-background relative py-12 px-4 sm:px-6 lg:px-8">
        <!-- Overlay for better text readability on the background image -->
        <div class="absolute inset-0 bg-black opacity-50"></div>

        <!-- Signup Form Container -->
        <div class="relative z-10 w-full max-w-xl p-8 bg-white rounded-xl shadow-2xl space-y-6">
            <h2 class="text-3xl font-bold text-center text-gray-800 mb-8">Create Your Account</h2>

            <!-- Alert Placeholder for server-side messages -->
            <div id="alertPlaceholder" runat="server" class="alert-placeholder">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- First Name Input Group -->
            <div class="space-y-2">
                <label for="<%= txtFirstName.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">First Name:</label>
                <asp:TextBox ID="txtFirstName" runat="server" placeholder="Enter first name"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                    ErrorMessage="First Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Middle Name Input Group (Optional) -->
            <div class="space-y-2">
                <label for="<%= txtMiddleName.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Middle Name (Optional):</label>
                <asp:TextBox ID="txtMiddleName" runat="server" placeholder="Enter middle name"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
            </div>

            <!-- Last Name Input Group -->
            <div class="space-y-2">
                <label for="<%= txtLastName.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Last Name:</label>
                <asp:TextBox ID="txtLastName" runat="server" placeholder="Enter last name"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                    ErrorMessage="Last Name is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <!-- Email Input Group -->
            <div class="space-y-2">
                <label for="<%= txtEmail.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter email address"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    ErrorMessage="Enter a valid email address." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <!-- Password Input Group -->
            <div class="space-y-2">
                <label for="<%= txtPassword.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+}{&quot;:;'?/&gt;.&lt;,])(?!.*\s).{8,}$"
                    ErrorMessage="Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <!-- Confirm Password Input Group -->
            <div class="space-y-2">
                <label for="<%= txtConfirmPassword.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Confirm Password:</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm password"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Confirm Password is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPasswords" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                    ErrorMessage="Passwords do not match." CssClass="validator-error" Display="Dynamic"></asp:CompareValidator>
            </div>

            <!-- Country Dropdown Group -->
            <div class="space-y-2">
                <label for="<%= ddlCountry.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Country:</label>
                <asp:DropDownList ID="ddlCountry" runat="server"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200">
                    <asp:ListItem Value="">-- Select Country --</asp:ListItem>
                    <asp:ListItem Value="Nepal">Nepal</asp:ListItem>
                    <asp:ListItem Value="India">India</asp:ListItem>
                    <asp:ListItem Value="USA">USA</asp:ListItem>
                    <asp:ListItem Value="UK">UK</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Phone Number Input Group -->
            <div class="space-y-2">
                <label for="<%= txtPhoneNo.ClientID %>" class="block text-gray-700 text-sm font-bold mb-2">Phone Number:</label>
                <asp:TextBox ID="txtPhoneNo" runat="server" placeholder="Enter phone number"
                    CssClass="block w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
            </div>

            <!-- User Type Selection Group -->
            <div class="space-y-2">
                <label class="block text-gray-700 text-sm font-bold mb-2">User Type:</label>
                <div class="user-type-selection flex justify-center gap-4 mb-4">
                    <asp:RadioButton ID="rbStudent" runat="server" GroupName="UserType" Text="Student" Value="Student" CssClass="user-type-radio" Checked="true" />
                    <asp:RadioButton ID="rbLecturer" runat="server" GroupName="UserType" Text="Lecturer" Value="Lecturer" CssClass="user-type-radio" />
                    <asp:RadioButton ID="rbAdmin" runat="server" GroupName="UserType" Text="Administrator" Value="Admin" CssClass="user-type-radio" />
                </div>
                <asp:CustomValidator ID="cvUserType" runat="server" ClientValidationFunction="ValidateUserType"
                    ErrorMessage="Please select a user type." CssClass="validator-error" Display="Dynamic"></asp:CustomValidator>
            </div>

            <!-- Register Button -->
            <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click"
                CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300 mt-6" />

            <!-- Login Link -->
            <div class="text-center mt-6 text-gray-600">
                Already have an account? <a href="Login.aspx" class="text-blue-600 hover:text-blue-800 font-semibold transition-colors duration-200">Login here</a>.
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

    <script type="text/javascript">
        // Client-side validation function for user type selection
        function ValidateUserType(source, args) {
            var studentChecked = document.getElementById('<%= rbStudent.ClientID %>').checked;
            var lecturerChecked = document.getElementById('<%= rbLecturer.ClientID %>').checked;
            var adminChecked = document.getElementById('<%= rbAdmin.ClientID %>').checked;
            args.IsValid = studentChecked || lecturerChecked || adminChecked;
        }

        // Client-side phone number auto-code (simplified example)
        $(document).ready(function () {
            $('#<%= ddlCountry.ClientID %>').change(function () {
                var country = $(this).val();
                var phoneNoField = $('#<%= txtPhoneNo.ClientID %>');
                var currentPhoneNo = phoneNoField.val();

                // Clear existing code if any (simple approach to avoid double prefixes)
                if (currentPhoneNo.startsWith('+')) {
                    var parts = currentPhoneNo.split(' ');
                    if (parts.length > 1) {
                        phoneNoField.val(parts[1]); // Keep just the number part
                    } else {
                        phoneNoField.val(''); // Clear if only prefix
                    }
                }

                switch (country) {
                    case "Nepal":
                        phoneNoField.val('+977 ' + phoneNoField.val());
                        break;
                    case "India":
                        phoneNoField.val('+91 ' + phoneNoField.val());
                        break;
                    case "USA":
                        phoneNoField.val('+1 ' + phoneNoField.val());
                        break;
                    case "UK":
                        phoneNoField.val('+44 ' + phoneNoField.val());
                        break;
                    default:
                        // No prefix or handle unknown countries
                        break;
                }
            });
        });
    </script>
</asp:Content>

