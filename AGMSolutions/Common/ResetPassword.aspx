<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="AGMSolutions.Common.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="reset-password-container">
            <h2>Reset Your Password</h2>
            <p>Enter your new password below. Make sure it meets the security requirements.</p>

            <asp:Literal ID="litAlert" runat="server"></asp:Literal>

            <div class="form-group mb-3">
                <label for="<%= txtNewPassword.ClientID %>">New Password:</label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" ControlToValidate="txtNewPassword"
                    ErrorMessage="New password is required." ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revNewPassword" runat="server" ControlToValidate="txtNewPassword"
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+}{&quot;:;'?/&gt;.&lt;,])(?!.*\s).{8,}$"
                    ErrorMessage="Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character." ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group mb-3">
                <label for="<%= txtConfirmPassword.ClientID %>">Confirm New Password:</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Confirmation password is required." ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPasswords" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                    ErrorMessage="Passwords do not match." ForeColor="Red" Display="Dynamic"></asp:CompareValidator>
            </div>

            <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" CssClass="btn btn-primary btn-block" OnClick="btnResetPassword_Click" />

            <div class="text-center mt-3">
                <a href="Login.aspx">Back to Login</a>
            </div>
        </div>
    </div>
</asp:Content>


