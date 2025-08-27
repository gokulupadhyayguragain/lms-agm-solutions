using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DebugPanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void btnTestLogin_Click(object sender, EventArgs e)
    {
        try
        {
            loginResults.InnerHtml = "<div class='info'>Testing demo account login...</div>";
            
            // Test 1: Check if demo account exists
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT UserID, Username, Email, PasswordHash, Salt, IsEmailConfirmed FROM Users WHERE Email = 'demo.admin@agm.com'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string userID = reader["UserID"].ToString();
                            string username = reader["Username"].ToString();
                            string email = reader["Email"].ToString();
                            string passwordHash = reader["PasswordHash"].ToString();
                            string salt = reader["Salt"].ToString();
                            bool isConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]);
                            
                            loginResults.InnerHtml += "<div class='success'>✅ Demo account found!</div>";
                            loginResults.InnerHtml += $"<div class='result'>UserID: {userID}<br/>Username: {username}<br/>Email: {email}<br/>Confirmed: {isConfirmed}</div>";
                            
                            // Test 2: Verify password
                            string testPassword = "demo123";
                            string computedHash = ComputeHash(testPassword, salt);
                            
                            if (computedHash == passwordHash)
                            {
                                loginResults.InnerHtml += "<div class='success'>✅ Password verification SUCCESS!</div>";
                                loginResults.InnerHtml += "<div class='result'>Demo account login should work with password: demo123</div>";
                            }
                            else
                            {
                                loginResults.InnerHtml += "<div class='error'>❌ Password verification FAILED!</div>";
                                loginResults.InnerHtml += $"<div class='result'>Expected: {passwordHash}<br/>Computed: {computedHash}</div>";
                                
                                // Try with different salt formats
                                string computedHash2 = ComputeHashAlternative(testPassword, salt);
                                if (computedHash2 == passwordHash)
                                {
                                    loginResults.InnerHtml += "<div class='warning'>⚠️ Alternative hash method works!</div>";
                                }
                            }
                        }
                        else
                        {
                            loginResults.InnerHtml += "<div class='error'>❌ Demo account not found!</div>";
                            loginResults.InnerHtml += "<div class='result'>Need to create demo account</div>";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            loginResults.InnerHtml = $"<div class='error'>❌ Error: {ex.Message}</div>";
        }
    }

    protected void btnTestToken_Click(object sender, EventArgs e)
    {
        try
        {
            string token = txtToken.Text.Trim();
            if (string.IsNullOrEmpty(token))
            {
                tokenResults.InnerHtml = "<div class='warning'>⚠️ Please enter a token to test</div>";
                return;
            }
            
            tokenResults.InnerHtml = "<div class='info'>Testing email confirmation token...</div>";
            
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT UserID, Email, EmailConfirmationToken, TokenExpiry, IsEmailConfirmed FROM Users WHERE EmailConfirmationToken = @token";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@token", token);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string userID = reader["UserID"].ToString();
                            string email = reader["Email"].ToString();
                            DateTime tokenExpiry = Convert.ToDateTime(reader["TokenExpiry"]);
                            bool isConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]);
                            
                            tokenResults.InnerHtml += "<div class='success'>✅ Token found in database!</div>";
                            tokenResults.InnerHtml += $"<div class='result'>UserID: {userID}<br/>Email: {email}<br/>Expiry: {tokenExpiry}<br/>Already Confirmed: {isConfirmed}</div>";
                            
                            if (DateTime.Now > tokenExpiry)
                            {
                                tokenResults.InnerHtml += "<div class='error'>❌ Token is EXPIRED!</div>";
                            }
                            else if (isConfirmed)
                            {
                                tokenResults.InnerHtml += "<div class='warning'>⚠️ Email already confirmed</div>";
                            }
                            else
                            {
                                tokenResults.InnerHtml += "<div class='success'>✅ Token is VALID and ready for confirmation!</div>";
                                
                                // Test the confirmation
                                reader.Close();
                                string updateQuery = "UPDATE Users SET IsEmailConfirmed = 1 WHERE EmailConfirmationToken = @token AND TokenExpiry > GETDATE()";
                                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                                {
                                    updateCmd.Parameters.AddWithValue("@token", token);
                                    int rowsAffected = updateCmd.ExecuteNonQuery();
                                    
                                    if (rowsAffected > 0)
                                    {
                                        tokenResults.InnerHtml += "<div class='success'>✅ Email confirmation SUCCESSFUL!</div>";
                                    }
                                    else
                                    {
                                        tokenResults.InnerHtml += "<div class='error'>❌ Email confirmation FAILED!</div>";
                                    }
                                }
                            }
                        }
                        else
                        {
                            tokenResults.InnerHtml += "<div class='error'>❌ Token not found in database!</div>";
                            tokenResults.InnerHtml += "<div class='result'>The token may be invalid, expired, or already used</div>";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            tokenResults.InnerHtml = $"<div class='error'>❌ Error: {ex.Message}</div>";
        }
    }

    protected void btnTestMessages_Click(object sender, EventArgs e)
    {
        messageResults.InnerHtml = @"
            <div class='info'>Testing message visibility...</div>
            <div class='alert alert-success' style='z-index: 10000; position: relative;'>
                ✅ <strong>Success Message:</strong> This should be visible in GREEN with high z-index
            </div>
            <div class='alert alert-danger' style='z-index: 10000; position: relative;'>
                ❌ <strong>Error Message:</strong> This should be visible in RED with high z-index  
            </div>
            <div class='invalid-feedback' style='display: block !important; z-index: 10000; position: relative;'>
                ❌ Invalid feedback message - should be visible in RED
            </div>
            <div class='valid-feedback' style='display: block !important; z-index: 10000; position: relative;'>
                ✅ Valid feedback message - should be visible in GREEN
            </div>
            <div class='result'>
                <strong>CSS Test:</strong> If you can see all colored messages above, the styling is working correctly!
            </div>";
    }

    protected void btnTestRegistration_Click(object sender, EventArgs e)
    {
        try
        {
            registrationResults.InnerHtml = "<div class='info'>Testing registration flow...</div>";
            
            // Test creating a test user
            string testEmail = "test." + DateTime.Now.Ticks + "@test.com";
            string testPassword = "Test123!";
            
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                // Generate password hash
                string salt = GenerateSalt();
                string passwordHash = ComputeHash(testPassword, salt);
                string token = GenerateToken();
                DateTime tokenExpiry = DateTime.Now.AddHours(24);
                
                string insertQuery = @"
                    INSERT INTO Users (Username, Email, PasswordHash, Salt, EmailConfirmationToken, TokenExpiry, IsEmailConfirmed, PhoneNumber, CountryCode) 
                    VALUES (@username, @email, @passwordHash, @salt, @token, @tokenExpiry, 0, @phone, @country)";
                
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@username", "test_user_" + DateTime.Now.Ticks);
                    cmd.Parameters.AddWithValue("@email", testEmail);
                    cmd.Parameters.AddWithValue("@passwordHash", passwordHash);
                    cmd.Parameters.AddWithValue("@salt", salt);
                    cmd.Parameters.AddWithValue("@token", token);
                    cmd.Parameters.AddWithValue("@tokenExpiry", tokenExpiry);
                    cmd.Parameters.AddWithValue("@phone", "1234567890");
                    cmd.Parameters.AddWithValue("@country", "US");
                    
                    int rowsAffected = cmd.ExecuteNonQuery();
                    
                    if (rowsAffected > 0)
                    {
                        registrationResults.InnerHtml += "<div class='success'>✅ Registration successful!</div>";
                        registrationResults.InnerHtml += $"<div class='result'>Test user created: {testEmail}<br/>Token: {token}</div>";
                        
                        // Test token confirmation
                        string confirmQuery = "UPDATE Users SET IsEmailConfirmed = 1 WHERE EmailConfirmationToken = @token AND TokenExpiry > GETDATE()";
                        using (SqlCommand confirmCmd = new SqlCommand(confirmQuery, conn))
                        {
                            confirmCmd.Parameters.AddWithValue("@token", token);
                            int confirmRows = confirmCmd.ExecuteNonQuery();
                            
                            if (confirmRows > 0)
                            {
                                registrationResults.InnerHtml += "<div class='success'>✅ Email confirmation successful!</div>";
                                registrationResults.InnerHtml += "<div class='result'>Complete registration flow working correctly!</div>";
                            }
                            else
                            {
                                registrationResults.InnerHtml += "<div class='error'>❌ Email confirmation failed!</div>";
                            }
                        }
                    }
                    else
                    {
                        registrationResults.InnerHtml += "<div class='error'>❌ Registration failed!</div>";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            registrationResults.InnerHtml = $"<div class='error'>❌ Error: {ex.Message}</div>";
        }
    }

    private string ComputeHash(string password, string salt)
    {
        using (SHA256 sha256Hash = SHA256.Create())
        {
            byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password + salt));
            return Convert.ToBase64String(bytes);
        }
    }

    private string ComputeHashAlternative(string password, string salt)
    {
        using (SHA256 sha256Hash = SHA256.Create())
        {
            byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(salt + password));
            return Convert.ToBase64String(bytes);
        }
    }

    private string GenerateSalt()
    {
        byte[] saltBytes = new byte[32];
        using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
        {
            rng.GetBytes(saltBytes);
        }
        return Convert.ToBase64String(saltBytes);
    }

    private string GenerateToken()
    {
        return Guid.NewGuid().ToString();
    }
}
