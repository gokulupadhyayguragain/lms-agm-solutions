using System;
using System.Net.Mail;
using System.Net;
using System.Configuration;

namespace AGMSolutions.App_Code.Services
{
    public class EmailService
    {
        private string _senderEmail = "gokulupadhayaya19@gmail.com";
        private string _senderPassword = "hjin zurz oxcs vimj"; // App password for Gmail
        private string _smtpHost = "smtp.gmail.com";
        private int _smtpPort = 587;
        private bool _enableSsl = true;

        public EmailService()
        {
            // Gmail SMTP configuration for AGM Solutions
        }

        public bool SendEmail(string recipientEmail, string subject, string body)
        {
            try
            {
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(_senderEmail, "AGM Solutions LMS");
                    mail.To.Add(recipientEmail);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    using (SmtpClient smtp = new SmtpClient(_smtpHost, _smtpPort))
                    {
                        smtp.Credentials = new NetworkCredential(_senderEmail, _senderPassword);
                        smtp.EnableSsl = _enableSsl;
                        smtp.Send(mail);
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                // Log error (in a real application, use proper logging)
                System.Diagnostics.Debug.WriteLine($"Email sending failed: {ex.Message}");
                return false;
            }
        }

        public bool SendConfirmationEmail(string recipientEmail, string userName, string confirmationToken)
        {
            string subject = "Welcome to AGM Solutions - Confirm Your Email";
            string body = $@"
                <html>
                <head>
                    <style>
                        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }}
                        .content {{ background: #f8f9fa; padding: 30px; }}
                        .button {{ display: inline-block; background: #28a745; color: white; padding: 12px 30px; text-decoration: none; border-radius: 25px; font-weight: bold; }}
                        .footer {{ background: #343a40; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; }}
                    </style>
                </head>
                <body>
                    <div class='container'>
                        <div class='header'>
                            <h1>Welcome to AGM Solutions!</h1>
                            <p>Your Learning Management System</p>
                        </div>
                        <div class='content'>
                            <h2>Hello {userName}!</h2>
                            <p>Thank you for joining AGM Solutions LMS. To complete your registration, please confirm your email address by clicking the button below:</p>
                            <p style='text-align: center; margin: 30px 0;'>
                                <a href='{GetBaseUrl()}/Common/ConfirmEmail.aspx?token={confirmationToken}' class='button'>Confirm Email Address</a>
                            </p>
                            <p>If the button doesn't work, you can copy and paste this link into your browser:</p>
                            <p style='word-break: break-all; background: #e9ecef; padding: 10px; border-radius: 5px;'>
                                {GetBaseUrl()}/Common/ConfirmEmail.aspx?token={confirmationToken}
                            </p>
                            <p><strong>This link will expire in 24 hours.</strong></p>
                        </div>
                        <div class='footer'>
                            <p>&copy; {DateTime.Now.Year} AGM Solutions. All rights reserved.</p>
                            <p>If you didn't create this account, please ignore this email.</p>
                        </div>
                    </div>
                </body>
                </html>";

            return SendEmail(recipientEmail, subject, body);
        }

        public bool SendPasswordResetEmail(string recipientEmail, string userName, string resetToken)
        {
            string subject = "AGM Solutions - Password Reset Request";
            string body = $@"
                <html>
                <head>
                    <style>
                        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }}
                        .content {{ background: #f8f9fa; padding: 30px; }}
                        .button {{ display: inline-block; background: #dc3545; color: white; padding: 12px 30px; text-decoration: none; border-radius: 25px; font-weight: bold; }}
                        .footer {{ background: #343a40; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; }}
                    </style>
                </head>
                <body>
                    <div class='container'>
                        <div class='header'>
                            <h1>Password Reset Request</h1>
                            <p>AGM Solutions LMS</p>
                        </div>
                        <div class='content'>
                            <h2>Hello {userName}!</h2>
                            <p>We received a request to reset your password. If you didn't make this request, please ignore this email.</p>
                            <p>To reset your password, click the button below:</p>
                            <p style='text-align: center; margin: 30px 0;'>
                                <a href='{GetBaseUrl()}/Common/ResetPassword.aspx?token={resetToken}' class='button'>Reset Password</a>
                            </p>
                            <p>If the button doesn't work, you can copy and paste this link into your browser:</p>
                            <p style='word-break: break-all; background: #e9ecef; padding: 10px; border-radius: 5px;'>
                                {GetBaseUrl()}/Common/ResetPassword.aspx?token={resetToken}
                            </p>
                            <p><strong>This link will expire in 1 hour for security reasons.</strong></p>
                        </div>
                        <div class='footer'>
                            <p>&copy; {DateTime.Now.Year} AGM Solutions. All rights reserved.</p>
                            <p>If you didn't request this password reset, please contact support.</p>
                        </div>
                    </div>
                </body>
                </html>";

            return SendEmail(recipientEmail, subject, body);
        }

        private string GetBaseUrl()
        {
            // Updated to use the correct HTTPS port for Visual Studio
            return "https://localhost:44312";
        }
    }
}

