using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Common
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        private UserManager _userManager;
        private string _resetToken;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                _resetToken = Request.QueryString["token"];

                if (string.IsNullOrEmpty(_resetToken))
                {
                    ShowAlert("Invalid or missing password reset token. Please use the link from your email.", "danger");
                    btnResetPassword.Enabled = false; // Disable button if no token
                }
                else
                {
                    // Optionally validate the token's existence/expiry here initially
                    // to provide immediate feedback, or do it on button click.
                    // For simplicity, we'll do the full validation on button click.
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _resetToken = Request.QueryString["token"];

                if (string.IsNullOrEmpty(_resetToken))
                {
                    ShowAlert("Invalid or missing password reset token. Please use the link from your email.", "danger");
                    return;
                }

                string newPassword = txtNewPassword.Text;

                // Validate and reset the password
                bool success = _userManager.ResetPassword(_resetToken, newPassword); // You'll create this method

                if (success)
                {
                    ShowAlert("Your password has been reset successfully! You can now log in with your new password.", "success");
                    // Clear fields
                    txtNewPassword.Text = string.Empty;
                    txtConfirmPassword.Text = string.Empty;
                    btnResetPassword.Enabled = false; // Prevent multiple submissions
                }
                else
                {
                    ShowAlert("Failed to reset password. The link may be invalid or expired. Please request a new one.", "danger");
                }
            }
        }

        private void ShowAlert(string message, string type)
        {
            litAlert.Text = $"<div class='alert alert-{type} alert-dismissible fade show' role='alert'>" +
                            $"{message}" +
                            "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>" +
                            "<span aria-hidden='true'>&times;</span>" +
                            "</button>" +
                            "</div>";
        }
    }
}


