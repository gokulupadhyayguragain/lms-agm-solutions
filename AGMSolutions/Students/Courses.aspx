<%@ Page Title="My Courses & Enroll" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="AGMSolutions.Students.Courses" %>

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

        /* Custom styling for the GridView to match Tailwind's aesthetic */
        .courses-gridview th {
            padding: 0.75rem 1.5rem; /* py-3 px-6 */
            text-align: left;
            font-size: 0.875rem; /* text-xs */
            font-weight: 600; /* font-semibold */
            color: #4b5563; /* gray-700 */
            text-transform: uppercase;
            letter-spacing: 0.05em;
            background-color: #f3f4f6; /* gray-100 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .courses-gridview td {
            padding: 1rem 1.5rem; /* py-4 px-6 */
            font-size: 0.875rem; /* text-sm */
            color: #6b7280; /* gray-600 */
            border-bottom: 1px solid #e5e7eb; /* gray-200 */
        }

        .courses-gridview tr:nth-child(odd) {
            background-color: #f9fafb; /* gray-50 for striped effect */
        }

        .courses-gridview tr:hover {
            background-color: #f3f4f6; /* gray-100 on hover */
            transition: background-color 0.2s ease-in-out;
        }

        /* Styling for empty data text */
        .courses-gridview .empty-data-row td {
            text-align: center;
            padding: 2rem;
            color: #9ca3af; /* gray-400 */
            font-style: italic;
        }

        /* Custom styling for pagination */
        .pagination-container {
            display: flex;
            justify-content: flex-end;
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
            font-size: 0.875rem; /* text-sm */
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
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-4xl md:text-5xl font-extrabold mb-4">My Courses & Available for Enrollment</h2>
                <p class="text-lg md:text-xl leading-relaxed max-w-3xl mx-auto">
                    Manage your enrolled courses and explore new opportunities for learning.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Tab Navigation -->
            <ul class="flex flex-wrap text-sm font-medium text-center text-gray-500 border-b border-gray-200 mb-8" id="myTab" role="tablist">
                <li class="mr-2">
                    <a class="inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300 active-tab-link"
                       id="enrolled-tab" data-toggle="tab" href="#enrolled" role="tab" aria-controls="enrolled" aria-selected="true">
                        <i class="fas fa-graduation-cap mr-2"></i>My Enrolled Courses
                    </a>
                </li>
                <li class="mr-2">
                    <a class="inline-block p-4 rounded-t-lg border-b-2 border-transparent hover:text-gray-600 hover:border-gray-300"
                       id="available-tab" data-toggle="tab" href="#available" role="tab" aria-controls="available" aria-selected="false">
                        <i class="fas fa-search mr-2"></i>Browse Available Courses
                    </a>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="myTabContent">
                <!-- Enrolled Courses Tab Pane -->
                <div class="tab-pane fade show active p-4 bg-white rounded-lg shadow-md" id="enrolled" role="tabpanel" aria-labelledby="enrolled-tab">
                    <h3 class="text-2xl font-bold text-gray-800 mb-6">Currently Enrolled Courses</h3>
                    <div class="overflow-x-auto rounded-lg shadow-lg">
                        <asp:GridView ID="gvEnrolledCourses" runat="server" AutoGenerateColumns="False"
                            CssClass="min-w-full divide-y divide-gray-200 courses-gridview"
                            EmptyDataText="You are not enrolled in any courses yet." DataKeyNames="EnrollmentID"
                            AllowPaging="True" PageSize="10" OnPageIndexChanging="gvEnrolledCourses_PageIndexChanging"
                            OnRowCommand="gvEnrolledCourses_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                                <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />
                                <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrolled On" DataFormatString="{0:d}" />
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnUnenroll" runat="server" Text="Unenroll"
                                            CssClass="inline-flex items-center px-4 py-2 bg-red-500 hover:bg-red-600 text-white text-sm font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-red-300"
                                            CommandName="UnenrollCourse" CommandArgument='<%# Eval("EnrollmentID") %>'
                                            ></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-container" />
                            <EmptyDataTemplate>
                                <div class="text-center py-8 text-gray-500 italic">
                                    You are not enrolled in any courses yet.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Available Courses Tab Pane -->
                <div class="tab-pane fade p-4 bg-white rounded-lg shadow-md" id="available" role="tabpanel" aria-labelledby="available-tab">
                    <h3 class="text-2xl font-bold text-gray-800 mb-6">Available for Enrollment</h3>
                    <div class="flex flex-col sm:flex-row gap-4 mb-6">
                        <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by course name or code"
                            CssClass="flex-grow px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                            CssClass="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-md shadow-md transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-300" />
                    </div>

                    <div class="overflow-x-auto rounded-lg shadow-lg">
                        <asp:GridView ID="gvAvailableCourses" runat="server" AutoGenerateColumns="False"
                            CssClass="min-w-full divide-y divide-gray-200 courses-gridview"
                            EmptyDataText="No courses available for enrollment." DataKeyNames="CourseID"
                            AllowPaging="True" PageSize="10" OnPageIndexChanging="gvAvailableCourses_PageIndexChanging"
                            OnRowCommand="gvAvailableCourses_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                                <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                                <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-Width="30%" />
                                <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />
                                <asp:TemplateField HeaderText="Enroll">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEnroll" runat="server" Text="Enroll"
                                            CssClass="inline-flex items-center px-4 py-2 bg-green-500 hover:bg-green-600 text-white text-sm font-medium rounded-md shadow-sm transition duration-300 ease-in-out focus:outline-none focus:ring-2 focus:ring-green-300"
                                            CommandName="EnrollCourse" CommandArgument='<%# Eval("CourseID") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination-container" />
                            <EmptyDataTemplate>
                                <div class="text-center py-8 text-gray-500 italic">
                                    No courses available for enrollment.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
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

    <script type="text/javascript">
        // JavaScript to handle tab switching (assuming Bootstrap JS is loaded via Site.Master)
        // This script ensures the active class is correctly applied for visual styling
        document.addEventListener('DOMContentLoaded', function () {
            const tabs = document.querySelectorAll('#myTab a');
            tabs.forEach(tab => {
                tab.addEventListener('click', function (event) {
                    event.preventDefault(); // Prevent default anchor behavior
                    const targetId = this.getAttribute('href');

                    // Remove 'active' classes from all tabs and tab panes
                    tabs.forEach(t => {
                        t.classList.remove('active-tab-link', 'text-blue-600', 'border-blue-600');
                        t.classList.add('border-transparent');
                    });
                    document.querySelectorAll('.tab-pane').forEach(pane => {
                        pane.classList.remove('show', 'active');
                    });

                    // Add 'active' classes to the clicked tab and its corresponding pane
                    this.classList.add('active-tab-link', 'text-blue-600', 'border-blue-600');
                    this.classList.remove('border-transparent');
                    document.querySelector(targetId).classList.add('show', 'active');
                });
            });

            // Set initial active tab on page load
            const initialActiveTab = document.querySelector('#myTab a.active-tab-link');
            if (initialActiveTab) {
                initialActiveTab.classList.add('text-blue-600', 'border-blue-600');
                initialActiveTab.classList.remove('border-transparent');
            } else {
                // Fallback: if no active-tab-link, activate the first tab
                const firstTab = document.querySelector('#myTab a');
                if (firstTab) {
                    firstTab.classList.add('active-tab-link', 'text-blue-600', 'border-blue-600');
                    firstTab.classList.remove('border-transparent');
                    document.querySelector(firstTab.getAttribute('href')).classList.add('show', 'active');
                }
            }
        });
    </script>
</asp:Content>
