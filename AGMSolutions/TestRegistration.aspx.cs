using System;
using System.Web.UI;

public partial class TestRegistration : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnTest_Click(object sender, EventArgs e)
    {
        try
        {
            // Create a test user
            var user = new User
            {
                FirstName = "Test",
                LastName = "User",
                Email = "test@example.com",
                PhoneNo = "1234567890",
                Country = "USA",
                UserTypeID = 3, // Student
                IsEmailConfirmed = false,
                RegistrationDate = DateTime.Now,
                ThemeColor = "skyblue"
            };

            // Test registration
            var userManager = new UserManager();
            bool result = userManager.RegisterUser(user, "testpassword123");
            
            if (result)
            {
                lblResult.ForeColor = System.Drawing.Color.Green;
                lblResult.Text = "Registration successful! Check debug output for email sending status.";
            }
            else
            {
                lblResult.ForeColor = System.Drawing.Color.Red;
                lblResult.Text = "Registration failed! Check debug output for details.";
            }
        }
        catch (Exception ex)
        {
            lblResult.ForeColor = System.Drawing.Color.Red;
            lblResult.Text = "Error: " + ex.Message + "<br/>Details: " + ex.ToString();
        }
    }
}
