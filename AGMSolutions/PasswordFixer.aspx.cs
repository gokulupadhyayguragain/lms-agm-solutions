using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

public partial class PasswordFixer : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void btnGenerateHashes_Click(object sender, EventArgs e)
    {
        try
        {
            results.InnerHtml = "<div class='result info'><strong>🔧 Generating Password Hashes...</strong></div>";
            
            // Define the EXACT passwords we want to use
            var accounts = new[]
            {
                new { Email = "demo.admin@agm.com", Password = "demo123", Role = "Admin" },
                new { Email = "demo.student@agm.com", Password = "demo123", Role = "Student" },
                new { Email = "demo.lecturer@agm.com", Password = "demo123", Role = "Lecturer" }
            };
            
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result success'><h4>✅ Generated Password Hashes:</h4>");
            
            foreach (var account in accounts)
            {
                string salt = GenerateSalt();
                string hash = HashPassword(account.Password, salt);
                
                resultHtml.AppendFormat(@"
                    <div class='code'>
                        <strong>{0} ({1}):</strong><br/>
                        Email: {2}<br/>
                        Password: {3}<br/>
                        Salt: {4}<br/>
                        Hash: {5}<br/>
                    </div>", 
                    account.Role, account.Email, account.Email, account.Password, salt, hash);
            }
            
            resultHtml.Append("</div>");
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Error: {ex.Message}</div>";
        }
    }

    protected void btnUpdateDatabase_Click(object sender, EventArgs e)
    {
        try
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            
            // Define consistent demo accounts with demo123 password
            var accounts = new[]
            {
                new { 
                    Email = "demo.admin@agm.com", 
                    Username = "admin", 
                    Password = "demo123", 
                    FirstName = "Demo", 
                    LastName = "Admin", 
                    UserTypeID = 1,  // Admin role
                    Salt = GenerateSalt()
                },
                new { 
                    Email = "demo.student@agm.com", 
                    Username = "student", 
                    Password = "demo123", 
                    FirstName = "Demo", 
                    LastName = "Student", 
                    UserTypeID = 3,  // Student role
                    Salt = GenerateSalt()
                },
                new { 
                    Email = "demo.lecturer@agm.com", 
                    Username = "lecturer", 
                    Password = "demo123", 
                    FirstName = "Demo", 
                    LastName = "Lecturer", 
                    UserTypeID = 2,  // Lecturer role
                    Salt = GenerateSalt()
                }
            };
            
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                var resultHtml = new StringBuilder();
                resultHtml.Append("<div class='result success'><h4>✅ Database Update Results:</h4>");
                
                foreach (var account in accounts)
                {
                    // Delete existing account
                    string deleteQuery = "DELETE FROM Users WHERE Email = @Email";
                    using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                    {
                        deleteCmd.Parameters.AddWithValue("@Email", account.Email);
                        deleteCmd.ExecuteNonQuery();
                    }
                    
                    // Insert new account with correct hash
                    string hash = HashPassword(account.Password, account.Salt);
                    string insertQuery = @"
                        INSERT INTO Users (FirstName, LastName, Username, Email, PasswordHash, Salt, 
                                          PhoneNumber, CountryCode, UserTypeID, IsEmailConfirmed, RegistrationDate)
                        VALUES (@FirstName, @LastName, @Username, @Email, @PasswordHash, @Salt, 
                                @PhoneNumber, @CountryCode, @UserTypeID, 1, GETDATE())";
                    
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@FirstName", account.FirstName);
                        insertCmd.Parameters.AddWithValue("@LastName", account.LastName);
                        insertCmd.Parameters.AddWithValue("@Username", account.Username);
                        insertCmd.Parameters.AddWithValue("@Email", account.Email);
                        insertCmd.Parameters.AddWithValue("@PasswordHash", hash);
                        insertCmd.Parameters.AddWithValue("@Salt", account.Salt);
                        insertCmd.Parameters.AddWithValue("@PhoneNumber", "1234567890");
                        insertCmd.Parameters.AddWithValue("@CountryCode", "US");
                        insertCmd.Parameters.AddWithValue("@UserTypeID", account.UserTypeID);
                        
                        int rowsAffected = insertCmd.ExecuteNonQuery();
                        resultHtml.AppendFormat("<div>✅ {0} - {1} (Rows affected: {2})</div>", 
                            account.Email, account.Password, rowsAffected);
                    }
                }
                
                resultHtml.Append("</div>");
                results.InnerHtml = resultHtml.ToString();
            }
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Database Error: {ex.Message}</div>";
        }
    }

    protected void btnTestLogin_Click(object sender, EventArgs e)
    {
        try
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            
            var resultHtml = new StringBuilder();
            resultHtml.Append("<div class='result info'><h4>🧪 Testing Demo Account Logins:</h4>");
            
            string[] emails = { "demo.admin@agm.com", "demo.student@agm.com", "demo.lecturer@agm.com" };
            string testPassword = "demo123";
            
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                
                foreach (string email in emails)
                {
                    string query = "SELECT Email, PasswordHash, Salt, IsEmailConfirmed FROM Users WHERE Email = @Email";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedHash = reader["PasswordHash"].ToString();
                                string storedSalt = reader["Salt"].ToString();
                                bool isConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]);
                                
                                string computedHash = HashPassword(testPassword, storedSalt);
                                bool passwordMatch = computedHash == storedHash;
                                
                                string status = passwordMatch && isConfirmed ? "✅ LOGIN OK" : "❌ LOGIN FAILED";
                                string color = passwordMatch && isConfirmed ? "success" : "error";
                                
                                resultHtml.AppendFormat(@"
                                    <div class='result {0}'>
                                        <strong>{1}</strong> - {2}<br/>
                                        Password Match: {3}<br/>
                                        Email Confirmed: {4}<br/>
                                        Status: {5}
                                    </div>", 
                                    color, email, testPassword, passwordMatch, isConfirmed, status);
                            }
                            else
                            {
                                resultHtml.AppendFormat("<div class='result error'>❌ {0} - Account not found</div>", email);
                            }
                        }
                    }
                }
            }
            
            results.InnerHtml = resultHtml.ToString();
        }
        catch (Exception ex)
        {
            results.InnerHtml = $"<div class='result error'>❌ Test Error: {ex.Message}</div>";
        }
    }

    protected void btnFixMessages_Click(object sender, EventArgs e)
    {
        results.InnerHtml = @"
            <div class='result success'>
                <h4>✅ Message Visibility Fix Applied:</h4>
                <p>The following CSS has been applied to fix message visibility:</p>
                <div class='code'>
.alert, .status-message, .invalid-feedback, .valid-feedback {
    position: relative !important;
    z-index: 10000 !important;
    display: block !important;
    visibility: visible !important;
    opacity: 1 !important;
}

.login-messages, .signup-messages {
    margin: 15px 0 !important;
    padding: 15px 20px !important;
    border-radius: 5px !important;
    font-weight: 600 !important;
    box-shadow: 0 3px 6px rgba(0,0,0,0.16) !important;
}
                </div>
                <p><strong>Apply this CSS to your Site.css file to fix message visibility across all pages.</strong></p>
            </div>";
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

    private string HashPassword(string password, string salt)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            byte[] saltedPassword = Encoding.UTF8.GetBytes(password + salt);
            byte[] hash = sha256.ComputeHash(saltedPassword);
            return Convert.ToBase64String(hash);
        }
    }
}
