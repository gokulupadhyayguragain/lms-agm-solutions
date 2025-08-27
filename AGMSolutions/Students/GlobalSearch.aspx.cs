using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class GlobalSearch : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }
            }
        }

        protected string PerformDatabaseSearch(string query, string type, string subject, string dateRange, string difficulty, string status)
        {
            try
            {
                // In a real implementation, this would perform full-text search across multiple tables
                // For now, we'll return a JSON response simulating the search results
                
                string jsonResults = @"[
                    {
                        'type': 'course',
                        'title': 'Advanced Database Management',
                        'description': 'Learn advanced database concepts and optimization techniques.',
                        'meta': ['Prof. David Wilson', '89 students', '4.6/5']
                    },
                    {
                        'type': 'assignment',
                        'title': 'SQL Query Optimization',
                        'description': 'Optimize complex SQL queries for better performance.',
                        'meta': ['Due: Friday', '4 hours estimated', 'Advanced']
                    }
                ]";

                return jsonResults;
            }
            catch (Exception ex)
            {
                // Log error and return empty results
                System.Diagnostics.Debug.WriteLine($"Search error: {ex.Message}");
                return "[]";
            }
        }
    }
}
