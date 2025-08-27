using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Admins
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private UserManager _userManager;
        // private RoleManager _roleManager; // Not strictly needed for Dashboard.aspx.cs, but common to have if you plan to use it later

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
            // _roleManager = new RoleManager(); // Initialize if you need it for future Dashboard features

            if (!IsPostBack)
            {
                // With Web.config authorization in place for the /Admins folder,
                // the explicit checks for IsAuthenticated and RoleName == "Admin"
                // are no longer necessary here. If the code reaches this point,
                // the user is already an authenticated Admin.
                BindUsersGridView();
            }
        }

        private void BindUsersGridView()
        {
            List<User> users = _userManager.GetAllUsers();
            gvUsers.DataSource = users;
            gvUsers.DataBind();
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            BindUsersGridView();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                bool success = _userManager.DeleteUser(userId);
                if (success)
                {
                    // Optional: Show a success message on the dashboard
                    // You'd need a Literal control on Dashboard.aspx for this, e.g.:
                    // <asp:Literal ID="litAlert" runat="server"></asp:Literal>
                    // And then a ShowAlert method:
                    // ShowAlert("User deleted successfully!", "success");

                    BindUsersGridView(); // Rebind the grid to reflect changes
                }
                else
                {
                    // Optional: Show an error message
                    // ShowAlert("Failed to delete user. Please try again.", "danger");
                }
            }
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddUser.aspx");
        }

        protected void btnManageCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("Courses.aspx");
        }

        // Optional: If you want to show alert messages on the Dashboard.aspx page
        // private void ShowAlert(string message, string type)
        // {
        //     // Make sure you have <asp:Literal ID="litAlert" runat="server"></asp:Literal>
        //     // somewhere in your Dashboard.aspx for this to work.
        //     litAlert.Text = $"<div class='alert alert-{type} alert-dismissible fade show' role='alert'>" +
        //                     $"{message}" +
        //                     "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>" +
        //                     "<span aria-hidden='true'>&times;</span>" +
        //                     "</button>" +
        //                     "</div>";
        // }
    }
}



