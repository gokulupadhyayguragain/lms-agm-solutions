<%@ Page Title="Email Confirmation" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="ConfirmEmail.aspx.cs" Inherits="AGMSolutions.Common.ConfirmEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .confirmation-container {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%, #f093fb 100%);
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }
        .confirmation-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="20" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }
        .confirmation-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 3rem;
            text-align: center;
            max-width: 500px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.2);
            position: relative;
            z-index: 1;
        }
        .confirmation-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        .success-icon { 
            color: #28a745; 
            text-shadow: 0 0 20px rgba(40, 167, 69, 0.3);
        }
        .danger-icon { 
            color: #dc3545; 
            text-shadow: 0 0 20px rgba(220, 53, 69, 0.3);
        }
        .warning-icon { 
            color: #ffc107; 
            text-shadow: 0 0 20px rgba(255, 193, 7, 0.3);
        }
        .confirmation-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #333;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .confirmation-message {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
            color: #555;
        }
        .btn-modern {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            margin: 5px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
            color: white;
            text-decoration: none;
        }
        .btn-warning {
            background: linear-gradient(45deg, #ffc107, #ff8806);
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.4);
        }
        .btn-warning:hover {
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.6);
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="confirmation-container">
        <div class="confirmation-card">
            <div class="confirmation-icon">
                <i class="fas fa-envelope-check success-icon" id="iconElement" runat="server"></i>
            </div>
            <h2 class="confirmation-title">Email Confirmation</h2>
            <div class="confirmation-message">
                <asp:Literal ID="litConfirmationStatus" runat="server"></asp:Literal>
                <asp:Literal ID="litStatus" runat="server"></asp:Literal>
            </div>
            <a href="Login.aspx" class="btn-modern">Continue to Login</a>
        </div>
    </div>
</asp:Content>

