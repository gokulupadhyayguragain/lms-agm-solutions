// Lecturers/ManageCourse.aspx.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Lecturers
{
    public partial class ManageCourse : System.Web.UI.Page
    {
        private CourseManager _courseManager;
        private UserManager _userManager; // Needed for authorization and lecturer list

        protected void Page_Load(object sender, EventArgs e)
        {


        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx"); // Go back to the course listing
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