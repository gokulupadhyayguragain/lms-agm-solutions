using System;
using System.Web.UI;
using System.Web.UI.WebControls; // Required for Literal and Alert
using AGMSolutions.App_Code.BLL; // For UserManager

namespace AGMSolutions.Common
{
    public partial class Signup : Page
    {
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            if (!IsPostBack)
            {
                // Optionally pre-fill country or other fields if needed
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // Validate all controls on the page before proceeding
            Page.Validate();
            if (!Page.IsValid)
            {
                ShowAlert("Please correct the errors on the form.", "danger");
                return;
            }

            string firstName = txtFirstName.Text.Trim();
            string middleName = txtMiddleName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text; // Keep as is for hashing
            string phoneNo = txtPhoneNo.Text.Trim();
            string country = ddlCountry.SelectedValue;

            string userRole = string.Empty;
            string themeColor = string.Empty;

            if (rbStudent.Checked)
            {
                userRole = "Student";
                themeColor = "skyblue";
            }
            else if (rbLecturer.Checked)
            {
                userRole = "Lecturer";
                themeColor = "lightgreen";
            }
            else if (rbAdmin.Checked)
            {
                userRole = "Admin";
                themeColor = "lightyellow";
            }
            else
            {
                // This case should ideally be caught by CustomValidator, but as a fallback
                ShowAlert("Please select a user type.", "danger");
                return;
            }

            // Attempt to register user via BLL
            bool registrationSuccess = _userManager.RegisterUser(
                firstName, middleName, lastName, email, password,
                phoneNo, country, userRole, themeColor);

            // Inside Signup.aspx.cs, within btnRegister_Click method:
            if (registrationSuccess)
            {
                //ShowAlert("Registration successful! Please check your email to confirm your account.", "success");

                // NEW LOGIC: We already trigger SendEmailConfirmationLink inside UserManager.RegisterUser
                // So here, just show a message directing user to email.
                ShowAlert("Registration successful! An email with a confirmation link has been sent to your inbox. Please click the link to activate your account.", "success");
                ClearFormFields();
            }
            else
            {
                ShowAlert("Registration failed. This email may already be registered or an internal error occurred.", "danger");
            }
        }

        private void ShowAlert(string message, string type)
        {
            // Enhanced alert styling with high visibility for signup page
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
                    alertClass = "status-warning";
                    iconClass = "fas fa-exclamation-triangle";
                    break;
                case "info":
                default:
                    alertClass = "status-info";
                    iconClass = "fas fa-info-circle";
                    break;
            }
            
            litAlert.Text = $@"
                <div class='status-message {alertClass} signup-messages' style='
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

        private void ClearFormFields()
        {
            txtFirstName.Text = string.Empty;
            txtMiddleName.Text = string.Empty;
            txtLastName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
            txtPhoneNo.Text = string.Empty;
            ddlCountry.SelectedIndex = 0; // Selects the first item "-- Select Country --"
            rbStudent.Checked = true; // Reset to default
            rbLecturer.Checked = false;
            rbAdmin.Checked = false;
        }
    }
}


