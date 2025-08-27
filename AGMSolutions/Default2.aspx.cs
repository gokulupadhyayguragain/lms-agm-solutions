using System;
using System.Web.UI;

namespace AGMSolutions
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Landing page - no authentication required
            // This is the public entry point to the application
        }

        protected void btnGetStarted_Click(object sender, EventArgs e)
        {
            // Redirect to signup page when "Get Started" is clicked
            Response.Redirect("~/Common/Signup.aspx");
        }

        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            // Redirect to home page when "Learn More" is clicked
            Response.Redirect("~/HomePage.aspx");
        }
    }
}
