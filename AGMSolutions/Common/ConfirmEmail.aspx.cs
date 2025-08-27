using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;

namespace AGMSolutions.Common
{
    public partial class ConfirmEmail : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string token = Request.QueryString["token"];
                if (!string.IsNullOrEmpty(token))
                {
                    UserManager userManager = new UserManager();
                    bool success = userManager.ConfirmUserEmail(token);

                    if (success)
                    {
                        ShowStatus("Your email has been successfully confirmed! You can now log in to your account.", "success");
                        // Add login link
                        litStatus.Text += "<div class='mt-3'><a href='Login.aspx' class='btn btn-primary'>Go to Login</a></div>";
                    }
                    else
                    {
                        ShowStatus("Email confirmation failed. The link may be invalid or expired.", "danger");
                        // Add resend option
                        litStatus.Text += "<div class='mt-3'><a href='ResendConfirmation.aspx' class='btn btn-warning'>Resend Confirmation Email</a></div>";
                    }
                }
                else
                {
                    ShowStatus("Invalid confirmation link. No token provided.", "danger");
                    // Add resend option
                    litStatus.Text += "<div class='mt-3'><a href='ResendConfirmation.aspx' class='btn btn-warning'>Get New Confirmation Email</a></div>";
                }
            }
        }

        private void ShowStatus(string message, string type)
        {
            string iconClass = "";
            string alertClass = "";
            
            switch (type)
            {
                case "success":
                    iconClass = "fas fa-check-circle success-icon";
                    alertClass = "confirmation-success";
                    break;
                case "danger":
                case "error":
                    iconClass = "fas fa-times-circle danger-icon";
                    alertClass = "confirmation-error";
                    break;
                case "warning":
                    iconClass = "fas fa-exclamation-triangle warning-icon";
                    alertClass = "alert-warning";
                    break;
                default:
                    iconClass = "fas fa-envelope success-icon";
                    alertClass = "alert-info";
                    break;
            }
            
            // Update the icon
            iconElement.Attributes["class"] = $"confirmation-icon {iconClass}";
            
            // Create visible status message with high z-index and proper styling
            litConfirmationStatus.Text = $@"
                <div class='confirmation-message {alertClass}' style='
                    position: relative !important; 
                    z-index: 10000 !important; 
                    display: block !important; 
                    visibility: visible !important; 
                    opacity: 1 !important;
                    margin: 20px 0 !important;
                    padding: 20px !important;
                    border-radius: 8px !important;
                    font-weight: 600 !important;
                    font-size: 16px !important;
                    text-align: center !important;
                    box-shadow: 0 4px 8px rgba(0,0,0,0.2) !important;
                '>
                    <i class='{iconClass}' style='font-size: 24px; margin-right: 10px;'></i>
                    {message}
                </div>";
        }
    }
}


