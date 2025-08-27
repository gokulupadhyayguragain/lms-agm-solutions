<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageQuizzes.aspx.cs" Inherits="Lecturers_ManageQuizzes" MasterPageFile="~/MasterPages/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-gradient-success text-white py-3">
                        <h4 class="mb-0">
                            <i class="fas fa-quiz me-2"></i>Quiz Management System
                        </h4>
                        <p class="mb-0 mt-2 opacity-90">Upload and manage JSON quiz files for your courses</p>
                    </div>
                    <div class="card-body p-4">
                        <!-- Upload New Quiz Section -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card border-success">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-upload text-success me-2"></i>Upload New Quiz</h5>
                                    </div>
                                    <div class="card-body">
                                        <asp:UpdatePanel ID="upUpload" runat="server">
                                            <ContentTemplate>
                                                <div class="mb-3">
                                                    <label for="ddlCourse" class="form-label">Select Course</label>
                                                    <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlCourse_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <label for="txtQuizTitle" class="form-label">Quiz Title</label>
                                                    <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" placeholder="e.g., ALGEBRA-01"></asp:TextBox>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <label for="fuQuizFile" class="form-label">Quiz JSON File</label>
                                                    <asp:FileUpload ID="fuQuizFile" runat="server" CssClass="form-control" accept=".json" />
                                                    <div class="form-text">Expected format: MATHS001-01-ALGEBRA-01.json</div>
                                                </div>
                                                
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label for="txtTimeLimit" class="form-label">Time Limit (minutes)</label>
                                                        <asp:TextBox ID="txtTimeLimit" runat="server" CssClass="form-control" Text="30" TextMode="Number"></asp:TextBox>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label for="txtPassingScore" class="form-label">Passing Score (%)</label>
                                                        <asp:TextBox ID="txtPassingScore" runat="server" CssClass="form-control" Text="70" TextMode="Number"></asp:TextBox>
                                                    </div>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <div class="form-check">
                                                        <asp:CheckBox ID="chkEnableProctoring" runat="server" CssClass="form-check-input" />
                                                        <label class="form-check-label" for="chkEnableProctoring">
                                                            Enable Proctoring (Camera & Screen monitoring)
                                                        </label>
                                                    </div>
                                                </div>
                                                
                                                <asp:Button ID="btnUploadQuiz" runat="server" CssClass="btn btn-success" Text="Upload Quiz" OnClick="btnUploadQuiz_Click" />
                                            </ContentTemplate>
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="btnUploadQuiz" />
                                            </Triggers>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="card border-info">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-info-circle text-info me-2"></i>JSON Format Guide</h5>
                                    </div>
                                    <div class="card-body">
                                        <h6>Required JSON Structure:</h6>
                                        <pre class="bg-light p-3 rounded"><code>{
  "quizTitle": "Algebra Basics",
  "totalQuestions": 5,
  "timeLimit": 30,
  "questions": [
    {
      "id": 1,
      "type": "mcq",
      "question": "What is 2+2?",
      "options": ["3", "4", "5", "6"],
      "correct": 1
    },
    {
      "id": 2,
      "type": "dragdrop",
      "question": "Match items",
      "items": ["x", "y"],
      "targets": ["Variable 1", "Variable 2"],
      "correct": [0, 1]
    }
  ]
}</code></pre>
                                        <div class="mt-3">
                                            <h6>Supported Question Types:</h6>
                                            <ul class="list-unstyled">
                                                <li><span class="badge bg-primary me-2">mcq</span>Multiple Choice Questions</li>
                                                <li><span class="badge bg-info me-2">dragdrop</span>Drag & Drop Matching</li>
                                                <li><span class="badge bg-warning me-2">dropdown</span>Dropdown Selection</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Existing Quizzes Section -->
                        <div class="card border-primary">
                            <div class="card-header bg-light">
                                <h5 class="mb-0"><i class="fas fa-list text-primary me-2"></i>Existing Quizzes</h5>
                            </div>
                            <div class="card-body">
                                <asp:UpdatePanel ID="upQuizList" runat="server">
                                    <ContentTemplate>
                                        <asp:GridView ID="gvQuizzes" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" 
                                                      OnRowCommand="gvQuizzes_RowCommand" DataKeyNames="QuizID">
                                            <Columns>
                                                <asp:BoundField DataField="CourseCode" HeaderText="Course" />
                                                <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                                                <asp:BoundField DataField="FileName" HeaderText="File Name" />
                                                <asp:BoundField DataField="TotalQuestions" HeaderText="Questions" />
                                                <asp:BoundField DataField="TimeLimit" HeaderText="Time (min)" />
                                                <asp:BoundField DataField="PassingScore" HeaderText="Pass %" />
                                                <asp:TemplateField HeaderText="Proctoring">
                                                    <ItemTemplate>
                                                        <span class="badge bg-<%# (bool)Eval("EnableProctoring") ? "success" : "secondary" %>">
                                                            <%# (bool)Eval("EnableProctoring") ? "Enabled" : "Disabled" %>
                                                        </span>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="UploadDate" HeaderText="Upload Date" DataFormatString="{0:MMM dd, yyyy}" />
                                                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="200px">
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm btn-outline-primary me-1" 
                                                                        CommandName="EditQuiz" CommandArgument='<%# Eval("QuizID") %>'>
                                                            <i class="fas fa-edit"></i> Edit
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnViewResults" runat="server" CssClass="btn btn-sm btn-outline-info me-1" 
                                                                        CommandName="ViewResults" CommandArgument='<%# Eval("QuizID") %>'>
                                                            <i class="fas fa-chart-bar"></i> Results
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger" 
                                                                        CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizID") %>'
                                                                        OnClientClick="return confirm('Are you sure you want to delete this quiz?');">
                                                            <i class="fas fa-trash"></i> Delete
                                                        </asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div class="text-center text-muted py-4">
                                                    <i class="fas fa-quiz fa-3x mb-3"></i>
                                                    <h5>No quizzes uploaded yet</h5>
                                                    <p>Upload your first JSON quiz file to get started!</p>
                                                </div>
                                            </EmptyDataTemplate>
                                        </asp:GridView>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>

                        <!-- Alert Messages -->
                        <asp:UpdatePanel ID="upMessages" runat="server">
                            <ContentTemplate>
                                <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show mt-3">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <asp:Label ID="lblSuccess" runat="server"></asp:Label>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </asp:Panel>
                                
                                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show mt-3">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <asp:Label ID="lblError" runat="server"></asp:Label>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .bg-gradient-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .card {
            border-radius: 10px;
        }
        
        pre {
            font-size: 0.85em;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .table th {
            border-top: none;
            font-weight: 600;
            background-color: #f8f9fa;
        }
        
        .btn {
            border-radius: 6px;
        }
        
        .form-control, .form-select {
            border-radius: 6px;
        }
        
        .badge {
            font-size: 0.75em;
        }
    </style>
</asp:Content>
