using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Common
{
    public partial class ResendConfirmation : Page
    {
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
        }

        protected void btnResend_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
            {
                ShowStatus("Please enter a valid email address.", "danger");
                return;
            }

            string email = txtEmail.Text.Trim();
            User user = _userManager.GetUserByEmail(email);

            if (user == null)
            {
                ShowStatus("No account found with that email address.", "danger");
                return;
            }

            if (user.IsEmailConfirmed)
            {
                ShowStatus("Your email is already confirmed. You can now log in.", "info");
                // Add login link
                litResendStatus.Text += "<div class='mt-3'><a href='Login.aspx' class='btn btn-primary'>Go to Login</a></div>";
                return;
            }

            // Attempt to resend confirmation email
            bool resendSuccess = _userManager.ResendEmailConfirmation(email);

            if (resendSuccess)
            {
                ShowStatus("Confirmation email resent successfully. Please check your inbox and spam folder.", "success");
                txtEmail.Text = string.Empty;
            }
            else
            {
                ShowStatus("Failed to resend confirmation email. Please wait at least 2 minutes between requests, then try again.", "warning");
            }
        }

        private void ShowStatus(string message, string type)
        {
            litResendStatus.Text = $"<div class='alert alert-{type}' role='alert'>{message}</div>";
        }
    }
}

