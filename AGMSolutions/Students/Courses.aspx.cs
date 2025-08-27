// Students/Courses.aspx.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL; // <--- ADD THIS LINE
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class Courses : System.Web.UI.Page
    {
        private EnrollmentManager _enrollmentManager;
        private UserManager _userManager; // To get current student's ID

        protected void Page_Load(object sender, EventArgs e)
        {
            _enrollmentManager = new EnrollmentManager();
            _userManager = new UserManager();

            if (!IsPostBack)
            {
                // Student authorization check
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

                BindEnrolledCourses();
                BindAvailableCourses();
            }
        }

        private int GetCurrentStudentID()
        {
            User currentUser = _userManager.GetUserByEmail(User.Identity.Name);
            return currentUser?.UserID ?? 0; // Return 0 or throw error if not found
        }

        private void BindEnrolledCourses()
        {
            int studentId = GetCurrentStudentID();
            if (studentId > 0)
            {
                List<Enrollment> enrolledCourses = _enrollmentManager.GetStudentEnrolledCourses(studentId);
                gvEnrolledCourses.DataSource = enrolledCourses;
                gvEnrolledCourses.DataBind();
            }
        }

        // Students/Courses.aspx.cs

        // ... (rest of the method) ...

        private void BindAvailableCourses()
        {
            int studentId = GetCurrentStudentID();
            if (studentId > 0)
            {
                List<Course> availableCourses = _enrollmentManager.GetAvailableCoursesForEnrollment(studentId);

                // Apply search filter if present
                string searchTerm = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    // CORRECTED LINES FOR CASE-INSENSITIVE SEARCH (lines 73, 74)
                    availableCourses = availableCourses
                        .Where(c => c.CourseName.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0 ||
                                    c.CourseCode.IndexOf(searchTerm, StringComparison.OrdinalIgnoreCase) >= 0)
                        .ToList();
                }

                gvAvailableCourses.DataSource = availableCourses;
                gvAvailableCourses.DataBind();
            }
        }
        // ... (rest of the class) ...

        protected void gvEnrolledCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEnrolledCourses.PageIndex = e.NewPageIndex;
            BindEnrolledCourses();
        }

        protected void gvAvailableCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAvailableCourses.PageIndex = e.NewPageIndex;
            BindAvailableCourses();
        }

        protected void gvEnrolledCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UnenrollCourse")
            {
                int enrollmentId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    bool success = _enrollmentManager.UnenrollStudentFromCourse(enrollmentId);
                    if (success)
                    {
                        ShowAlert("Successfully unenrolled from course.", "success");
                        BindEnrolledCourses();
                        BindAvailableCourses(); // Rebind available courses as one might become available
                    }
                    else
                    {
                        ShowAlert("Failed to unenroll from course.", "danger");
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert($"Error: {ex.Message}", "danger");
                    System.Diagnostics.Debug.WriteLine($"Error unenrolling: {ex.Message}");
                }
            }
        }

        protected void gvAvailableCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EnrollCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                int studentId = GetCurrentStudentID();

                if (studentId > 0)
                {
                    try
                    {
                        bool success = _enrollmentManager.EnrollStudentInCourse(studentId, courseId);
                        if (success)
                        {
                            ShowAlert("Successfully enrolled in course!", "success");
                            BindEnrolledCourses();
                            BindAvailableCourses(); // Rebind as one course is now unavailable
                        }
                        else
                        {
                            ShowAlert("Failed to enroll in course.", "danger");
                        }
                    }
                    catch (Exception ex)
                    {
                        // Catch specific exceptions from BLL (e.g., already enrolled)
                        ShowAlert($"Error: {ex.Message}", "danger");
                        System.Diagnostics.Debug.WriteLine($"Error enrolling: {ex.Message}");
                    }
                }
                else
                {
                    ShowAlert("Could not determine student ID. Please log in again.", "danger");
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindAvailableCourses(); // Rebind only the available courses grid with search filter
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


