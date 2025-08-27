using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

public partial class TestLogin : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnTestDemo_Click(object sender, EventArgs e)
    {
        litResults.Text = "";
        var results = new System.Text.StringBuilder();

        try
        {
            var userManager = new UserManager();
            
            // Test demo accounts
            string[] testEmails = { "demo.admin@agm.com", "demo.lecturer@agm.com", "demo.student@agm.com" };
            string testPassword = "demo123";

            results.Append("<h3>🧪 Demo Account Login Tests</h3>");

            foreach (string email in testEmails)
            {
                results.Append($"<h4>Testing: {email}</h4>");
                
                // Get user from database
                User user = userManager.GetUserByEmail(email);
                if (user == null)
                {
                    results.Append($"<div class='test-result error'>❌ User not found: {email}</div>");
                    continue;
                }

                results.Append($"<div class='test-result info'>✅ User found: {user.FirstName} {user.LastName}</div>");
                results.Append($"<div class='test-result info'>📧 Email confirmed: {user.IsEmailConfirmed}</div>");
                results.Append($"<div class='test-result info'>🔑 Has password hash: {!string.IsNullOrEmpty(user.PasswordHash)}</div>");
                results.Append($"<div class='test-result info'>🧂 Has salt: {!string.IsNullOrEmpty(user.Salt)}</div>");

                // Test password verification
                if (!string.IsNullOrEmpty(user.PasswordHash) && !string.IsNullOrEmpty(user.Salt))
                {
                    bool passwordValid = userManager.VerifyPassword(testPassword, user.PasswordHash, user.Salt);
                    if (passwordValid)
                    {
                        results.Append($"<div class='test-result success'>✅ Password verification PASSED for {email}</div>");
                    }
                    else
                    {
                        results.Append($"<div class='test-result error'>❌ Password verification FAILED for {email}</div>");
                        
                        // Try to generate correct hash for debugging
                        string newSalt = userManager.GenerateSalt();
                        string newHash = userManager.HashPassword(testPassword, newSalt);
                        results.Append($"<div class='test-result info'>🔧 New hash with 'demo123': {newHash}</div>");
                        results.Append($"<div class='test-result info'>🔧 New salt: {newSalt}</div>");
                    }
                }
                else
                {
                    results.Append($"<div class='test-result error'>❌ Missing password hash or salt for {email}</div>");
                }

                results.Append("<hr/>");
            }

            // Test token confirmation
            results.Append("<h3>🎫 Token Confirmation Test</h3>");
            string testToken = "test-token-123456789";
            bool confirmResult = userManager.ConfirmUserEmail(testToken);
            results.Append($"<div class='test-result info'>🎫 Token confirmation test (invalid token): {confirmResult}</div>");

        }
        catch (Exception ex)
        {
            results.Append($"<div class='test-result error'>💥 Error: {ex.Message}</div>");
            results.Append($"<div class='test-result error'>📍 Stack trace: {ex.StackTrace}</div>");
        }

        litResults.Text = results.ToString();
    }
}
