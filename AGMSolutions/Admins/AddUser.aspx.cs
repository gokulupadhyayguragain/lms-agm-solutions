// Admins/AddUser.aspx.cs
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.Services; // For PasswordHasher

namespace AGMSolutions.Admins
{
    public partial class AddUser : System.Web.UI.Page
    {
        private UserManager _userManager;
        private RoleManager _roleManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _roleManager = new RoleManager();

            if (!IsPostBack)
            {
                // Admin authorization check (similar to EditUser.aspx.cs)
                // Assuming Site.Master already handles general authentication for Admins folder via Web.config
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Admin")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx"); // Or an unauthorized page
                    return;
                }

                BindCountriesDropdown();
                BindUserTypesDropdown();

                // Set default for Email Confirmed for admin added users
                chkIsEmailConfirmed.Checked = true;
            }
        }

        private void BindCountriesDropdown()
        {
            ddlCountry.Items.Clear();
            ddlCountry.Items.Add(new ListItem("-- Select Country --", ""));
            ddlCountry.Items.Add(new ListItem("Nepal", "Nepal"));
            ddlCountry.Items.Add(new ListItem("India", "India"));
            ddlCountry.Items.Add(new ListItem("USA", "USA"));
            ddlCountry.Items.Add(new ListItem("UK", "UK"));
            // Add more countries as needed
        }

        private void BindUserTypesDropdown()
        {
            List<Role> roles = _roleManager.GetAllRoles();
            ddlUserType.DataSource = roles;
            ddlUserType.DataTextField = "RoleName";
            ddlUserType.DataValueField = "RoleID";
            ddlUserType.DataBind();
            ddlUserType.Items.Insert(0, new ListItem("-- Select User Type --", "")); // Add default option
        }

        protected void cvEmailUnique_ServerValidate(object source, ServerValidateEventArgs args)
        {
            // Check if email already exists
            if (_userManager.GetUserByEmail(args.Value) != null)
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text;

                // Hash password and generate salt
                // Corrected lines:
                string salt = PasswordService.GenerateSalt();
                string passwordHash = PasswordService.HashPassword(password, salt);
                // Create a new User object with the provided details
                User newUser = new User
                {
                    FirstName = txtFirstName.Text.Trim(),
                    MiddleName = txtMiddleName.Text.Trim(),
                    LastName = txtLastName.Text.Trim(),
                    Email = email,
                    PasswordHash = passwordHash,
                    Salt = salt,
                    PhoneNo = txtPhoneNo.Text.Trim(),
                    Country = ddlCountry.SelectedValue,
                    UserTypeID = Convert.ToInt32(ddlUserType.SelectedValue),
                    ProfilePictureURL = null, // Default to null or a placeholder URL
                    Gender = null,          // These can be set later by the user in their profile
                    DateOfBirth = null,
                    IsEmailConfirmed = chkIsEmailConfirmed.Checked, // Set based on admin's choice
                    RegistrationDate = DateTime.Now,
                    LastLoginDate = null,
                    ThemeColor = null // Default theme, can be updated later
                };

                try
                {
                    bool success = _userManager.RegisterUser(
                        newUser.FirstName,
                        newUser.MiddleName,
                        newUser.LastName,
                        newUser.Email,
                        password, // Pass the plain password, not the hash
                        newUser.PhoneNo,
                        newUser.Country,
                        ddlUserType.SelectedItem.Text,
                        newUser.ThemeColor ?? ""
                    ); // Call with individual parameters
                    if (success)
                    {
                        ShowAlert("User added successfully!", "success");
                        // Clear fields or redirect after successful addition
                        ClearFormFields();
                    }
                    else
                    {
                        ShowAlert("Failed to add user. Email might already be registered or an error occurred.", "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert($"An error occurred: {ex.Message}", "danger");
                    // Log the exception for debugging
                    System.Diagnostics.Debug.WriteLine($"Error adding user: {ex.Message}");
                }
            }
            else
            {
                ShowAlert("Please correct the validation errors.", "danger");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx"); // Redirect back to the Admin Dashboard
        }

        private void ClearFormFields()
        {
            txtFirstName.Text = "";
            txtMiddleName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            txtPhoneNo.Text = "";
            ddlCountry.SelectedValue = "";
            ddlUserType.SelectedValue = "";
            chkIsEmailConfirmed.Checked = true; // Reset to default
        }

        private void ShowAlert(string message, string type)
        {
            string script = $@"
                <div class='alert alert-{type} alert-dismissible fade show' role='alert'>
                    {message}
                    <button type='button' class='close' data-dismiss='alert' aria-label='Close'>
                        <span aria-hidden='true'>&times;</span>
                    </button>
                </div>";
            litAlert.Text = script;
        }
    }
}


