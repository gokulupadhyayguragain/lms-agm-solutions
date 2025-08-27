<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourses.aspx.cs" Inherits="AGMSolutions.Admins.ManageCourses" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
    <style>
        .course-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
        }
        .course-body {
            padding: 20px;
        }
        .add-course-form {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-bottom: 30px;
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        .btn-action {
            margin: 2px;
            min-width: 80px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <h2 class="mb-4">
                    <i class="fas fa-graduation-cap me-2 text-primary"></i>
                    Course Management
                </h2>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number" runat="server" id="totalCoursesCount">0</div>
                            <div class="text-muted">Total Courses</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number" runat="server" id="activeCoursesCount">0</div>
                            <div class="text-muted">Active Courses</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number" runat="server" id="totalEnrollmentsCount">0</div>
                            <div class="text-muted">Total Enrollments</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="stats-number" runat="server" id="totalLecturersCount">0</div>
                            <div class="text-muted">Lecturers</div>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div runat="server" id="alertDiv" class="alert" visible="false">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </div>

                <!-- Add/Edit Course Form -->
                <div class="add-course-form">
                    <h4 class="mb-3">
                        <i class="fas fa-plus-circle me-2"></i>
                        Add New Course
                    </h4>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="txtCourseCode" class="form-label">Course Code *</label>
                                <asp:TextBox ID="txtCourseCode" runat="server" CssClass="form-control" 
                                    placeholder="e.g. CS101" MaxLength="20"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCourseCode" runat="server" 
                                    ControlToValidate="txtCourseCode" ErrorMessage="Course code is required" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="txtCourseName" class="form-label">Course Name *</label>
                                <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" 
                                    placeholder="e.g. Introduction to Computer Science" MaxLength="200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" 
                                    ControlToValidate="txtCourseName" ErrorMessage="Course name is required" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="txtDescription" class="form-label">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                            TextMode="MultiLine" Rows="3" placeholder="Course description..."></asp:TextBox>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="ddlLecturer" class="form-label">Assign Lecturer *</label>
                                <asp:DropDownList ID="ddlLecturer" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Select Lecturer --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvLecturer" runat="server" 
                                    ControlToValidate="ddlLecturer" ErrorMessage="Please select a lecturer" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="chkIsActive" class="form-label">Status</label>
                                <div class="form-check">
                                    <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                                    <label class="form-check-label" for="chkIsActive">Active Course</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-end">
                        <asp:Button ID="btnAddCourse" runat="server" Text="Add Course" 
                            CssClass="btn btn-primary" OnClick="btnAddCourse_Click" />
                        <asp:Button ID="btnUpdateCourse" runat="server" Text="Update Course" 
                            CssClass="btn btn-success" OnClick="btnUpdateCourse_Click" Visible="false" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" 
                            CssClass="btn btn-secondary" OnClick="btnCancelEdit_Click" Visible="false" CausesValidation="false" />
                    </div>
                    
                    <asp:HiddenField ID="hdnEditCourseId" runat="server" />
                </div>

                <!-- Courses List -->
                <div class="mb-3">
                    <h4>
                        <i class="fas fa-list me-2"></i>
                        All Courses
                    </h4>
                </div>

                <!-- Search and Filter -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="input-group">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                                placeholder="Search courses..."></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" 
                                CssClass="btn btn-outline-primary" OnClick="btnSearch_Click" CausesValidation="false" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                            <asp:ListItem Value="">All Courses</asp:ListItem>
                            <asp:ListItem Value="1">Active Only</asp:ListItem>
                            <asp:ListItem Value="0">Inactive Only</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="btnExportCourses" runat="server" Text="Export to Excel" 
                            CssClass="btn btn-outline-success w-100" OnClick="btnExportCourses_Click" CausesValidation="false" />
                    </div>
                </div>

                <!-- Courses Grid -->
                <asp:GridView ID="gvCourses" runat="server" CssClass="table table-striped table-hover"
                    AutoGenerateColumns="false" OnRowCommand="gvCourses_RowCommand" 
                    OnRowDataBound="gvCourses_RowDataBound" AllowPaging="true" PageSize="10" 
                    OnPageIndexChanging="gvCourses_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="CourseCode" HeaderText="Code" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                        <asp:BoundField DataField="LecturerName" HeaderText="Lecturer" />
                        <asp:BoundField DataField="EnrollmentCount" HeaderText="Enrollments" />
                        <asp:BoundField DataField="CreationDate" HeaderText="Created" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge bg-success" : "badge bg-secondary" %>'>
                                    <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnEdit" runat="server" Text="Edit" 
                                    CssClass="btn btn-sm btn-outline-primary btn-action" 
                                    CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' CausesValidation="false" />
                                <asp:Button ID="btnToggleStatus" runat="server" 
                                    Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>'
                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-sm btn-outline-warning btn-action" : "btn btn-sm btn-outline-success btn-action" %>'
                                    CommandName="ToggleStatus" CommandArgument='<%# Eval("CourseID") %>' 
                                    OnClientClick="return confirm('Are you sure you want to change the course status?');" CausesValidation="false" />
                                <asp:Button ID="btnViewDetails" runat="server" Text="Details" 
                                    CssClass="btn btn-sm btn-outline-info btn-action" 
                                    CommandName="ViewDetails" CommandArgument='<%# Eval("CourseID") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center py-4">
                            <i class="fas fa-graduation-cap fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No Courses Found</h5>
                            <p class="text-muted">No courses match your search criteria.</p>
                        </div>
                    </EmptyDataTemplate>
                    <PagerStyle CssClass="pagination justify-content-center" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
