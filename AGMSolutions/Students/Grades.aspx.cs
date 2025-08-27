using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class Grades : Page
    {
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();

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

                LoadGrades(currentUser.UserID);
            }
        }

        private void LoadGrades(int studentId)
        {
            try
            {
                // Create sample data for demonstration
                DataTable gradesTable = new DataTable();
                gradesTable.Columns.Add("CourseCode", typeof(string));
                gradesTable.Columns.Add("CourseName", typeof(string));
                gradesTable.Columns.Add("AssignmentName", typeof(string));
                gradesTable.Columns.Add("Score", typeof(decimal));
                gradesTable.Columns.Add("MaxScore", typeof(decimal));
                gradesTable.Columns.Add("Grade", typeof(string));
                gradesTable.Columns.Add("DateGraded", typeof(DateTime));

                // Add sample grade data
                gradesTable.Rows.Add("CS101", "Computer Science 101", "Programming Assignment 1", 92.5, 100, "A", DateTime.Now.AddDays(-5));
                gradesTable.Rows.Add("MATH101", "Mathematics 101", "Calculus Quiz 1", 87.3, 100, "B+", DateTime.Now.AddDays(-3));
                gradesTable.Rows.Add("WEB101", "Web Development", "HTML/CSS Project", 89.7, 100, "A-", DateTime.Now.AddDays(-1));

                gvCurrentGrades.DataSource = gradesTable;
                gvCurrentGrades.DataBind();
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Error loading grades: " + ex.Message);
            }
        }
    }
}
