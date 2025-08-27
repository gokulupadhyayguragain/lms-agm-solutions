using System;
using System.Web.UI;

namespace AGMSolutions
{
    public partial class ProjectSummary : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Project summary page - publicly accessible
            // Shows comprehensive overview of the completed AGM Solutions LMS
        }

        protected void btnGoToDefault_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }

        protected void btnGoToTest_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Test.aspx");
        }

        protected void btnGoToLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Login.aspx");
        }

        protected void btnGoToSignup_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Signup.aspx");
        }
    }
}
