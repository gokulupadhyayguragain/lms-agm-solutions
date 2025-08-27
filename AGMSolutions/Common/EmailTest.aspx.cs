using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.Services;

namespace AGMSolutions.Common
{
    public partial class EmailTest : Page
    {
        private UserManager _userManager;
        private EmailService _emailService;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _emailService = new EmailService();
        }

        protected void btnTestRegistration_Click(object sender, EventArgs e)
        {
            string testEmail = txtTestEmail.Text.Trim();
            if (string.IsNullOrEmpty(testEmail))
            {
                ShowResult("Please enter a test email address.", "error");
                return;
            }

            // Test email sending directly
            string testToken = Guid.NewGuid().ToString("N");
            bool emailSent = _emailService.SendConfirmationEmail(testEmail, "Test User", testToken);
            
            if (emailSent)
            {
                ShowResult($"✅ Test email sent successfully to {testEmail}<br/>Token: {testToken}", "success");
            }
            else
            {
                ShowResult("❌ Failed to send test email.", "error");
            }
        }

        protected void btnTestConfirmation_Click(object sender, EventArgs e)
        {
            string testToken = txtTestToken.Text.Trim();
            if (string.IsNullOrEmpty(testToken))
            {
                ShowResult("Please enter a token to test.", "error");
                return;
            }

            bool confirmationResult = _userManager.ConfirmUserEmail(testToken);
            
            if (confirmationResult)
            {
                ShowResult("✅ Token confirmation successful!", "success");
            }
            else
            {
                ShowResult("❌ Token confirmation failed. Token may be invalid or expired.", "error");
            }
        }

        protected void btnTestResend_Click(object sender, EventArgs e)
        {
            string resendEmail = txtResendEmail.Text.Trim();
            if (string.IsNullOrEmpty(resendEmail))
            {
                ShowResult("Please enter an email address.", "error");
                return;
            }

            User user = _userManager.GetUserByEmail(resendEmail);
            if (user == null)
            {
                ShowResult("❌ No user found with that email address.", "error");
                return;
            }

            if (user.IsEmailConfirmed)
            {
                ShowResult("ℹ️ Email is already confirmed.", "info");
                return;
            }

            bool resendResult = _userManager.ResendEmailConfirmation(resendEmail);
            
            if (resendResult)
            {
                ShowResult("✅ Resend email successful!", "success");
            }
            else
            {
                ShowResult("❌ Resend failed. Please wait 2 minutes between requests.", "error");
            }
        }

        private void ShowResult(string message, string type)
        {
            string cssClass = type == "success" ? "status-success" : 
                            type == "error" ? "status-error" : "text-info";
            
            litTestResults.Text += $"<div class='{cssClass} p-2 border-left border-{type} mb-2'>{message}</div>";
        }
    }
}
