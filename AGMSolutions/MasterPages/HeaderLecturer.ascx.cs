using System;
using System.Web.Security;

namespace AGMSolutions.MasterPages
{
    public partial class HeaderLecturer : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Common/Login.aspx");
        }
    }
}
