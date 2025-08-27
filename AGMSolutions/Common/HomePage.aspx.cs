using System;
using System.Web.UI;

namespace AGMSolutions.Common
{
    public partial class HomePage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No specific logic needed on page load for now
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Login.aspx"); // Will be created in Phase 4
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Common/Signup.aspx"); // Will be created in Phase 3
        }
    }
}

