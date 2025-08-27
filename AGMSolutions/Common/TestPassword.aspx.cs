using System;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Common
{
    public partial class TestPassword : Page
    {
        private UserManager _userManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            _userManager = new UserManager();
        }

        protected void btnTest_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text;
            
            // Test the current hashing method
            string salt1 = GenerateSalt();
            string hash1 = HashPassword(password, salt1);
            
            // Test verification
            bool verified = VerifyPassword(password, hash1, salt1);
            
            // Test against demo admin account
            User demoAdmin = _userManager.GetUserByEmail("demo.admin@agm.com");
            bool demoVerified = false;
            if (demoAdmin != null)
            {
                demoVerified = _userManager.VerifyPassword(password, demoAdmin.PasswordHash, demoAdmin.Salt);
            }
            
            string results = $@"
                <div class='test-result'>
                    <h3>Password Hash Test Results</h3>
                    <p><strong>Password:</strong> {password}</p>
                    <p><strong>Generated Salt:</strong> {salt1}</p>
                    <p><strong>Generated Hash:</strong> {hash1}</p>
                    <p><strong>Verification Test:</strong> <span class='{(verified ? "success" : "error")}'>{verified}</span></p>
                </div>
                
                <div class='test-result'>
                    <h3>Demo Admin Account Test</h3>
                    <p><strong>Demo Admin Found:</strong> {(demoAdmin != null ? "Yes" : "No")}</p>";
            
            if (demoAdmin != null)
            {
                results += $@"
                    <p><strong>Demo Admin Email:</strong> {demoAdmin.Email}</p>
                    <p><strong>Demo Admin Salt:</strong> {demoAdmin.Salt}</p>
                    <p><strong>Demo Admin Hash:</strong> {demoAdmin.PasswordHash}</p>
                    <p><strong>Password Verification:</strong> <span class='{(demoVerified ? "success" : "error")}'>{demoVerified}</span></p>";
            }
            
            results += "</div>";
            
            // Test with correct password format for demo accounts
            string correctSalt = "nLYrH1M5IbjR+4fOnP0xDy==";
            string correctHash = HashPassword(password, correctSalt);
            
            results += $@"
                <div class='test-result'>
                    <h3>Expected Demo Hash Test</h3>
                    <p><strong>Expected Salt:</strong> {correctSalt}</p>
                    <p><strong>Generated Hash with Expected Salt:</strong> {correctHash}</p>
                    <p><strong>Expected Hash:</strong> pL6U1FrO5sQgM0eN7fX2rKyB3I8VCblAGJ4TJ2QK2hk=</p>
                    <p><strong>Hashes Match:</strong> <span class='{(correctHash == "pL6U1FrO5sQgM0eN7fX2rKyB3I8VCblAGJ4TJ2QK2hk=" ? "success" : "error")}'>{correctHash == "pL6U1FrO5sQgM0eN7fX2rKyB3I8VCblAGJ4TJ2QK2hk="}</span></p>
                </div>";
                
            litResults.Text = results;
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
        
        private bool VerifyPassword(string password, string storedHash, string storedSalt)
        {
            string hashToVerify = HashPassword(password, storedSalt);
            return hashToVerify == storedHash;
        }
    }
}
