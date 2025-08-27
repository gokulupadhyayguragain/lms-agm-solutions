using System;
using System.Web.UI;

namespace AGMSolutions
{
    public partial class HomePage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Public page - no authentication required
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Login.aspx");
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Signup.aspx");
        }

        protected void btnGetStartedHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Signup.aspx");
        }

        protected void btnBackToHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }

        protected void btnJoinNow_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Signup.aspx");
        }
    }
}
