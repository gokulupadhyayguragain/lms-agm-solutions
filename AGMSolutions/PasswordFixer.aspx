<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PasswordFixer.aspx.cs" Inherits="PasswordFixer" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Password Hash Fixer</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .result { margin: 10px 0; padding: 15px; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .info { background: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb; }
        .code { background: #f8f9fa; border: 1px solid #e9ecef; padding: 10px; font-family: monospace; }
        .btn { padding: 10px 20px; margin: 5px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 Password Hash Fixer - Complete Solution</h1>
        
        <div class="result info">
            <strong>🎯 Purpose:</strong> Fix all password hash mismatches and message visibility issues
        </div>
        
        <form id="form1" runat="server">
            
            <h3>Step 1: Generate Correct Hashes</h3>
            <asp:Button ID="btnGenerateHashes" runat="server" Text="Generate Demo Account Hashes" 
                       OnClick="btnGenerateHashes_Click" CssClass="btn btn-primary" />
            
            <h3>Step 2: Update Database</h3>
            <asp:Button ID="btnUpdateDatabase" runat="server" Text="Update Demo Accounts in Database" 
                       OnClick="btnUpdateDatabase_Click" CssClass="btn btn-success" />
            
            <h3>Step 3: Test Login</h3>
            <asp:Button ID="btnTestLogin" runat="server" Text="Test Demo Account Login" 
                       OnClick="btnTestLogin_Click" CssClass="btn btn-primary" />
            
            <h3>Step 4: Fix Message Visibility</h3>
            <asp:Button ID="btnFixMessages" runat="server" Text="Fix CSS Message Visibility" 
                       OnClick="btnFixMessages_Click" CssClass="btn btn-success" />
            
            <div id="results" runat="server"></div>
            
            <!-- Test Messages -->
            <h3>Message Visibility Test</h3>
            <div class="alert alert-success" style="z-index: 10000 !important; position: relative !important; display: block !important;">
                ✅ <strong>Success Test:</strong> This message should be visible in GREEN
            </div>
            
            <div class="alert alert-danger" style="z-index: 10000 !important; position: relative !important; display: block !important;">
                ❌ <strong>Error Test:</strong> This message should be visible in RED
            </div>
            
        </form>
    </div>
</body>
</html>
