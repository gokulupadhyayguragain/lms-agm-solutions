<%@ Page Title="My Assignments" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="AGMSolutions.Students.Assignments" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .alert-message {
            padding: 0.75rem 1.25rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            font-weight: 500;
        }
        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
        }
        .alert-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="bg-gray-50 min-h-screen py-12 px-4 sm:px-6 lg:px-8">
        <div class="container mx-auto max-w-4xl">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white rounded-xl shadow-lg p-8 mb-12 text-center">
                <h2 class="text-5xl md:text-6xl font-extrabold mb-4">
                    <i class="fas fa-clipboard-list mr-3"></i>Your Assignments
                </h2>
                <p class="text-xl md:text-2xl leading-relaxed max-w-3xl mx-auto">
                    View assigned tasks and submit your work.
                </p>
            </div>

            <!-- Alert Placeholder -->
            <div id="alertPlaceholder" runat="server" class="mb-6 alert-message">
                <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            </div>

            <!-- Assignments List Section -->
            <div class="bg-white rounded-xl shadow-lg p-6">
                <h3 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-tasks text-indigo-600 mr-3"></i>Upcoming Assignments
                </h3>

                <asp:Repeater ID="rptAssignments" runat="server">
                    <HeaderTemplate>
                        <div class="grid gap-6">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="bg-gray-100 rounded-lg shadow-md p-6 border border-gray-200">
                            <h4 class="text-2xl font-semibold text-gray-900 mb-2 flex items-center">
                                <i class="fas fa-file-invoice mr-2 text-blue-600"></i><%# Eval("Title") %>
                            </h4>
                            <p class="text-gray-700 mb-3"><%# Eval("Description") %></p>
                            <div class="flex flex-wrap items-center text-gray-600 text-base mb-4">
                                <span class="mr-4"><i class="far fa-calendar-alt mr-1"></i>Due: <%# Eval("DueDate", "{0:yyyy-MM-dd HH:mm}") %></span>
                                <span class="mr-4"><i class="fas fa-percent mr-1"></i>Max Marks: <%# Eval("MaxMarks") != DBNull.Value ? Eval("MaxMarks") : "N/A" %></span>
                                <span><i class="fas fa-book mr-1"></i>Course: Sample Course</span>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex space-x-3 mt-4">
                                <button type="button" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg transition duration-200">
                                    <i class="fas fa-upload mr-2"></i>Submit Assignment
                                </button>
                                <button type="button" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg transition duration-200">
                                    <i class="fas fa-eye mr-2"></i>View Details
                                </button>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <!-- Empty State -->
                <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false" CssClass="text-center py-12">
                    <i class="fas fa-clipboard-list text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-2xl font-semibold text-gray-600 mb-2">No Assignments Yet</h3>
                    <p class="text-gray-500">You don't have any assignments at the moment. Check back later!</p>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>
