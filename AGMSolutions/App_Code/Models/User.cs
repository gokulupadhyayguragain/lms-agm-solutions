using System;

namespace AGMSolutions.App_Code.Models
{
    public class User
    {
        public int UserID { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string Salt { get; set; }
        public string PhoneNo { get; set; }
        public string Country { get; set; }
        public int UserTypeID { get; set; }
        public string ProfilePictureURL { get; set; }
        public string Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public bool IsEmailConfirmed { get; set; }
        public DateTime RegistrationDate { get; set; }
        public DateTime? LastLoginDate { get; set; }
        public string ThemeColor { get; set; }
        public string EmailConfirmationToken { get; set; }
        public DateTime? EmailConfirmationTokenExpiry { get; set; }
        public DateTime? LastEmailConfirmationRequest { get; set; }
        public string PasswordResetToken { get; set; }
        public DateTime? PasswordResetTokenExpiry { get; set; }

        public Role UserType { get; set; }

        public User() { }
    }
}
