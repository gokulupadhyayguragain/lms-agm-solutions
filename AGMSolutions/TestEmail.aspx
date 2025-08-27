<%@ Page Title="Test Email" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="TestEmail.aspx.cs" Inherits="AGMSolutions.TestEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="card">
            <div class="card-header">
                <h3>Email System Test</h3>
            </div>
            <div class="card-body">
                <asp:Literal ID="litResult" runat="server"></asp:Literal>
                
                <div class="form-group mb-3">
                    <label>Test Email Address:</label>
                    <asp:TextBox ID="txtTestEmail" runat="server" CssClass="form-control" Text="gokulupadhayaya19@gmail.com"></asp:TextBox>
                </div>
                
                <div class="form-group mb-3">
                    <asp:Button ID="btnTestConfirmation" runat="server" Text="Test Confirmation Email" CssClass="btn btn-primary me-2" OnClick="btnTestConfirmation_Click" />
                    <asp:Button ID="btnTestPasswordReset" runat="server" Text="Test Password Reset Email" CssClass="btn btn-secondary" OnClick="btnTestPasswordReset_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
