using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Students
{
    public partial class Chat : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }
                
                LoadCurrentUser();
                LoadStudents();
            }
        }

        private void LoadCurrentUser()
        {
            try
            {
                UserManager userManager = new UserManager();
                User currentUser = userManager.GetUserByEmail(User.Identity.Name);
                
                if (currentUser != null)
                {
                    // Store current user ID for future use
                    // hdnCurrentUserId.Value = currentUser.UserID.ToString();
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Error loading current user: " + ex.Message);
            }
        }

        private void LoadStudents()
        {
            try
            {
                UserManager userManager = new UserManager();
                var students = userManager.GetUsersByType("Student");
                
                // For now, we'll use the static HTML list
                // In a real implementation, you would bind to rptUsers.DataSource = students;
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Error loading students: " + ex.Message);
            }
        }
    }
}
