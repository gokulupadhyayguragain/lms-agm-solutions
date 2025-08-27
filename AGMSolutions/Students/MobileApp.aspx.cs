using System;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class MobileApp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                // Set mobile-friendly headers
                Response.Headers.Add("X-UA-Compatible", "IE=edge");
                Response.Headers.Add("viewport", "width=device-width, initial-scale=1.0");
            }
        }
    }
}
