// Lecturers/MyCourses.aspx.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Lecturers
{
    public partial class MyCourses : System.Web.UI.Page
    {
        private CourseManager _courseManager;
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _courseManager = new CourseManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Lecturer authorization check
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Lecturer")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                BindMyCourses(currentUser.UserID);
            }
        }

        private void BindMyCourses(int lecturerId)
        {
            List<Course> myCourses = _courseManager.GetCoursesByLecturerId(lecturerId);
            gvMyCourses.DataSource = myCourses;
            gvMyCourses.DataBind();
        }

        protected void gvMyCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMyCourses.PageIndex = e.NewPageIndex;
            int lecturerId = _userManager.GetUserByEmail(User.Identity.Name)?.UserID ?? 0;
            if (lecturerId > 0)
            {
                BindMyCourses(lecturerId);
            }
            else
            {
                ShowAlert("Lecturer ID not found. Please log in again.", "danger");
            }
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

