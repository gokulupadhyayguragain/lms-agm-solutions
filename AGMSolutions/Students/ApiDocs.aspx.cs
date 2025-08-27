using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace AGMSolutions.Students
{
    public partial class ApiDocs : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            // Set page title and meta tags for SEO
            Page.Title = "API Documentation - AGM Solutions";
            Page.MetaDescription = "Complete API documentation for AGM Solutions Learning Management System integration";
            
            // Add meta tags for better documentation experience
            HtmlMeta viewport = new HtmlMeta();
            viewport.Name = "viewport";
            viewport.Content = "width=device-width, initial-scale=1.0";
            Page.Header.Controls.Add(viewport);

            HtmlMeta robots = new HtmlMeta();
            robots.Name = "robots";
            robots.Content = "noindex, nofollow"; // API docs should not be indexed
            Page.Header.Controls.Add(robots);

            // Add JSON-LD structured data for API documentation
            string jsonLd = @"
            {
                ""@context"": ""https://schema.org"",
                ""@type"": ""APIReference"",
                ""name"": ""AGM Solutions LMS API"",
                ""description"": ""Complete API reference for integrating with AGM Solutions Learning Management System"",
                ""provider"": {
                    ""@type"": ""Organization"",
                    ""name"": ""AGM Solutions""
                },
                ""documentation"": """ + Request.Url.ToString() + @""",
                ""programmingModel"": ""REST"",
                ""version"": ""1.0""
            }";

            LiteralControl jsonLdScript = new LiteralControl(
                "<script type=\"application/ld+json\">" + jsonLd + "</script>");
            Page.Header.Controls.Add(jsonLdScript);

            // Log API documentation access
            LogApiDocumentationAccess();
        }

        private void LogApiDocumentationAccess()
        {
            try
            {
                // Log the API documentation access for analytics
                string userID = Session["UserID"]?.ToString();
                string userRole = Session["UserRole"]?.ToString();
                string ipAddress = Request.UserHostAddress;
                string userAgent = Request.UserAgent;

                // You can implement logging to database or file here
                System.Diagnostics.Debug.WriteLine($"API Documentation accessed by User: {userID}, Role: {userRole}, IP: {ipAddress}");
            }
            catch (Exception ex)
            {
                // Log error but don't break the page
                System.Diagnostics.Debug.WriteLine($"Error logging API documentation access: {ex.Message}");
            }
        }

        // Method to generate API key (for future implementation)
        protected string GenerateApiKey()
        {
            return Guid.NewGuid().ToString("N").ToUpper();
        }

        // Method to validate API permissions (for future implementation)
        protected bool HasApiAccess(string userRole)
        {
            string[] allowedRoles = { "Admin", "Lecturer", "Student" };
            return allowedRoles.Contains(userRole);
        }
    }
}
