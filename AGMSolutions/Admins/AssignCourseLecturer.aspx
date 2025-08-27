<%-- Admin/AssignCourseLecturer.aspx --%>
<%@ Page Title="Assign Lecturer to Course" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="AssignCourseLecturer.aspx.cs" Inherits="AGMSolutions.Admin.AssignCourseLecturer" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <h2 class="mb-4">Assign Lecturers to Courses</h2>
        <hr />

        <asp:Literal ID="litAlert" runat="server"></asp:Literal>

        <div class="input-group mb-3">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search courses by name or code"></asp:TextBox>
            <div class="input-group-append">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
            </div>
        </div>

        <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered"
            EmptyDataText="No courses found." DataKeyNames="CourseID"
            AllowPaging="True" PageSize="10" OnPageIndexChanging="gvCourses_PageIndexChanging"
            OnRowEditing="gvCourses_RowEditing" OnRowUpdating="gvCourses_RowUpdating"
            OnRowCancelingEdit="gvCourses_RowCancelingEdit">
            <Columns>
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" ReadOnly="True" />
                <asp:BoundField DataField="CourseCode" HeaderText="Code" ReadOnly="True" />
                <asp:TemplateField HeaderText="Current Lecturer">
                    <ItemTemplate>
                        <asp:Label ID="lblCurrentLecturer" runat="server" Text='<%# Eval("LecturerName") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlLecturer" runat="server" AppendDataBoundItems="true" DataValueField="UserID" DataTextField="FullName">
                            <asp:ListItem Text="-- Select Lecturer --" Value="" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" Text="Assign/Edit" CssClass="btn btn-sm btn-info" CommandName="Edit"></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-sm btn-success" CommandName="Update"></asp:LinkButton>&nbsp;
                        <asp:LinkButton ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-sm btn-secondary" CommandName="Cancel"></asp:LinkButton>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <PagerStyle CssClass="pagination-ys" HorizontalAlign="Right" />
        </asp:GridView>
    </div>
</asp:Content>

