<%@ Page Title="My Assignments" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="AssignmentsNew.aspx.cs" Inherits="AGMSolutions.Students.AssignmentsNew" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .assignment-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
            transition: transform 0.3s ease;
        }
        .assignment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-submitted { background: #d1ecf1; color: #0c5460; }
        .status-overdue { background: #f8d7da; color: #721c24; }
        .upload-area {
            border: 2px dashed #ddd;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            margin: 15px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <h2 class="mb-4">
                    <i class="fas fa-tasks me-2 text-primary"></i>
                    My Assignments
                </h2>

                <!-- Alert Messages -->
                <div runat="server" id="alertDiv" class="alert alert-info" visible="false">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </div>

                <!-- Assignments List -->
                <asp:Repeater ID="rptAssignments" runat="server" OnItemCommand="rptAssignments_ItemCommand">
                    <ItemTemplate>
                        <div class="assignment-card">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-2">
                                        <i class="fas fa-file-alt me-2"></i>
                                        <%# Eval("Title") %>
                                    </h5>
                                    <p class="text-muted mb-2"><%# Eval("Description") %></p>
                                    <small class="text-muted">
                                        <i class="fas fa-book me-1"></i>
                                        Course: <%# Eval("CourseName") %>
                                    </small>
                                </div>
                                <div class="col-md-3 text-center">
                                    <p class="mb-1"><strong>Due Date:</strong></p>
                                    <p class="text-danger">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <%# Convert.ToDateTime(Eval("DueDate")).ToString("MMM dd, yyyy") %>
                                    </p>
                                </div>
                                <div class="col-md-3 text-center">
                                    <span class="status-badge status-pending">
                                        Pending
                                    </span>
                                    <div class="mt-3">
                                        <asp:Button ID="btnSubmit" runat="server" 
                                            Text="Submit" 
                                            CssClass="btn btn-primary btn-sm" 
                                            CommandName="Submit" 
                                            CommandArgument='<%# Eval("AssignmentID") %>' />
                                    </div>
                                </div>
                            </div>

                            <!-- Upload Form -->
                            <div class="upload-section mt-3" style="display: none;" id="uploadForm_<%# Eval("AssignmentID") %>">
                                <hr class="my-3" />
                                <h6>Submit Assignment</h6>
                                <div class="upload-area">
                                    <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                    <p>Choose file to upload</p>
                                    <asp:FileUpload ID="fuAssignment" runat="server" CssClass="form-control mb-3" />
                                    <asp:Button ID="btnUpload" runat="server" 
                                        Text="Upload Assignment" 
                                        CssClass="btn btn-success" 
                                        CommandName="Upload" 
                                        CommandArgument='<%# Eval("AssignmentID") %>' />
                                    <button type="button" class="btn btn-secondary ms-2">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- No Assignments Message -->
                <div runat="server" id="noAssignmentsDiv" class="text-center py-5" visible="false">
                    <i class="fas fa-tasks fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No Assignments Yet</h4>
                    <p class="text-muted">You haven't been assigned any assignments yet.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showUploadForm(assignmentId) {
            document.getElementById('uploadForm_' + assignmentId).style.display = 'block';
        }

        function hideUploadForm(assignmentId) {
            document.getElementById('uploadForm_' + assignmentId).style.display = 'none';
        }
    </script>
</asp:Content>
