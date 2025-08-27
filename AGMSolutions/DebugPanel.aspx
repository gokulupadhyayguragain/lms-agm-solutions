<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DebugPanel.aspx.cs" Inherits="DebugPanel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Debug Panel - Fix All Issues</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { 
            border: 1px solid #ddd; 
            margin: 20px 0; 
            padding: 15px; 
            border-radius: 5px; 
        }
        .success { color: #28a745; font-weight: bold; }
        .error { color: #dc3545; font-weight: bold; }
        .info { color: #007bff; font-weight: bold; }
        .warning { color: #ffc107; font-weight: bold; }
        .result { 
            margin: 10px 0; 
            padding: 10px; 
            border-radius: 3px; 
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>🔧 Debug Panel - Fix All Issues</h1>
            
            <div class="test-section">
                <h3>1. Test Demo Account Login</h3>
                <asp:Button ID="btnTestLogin" runat="server" Text="Test Demo Login" OnClick="btnTestLogin_Click" />
                <div id="loginResults" runat="server"></div>
            </div>
            
            <div class="test-section">
                <h3>2. Test Email Token Confirmation</h3>
                <asp:TextBox ID="txtToken" runat="server" placeholder="Enter token to test" Width="300px"></asp:TextBox>
                <asp:Button ID="btnTestToken" runat="server" Text="Test Token" OnClick="btnTestToken_Click" />
                <div id="tokenResults" runat="server"></div>
            </div>
            
            <div class="test-section">
                <h3>3. Test Message Visibility</h3>
                <asp:Button ID="btnTestMessages" runat="server" Text="Test Message Styles" OnClick="btnTestMessages_Click" />
                <div id="messageResults" runat="server"></div>
            </div>
            
            <div class="test-section">
                <h3>4. Test Registration Flow</h3>
                <asp:Button ID="btnTestRegistration" runat="server" Text="Test Registration" OnClick="btnTestRegistration_Click" />
                <div id="registrationResults" runat="server"></div>
            </div>
            
            <!-- Test Messages Here -->
            <div class="alert alert-success" style="margin: 20px 0;">
                ✅ <strong>Success Test:</strong> This message should be visible in GREEN
            </div>
            
            <div class="alert alert-danger" style="margin: 20px 0;">
                ❌ <strong>Error Test:</strong> This message should be visible in RED
            </div>
            
            <div class="alert alert-warning" style="margin: 20px 0;">
                ⚠️ <strong>Warning Test:</strong> This message should be visible in YELLOW
            </div>
            
            <div class="alert alert-info" style="margin: 20px 0;">
                ℹ️ <strong>Info Test:</strong> This message should be visible in BLUE
            </div>
            
        </div>
    </form>
</body>
</html>
