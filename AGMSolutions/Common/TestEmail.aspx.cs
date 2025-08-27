using System;
using System.Web.UI;
using AGMSolutions.App_Code.Services;

namespace AGMSolutions.Common
{
    public partial class TestEmail : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Display initial configuration info
                TestResultsPanel.Controls.Add(new LiteralControl(
                    "<div class='info'><p>Click the button below to test your SMTP configuration.</p></div>"));
            }
        }

        protected void btnTestEmail_Click(object sender, EventArgs e)
        {
            TestEmailConfiguration();
        }

        private void TestEmailConfiguration()
        {
            TestResultsPanel.Controls.Clear();
            
            try
            {
                // Create instance of EmailService
                EmailService emailService = new EmailService();
                
                // Test basic email sending
                string testEmail = "gokulupadhayaya19@gmail.com"; // Send test to same email
                string subject = "AGM Solutions - SMTP Test Email";
                string body = @"
                    <h2>✅ SMTP Configuration Test Successful!</h2>
                    <p>This test email confirms that your AGM Solutions LMS email system is working correctly.</p>
                    <p><strong>Configuration Details:</strong></p>
                    <ul>
                        <li>SMTP Host: smtp.gmail.com</li>
                        <li>Port: 587</li>
                        <li>SSL: Enabled</li>
                        <li>App Password: hjin zurz oxcs vimj</li>
                    </ul>
                    <p><em>Test performed on: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + @"</em></p>
                ";
                
                bool success = emailService.SendEmail(testEmail, subject, body);
                
                if (success)
                {
                    TestResultsPanel.Controls.Add(new LiteralControl(
                        "<div class='success'>✅ EMAIL TEST SUCCESSFUL!</div>" +
                        "<p>Test email sent successfully to: " + testEmail + "</p>" +
                        "<p>Check your inbox to confirm email delivery.</p>"));
                }
                else
                {
                    TestResultsPanel.Controls.Add(new LiteralControl(
                        "<div class='error'>❌ EMAIL TEST FAILED!</div>" +
                        "<p>Email could not be sent. Please check your SMTP configuration.</p>"));
                }
                
                // Also test confirmation email template
                TestResultsPanel.Controls.Add(new LiteralControl(
                    "<hr><h3>🧪 Testing Confirmation Email Template</h3>"));
                
                bool confirmationTest = emailService.SendConfirmationEmail(
                    testEmail, 
                    "Test User", 
                    "test-token-123456"
                );
                
                if (confirmationTest)
                {
                    TestResultsPanel.Controls.Add(new LiteralControl(
                        "<div class='success'>✅ CONFIRMATION EMAIL TEST SUCCESSFUL!</div>" +
                        "<p>Confirmation email template working correctly.</p>"));
                }
                else
                {
                    TestResultsPanel.Controls.Add(new LiteralControl(
                        "<div class='error'>❌ CONFIRMATION EMAIL TEST FAILED!</div>"));
                }
                
            }
            catch (Exception ex)
            {
                TestResultsPanel.Controls.Add(new LiteralControl(
                    "<div class='error'>❌ EMAIL CONFIGURATION ERROR!</div>" +
                    "<p><strong>Error Details:</strong> " + ex.Message + "</p>"));
                    
                if (ex.InnerException != null)
                {
                    TestResultsPanel.Controls.Add(new LiteralControl(
                        "<p><strong>Inner Exception:</strong> " + ex.InnerException.Message + "</p>"));
                }
            }
        }
    }
}
