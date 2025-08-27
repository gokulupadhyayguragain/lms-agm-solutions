<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestPassword.aspx.cs" Inherits="AGMSolutions.Common.TestPassword" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Password Hash Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-result { margin: 10px 0; padding: 10px; border: 1px solid #ccc; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Password Hashing Test</h1>
        
        <div>
            <label>Password to test:</label>
            <asp:TextBox ID="txtPassword" runat="server" Text="Admin123!" />
            <asp:Button ID="btnTest" runat="server" Text="Test Hash" OnClick="btnTest_Click" />
        </div>
        
        <div>
            <asp:Literal ID="litResults" runat="server" />
        </div>
    </form>
</body>
</html>
