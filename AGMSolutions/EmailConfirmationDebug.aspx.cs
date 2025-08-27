using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Services;

public partial class EmailConfirmationDebug : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void btnAnalyzeDB_Click(object sender, EventArgs e)
    {
        try
        {
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result info'><h4>📊 Database Email Confirmation Analysis</h4>");
            
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                // Check total users
                string totalQuery = "SELECT COUNT(*) FROM Users";
                using (SqlCommand cmd = new SqlCommand(totalQuery, conn))
                {
                    int totalUsers = (int)cmd.ExecuteScalar();
                    resultHtml.AppendFormat("<p><strong>Total Users:</strong> {0}</p>", totalUsers);
                }
                
                // Check confirmed users
                string confirmedQuery = "SELECT COUNT(*) FROM Users WHERE IsEmailConfirmed = 1";
                using (SqlCommand cmd = new SqlCommand(confirmedQuery, conn))
                {
                    int confirmedUsers = (int)cmd.ExecuteScalar();
                    resultHtml.AppendFormat("<p><strong>Email Confirmed Users:</strong> {0}</p>", confirmedUsers);
                }
                
                // Check pending confirmations
                string pendingQuery = "SELECT COUNT(*) FROM Users WHERE IsEmailConfirmed = 0 AND EmailConfirmationToken IS NOT NULL";
                using (SqlCommand cmd = new SqlCommand(pendingQuery, conn))
                {
                    int pendingUsers = (int)cmd.ExecuteScalar();
                    resultHtml.AppendFormat("<p><strong>Pending Email Confirmations:</strong> {0}</p>", pendingUsers);
                }
                
                // Check expired tokens
                string expiredQuery = "SELECT COUNT(*) FROM Users WHERE EmailConfirmationToken IS NOT NULL AND TokenExpiry < GETDATE()";
                using (SqlCommand cmd = new SqlCommand(expiredQuery, conn))
                {
                    int expiredTokens = (int)cmd.ExecuteScalar();
                    resultHtml.AppendFormat("<p><strong>Expired Tokens:</strong> {0}</p>", expiredTokens);
                }
                
                // Show recent registrations
                string recentQuery = @"SELECT TOP 5 Email, IsEmailConfirmed, 
                    CASE WHEN EmailConfirmationToken IS NULL THEN 'No Token' ELSE 'Has Token' END as TokenStatus,
                    CASE WHEN TokenExpiry IS NULL THEN 'No Expiry' 
                         WHEN TokenExpiry > GETDATE() THEN 'Valid' 
                         ELSE 'Expired' END as TokenExpiry,
                    RegistrationDate
                    FROM Users ORDER BY RegistrationDate DESC";
                
                using (SqlCommand cmd = new SqlCommand(recentQuery, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        resultHtml.Append("<div class='code'><strong>Recent Registrations:</strong><br/>");
                        while (reader.Read())
                        {
                            resultHtml.AppendFormat("{0} | Confirmed: {1} | Token: {2} | Expiry: {3} | Registered: {4}<br/>",
                                reader["Email"], reader["IsEmailConfirmed"], reader["TokenStatus"], 
                                reader["TokenExpiry"], reader["RegistrationDate"]);
                        }
                        resultHtml.Append("</div>");
                    }
                }
            }
            
            resultHtml.Append("</div>");
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Database Analysis Error: {ex.Message}</div>";
        }
    }

    protected void btnCreateTestUser_Click(object sender, EventArgs e)
    {
        try
        {
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result success'><h4>👤 Creating Test User with Email Confirmation Token</h4>");
            
            // Generate test data
            string testEmail = "debug.test." + DateTime.Now.Ticks + "@test.com";
            string testToken = Guid.NewGuid().ToString();
            DateTime tokenExpiry = DateTime.Now.AddHours(24);
            
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                string insertQuery = @"
                    INSERT INTO Users (FirstName, LastName, Username, Email, PasswordHash, Salt, 
                                      PhoneNumber, CountryCode, UserTypeID, IsEmailConfirmed, 
                                      EmailConfirmationToken, TokenExpiry, RegistrationDate)
                    OUTPUT INSERTED.UserID
                    VALUES (@FirstName, @LastName, @Username, @Email, @PasswordHash, @Salt, 
                            @PhoneNumber, @CountryCode, @UserTypeID, 0, @Token, @TokenExpiry, GETDATE())";
                
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", "Debug");
                    cmd.Parameters.AddWithValue("@LastName", "Test");
                    cmd.Parameters.AddWithValue("@Username", "debugtest" + DateTime.Now.Ticks);
                    cmd.Parameters.AddWithValue("@Email", testEmail);
                    cmd.Parameters.AddWithValue("@PasswordHash", "testhash123");
                    cmd.Parameters.AddWithValue("@Salt", "testsalt123");
                    cmd.Parameters.AddWithValue("@PhoneNumber", "1234567890");
                    cmd.Parameters.AddWithValue("@CountryCode", "US");
                    cmd.Parameters.AddWithValue("@UserTypeID", 3);
                    cmd.Parameters.AddWithValue("@Token", testToken);
                    cmd.Parameters.AddWithValue("@TokenExpiry", tokenExpiry);
                    
                    int newUserId = (int)cmd.ExecuteScalar();
                    
                    resultHtml.AppendFormat(@"
                        <p><strong>✅ Test User Created Successfully!</strong></p>
                        <div class='code'>
                            UserID: {0}<br/>
                            Email: {1}<br/>
                            Token: {2}<br/>
                            Token Expiry: {3}<br/>
                            Email Confirmed: False
                        </div>
                        <p><strong>🔗 Test Confirmation Link:</strong></p>
                        <div class='code'>
                            /Common/ConfirmEmail.aspx?token={2}
                        </div>", newUserId, testEmail, testToken, tokenExpiry);
                    
                    // Set the token in the textbox for easy testing
                    txtTestToken.Text = testToken;
                }
            }
            
            resultHtml.Append("</div>");
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Create Test User Error: {ex.Message}</div>";
        }
    }

    protected void btnTestConfirmation_Click(object sender, EventArgs e)
    {
        try
        {
            string token = txtTestToken.Text.Trim();
            if (string.IsNullOrEmpty(token))
            {
                results.InnerHtml = "<div class='result error'>❌ Please enter a token to test</div>";
                return;
            }
            
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result info'><h4>🧪 Testing Email Confirmation Process</h4>");
            
            // Test using UserManager (same as ConfirmEmail.aspx)
            UserManager userManager = new UserManager();
            bool success = userManager.ConfirmUserEmail(token);
            
            if (success)
            {
                resultHtml.Append("<div class='result success'>✅ <strong>Email Confirmation SUCCESSFUL!</strong>");
                resultHtml.Append("<p>The token was valid and the user's email has been confirmed.</p></div>");
            }
            else
            {
                resultHtml.Append("<div class='result error'>❌ <strong>Email Confirmation FAILED!</strong>");
                resultHtml.Append("<p>The token may be invalid, expired, or already used.</p>");
                
                // Additional debugging - check if token exists in database
                string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string checkQuery = @"SELECT UserID, Email, IsEmailConfirmed, TokenExpiry, 
                        CASE WHEN TokenExpiry > GETDATE() THEN 'Valid' ELSE 'Expired' END as TokenStatus
                        FROM Users WHERE EmailConfirmationToken = @Token";
                    
                    using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                resultHtml.AppendFormat(@"
                                    <div class='code'>
                                        <strong>Token Found in Database:</strong><br/>
                                        UserID: {0}<br/>
                                        Email: {1}<br/>
                                        Already Confirmed: {2}<br/>
                                        Token Expiry: {3}<br/>
                                        Token Status: {4}
                                    </div>", 
                                    reader["UserID"], reader["Email"], reader["IsEmailConfirmed"], 
                                    reader["TokenExpiry"], reader["TokenStatus"]);
                            }
                            else
                            {
                                resultHtml.Append("<div class='code'><strong>❌ Token NOT found in database</strong></div>");
                            }
                        }
                    }
                }
                resultHtml.Append("</div>");
            }
            
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Test Confirmation Error: {ex.Message}<br/>Details: {ex.StackTrace}</div>";
        }
    }

    protected void btnTestRegistration_Click(object sender, EventArgs e)
    {
        try
        {
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result info'><h4>🔄 Testing Complete Registration Flow</h4>");
            
            // Test user registration through UserManager
            UserManager userManager = new UserManager();
            
            string testEmail = "fulltest." + DateTime.Now.Ticks + "@test.com";
            string password = "TestPass123!";
            
            bool regSuccess = userManager.RegisterUser(
                "Full", "Test", "User", testEmail, password,
                "1234567890", "US", "Student", "lightblue");
            
            if (regSuccess)
            {
                resultHtml.AppendFormat(@"
                    <div class='result success'>
                        ✅ <strong>Registration Successful!</strong><br/>
                        Email: {0}<br/>
                        Password: {1}
                    </div>", testEmail, password);
                
                // Check if confirmation token was created
                string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string tokenQuery = "SELECT EmailConfirmationToken, TokenExpiry, IsEmailConfirmed FROM Users WHERE Email = @Email";
                    
                    using (SqlCommand cmd = new SqlCommand(tokenQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", testEmail);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string token = reader["EmailConfirmationToken"] as string;
                                object expiry = reader["TokenExpiry"];
                                bool confirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]);
                                
                                if (!string.IsNullOrEmpty(token))
                                {
                                    resultHtml.AppendFormat(@"
                                        <div class='code'>
                                            <strong>✅ Email Confirmation Token Generated:</strong><br/>
                                            Token: {0}<br/>
                                            Expiry: {1}<br/>
                                            Already Confirmed: {2}
                                        </div>
                                        <p><strong>🔗 Confirmation Link:</strong></p>
                                        <div class='code'>/Common/ConfirmEmail.aspx?token={0}</div>", 
                                        token, expiry, confirmed);
                                    
                                    txtTestToken.Text = token;
                                }
                                else
                                {
                                    resultHtml.Append("<div class='result error'>❌ No email confirmation token was generated during registration</div>");
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                resultHtml.Append("<div class='result error'>❌ Registration failed</div>");
            }
            
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Registration Test Error: {ex.Message}</div>";
        }
    }
}
