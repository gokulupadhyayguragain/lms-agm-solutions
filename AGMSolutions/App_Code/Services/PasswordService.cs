using System;
using System.Security.Cryptography; // Needed for RNGCryptoServiceProvider and Rfc2898DeriveBytes
using System.Text; // Not strictly needed here if not using Encoding directly

namespace AGMSolutions.App_Code.Services
{
    public static class PasswordService // It must be public static
    {
        // Generates a random salt
        public static string GenerateSalt() // Make public static
        {
            byte[] saltBytes = new byte[16]; // 128-bit salt
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(saltBytes);
            }
            return Convert.ToBase64String(saltBytes);
        }

        // Hashes a password using PBKDF2 (Rfc2898DeriveBytes)
        public static string HashPassword(string password, string salt) // Make public static
        {
            int iterations = 10000;
            byte[] saltBytes = Convert.FromBase64String(salt);

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, iterations, HashAlgorithmName.SHA256))
            {
                byte[] hash = pbkdf2.GetBytes(32); // 256-bit hash
                return Convert.ToBase64String(hash);
            }
        }

        // Verifies a password against a stored hash and salt
        public static bool VerifyPassword(string password, string storedHash, string storedSalt) // Make public static
        {
            // Hash the input password using the same salt and parameters
            string hashOfInput = HashPassword(password, storedSalt);

            // Compare the hashes
            return hashOfInput.Equals(storedHash);
        }
    }
}

