// Admins/Courses.aspx.cs
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Admins
{
    public partial class Courses : System.Web.UI.Page
    {
        private CourseManager _courseManager;
        private UserManager _userManager; // Needed for authorization

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

                BindCoursesGridView();
            }
        }

        private void BindCoursesGridView()
        {
            List<Course> courses = _courseManager.GetAllCourses();
            gvCourses.DataSource = courses;
            gvCourses.DataBind();
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindCoursesGridView();
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                bool success = _courseManager.DeleteCourse(courseId);
                if (success)
                {
                    ShowAlert("Course deleted successfully!", "success");
                    BindCoursesGridView(); // Rebind the grid to reflect changes
                }
                else
                {
                    ShowAlert("Failed to delete course. It might have associated enrollments or data.", "danger");
                }
            }
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddEditCourse.aspx"); // Redirect to the add/edit form
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


