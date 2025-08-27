<%@ Page Title="Welcome to AGM Solutions" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="AGMSolutions.Common.Landing" %>

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

        /* Custom styling for the hero banner background image */
        .landing-banner {
            /* Updated to use your local image path */
            background-image: url('../Images/landing-banner.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hero Section -->
    <!-- Changed height from h-screen to h-[60vh] to make it smaller but still responsive -->
    <div class="landing-banner relative h-[60vh] flex items-center justify-center text-white overflow-hidden">
        <!-- Overlay for better text readability -->
        <div class="absolute inset-0 bg-black opacity-60"></div>
        <div class="relative z-10 text-center px-4">
            <h1 class="text-5xl md:text-6xl font-extrabold mb-6 drop-shadow-lg animate-fade-in-down">
                Welcome to AGM Solutions LMS
            </h1>
            <p class="text-xl md:text-2xl mb-8 leading-relaxed drop-shadow-md animate-fade-in-up">
                Your journey to knowledge starts here. Empowering minds, one lesson at a time.
            </p>
            <div class="flex flex-col sm:flex-row justify-center gap-4">
                <asp:Button ID="btnGetStarted" runat="server" Text="Get Started"
                    CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-blue-300 animate-fade-in-left"
                    OnClick="btnGetStarted_Click" />
                <asp:Button ID="btnLearnMore" runat="server" Text="Learn More"
                    CssClass="bg-transparent border-2 border-white hover:bg-white hover:text-blue-600 text-white font-bold py-3 px-8 rounded-full shadow-lg transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-white animate-fade-in-right"
                    OnClick="btnLearnMore_Click" />
            </div>
        </div>
    </div>

    <!-- About Our Platform Section -->
    <section class="container mx-auto my-16 px-4 py-8 text-center bg-white rounded-xl shadow-2xl">
        <h2 class="text-4xl font-bold text-gray-800 mb-6">About Our Platform</h2>
        <p class="text-lg text-gray-600 max-w-3xl mx-auto mb-12">
            AGM Solutions provides a comprehensive online learning experience designed to meet the needs of students, lecturers, and administrators alike. Discover a world of knowledge at your fingertips.
        </p>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Feature 1: Flexible Learning -->
            <div class="bg-gradient-to-br from-blue-50 to-blue-100 p-8 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
                <i class="fas fa-mobile-alt text-blue-600 text-5xl mb-4"></i>
                <h3 class="text-2xl font-semibold text-gray-800 mb-3">Flexible Learning</h3>
                <p class="text-gray-600 leading-relaxed">Access courses anytime, anywhere, on any device. Our platform is designed for your convenience and learning on the go.</p>
            </div>
            <!-- Feature 2: Expert Lecturers -->
            <div class="bg-gradient-to-br from-green-50 to-green-100 p-8 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
                <i class="fas fa-chalkboard-teacher text-green-600 text-5xl mb-4"></i>
                <h3 class="text-2xl font-semibold text-gray-800 mb-3">Expert Lecturers</h3>
                <p class="text-gray-600 leading-relaxed">Learn from experienced educators and industry professionals dedicated to your success and growth.</p>
            </div>
            <!-- Feature 3: Robust Management -->
            <div class="bg-gradient-to-br from-purple-50 to-purple-100 p-8 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
                <i class="fas fa-cogs text-purple-600 text-5xl mb-4"></i>
                <h3 class="text-2xl font-semibold text-gray-800 mb-3">Robust Management</h3>
                <p class="text-gray-600 leading-relaxed">Enjoy seamless course and user administration with powerful tools for efficient platform management.</p>
            </div>
        </div>
    </section>

    <!-- Why Choose Us Section -->
    <section class="bg-gray-50 py-16 px-4">
        <div class="container mx-auto text-center">
            <h2 class="text-4xl font-bold text-gray-800 mb-6">Why Choose AGM Solutions?</h2>
            <p class="text-lg text-gray-600 max-w-4xl mx-auto mb-12">
                We are committed to providing an unparalleled learning experience. Our platform is built with you in mind, offering features that truly make a difference.
            </p>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-check-circle text-blue-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Intuitive Interface</h4>
                        <p class="text-gray-600">Easy to navigate, ensuring a smooth and enjoyable learning journey for everyone.</p>
                    </div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-globe text-green-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Global Access</h4>
                        <p class="text-gray-600">Learn from anywhere in the world, breaking down geographical barriers to education.</p>
                    </div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-headset text-purple-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Dedicated Support</h4>
                        <p class="text-gray-600">Our support team is always ready to assist you with any queries or issues.</p>
                    </div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-certificate text-yellow-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Certified Courses</h4>
                        <p class="text-gray-600">Gain valuable certifications upon completion of our high-quality courses.</p>
                    </div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-users text-red-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Community Driven</h4>
                        <p class="text-gray-600">Connect with peers and lecturers in an engaging and supportive community.</p>
                    </div>
                </div>
                <div class="bg-white p-6 rounded-xl shadow-md flex items-start text-left">
                    <i class="fas fa-chart-line text-teal-500 text-3xl mr-4 mt-1"></i>
                    <div>
                        <h4 class="text-xl font-semibold text-gray-800 mb-2">Progress Tracking</h4>
                        <p class="text-gray-600">Monitor your learning progress with detailed analytics and insights.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action Section -->
    <section class="bg-blue-700 text-white py-20 px-4 text-center">
        <div class="container mx-auto">
            <h2 class="text-4xl md:text-5xl font-extrabold mb-6">Ready to Start Your Learning Journey?</h2>
            <p class="text-xl md:text-2xl mb-10 max-w-3xl mx-auto">
                Join thousands of learners who are transforming their futures with AGM Solutions LMS.
            </p>
            <asp:Button ID="btnJoinNow" runat="server" Text="Join Now"
                CssClass="bg-white hover:bg-blue-100 text-blue-700 font-bold py-4 px-10 rounded-full shadow-xl transition duration-300 ease-in-out transform hover:scale-110 focus:outline-none focus:ring-4 focus:ring-blue-300"
                OnClick="btnGetStarted_Click" /> <!-- Reusing GetStarted click handler -->
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

