using System;
using System.Web.UI;
using AGMSolutions.App_Code.Services;

namespace AGMSolutions
{
    public partial class TestEmail : Page
    {
        private EmailService _emailService;

        protected void Page_Load(object sender, EventArgs e)
        {
            _emailService = new EmailService();
        }

        protected void btnTestConfirmation_Click(object sender, EventArgs e)
        {
            try
            {
                string testEmail = txtTestEmail.Text.Trim();
                string testToken = Guid.NewGuid().ToString();
                
                bool result = _emailService.SendConfirmationEmail(testEmail, "Test User", testToken);
                
                if (result)
                {
                    litResult.Text = "<div class='alert alert-success'>✅ Confirmation email sent successfully!</div>";
                }
                else
                {
                    litResult.Text = "<div class='alert alert-danger'>❌ Failed to send confirmation email.</div>";
                }
            }
            catch (Exception ex)
            {
                litResult.Text = $"<div class='alert alert-danger'>❌ Error: {ex.Message}</div>";
            }
        }

        protected void btnTestPasswordReset_Click(object sender, EventArgs e)
        {
            try
            {
                string testEmail = txtTestEmail.Text.Trim();
                string testToken = Guid.NewGuid().ToString();
                
                bool result = _emailService.SendPasswordResetEmail(testEmail, "Test User", testToken);
                
                if (result)
                {
                    litResult.Text = "<div class='alert alert-success'>✅ Password reset email sent successfully!</div>";
                }
                else
                {
                    litResult.Text = "<div class='alert alert-danger'>❌ Failed to send password reset email.</div>";
                }
            }
            catch (Exception ex)
            {
                litResult.Text = $"<div class='alert alert-danger'>❌ Error: {ex.Message}</div>";
            }
        }
    }
}
