<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="AGMSolutions.Common.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .forgot-password-container {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #ffd89b 0%, #19547b 100%);
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }
        .forgot-password-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="waves" width="50" height="50" patternUnits="userSpaceOnUse"><path d="M 0 25 Q 12.5 10 25 25 T 50 25" stroke="rgba(255,255,255,0.1)" stroke-width="1" fill="none"/></pattern></defs><rect width="100" height="100" fill="url(%23waves)"/></svg>');
        }
        .forgot-password-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 3rem;
            max-width: 450px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 1;
        }
        .forgot-password-icon {
            text-align: center;
            margin-bottom: 2rem;
        }
        .forgot-password-icon i {
            font-size: 3.5rem;
            background: linear-gradient(45deg, #ffd89b, #19547b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: swing 3s ease-in-out infinite;
        }
        @keyframes swing {
            0%, 100% { transform: rotate(-5deg); }
            50% { transform: rotate(5deg); }
        }
        .forgot-password-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #ffd89b, #19547b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .forgot-password-subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 2rem;
            line-height: 1.5;
            font-size: 1.1rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-control-modern {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
            width: 100%;
        }
        .form-control-modern:focus {
            border-color: #ffd89b;
            box-shadow: 0 0 0 0.2rem rgba(255, 216, 155, 0.25);
            outline: none;
        }
        .btn-modern {
            background: linear-gradient(45deg, #ffd89b, #19547b);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: block;
            width: 100%;
            text-align: center;
            transition: all 0.3s ease;
            margin-bottom: 1rem;
        }
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
        }
        .back-link {
            text-align: center;
            margin-top: 1rem;
        }
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
        .validator-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="forgot-password-container">
        <div class="forgot-password-card">
            <div class="forgot-password-icon">
                <i class="fas fa-key"></i>
            </div>
            <h2 class="forgot-password-title">Forgot Password?</h2>
            <p class="forgot-password-subtitle">
                Enter your email address below and we'll send you a link to reset your password.
            </p>
            
            <asp:Literal ID="litAlert" runat="server"></asp:Literal>
            
            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-modern" TextMode="Email" placeholder="Enter your email address"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email address is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    ErrorMessage="Enter a valid email address." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <asp:Button ID="btnSendResetLink" runat="server" Text="Send Reset Link" CssClass="btn-modern" OnClick="btnSendResetLink_Click" />

            <div class="back-link">
                <a href="Login.aspx"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
    </div>
</asp:Content>

