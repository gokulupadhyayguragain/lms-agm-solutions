using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System.IO;
using System.Web.Security;
using AGMSolutions.App_Code.Services; // <-- ADD THIS LINE

namespace AGMSolutions.Students
{
    public partial class Profile : System.Web.UI.Page
    {
        private UserManager _userManager;
        private User currentUser; // To hold the currently logged-in user's data

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Get the logged-in user's email
                string userEmail = Context.User.Identity.Name;

                // Retrieve user details
                currentUser = _userManager.GetUserByEmail(userEmail);

                if (currentUser != null)
                {
                    PopulateProfileData(currentUser);
                }
                else
                {
                    // User not found, log out or redirect
                    FormsAuthentication.SignOut();
                    Response.Redirect("~/Common/Login.aspx");
                }
            }
        }

        private void PopulateProfileData(User user)
        {
            txtFirstName.Text = user.FirstName;
            txtMiddleName.Text = user.MiddleName;
            txtLastName.Text = user.LastName;
            txtEmail.Text = user.Email; // Email is read-only
            txtPhoneNo.Text = user.PhoneNo;
            txtCountry.Text = user.Country; // Populate country

            // Populate Gender DropDownList
            if (ddlGender.Items.FindByValue(user.Gender) != null)
            {
                ddlGender.SelectedValue = user.Gender;
            }

            // Populate Date of Birth (assuming it's stored as DateTime in DB)
            if (user.DateOfBirth.HasValue)
            {
                txtDateOfBirth.Text = user.DateOfBirth.Value.ToString("yyyy-MM-dd");
            }

            // Populate Profile Picture
            if (!string.IsNullOrEmpty(user.ProfilePictureURL))
            {
                imgProfilePicture.ImageUrl = user.ProfilePictureURL;
            }
            else
            {
                imgProfilePicture.ImageUrl = "~/Images/default-profile.png"; // Default image
            }
        }

        // In Students/Profile.aspx.cs

        protected void btnUpdateProfile_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string userEmail = Context.User.Identity.Name;
                currentUser = _userManager.GetUserByEmail(userEmail);

                if (currentUser != null)
                {
                    currentUser.FirstName = txtFirstName.Text.Trim();
                    currentUser.MiddleName = txtMiddleName.Text.Trim();
                    currentUser.LastName = txtLastName.Text.Trim();
                    currentUser.PhoneNo = txtPhoneNo.Text.Trim();
                    currentUser.Country = txtCountry.Text.Trim();
                    currentUser.Gender = ddlGender.SelectedValue;

                    DateTime dob;
                    if (DateTime.TryParse(txtDateOfBirth.Text, out dob))
                    {
                        currentUser.DateOfBirth = dob;
                    }
                    else
                    {
                        currentUser.DateOfBirth = null;
                    }

                    try
                    {
                        // CHANGE THIS LINE: Call the specific profile update method
                        bool success = _userManager.UpdateUserProfile(currentUser); // <--- HERE IS THE FIX
                        if (success)
                        {
                            lblProfileMessage.Text = "<span class='text-success'>Profile updated successfully!</span>";
                            PopulateProfileData(currentUser);
                        }
                        else
                        {
                            lblProfileMessage.Text = "<span class='text-danger'>Failed to update profile.</span>";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblProfileMessage.Text = $"<span class='text-danger'>An error occurred: {ex.Message}</span>";
                        // Log the exception: Logger.LogError(ex);
                    }
                }
            }
            else
            {
                lblProfileMessage.Text = "<span class='text-danger'>Please correct the validation errors.</span>";
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Check validators specific to password fields
            {
                string userEmail = Context.User.Identity.Name;
                currentUser = _userManager.GetUserByEmail(userEmail);

                if (currentUser != null)
                {
                    string currentPassword = txtCurrentPassword.Text;
                    string newPassword = txtNewPassword.Text;

                    // Verify current password first
                    if (_userManager.VerifyPassword(currentPassword, currentUser.PasswordHash, currentUser.Salt))
                    {
                        // Update password using the UserManager method
                        bool success = _userManager.UpdateUserPassword(currentUser.UserID, newPassword);
                        if (success)
                        {
                            lblPasswordMessage.Text = "<span class='text-success'>Password changed successfully!</span>";
                            // Clear password fields
                            txtCurrentPassword.Text = string.Empty;
                            txtNewPassword.Text = string.Empty;
                            txtConfirmNewPassword.Text = string.Empty;
                        }
                        else
                        {
                            lblPasswordMessage.Text = "<span class='text-danger'>Failed to change password.</span>";
                        }
                    }
                    else
                    {
                        lblPasswordMessage.Text = "<span class='text-danger'>Incorrect current password.</span>";
                    }
                }
            }
            else
            {
                lblPasswordMessage.Text = "<span class='text-danger'>Please correct password validation errors.</span>";
            }
        }

        protected void btnUploadPicture_Click(object sender, EventArgs e)
        {
            if (fuProfilePicture.HasFile)
            {
                try
                {
                    string userEmail = Context.User.Identity.Name;
                    currentUser = _userManager.GetUserByEmail(userEmail);

                    if (currentUser != null)
                    {
                        // Define the path to save images. Make sure 'Images' folder exists in your project root
                        string uploadPath = Server.MapPath("~/Images/ProfilePictures/");
                        if (!Directory.Exists(uploadPath))
                        {
                            Directory.CreateDirectory(uploadPath);
                        }

                        // Generate a unique filename for the image
                        string fileExtension = Path.GetExtension(fuProfilePicture.FileName).ToLower();
                        if (fileExtension != ".jpg" && fileExtension != ".jpeg" && fileExtension != ".png" && fileExtension != ".gif")
                        {
                            lblPictureMessage.Text = "<span class='text-danger'>Only JPG, JPEG, PNG, GIF images are allowed.</span>";
                            return;
                        }

                        // Use UserID for filename to ensure uniqueness per user and easy lookup
                        string fileName = $"{currentUser.UserID}{fileExtension}";
                        string filePath = Path.Combine(uploadPath, fileName);

                        // Save the file
                        fuProfilePicture.SaveAs(filePath);

                        // Update the user's ProfilePictureURL in the database
                        string relativePath = $"~/Images/ProfilePictures/{fileName}";
                        bool success = _userManager.UpdateUserProfilePicture(currentUser.UserID, relativePath);

                        if (success)
                        {
                            imgProfilePicture.ImageUrl = relativePath; // Update the image on the page
                            lblPictureMessage.Text = "<span class='text-success'>Profile picture uploaded successfully!</span>";
                        }
                        else
                        {
                            lblPictureMessage.Text = "<span class='text-danger'>Failed to update profile picture in database.</span>";
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblPictureMessage.Text = $"<span class='text-danger'>Error uploading picture: {ex.Message}</span>";
                    // Log the exception
                }
            }
            else
            {
                lblPictureMessage.Text = "<span class='text-info'>Please select a file to upload.</span>";
            }
        }
    }
}


