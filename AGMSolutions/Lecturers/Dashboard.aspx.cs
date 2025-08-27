// Lecturers/Dashboard.aspx.cs
using System;
using System.Linq;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using System.Collections.Generic; // Added for List<Course>

namespace AGMSolutions.Lecturers
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private UserManager _userManager;
        private CourseManager _courseManager; // Changed from EnrollmentManager

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            _courseManager = new CourseManager(); // Initialized

            if (!IsPostBack)
            {
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

                // Display lecturer's name on dashboard (assuming you have a lblWelcome or similar)
                // If you have a Label with ID="lblWelcome" on your Dashboard.aspx
                // lblWelcome.Text = $"Welcome, {currentUser.FirstName} {currentUser.LastName}!";

                BindRecentCourses(currentUser.UserID); // Pass current lecturer's ID
            }
        }

        private void BindRecentCourses(int lecturerId) // Changed parameter name
        {
            // Fetch courses assigned to this lecturer
            List<Course> recentCourses = _courseManager.GetCoursesByLecturerId(lecturerId)
                                                      .OrderByDescending(c => c.CreationDate) // Order by course creation date
                                                      .Take(3) // Show top 3 recent courses
                                                      .ToList();
            gvRecentCourses.DataSource = recentCourses;
            gvRecentCourses.DataBind();
        }
    }
}

