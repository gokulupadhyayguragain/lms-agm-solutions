using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; // Add this for FormsAuthentication
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Common
{
    public partial class Login : Page
    {
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            if (!IsPostBack)
            {
                // Optionally clear any existing session data or redirect if already logged in
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
            {
                ShowAlert("Please enter your email and password.", "danger");
                return;
            }

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            User user = _userManager.GetUserByEmail(email);

            if (user == null)
            {
                ShowAlert("Invalid email or password.", "danger");
                return;
            }

            // Verify password
            if (!_userManager.VerifyPassword(password, user.PasswordHash, user.Salt))
            {
                ShowAlert("Invalid email or password.", "danger");
                return;
            }

            // Check if email is confirmed
            if (!user.IsEmailConfirmed)
            {
                ShowAlert("Your email address has not been confirmed. Please check your inbox for a confirmation link.", "warning");
                // Important: This part is dependent on email confirmation working.
                // If the user can't confirm, they will be stuck here.
                return;
            }

            // --- NEW FORMS AUTHENTICATION LOGIC ---
            // Sign in the user using Forms Authentication
            FormsAuthentication.SetAuthCookie(user.Email, false); // 'false' for non-persistent cookie (session-based)

            // Optionally, update LastLoginDate
            user.LastLoginDate = DateTime.Now;
            _userManager.UpdateUserLastLoginDate(user.UserID); // You'll need to add this method to UserDAL/UserManager

            // Redirect to the return URL if one exists, otherwise to the default URL
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect(returnUrl);
            }
            else
            {
                Response.Redirect(FormsAuthentication.DefaultUrl); // Or specific dashboard based on user role
            }
            // --- END NEW FORMS AUTHENTICATION LOGIC ---
        }

        private void ShowAlert(string message, string type)
        {
            // Enhanced alert styling with high visibility
            string alertClass = "";
            string iconClass = "";
            
            switch (type)
            {
                case "success":
                    alertClass = "status-success";
                    iconClass = "fas fa-check-circle";
                    break;
                case "danger":
                case "error":
                    alertClass = "status-error";
                    iconClass = "fas fa-times-circle";
                    break;
                case "warning":
                    alertClass = "alert-warning";
                    iconClass = "fas fa-exclamation-triangle";
                    break;
                case "info":
                default:
                    alertClass = "alert-info";
                    iconClass = "fas fa-info-circle";
                    break;
            }
            
            litAlert.Text = $@"
                <div class='status-message {alertClass} login-messages' style='
                    position: relative !important; 
                    z-index: 10000 !important; 
                    display: block !important; 
                    visibility: visible !important; 
                    opacity: 1 !important;
                    margin: 15px 0 !important;
                    padding: 15px 20px !important;
                    border-radius: 5px !important;
                    font-weight: 600 !important;
                    font-size: 14px !important;
                    box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23) !important;
                '>
                    <i class='{iconClass}' style='margin-right: 8px;'></i>
                    {message}
                </div>";
        }
    }
}


