<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestLogin.aspx.cs" Inherits="TestLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Login System</title>
    <style>
        .test-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        .test-result {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            font-weight: bold;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="test-container">
            <h2>🔐 Login System Test</h2>
            <asp:Button ID="btnTestDemo" runat="server" Text="Test Demo Account Login" OnClick="btnTestDemo_Click" CssClass="btn btn-primary" />
            <br /><br />
            <asp:Literal ID="litResults" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
