using System;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class Timetable : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Common/Login.aspx");
                    return;
                }
                
                LoadTimetableData();
            }
        }

        private void LoadTimetableData()
        {
            try
            {
                // Load student's enrolled courses and their schedules
                // This would typically come from the database
                // For now, the timetable is populated with static HTML
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine("Error loading timetable: " + ex.Message);
            }
        }
    }
}
