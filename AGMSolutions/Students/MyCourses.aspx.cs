using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace AGMSolutions.Students
{
    public partial class MyCourses : System.Web.UI.Page
    {
        private UserManager _userManager;
        private CourseManager _courseManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _courseManager = new CourseManager();

            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Student")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                BindStudentCourses(currentUser.UserID);
            }
        }

        private void BindStudentCourses(int studentId)
        {
            List<Course> enrolledCourses = _courseManager.GetCoursesByStudentId(studentId);
            gvMyCourses.DataSource = enrolledCourses;
            gvMyCourses.DataBind();
        }

        // --- Ensure this method is present ---
        protected string GetLecturerName(int lecturerId)
        {
            User lecturer = _userManager.GetUserById(lecturerId);
            return lecturer != null ? $"{lecturer.FirstName} {lecturer.LastName}" : "Unassigned Lecturer";
        }
        // ------------------------------------

        protected void gvMyCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMyCourses.PageIndex = e.NewPageIndex;
            User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
            if (currentUser != null)
            {
                BindStudentCourses(currentUser.UserID);
            }
        }

        // --- Ensure this method is present ---
        private void ShowAlert(string message, string type)
        {
            string script = $@"
                <div class='alert alert-{type} alert-dismissible fade show' role='alert'>
                    {message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
            litAlert.Text = script;
        }
        // ------------------------------------
    }
}


