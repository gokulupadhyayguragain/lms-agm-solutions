<%@ Page Title="About AGM Solutions" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="AGMSolutions.Common.HomePage" %>

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
    <style>
        /* Ensure the body uses the Inter font */
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Navigation/Auth Section -->
    <div class="bg-gray-100 py-4 border-b border-gray-200 shadow-sm">
        <div class="container mx-auto flex justify-end items-center px-4">
            <asp:Button ID="btnLogin" runat="server" Text="Login"
                CssClass="bg-transparent border-2 border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white font-bold py-2 px-6 rounded-full transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300 mr-3"
                OnClick="btnLogin_Click" />
            <asp:Button ID="btnSignup" runat="server" Text="Signup"
                CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300"
                OnClick="btnSignup_Click" />
        </div>
    </div>

    <!-- About Section - Hero Style -->
    <section class="bg-gradient-to-r from-blue-600 to-blue-800 text-white py-20 px-4 text-center">
        <div class="container mx-auto">
            <h1 class="text-5xl md:text-6xl font-extrabold mb-6 animate-fade-in-down">About AGM Solutions</h1>
            <p class="text-xl md:text-2xl leading-relaxed max-w-4xl mx-auto animate-fade-in-up">
                AGM Solutions is a cutting-edge Learning Management System designed to revolutionize online education.
                Our platform seamlessly connects students, lecturers, and administrators, providing a rich and interactive learning environment.
            </p>
        </div>
    </section>

    <!-- Mission and Features Section -->
    <section class="container mx-auto my-16 px-4 py-8 bg-white rounded-xl shadow-2xl">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <!-- Our Mission -->
            <div class="p-6 rounded-xl shadow-lg bg-gradient-to-br from-blue-50 to-blue-100 hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
                <i class="fas fa-bullseye text-blue-600 text-4xl mb-4"></i>
                <h3 class="text-3xl font-bold text-gray-800 mb-4">Our Mission</h3>
                <p class="text-lg text-gray-700 leading-relaxed">
                    To empower learners and educators with innovative tools and resources, making quality education accessible to everyone, everywhere. We strive to foster a global community of lifelong learners.
                </p>
            </div>
            <!-- Key Features -->
            <div class="p-6 rounded-xl shadow-lg bg-gradient-to-br from-green-50 to-green-100 hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
                <i class="fas fa-key text-green-600 text-4xl mb-4"></i>
                <h3 class="text-3xl font-bold text-gray-800 mb-4">Key Features</h3>
                <ul class="list-none p-0 space-y-3 text-lg text-gray-700">
                    <li class="flex items-center"><i class="fas fa-check-circle text-green-500 mr-3"></i>Comprehensive Course Management</li>
                    <li class="flex items-center"><i class="fas fa-check-circle text-green-500 mr-3"></i>Robust Quiz and Assignment System</li>
                    <li class="flex items-center"><i class="fas fa-check-circle text-green-500 mr-3"></i>Real-time Communication Tools</li>
                    <li class="flex items-center"><i class="fas fa-check-circle text-green-500 mr-3"></i>Personalized Dashboards</li>
                    <li class="flex items-center"><i class="fas fa-check-circle text-green-500 mr-3"></i>Secure User Authentication and Authorization</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- Call to Action Section -->
    <section class="bg-gray-800 text-white py-16 px-4 text-center">
        <div class="container mx-auto">
            <h2 class="text-4xl md:text-5xl font-extrabold mb-6">Ready to Experience the Future of Learning?</h2>
            <p class="text-xl md:text-2xl mb-10 max-w-3xl mx-auto">
                Join our growing community and unlock your full potential with AGM Solutions.
            </p>
            <a href="<%= ResolveUrl("~/Common/Signup.aspx") %>"
                class="inline-block bg-white hover:bg-blue-100 text-blue-700 font-bold py-4 px-10 rounded-full shadow-xl transition duration-300 ease-in-out transform hover:scale-110 focus:outline-none focus:ring-4 focus:ring-blue-300">
                Sign Up Now!
            </a>
        </div>
    </section>

    <!-- Footer -->
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

