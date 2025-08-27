using System;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace AGMSolutions.Common
{
    public partial class HashGenerator : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentType = "text/plain";
            
            // Generate correct hashes for demo passwords
            string adminPassword = "Admin123!";
            string studentPassword = "Student123!";
            string lecturerPassword = "Lecturer123!";
            
            string adminSalt = "nLYrH1M5IbjR+4fOnP0xDy==";
            string studentSalt = "qJXrF9K3GZhP+2dLmN8vBw==";
            string lecturerSalt = "mKXsG0L4HaiQ+3eNnO9wCx==";
            
            string adminHash = HashPassword(adminPassword, adminSalt);
            string studentHash = HashPassword(studentPassword, studentSalt);
            string lecturerHash = HashPassword(lecturerPassword, lecturerSalt);
            
            StringBuilder output = new StringBuilder();
            output.AppendLine("Demo Account Password Hashes:");
            output.AppendLine("============================");
            output.AppendLine();
            
            output.AppendLine($"Admin Account:");
            output.AppendLine($"  Email: demo.admin@agm.com");
            output.AppendLine($"  Password: {adminPassword}");
            output.AppendLine($"  Salt: {adminSalt}");
            output.AppendLine($"  Hash: {adminHash}");
            output.AppendLine();
            
            output.AppendLine($"Student Account:");
            output.AppendLine($"  Email: demo.student@agm.com");
            output.AppendLine($"  Password: {studentPassword}");
            output.AppendLine($"  Salt: {studentSalt}");
            output.AppendLine($"  Hash: {studentHash}");
            output.AppendLine();
            
            output.AppendLine($"Lecturer Account:");
            output.AppendLine($"  Email: demo.lecturer@agm.com");
            output.AppendLine($"  Password: {lecturerPassword}");
            output.AppendLine($"  Salt: {lecturerSalt}");
            output.AppendLine($"  Hash: {lecturerHash}");
            output.AppendLine();
            
            output.AppendLine("SQL Update Commands:");
            output.AppendLine("===================");
            output.AppendLine($"UPDATE Users SET PasswordHash = '{adminHash}' WHERE Email = 'demo.admin@agm.com';");
            output.AppendLine($"UPDATE Users SET PasswordHash = '{studentHash}' WHERE Email = 'demo.student@agm.com';");
            output.AppendLine($"UPDATE Users SET PasswordHash = '{lecturerHash}' WHERE Email = 'demo.lecturer@agm.com';");
            
            Response.Write(output.ToString());
            Response.End();
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
}
