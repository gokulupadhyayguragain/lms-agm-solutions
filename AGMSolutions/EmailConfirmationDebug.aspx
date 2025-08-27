<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmailConfirmationDebug.aspx.cs" Inherits="EmailConfirmationDebug" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Email Confirmation Debug Tool</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-section { 
            border: 1px solid #ddd; 
            margin: 20px 0; 
            padding: 15px; 
            border-radius: 5px; 
            background: #f9f9f9;
        }
        .result { margin: 10px 0; padding: 10px; border-radius: 3px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .code { background: #f8f9fa; border: 1px solid #e9ecef; padding: 10px; font-family: monospace; margin: 10px 0; }
        .btn { padding: 8px 16px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-warning { background: #ffc107; color: black; }
    </style>
</head>
<body>
    <div>
        <h1>🔍 Email Confirmation Debug Tool</h1>
        
        <form id="form1" runat="server">
            
            <div class="debug-section">
                <h3>Step 1: Database Analysis</h3>
                <asp:Button ID="btnAnalyzeDB" runat="server" Text="Analyze Email Confirmation Data" 
                           OnClick="btnAnalyzeDB_Click" CssClass="btn btn-primary" />
            </div>
            
            <div class="debug-section">
                <h3>Step 2: Create Test User with Token</h3>
                <asp:Button ID="btnCreateTestUser" runat="server" Text="Create Test User with Token" 
                           OnClick="btnCreateTestUser_Click" CssClass="btn btn-success" />
            </div>
            
            <div class="debug-section">
                <h3>Step 3: Test Token Confirmation</h3>
                <p>Token to test:</p>
                <asp:TextBox ID="txtTestToken" runat="server" placeholder="Enter token or use generated one" Width="300px"></asp:TextBox>
                <asp:Button ID="btnTestConfirmation" runat="server" Text="Test Email Confirmation" 
                           OnClick="btnTestConfirmation_Click" CssClass="btn btn-primary" />
            </div>
            
            <div class="debug-section">
                <h3>Step 4: Test Complete Registration Flow</h3>
                <asp:Button ID="btnTestRegistration" runat="server" Text="Test Full Registration Process" 
                           OnClick="btnTestRegistration_Click" CssClass="btn btn-warning" />
            </div>
            
            <div id="results" runat="server"></div>
            
        </form>
    </div>
</body>
</html>
