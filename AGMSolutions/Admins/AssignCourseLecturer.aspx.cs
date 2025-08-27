// Admin/AssignCourseLecturer.aspx.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Admin
{
    public partial class AssignCourseLecturer : System.Web.UI.Page
    {
        private CourseManager _courseManager;
        private UserManager _userManager; // To get list of lecturers

        protected void Page_Load(object sender, EventArgs e)
        {
            _courseManager = new CourseManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Admin authorization check
                if (!User.Identity.IsAuthenticated || !User.IsInRole("Admin")) // Assuming "Admin" is the role name
                {
                    Response.Redirect("~/Common/Login.aspx"); // Redirect to login if not authorized
                    return;
                }
                BindCourses();
            }
        }

        private void BindCourses()
        {
            List<Course> courses = _courseManager.GetAllCourses(); // Gets all courses with lecturer names

            // Apply search filter if present
            string searchTerm = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchTerm))
            {
                courses = courses
                    .Where(c => c.CourseName.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0 ||
                                c.CourseCode.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0)
                    .ToList();
            }

            gvCourses.DataSource = courses;
            gvCourses.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindCourses();
        }

        protected void gvCourses_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCourses.EditIndex = e.NewEditIndex;
            BindCourses(); // Rebind to show the row in edit mode

            // Populate the DropDownList in EditItemTemplate
            DropDownList ddlLecturer = (DropDownList)gvCourses.Rows[e.NewEditIndex].FindControl("ddlLecturer");
            if (ddlLecturer != null)
            {
                List<User> lecturers = _userManager.GetUsersByType("Lecturer"); // Get users with "Lecturer" role
                ddlLecturer.DataSource = lecturers.Select(u => new { UserID = u.UserID, FullName = $"{u.FirstName} {u.LastName}" }).ToList();
                ddlLecturer.DataBind();

                // Select the currently assigned lecturer
                int courseId = Convert.ToInt32(gvCourses.DataKeys[e.NewEditIndex].Value);
                Course currentCourse = _courseManager.GetCourseById(courseId);
                if (currentCourse != null && currentCourse.LecturerID.HasValue)
                {
                    ddlLecturer.SelectedValue = currentCourse.LecturerID.Value.ToString();
                }
            }
        }

        protected void gvCourses_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int courseId = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);
            DropDownList ddlLecturer = (DropDownList)gvCourses.Rows[e.RowIndex].FindControl("ddlLecturer");

            int? selectedLecturerId = null;
            if (!string.IsNullOrEmpty(ddlLecturer.SelectedValue))
            {
                selectedLecturerId = Convert.ToInt32(ddlLecturer.SelectedValue);
            }

            try
            {
                Course courseToUpdate = _courseManager.GetCourseById(courseId);
                if (courseToUpdate != null)
                {
                    courseToUpdate.LecturerID = selectedLecturerId;
                    bool success = _courseManager.UpdateCourse(courseToUpdate);
                    if (success)
                    {
                        ShowAlert("Lecturer assigned successfully!", "success");
                    }
                    else
                    {
                        ShowAlert("Failed to assign lecturer.", "danger");
                    }
                }
                else
                {
                    ShowAlert("Course not found.", "danger");
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"Error assigning lecturer: {ex.Message}", "danger");
                System.Diagnostics.Debug.WriteLine($"Error assigning lecturer: {ex.Message}");
            }

            gvCourses.EditIndex = -1; // Exit edit mode
            BindCourses();
        }

        protected void gvCourses_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCourses.EditIndex = -1; // Exit edit mode
            BindCourses();
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

