<%@ Page Title="Resend Confirmation" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ResendConfirmation.aspx.cs" Inherits="AGMSolutions.Common.ResendConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .resend-container {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }
        .resend-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="rgba(255,255,255,0.2)"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
        }
        .resend-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 3rem;
            max-width: 500px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 1;
        }
        .resend-icon {
            text-align: center;
            margin-bottom: 2rem;
        }
        .resend-icon i {
            font-size: 3.5rem;
            background: linear-gradient(45deg, #ff9a9e, #fecfef);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        .resend-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            background: linear-gradient(45deg, #ff9a9e, #fecfef);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .resend-subtitle {
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
            border-color: #ff9a9e;
            box-shadow: 0 0 0 0.2rem rgba(255, 154, 158, 0.25);
            outline: none;
        }
        .btn-modern {
            background: linear-gradient(45deg, #ff9a9e, #fecfef);
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
    <div class="resend-container">
        <div class="resend-card">
            <div class="resend-icon">
                <i class="fas fa-envelope-open"></i>
            </div>
            <h2 class="resend-title">Resend Confirmation Email</h2>
            <p class="resend-subtitle">
                If you haven't received your confirmation email, enter your registered email address below to resend it.
            </p>
            
            <div class="alert-placeholder" runat="server">
                <asp:Literal ID="litResendStatus" runat="server"></asp:Literal>
            </div>
            
            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-modern" TextMode="Email" placeholder="Enter your registered email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    ErrorMessage="Enter a valid email address." CssClass="validator-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <asp:Button ID="btnResend" runat="server" Text="Resend Confirmation Email" CssClass="btn-modern" OnClick="btnResend_Click" />
            
            <div class="back-link">
                <a href="Login.aspx"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
    </div>
</asp:Content>

