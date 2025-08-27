<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestEmail.aspx.cs" Inherits="AGMSolutions.Common.TestEmail" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Email Configuration Test - AGM Solutions</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
        .config-box { background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>📧 AGM Solutions - SMTP Email Test</h1>
        
        <div class="config-box">
            <h3>🔧 Current SMTP Configuration</h3>
            <div class="info">
                <strong>Email:</strong> gokulupadhayaya19@gmail.com<br>
                <strong>SMTP Host:</strong> smtp.gmail.com<br>
                <strong>Port:</strong> 587<br>
                <strong>SSL:</strong> Enabled<br>
                <strong>App Password:</strong> hjin zurz oxcs vimj<br>
                <strong>Updated:</strong> August 2, 2025
            </div>
        </div>

        <asp:Panel ID="TestResultsPanel" runat="server">
            <!-- Test results will be displayed here -->
        </asp:Panel>
        
        <asp:Button ID="btnTestEmail" runat="server" Text="🧪 Run Email Test" 
                    OnClick="btnTestEmail_Click" CssClass="button" />
                    
        <hr style="margin: 20px 0;" />
        <div class="info">
            <p><strong>Note:</strong> This test page verifies that your SMTP configuration is working correctly.</p>
            <p>If emails are being sent successfully, all registration confirmations and password resets will work.</p>
        </div>
        
        <p><a href="../Default.aspx">← Back to Homepage</a></p>
    </form>
</body>
</html>
