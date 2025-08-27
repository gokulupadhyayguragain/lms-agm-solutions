using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.Services; // For EmailService
using System.Web; // For HttpUtility.UrlEncode

namespace AGMSolutions.Common
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private UserManager _userManager;
        private EmailService _emailService;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _emailService = new EmailService();
        }

        protected void btnSendResetLink_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = txtEmail.Text.Trim();
                User user = _userManager.GetUserByEmail(email);

                // IMPORTANT SECURITY NOTE: Always return a generic success message
                // regardless of whether the email exists. This prevents user enumeration.
                if (user != null)
                {
                    // Generate a unique token for password reset
                    string resetToken = _userManager.GeneratePasswordResetToken(user.Email);

                    // Use the EmailService method for sending password reset email
                    bool emailSent = _emailService.SendPasswordResetEmail(user.Email, user.FirstName, resetToken);

                    if (emailSent)
                    {
                        ShowAlert("A password reset link has been sent to your email address. Please check your inbox (and spam folder).", "success");
                        // Clear email field after sending
                        txtEmail.Text = string.Empty;
                    }
                    else
                    {
                        // This indicates a problem with the EmailService itself, not that the email wasn't found.
                        ShowAlert("Failed to send the password reset email. Please try again later.", "danger");
                    }
                }
                else
                {
                    // Even if user not found, show generic success to prevent enumeration
                    ShowAlert("If an account with that email exists, a password reset link has been sent to your email address. Please check your inbox (and spam folder).", "success");
                    txtEmail.Text = string.Empty;
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

