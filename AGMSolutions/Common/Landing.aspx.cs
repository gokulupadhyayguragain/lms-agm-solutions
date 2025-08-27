using System;
using System.Web.UI;

namespace AGMSolutions.Common
{
    public partial class Landing : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No specific logic needed on page load for now
        }

        protected void btnGetStarted_Click(object sender, EventArgs e)
        {
            // Redirect to Signup page (will be created in Phase 3)
            Response.Redirect("~/Common/Signup.aspx");
        }

        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            // Redirect to HomePage.aspx
            Response.Redirect("~/Common/HomePage.aspx");
        }
    }
}

