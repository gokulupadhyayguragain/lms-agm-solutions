<%-- Admins/AddEditCourse.aspx --%>
<%@ Page Title="Add/Edit Course" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="AddEditCourse.aspx.cs" Inherits="AGMSolutions.Admins.AddEditCourse" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2 class="mb-4"><asp:Literal ID="litPageTitle" runat="server"></asp:Literal></h2>
        <hr />

        <asp:Literal ID="litAlert" runat="server"></asp:Literal>
        
        <%-- Hidden field to store CourseID for edit mode --%>
        <asp:HiddenField ID="hdnCourseID" runat="server" Value="0" />

        <div class="card shadow-sm p-4">
            <h5 class="card-title mb-4">Course Information</h5>
            
            <div class="form-group row">
                <label for="txtCourseName" class="col-sm-3 col-form-label">Course Name:</label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" ControlToValidate="txtCourseName" ErrorMessage="Course Name is required." ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="form-group row">
                <label for="txtCourseCode" class="col-sm-3 col-form-label">Course Code:</label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtCourseCode" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCourseCode" runat="server" ControlToValidate="txtCourseCode" ErrorMessage="Course Code is required." ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="cvCourseCodeUnique" runat="server" OnServerValidate="cvCourseCodeUnique_ServerValidate"
                        ErrorMessage="This Course Code already exists." ForeColor="Red" Display="Dynamic"></asp:CustomValidator>
                </div>
            </div>

            <div class="form-group row">
                <label for="txtDescription" class="col-sm-3 col-form-label">Description:</label>
                <div class="col-sm-9">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
                </div>
            </div>

            <div class="form-group row">
                <label for="ddlLecturer" class="col-sm-3 col-form-label">Assigned Lecturer:</label>
                <div class="col-sm-9">
                    <asp:DropDownList ID="ddlLecturer" runat="server" CssClass="form-control"></asp:DropDownList>
                    <small class="form-text text-muted">Leave blank if no lecturer is assigned yet. Only Lecturers can be assigned.</small>
                </div>
            </div>

            <div class="form-group row">
                <label for="chkIsActive" class="col-sm-3 col-form-label">Is Active:</label>
                <div class="col-sm-9">
                    <div class="form-check mt-2">
                        <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12 text-right">
                    <asp:Button ID="btnSave" runat="server" Text="Save Course" CssClass="btn btn-primary mr-2" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>


