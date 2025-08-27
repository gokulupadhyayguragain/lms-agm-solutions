using System;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;
using AGMSolutions.App_Code.Services;
using System.Configuration;
using System.Data.SqlClient;

namespace AGMSolutions
{
    public partial class Test : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RunAllTests();
            }
        }

        protected void btnRunTests_Click(object sender, EventArgs e)
        {
            RunAllTests();
        }

        private void RunAllTests()
        {
            bool allTestsPassed = true;

            // Test 1: Database Connection
            bool dbTest = TestDatabaseConnection();
            UpdateTestSection(dbTestSection, lblDbTest, dbTest, "Database connection");
            if (!dbTest) allTestsPassed = false;

            // Test 2: User Authentication
            bool authTest = TestUserAuthentication();
            UpdateTestSection(authTestSection, lblAuthTest, authTest, "User authentication system");
            if (!authTest) allTestsPassed = false;

            // Test 3: Master Pages
            bool masterTest = TestMasterPages();
            UpdateTestSection(masterTestSection, lblMasterTest, masterTest, "Master pages and theming");
            if (!masterTest) allTestsPassed = false;

            // Test 4: Email Service
            bool emailTest = TestEmailService();
            UpdateTestSection(emailTestSection, lblEmailTest, emailTest, "Email service configuration");
            if (!emailTest) allTestsPassed = false;

            // Test 5: Course Management
            bool courseTest = TestCourseManagement();
            UpdateTestSection(courseTestSection, lblCourseTest, courseTest, "Course management system");
            if (!courseTest) allTestsPassed = false;

            // Update overall status
            UpdateOverallStatus(allTestsPassed);
        }

        private bool TestDatabaseConnection()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AGMDBConnection"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Roles", connection);
                    int roleCount = (int)cmd.ExecuteScalar();
                    return roleCount > 0;
                }
            }
            catch (Exception ex)
            {
                lblDbTest.Text += $" ERROR: {ex.Message}";
                return false;
            }
        }

        private bool TestUserAuthentication()
        {
            try
            {
                UserManager userManager = new UserManager();
                // Try to get a user (this tests the DAL/BLL layers)
                var users = userManager.GetAllUsers();
                return users != null;
            }
            catch (Exception ex)
            {
                lblAuthTest.Text += $" ERROR: {ex.Message}";
                return false;
            }
        }

        private bool TestMasterPages()
        {
            try
            {
                // Check if master page files exist
                string masterPagePath = Server.MapPath("~/MasterPages/Site.Master");
                string footerPagePath = Server.MapPath("~/MasterPages/Footer.Master");
                
                bool siteExists = System.IO.File.Exists(masterPagePath);
                bool footerExists = System.IO.File.Exists(footerPagePath);
                
                return siteExists && footerExists;
            }
            catch (Exception ex)
            {
                lblMasterTest.Text += $" ERROR: {ex.Message}";
                return false;
            }
        }

        private bool TestEmailService()
        {
            try
            {
                EmailService emailService = new EmailService();
                // Just test if the service can be instantiated
                return emailService != null;
            }
            catch (Exception ex)
            {
                lblEmailTest.Text += $" ERROR: {ex.Message}";
                return false;
            }
        }

        private bool TestCourseManagement()
        {
            try
            {
                CourseManager courseManager = new CourseManager();
                var courses = courseManager.GetAllCourses();
                return courses != null;
            }
            catch (Exception ex)
            {
                lblCourseTest.Text += $" ERROR: {ex.Message}";
                return false;
            }
        }

        private void UpdateTestSection(System.Web.UI.HtmlControls.HtmlGenericControl section, Label label, bool success, string testName)
        {
            if (success)
            {
                section.Attributes["class"] = "test-section success";
                label.Text = $"✅ {testName} - PASSED";
            }
            else
            {
                section.Attributes["class"] = "test-section error";
                label.Text = $"❌ {testName} - FAILED";
            }
        }

        private void UpdateOverallStatus(bool allPassed)
        {
            if (allPassed)
            {
                overallSection.Attributes["class"] = "test-section success";
                lblOverallStatus.Text = "🎉 ALL TESTS PASSED - System is ready!";
                lblOverallStatus.CssClass = "badge badge-success";
            }
            else
            {
                overallSection.Attributes["class"] = "test-section error";
                lblOverallStatus.Text = "⚠️ Some tests failed - Check individual components";
                lblOverallStatus.CssClass = "badge badge-danger";
            }
        }
    }
}
