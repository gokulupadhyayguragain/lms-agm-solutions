// Students/Dashboard.aspx.cs
using System;
using System.Linq;
using System.Web.UI;
using AGMSolutions.App_Code.BLL; // <--- ADD THIS LINE
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private UserManager _userManager;
        private EnrollmentManager _enrollmentManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _enrollmentManager = new EnrollmentManager();

            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }

                string userEmail = User.Identity.Name;
                User currentUser = _userManager.GetUserByEmail(userEmail);

                if (currentUser == null || _userManager.GetRoleNameById(currentUser.UserTypeID) != "Student")
                {
                    System.Web.Security.FormsAuthentication.SignOut();
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                lblWelcome.Text = $"Welcome, {currentUser.FirstName} {currentUser.LastName}!";

                BindRecentCourses(currentUser.UserID);
            }
        }

        private void BindRecentCourses(int studentId)
        {
            var recentCourses = _enrollmentManager.GetEnrollmentsByStudentId(studentId)
                                                  .OrderByDescending(e => e.EnrollmentDate)
                                                  .Take(3)
                                                  .ToList();
            gvRecentCourses.DataSource = recentCourses;
            gvRecentCourses.DataBind();
        }
    }
}


