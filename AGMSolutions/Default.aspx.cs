using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;

namespace AGMSolutions
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Landing page - no authentication required
            // This is the public entry point to the application
            
            if (!IsPostBack)
            {
                // Check if user is already logged in and redirect accordingly
                if (User.Identity.IsAuthenticated)
                {
                    RedirectAuthenticatedUser();
                }
                
                // Set page meta tags for SEO
                SetPageMetaTags();
                
                // Log page visit for analytics
                LogPageVisit();
            }
        }

        protected void btnGetStarted_Click(object sender, EventArgs e)
        {
            try
            {
                // Check if user is already authenticated
                if (User.Identity.IsAuthenticated)
                {
                    RedirectAuthenticatedUser();
                }
                else
                {
                    // Redirect to signup page when "Get Started" is clicked
                    Response.Redirect("~/Common/Signup.aspx");
                }
            }
            catch (Exception ex)
            {
                // Log error and show user-friendly message
                LogError("btnGetStarted_Click", ex);
                ShowErrorMessage("Unable to proceed. Please try again later.");
            }
        }

        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            try
            {
                // Redirect to about/features page when "Learn More" is clicked
                Response.Redirect("~/Common/About.aspx");
            }
            catch (Exception ex)
            {
                // Log error and show user-friendly message
                LogError("btnLearnMore_Click", ex);
                ShowErrorMessage("Unable to load additional information. Please try again later.");
            }
        }

        protected void btnProjectSummary_Click(object sender, EventArgs e)
        {
            try
            {
                // Redirect to project summary when "Project Summary" is clicked
                Response.Redirect("~/Common/ProjectSummary.aspx");
            }
            catch (Exception ex)
            {
                // Log error and show user-friendly message
                LogError("btnProjectSummary_Click", ex);
                ShowErrorMessage("Unable to load project summary. Please try again later.");
            }
        }

        private void RedirectAuthenticatedUser()
        {
            try
            {
                // Get user role and redirect to appropriate dashboard
                string userRole = GetUserRole();
                
                switch (userRole?.ToLower())
                {
                    case "student":
                        Response.Redirect("~/Students/Dashboard.aspx");
                        break;
                    case "lecturer":
                        Response.Redirect("~/Lecturers/Dashboard.aspx");
                        break;
                    case "admin":
                        Response.Redirect("~/Admins/Dashboard.aspx");
                        break;
                    default:
                        Response.Redirect("~/Dashboard.aspx");
                        break;
                }
            }
            catch (Exception ex)
            {
                LogError("RedirectAuthenticatedUser", ex);
                // If redirect fails, continue to landing page
            }
        }

        private string GetUserRole()
        {
            try
            {
                // Get user role from session or database
                if (Session["UserRole"] != null)
                {
                    return Session["UserRole"].ToString();
                }
                
                // Alternative: Check roles using FormsAuthentication
                if (Roles.IsUserInRole("Admin"))
                    return "Admin";
                else if (Roles.IsUserInRole("Lecturer"))
                    return "Lecturer";
                else if (Roles.IsUserInRole("Student"))
                    return "Student";
                
                return "Student"; // Default role
            }
            catch (Exception ex)
            {
                LogError("GetUserRole", ex);
                return "Student"; // Default fallback
            }
        }

        private void SetPageMetaTags()
        {
            try
            {
                // Set SEO-friendly meta tags
                Page.Title = "AGM Solutions - Advanced Learning Management System";
                
                // Add meta description
                HtmlMeta metaDescription = new HtmlMeta();
                metaDescription.Name = "description";
                metaDescription.Content = "AGM Solutions LMS - Comprehensive learning management system with advanced quiz features, role-based access, real-time communication, and enterprise security.";
                Page.Header.Controls.Add(metaDescription);
                
                // Add meta keywords
                HtmlMeta metaKeywords = new HtmlMeta();
                metaKeywords.Name = "keywords";
                metaKeywords.Content = "LMS, Learning Management System, Online Education, Quiz System, Course Management, Student Portal, E-Learning";
                Page.Header.Controls.Add(metaKeywords);
                
                // Add Open Graph tags for social media
                HtmlMeta ogTitle = new HtmlMeta();
                ogTitle.Attributes["property"] = "og:title";
                ogTitle.Content = "AGM Solutions - Advanced Learning Management System";
                Page.Header.Controls.Add(ogTitle);
                
                HtmlMeta ogDescription = new HtmlMeta();
                ogDescription.Attributes["property"] = "og:description";
                ogDescription.Content = "Empowering education through innovative technology. Experience seamless learning with our comprehensive LMS platform.";
                Page.Header.Controls.Add(ogDescription);
                
                HtmlMeta ogType = new HtmlMeta();
                ogType.Attributes["property"] = "og:type";
                ogType.Content = "website";
                Page.Header.Controls.Add(ogType);
            }
            catch (Exception ex)
            {
                LogError("SetPageMetaTags", ex);
                // Continue execution if meta tag setting fails
            }
        }

        private void LogPageVisit()
        {
            try
            {
                // Log page visit for analytics (implement based on your logging strategy)
                string userIP = Request.UserHostAddress;
                string userAgent = Request.UserAgent;
                string referrer = Request.UrlReferrer?.ToString() ?? "Direct";
                
                // You can implement logging to database or file here
                // For now, we'll just log to application event log
                System.Diagnostics.EventLog.WriteEntry("AGMSolutions", 
                    $"Landing page visit - IP: {userIP}, UserAgent: {userAgent}, Referrer: {referrer}",
                    System.Diagnostics.EventLogEntryType.Information);
            }
            catch (Exception ex)
            {
                // Don't throw exception for logging failures
                LogError("LogPageVisit", ex);
            }
        }

        private void LogError(string method, Exception ex)
        {
            try
            {
                // Log error details
                string errorMessage = $"Error in {method}: {ex.Message}";
                if (ex.InnerException != null)
                {
                    errorMessage += $" Inner Exception: {ex.InnerException.Message}";
                }
                
                // Log to application event log
                System.Diagnostics.EventLog.WriteEntry("AGMSolutions", 
                    errorMessage,
                    System.Diagnostics.EventLogEntryType.Error);
            }
            catch
            {
                // Ignore logging errors to prevent infinite loops
            }
        }

        private void ShowErrorMessage(string message)
        {
            try
            {
                // Show error message to user (you can customize this based on your error handling strategy)
                string script = $"alert('{message.Replace("'", "\\'")}');";
                ClientScript.RegisterStartupScript(this.GetType(), "ErrorMessage", script, true);
            }
            catch
            {
                // Ignore if unable to show error message
            }
        }
    }
}







