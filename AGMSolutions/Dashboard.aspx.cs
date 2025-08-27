using System;
using System.Web.UI;
using System.Web.Security; // For FormsAuthentication

namespace AGMSolutions
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (User.Identity.IsAuthenticated)
                {
                    // User.Identity.Name will contain the email set by FormsAuthentication.SetAuthCookie
                    lblWelcomeMessage.Text = $"Hello, {User.Identity.Name}!";
                }
                else
                {
                    // Should not happen if Forms Authentication is set up correctly,
                    // but good for robustness. Redirect to login if somehow not authenticated.
                    FormsAuthentication.RedirectToLoginPage();
                }
            }
        }
    }
}

