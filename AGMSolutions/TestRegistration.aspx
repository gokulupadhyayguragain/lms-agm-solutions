<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestRegistration.aspx.cs" Inherits="TestRegistration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Test Registration</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Test Registration Flow</h2>
            <asp:Button ID="btnTest" runat="server" Text="Test Registration" OnClick="btnTest_Click" />
            <br /><br />
            <asp:Label ID="lblResult" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>
