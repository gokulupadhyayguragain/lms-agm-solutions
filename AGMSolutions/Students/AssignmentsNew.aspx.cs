using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace AGMSolutions.Students
{
    public partial class AssignmentsNew : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            // TODO: Implement assignment loading logic
            // For now, show no assignments message
            noAssignmentsDiv.Visible = true;
            rptAssignments.Visible = false;
        }

        protected void rptAssignments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // TODO: Handle assignment commands (Submit, Upload)
            string commandName = e.CommandName;
            string assignmentId = e.CommandArgument.ToString();

            switch (commandName)
            {
                case "Submit":
                    // Show upload form for this assignment
                    break;
                case "Upload":
                    // Handle file upload
                    break;
            }
        }
    }
}
