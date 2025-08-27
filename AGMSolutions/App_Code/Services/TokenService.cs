using System;
using System.Security.Cryptography;
using System.Text;

namespace AGMSolutions.App_Code.Services
{
    public static class TokenService
    {
        /// <summary>
        /// Generates a unique, cryptographically strong token.
        /// </summary>
        /// <param name="length">The length of the token in bytes (default 32 bytes = 64 hex characters).</param>
        /// <returns>A unique hexadecimal string token.</returns>
        public static string GenerateUniqueToken(int length = 32)
        {
            using (RNGCryptoServiceProvider rngCsp = new RNGCryptoServiceProvider())
            {
                byte[] data = new byte[length];
                rngCsp.GetBytes(data); // Fills array with cryptographically strong random bytes
                return BitConverter.ToString(data).Replace("-", "").ToLowerInvariant(); // Convert to hex string
            }
        }

        // You can add more token-related methods here if needed, e.g., for validating format etc.
    }
}

