<%@ Page Title="Your Page Title" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourse.aspx.cs" Inherits="AGMSolutions.Lecturers.ManageCourse" %>

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
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto max-w-4xl">
            <!-- Page Header Example -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">
                    <i class="fas fa-file-alt mr-3"></i>Your Page Title Here
                </h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    This is a description for your new page.
                </p>
            </div>

            <!-- Alert Placeholder Example -->
            <div id="alertPlaceholder" runat="server" class="mb-6 alert-message">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Your Page Content Goes Here -->
            <div class="bg-white rounded-xl shadow-lg p-8">
                <h3 class="text-3xl font-bold text-gray-800 mb-6">Section Title</h3>
                <p class="text-gray-700 mb-4">
                    Start building your new Web Form content here. You can add ASP.NET controls,
                    HTML elements, and apply Tailwind CSS classes for styling.
                </p>
                <!-- Example of an input field -->
                <div class="mb-4">
                    <label for="txtExample" class="block text-gray-700 text-lg font-bold mb-2">Example Input:</label>
                    <asp:TextBox ID="txtExample" runat="server"
                        CssClass="block w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 text-lg"></asp:TextBox>
                </div>
                <!-- Example of a button -->
                <div class="text-right">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit"
                        CssClass="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-green-300 text-lg" />
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
