// Admins/EditUser.aspx.cs
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System.Collections.Generic;
using System.Web.Security;

namespace AGMSolutions.Admins
{
    public partial class EditUser : System.Web.UI.Page
    {
        private UserManager _userManager;
        private RoleManager _roleManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _roleManager = new RoleManager();

            if (!IsPostBack)
            {
                // Basic authorization check: Only Admins should access this page
                if (!User.Identity.IsAuthenticated || string.IsNullOrEmpty(User.Identity.Name))
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                string currentUserRoleName = _userManager.GetRoleNameById(currentUser.UserTypeID);

                if (currentUser == null || currentUserRoleName != "Admin")
                {
                    FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                BindCountriesDropdown();
                BindUserTypesDropdown();

                // --- CHANGE HERE: Expect Email in QueryString ---
                if (Request.QueryString["Email"] != null)
                {
                    string userEmail = Request.QueryString["Email"].ToString();
                    LoadUserData(userEmail);
                    // Store email in hidden field for postback
                    hdnUserEmail.Value = userEmail;
                }
                else
                {
                    ShowAlert("No user email provided. Please select a user to edit.", "danger");
                    Response.Redirect("EditUser.aspx"); // Redirect to a user listing page
                }
            }
        }

        // --- CHANGE HERE: Method now accepts email (string) ---
        private void LoadUserData(string userEmail)
        {
            User user = _userManager.GetUserByEmail(userEmail); // Use GetUserByEmail
            if (user != null)
            {
                lblUserIDValue.Text = user.UserID.ToString(); // Still display UserID if needed, but not used for lookup
                txtFirstName.Text = user.FirstName;
                txtMiddleName.Text = user.MiddleName;
                txtLastName.Text = user.LastName;
                txtEmail.Text = user.Email; // This should be read-only if email is the lookup key
                txtPhoneNo.Text = user.PhoneNo;

                if (ddlCountry.Items.FindByValue(user.Country) != null)
                {
                    ddlCountry.SelectedValue = user.Country;
                }
                else
                {
                    ddlCountry.SelectedValue = "";
                }

                if (ddlUserType.Items.FindByValue(user.UserTypeID.ToString()) != null)
                {
                    ddlUserType.SelectedValue = user.UserTypeID.ToString();
                }
                else
                {
                    ddlUserType.SelectedValue = "";
                }

                chkIsEmailConfirmed.Checked = user.IsEmailConfirmed;
            }
            else
            {
                ShowAlert("User not found.", "danger");
                Response.Redirect("EditUser.aspx");
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
        }

        private void BindUserTypesDropdown()
        {
            List<Role> roles = _roleManager.GetAllRoles();
            ddlUserType.DataSource = roles;
            ddlUserType.DataTextField = "RoleName";
            ddlUserType.DataValueField = "RoleID";
            ddlUserType.DataBind();
            ddlUserType.Items.Insert(0, new ListItem("-- Select User Type --", ""));
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // --- CHANGE HERE: Get email from hidden field ---
                string userEmail = hdnUserEmail.Value;
                User userToUpdate = _userManager.GetUserByEmail(userEmail); // Fetch existing user to update by email

                if (userToUpdate != null)
                {
                    // Update userToUpdate object with values from form fields
                    userToUpdate.FirstName = txtFirstName.Text.Trim();
                    userToUpdate.MiddleName = txtMiddleName.Text.Trim();
                    userToUpdate.LastName = txtLastName.Text.Trim();
                    userToUpdate.PhoneNo = txtPhoneNo.Text.Trim();
                    userToUpdate.Country = ddlCountry.SelectedValue;
                    userToUpdate.UserTypeID = Convert.ToInt32(ddlUserType.SelectedValue);
                    userToUpdate.IsEmailConfirmed = chkIsEmailConfirmed.Checked;

                    try
                    {
                        // Use UpdateUserByAdmin - this method internally uses UserID
                        // The UserID is present in 'userToUpdate' object, fetched by email.
                        bool success = _userManager.UpdateUserByAdmin(userToUpdate);
                        if (success)
                        {
                            ShowAlert("User updated successfully!", "success");
                            // Re-load data to ensure UI reflects any trimming/updates
                            LoadUserData(userEmail); // Load by email again
                        }
                        else
                        {
                            ShowAlert("Failed to update user. Please try again.", "danger");
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowAlert($"An error occurred: {ex.Message}", "danger");
                    }
                }
                else
                {
                    ShowAlert("User not found for update.", "danger");
                }
            }
            else
            {
                ShowAlert("Please correct the validation errors.", "danger");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditUser.aspx");
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

