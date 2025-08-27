<%@ Page Title="Email System Test" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="EmailTest.aspx.cs" Inherits="AGMSolutions.Common.EmailTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .test-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
        }
        .test-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .status-success { color: #28a745; font-weight: bold; }
        .status-error { color: #dc3545; font-weight: bold; }
        .test-button {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            margin: 5px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="test-container">
        <div class="test-card">
            <h2><i class="fas fa-envelope-open"></i> Email System Test</h2>
            <p>Use this page to test the email confirmation system.</p>
            
            <div class="alert alert-info">
                <strong>Note:</strong> This is a development testing page. Remove before production.
            </div>

            <asp:Literal ID="litTestResults" runat="server"></asp:Literal>

            <h4>Test Registration Email</h4>
            <div class="form-group">
                <label>Test Email Address:</label>
                <asp:TextBox ID="txtTestEmail" runat="server" CssClass="form-control" placeholder="Enter email to test"></asp:TextBox>
            </div>
            <asp:Button ID="btnTestRegistration" runat="server" Text="Test Registration Email" CssClass="test-button" OnClick="btnTestRegistration_Click" />
            
            <h4>Test Email Confirmation</h4>
            <div class="form-group">
                <label>Confirmation Token:</label>
                <asp:TextBox ID="txtTestToken" runat="server" CssClass="form-control" placeholder="Enter token to test"></asp:TextBox>
            </div>
            <asp:Button ID="btnTestConfirmation" runat="server" Text="Test Token Confirmation" CssClass="test-button" OnClick="btnTestConfirmation_Click" />

            <h4>Test Resend Email</h4>
            <div class="form-group">
                <label>Existing Email:</label>
                <asp:TextBox ID="txtResendEmail" runat="server" CssClass="form-control" placeholder="Enter registered email"></asp:TextBox>
            </div>
            <asp:Button ID="btnTestResend" runat="server" Text="Test Resend Email" CssClass="test-button" OnClick="btnTestResend_Click" />
        </div>
    </div>
</asp:Content>
