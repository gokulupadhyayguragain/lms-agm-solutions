// Admins/AddEditCourse.aspx.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Admins
{
    public partial class AddEditCourse : System.Web.UI.Page
    {
        private CourseManager _courseManager;
        private UserManager _userManager; // Needed for authorization and lecturer list

        protected void Page_Load(object sender, EventArgs e)
        {
            _courseManager = new CourseManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Admin authorization check
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Admin")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                BindLecturersDropdown();

                if (Request.QueryString["CourseID"] != null)
                {
                    // Edit mode
                    int courseId = Convert.ToInt32(Request.QueryString["CourseID"]);
                    hdnCourseID.Value = courseId.ToString();
                    litPageTitle.Text = "Edit Course Details";
                    LoadCourseData(courseId);
                }
                else
                {
                    // Add mode
                    litPageTitle.Text = "Add New Course";
                    // Default values for new course
                    chkIsActive.Checked = true;
                }
            }
        }

        private void BindLecturersDropdown()
        {
            ddlLecturer.Items.Clear();
            ddlLecturer.Items.Add(new ListItem("-- Select Lecturer (Optional) --", ""));

            // Get all users who are Lecturers
            List<User> lecturers = _courseManager.GetAllLecturers(); // This calls UserManager.GetUsersByType("Lecturer")

            foreach (User lecturer in lecturers)
            {
                ddlLecturer.Items.Add(new ListItem($"{lecturer.FirstName} {lecturer.LastName} ({lecturer.Email})", lecturer.UserID.ToString()));
            }
        }

        private void LoadCourseData(int courseId)
        {
            Course course = _courseManager.GetCourseById(courseId);
            if (course != null)
            {
                txtCourseName.Text = course.CourseName;
                txtCourseCode.Text = course.CourseCode;
                //txtDescription.Text = course.Description;
                chkIsActive.Checked = course.IsActive;

                if (course.LecturerID.HasValue && ddlLecturer.Items.FindByValue(course.LecturerID.Value.ToString()) != null)
                {
                    ddlLecturer.SelectedValue = course.LecturerID.Value.ToString();
                }
                else
                {
                    ddlLecturer.SelectedValue = ""; // No lecturer selected or lecturer not found
                }
            }
            else
            {
                ShowAlert("Course not found.", "danger");
                // Redirect back to courses list
                Response.Redirect("Courses.aspx");
            }
        }

        protected void cvCourseCodeUnique_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string courseCode = args.Value;
            int currentCourseId = Convert.ToInt32(hdnCourseID.Value); // 0 for add mode

            List<Course> allCourses = _courseManager.GetAllCourses();
            bool isCodeTaken = allCourses.Any(c => c.CourseCode.Equals(courseCode, StringComparison.OrdinalIgnoreCase) && c.CourseID != currentCourseId);

            args.IsValid = !isCodeTaken;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Course course = new Course
                {
                    CourseName = txtCourseName.Text.Trim(),
                    CourseCode = txtCourseCode.Text.Trim(),
                    //Description = txtDescription.Text.Trim(),
                    IsActive = chkIsActive.Checked
                };

                // Handle nullable LecturerID
                if (!string.IsNullOrEmpty(ddlLecturer.SelectedValue))
                {
                    course.LecturerID = Convert.ToInt32(ddlLecturer.SelectedValue);
                }
                else
                {
                    course.LecturerID = null;
                }

                bool success = false;
                try
                {
                    if (hdnCourseID.Value == "0") // Add mode
                    {
                        success = _courseManager.AddCourse(course);
                        if (success)
                        {
                            ShowAlert("Course added successfully!", "success");
                            // Optionally, clear fields or redirect
                            ClearFormFields();
                            BindLecturersDropdown(); // Rebind to update lecturer list if needed (though not typically affected by course add)
                        }
                    }
                    else // Edit mode
                    {
                        course.CourseID = Convert.ToInt32(hdnCourseID.Value);
                        success = _courseManager.UpdateCourse(course);
                        if (success)
                        {
                            ShowAlert("Course updated successfully!", "success");
                            // Re-load data to ensure UI reflects any trimming/updates
                            LoadCourseData(course.CourseID);
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Catch custom exceptions thrown from DAL/BLL, e.g., unique constraint violation
                    ShowAlert($"An error occurred: {ex.Message}", "danger");
                    System.Diagnostics.Debug.WriteLine($"Error saving course: {ex.Message}");
                    return; // Stop further processing if an error occurred
                }

                if (!success)
                {
                    ShowAlert("Failed to save course. Please try again.", "danger");
                }
            }
            else
            {
                ShowAlert("Please correct the validation errors.", "danger");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx"); // Go back to the course listing
        }

        private void ClearFormFields()
        {
            txtCourseName.Text = "";
            txtCourseCode.Text = "";
            //txtDescription.Text = "";
            ddlLecturer.SelectedValue = ""; // Select the "optional" item
            chkIsActive.Checked = true;
            hdnCourseID.Value = "0"; // Reset to add mode
            litPageTitle.Text = "Add New Course";
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


