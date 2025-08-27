<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HeaderAdmin.ascx.cs" Inherits="AGMSolutions.MasterPages.HeaderAdmin" %>

<!-- Note: Tailwind CSS and Font Awesome CDN links should ideally be in your MasterPage's <head> section
     to avoid duplication across multiple user controls/pages.
     However, for demonstration, I'll include them here to ensure styling is applied if this control
     is viewed in isolation or if your MasterPage doesn't already have them. -->
<script src="https://cdn.tailwindcss.com"></script>
<script>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

<style>
    /* Ensure the body uses the Inter font, assuming MasterPage sets this */
    body {
        font-family: 'Inter', sans-serif;
    }

    /* Custom styles for the responsive toggle button icon */
    .navbar-toggler-icon-tailwind {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgb(255, 255, 255)' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
        display: inline-block;
        width: 1.5em;
        height: 1.5em;
        vertical-align: middle;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 100%;
    }
</style>

<nav class="bg-gray-800 p-4 shadow-xl rounded-b-lg">
    <div class="container mx-auto flex justify-between items-center flex-wrap">
        <!-- Brand Logo/Text -->
        <a class="text-white text-2xl font-bold hover:text-blue-300 transition-colors duration-300 flex items-center" href="/Admins/Dashboard.aspx">
            <i class="fas fa-tools mr-3 text-blue-400"></i>AGM Admin Portal
        </a>

        <!-- Mobile Toggler Button -->
        <button class="block lg:hidden px-3 py-2 border border-white rounded focus:outline-none focus:ring-2 focus:ring-blue-300" type="button" data-toggle="collapse" data-target="#navbarNavAdmin" aria-controls="navbarNavAdmin" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon-tailwind"></span>
        </button>

        <!-- Navigation Links (collapsed on mobile, expanded on large screens) -->
        <div class="hidden w-full lg:flex lg:items-center lg:w-auto" id="navbarNavAdmin">
            <ul class="lg:flex items-center space-y-2 lg:space-y-0 lg:space-x-6 mt-4 lg:mt-0 w-full lg:w-auto">
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/Dashboard.aspx">
                        <i class="fas fa-tachometer-alt mr-2"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/EditUser.aspx">
                        <i class="fas fa-users mr-2"></i>Users
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/Courses.aspx">
                        <i class="fas fa-book mr-2"></i>Courses
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/Roles.aspx">
                        <i class="fas fa-user-tag mr-2"></i>Roles
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/Settings.aspx">
                        <i class="fas fa-cog mr-2"></i>Settings
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-gray-300 hover:text-white transition-colors duration-300 text-lg flex items-center py-2 px-3 rounded-md hover:bg-gray-700" href="/Admins/Profile.aspx">
                        <i class="fas fa-user-circle mr-2"></i>Profile
                    </a>
                </li>
            </ul>
            
            <!-- Logout Button -->
            <ul class="lg:ml-auto mt-4 lg:mt-0 w-full lg:w-auto"> <%-- ml-auto for right alignment on large screens --%>
                <li class="nav-item">
                    <asp:LinkButton ID="lnkLogout" runat="server" OnClick="lnkLogout_Click"
                        CssClass="nav-link bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-5 rounded-full shadow-md transition duration-300 ease-in-out transform hover:scale-105 text-lg flex items-center justify-center lg:inline-flex">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </asp:LinkButton>
                </li>
            </ul>
        </div>
    </div>
</nav>
