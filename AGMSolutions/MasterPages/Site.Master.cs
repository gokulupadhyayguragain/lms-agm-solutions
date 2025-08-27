using System;
using System.Web.Security;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.MasterPages
{
    public partial class Site : System.Web.UI.MasterPage
    {
        private UserManager _userManager;

        protected void Page_Init(object sender, EventArgs e)
        {
            _userManager = new UserManager();

            // Check if user is authenticated
            if (Context.User.Identity.IsAuthenticated)
            {
                LoadUserSpecificContent();
            }
            else
            {
                LoadPublicContent();
            }
        }

        private void LoadUserSpecificContent()
        {
            try
            {
                string userEmail = Context.User.Identity.Name;
                User currentUser = _userManager.GetUserByEmail(userEmail);

                if (currentUser != null)
                {
                    string userRoleName = _userManager.GetRoleNameById(currentUser.UserTypeID);
                    LoadRoleSpecificHeader(userRoleName);
                    ApplyRoleBasedTheme(userRoleName);
                    SetUserDataAttributes(userRoleName, currentUser);
                }
                else
                {
                    // User not found in database, sign out for security
                    FormsAuthentication.SignOut();
                    Response.Redirect("~/Common/Login.aspx");
                }
            }
            catch (Exception ex)
            {
                // Log error and redirect to login
                System.Diagnostics.Debug.WriteLine($"Master Page Error: {ex.Message}");
                FormsAuthentication.SignOut();
                Response.Redirect("~/Common/Login.aspx");
            }
        }

        private void LoadPublicContent()
        {
            // For public pages, apply default theme
            bodyTag.Attributes["class"] = "public-theme";
            bodyTag.Attributes["data-user-role"] = "public";
        }

        private void LoadRoleSpecificHeader(string roleName)
        {
            string headerUserControlPath = GetHeaderControlPath(roleName);

            if (!string.IsNullOrEmpty(headerUserControlPath))
            {
                try
                {
                    // Check if the header control file exists
                    string physicalPath = Server.MapPath(headerUserControlPath);
                    if (System.IO.File.Exists(physicalPath))
                    {
                        // Load the appropriate header user control
                        Control headerControl = LoadControl(headerUserControlPath);
                        dynamicHeaderPlaceholder.Controls.Clear();
                        dynamicHeaderPlaceholder.Controls.Add(headerControl);
                    }
                    else
                    {
                        // Fallback to basic header if specific header not found
                        LoadBasicHeader(roleName);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Header Loading Error: {ex.Message}");
                    LoadBasicHeader(roleName);
                }
            }
        }

        private string GetHeaderControlPath(string roleName)
        {
            switch (roleName?.ToLower())
            {
                case "student":
                    return "~/MasterPages/HeaderStudent.ascx";
                case "lecturer":
                    return "~/MasterPages/HeaderLecturer.ascx";
                case "admin":
                    return "~/MasterPages/HeaderAdmin.ascx";
                default:
                    return string.Empty;
            }
        }

        private void ApplyRoleBasedTheme(string roleName)
        {
            string themeClass = GetThemeClass(roleName);
            string currentClasses = bodyTag.Attributes["class"] ?? "";
            
            // Remove any existing theme classes
            currentClasses = RemoveExistingThemeClasses(currentClasses);
            
            // Add new theme class
            bodyTag.Attributes["class"] = $"{currentClasses} {themeClass}".Trim();
        }

        private string GetThemeClass(string roleName)
        {
            switch (roleName?.ToLower())
            {
                case "student":
                    return "student-theme";
                case "lecturer":
                    return "lecturer-theme";
                case "admin":
                    return "admin-theme";
                default:
                    return "default-theme";
            }
        }

        private string RemoveExistingThemeClasses(string classes)
        {
            return classes
                .Replace("student-theme", "")
                .Replace("lecturer-theme", "")
                .Replace("admin-theme", "")
                .Replace("default-theme", "")
                .Replace("public-theme", "")
                .Replace("  ", " ")
                .Trim();
        }

        private void SetUserDataAttributes(string roleName, User user)
        {
            // Set data attributes for JavaScript and CSS targeting
            bodyTag.Attributes["data-user-role"] = roleName;
            bodyTag.Attributes["data-user-id"] = user.UserID.ToString();
            bodyTag.Attributes["data-theme-color"] = user.ThemeColor ?? GetDefaultThemeColor(roleName);
        }

        private string GetDefaultThemeColor(string roleName)
        {
            switch (roleName?.ToLower())
            {
                case "student":
                    return "skyblue";
                case "lecturer":
                    return "lightgreen";
                case "admin":
                    return "lightyellow";
                default:
                    return "default";
            }
        }

        private void LoadBasicHeader(string roleName)
        {
            // Create a basic header if the specific header control is not found
            var basicHeader = new System.Web.UI.LiteralControl($@"
                <nav class='navbar navbar-expand-lg navbar-dark bg-primary'>
                    <div class='container'>
                        <a class='navbar-brand' href='#'>
                            <i class='fas fa-graduation-cap me-2'></i>
                            AGM Solutions - {roleName}
                        </a>
                        <div class='navbar-nav ms-auto'>
                            <a class='nav-link' href='#' onclick='logout()'>
                                <i class='fas fa-sign-out-alt me-1'></i>
                                Logout
                            </a>
                        </div>
                    </div>
                </nav>
                <script>
                    function logout() {{
                        if (confirm('Are you sure you want to logout?')) {{
                            window.location.href = '/Common/Logout.aspx';
                        }}
                    }}
                </script>
            ");
            
            dynamicHeaderPlaceholder.Controls.Clear();
            dynamicHeaderPlaceholder.Controls.Add(basicHeader);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Additional page load logic if needed
            // Most dynamic loading should happen in Page_Init for Master Pages
        }

        // Helper method to get current user information for child pages
        public User GetCurrentUser()
        {
            if (Context.User.Identity.IsAuthenticated && _userManager != null)
            {
                return _userManager.GetUserByEmail(Context.User.Identity.Name);
            }
            return null;
        }

        // Helper method to get current user role for child pages
        public string GetCurrentUserRole()
        {
            var user = GetCurrentUser();
            if (user != null && _userManager != null)
            {
                return _userManager.GetRoleNameById(user.UserTypeID);
            }
            return "Guest";
        }
    }
}

