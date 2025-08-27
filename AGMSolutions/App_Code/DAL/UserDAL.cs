using AGMSolutions.App_Code.Models; // Ensure this namespace is imported
using System;
using System.Collections.Generic;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;


namespace AGMSolutions.App_Code.DAL
{
    public class UserDAL : BaseDAL
    {
        public UserDAL()
        {
        }

        // Method to get a user by email
        public User GetUserByEmail(string email)
        {
            User user = null;
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT u.*, r.RoleName FROM Users u JOIN Roles r ON u.UserTypeID = r.RoleID WHERE u.Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                FirstName = reader["FirstName"].ToString(),
                                MiddleName = reader["MiddleName"] as string, // Handle NULL
                                LastName = reader["LastName"].ToString(),
                                Email = reader["Email"].ToString(),
                                PasswordHash = reader["PasswordHash"].ToString(),
                                Salt = reader["Salt"].ToString(),
                                PhoneNo = reader["PhoneNumber"] as string, // DB column is PhoneNumber
                                Country = reader["CountryCode"] as string, // DB column is CountryCode
                                UserTypeID = Convert.ToInt32(reader["UserTypeID"]),
                                ProfilePictureURL = reader["ProfilePicture"] as string, // DB column is ProfilePicture
                                Gender = reader["Gender"] as string,
                                DateOfBirth = reader["DateOfBirth"] as DateTime?,
                                IsEmailConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]),
                                RegistrationDate = Convert.ToDateTime(reader["RegistrationDate"]),
                                LastLoginDate = reader["LastLoginDate"] as DateTime?,
                                ThemeColor = "", // Not in DB schema, set default
                                // Add new properties
                                EmailConfirmationToken = reader["EmailConfirmationToken"] as string,
                                EmailConfirmationTokenExpiry = reader["TokenExpiry"] as DateTime?, // DB column is TokenExpiry
                                LastEmailConfirmationRequest = reader["ModifiedDate"] as DateTime?, // Use ModifiedDate as fallback
                                UserType = new Role { RoleID = Convert.ToInt32(reader["UserTypeID"]), RoleName = reader["RoleName"].ToString() }
                            };
                        }
                    }
                }
            }
            return user;
        }

        // Method to add a new user (used in registration)
        public int AddUser(User user)
        {
            int userId = 0;
            using (SqlConnection con = GetConnection())
            {
                string query = @"INSERT INTO Users (FirstName, MiddleName, LastName, Username, Email, PasswordHash, Salt, PhoneNumber, CountryCode, UserTypeID, ProfilePicture, Gender, DateOfBirth, IsEmailConfirmed, RegistrationDate)
                                 OUTPUT INSERTED.UserID
                                 VALUES (@FirstName, @MiddleName, @LastName, @Username, @Email, @PasswordHash, @Salt, @PhoneNumber, @CountryCode, @UserTypeID, @ProfilePicture, @Gender, @DateOfBirth, @IsEmailConfirmed, @RegistrationDate)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                    cmd.Parameters.AddWithValue("@MiddleName", (object)user.MiddleName ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@LastName", user.LastName);
                    cmd.Parameters.AddWithValue("@Username", user.Email); // Use email as username
                    cmd.Parameters.AddWithValue("@Email", user.Email);
                    cmd.Parameters.AddWithValue("@PasswordHash", user.PasswordHash);
                    cmd.Parameters.AddWithValue("@Salt", user.Salt);
                    cmd.Parameters.AddWithValue("@PhoneNumber", (object)user.PhoneNo ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CountryCode", (object)user.Country ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@UserTypeID", user.UserTypeID);
                    cmd.Parameters.AddWithValue("@ProfilePicture", (object)user.ProfilePictureURL ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Gender", (object)user.Gender ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateOfBirth", (object)user.DateOfBirth ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsEmailConfirmed", user.IsEmailConfirmed);
                    cmd.Parameters.AddWithValue("@RegistrationDate", user.RegistrationDate);
                    cmd.Parameters.AddWithValue("@Gender", (object)user.Gender ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateOfBirth", (object)user.DateOfBirth ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IsEmailConfirmed", user.IsEmailConfirmed);
                    cmd.Parameters.AddWithValue("@RegistrationDate", user.RegistrationDate);

                    con.Open();
                    userId = (int)cmd.ExecuteScalar(); // Returns the ID of the newly inserted row
                }
            }
            return userId;
        }

        // Method to get a role by RoleName
        public Role GetRoleByName(string roleName)
        {
            Role role = null;
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT RoleID, RoleName FROM Roles WHERE RoleName = @RoleName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@RoleName", roleName);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            role = new Role
                            {
                                RoleID = Convert.ToInt32(reader["RoleID"]),
                                RoleName = reader["RoleName"].ToString()
                            };
                        }
                    }
                }
            }
            return role;
        }

        // Method to get a role by RoleID
        public Role GetRoleById(int roleId)
        {
            Role role = null;
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT RoleID, RoleName FROM Roles WHERE RoleID = @RoleID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@RoleID", roleId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            role = new Role
                            {
                                RoleID = Convert.ToInt32(reader["RoleID"]),
                                RoleName = reader["RoleName"].ToString()
                            };
                        }
                    }
                }
            }
            return role;
        }

        // Method to update a user's email confirmation status and token
        public bool UpdateUserEmailConfirmation(int userId, bool isConfirmed, string token = null, DateTime? tokenExpiry = null, DateTime? lastRequest = null)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = @"UPDATE Users
                         SET IsEmailConfirmed = @IsEmailConfirmed,
                             EmailConfirmationToken = @EmailConfirmationToken,
                             EmailConfirmationTokenExpiry = @EmailConfirmationTokenExpiry,
                             LastEmailConfirmationRequest = @LastEmailConfirmationRequest
                         WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@IsEmailConfirmed", isConfirmed);
                    cmd.Parameters.AddWithValue("@EmailConfirmationToken", (object)token ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@EmailConfirmationTokenExpiry", (object)tokenExpiry ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@LastEmailConfirmationRequest", (object)lastRequest ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    con.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // Method to get a user by Email Confirmation Token
        public User GetUserByEmailConfirmationToken(string token)
        {
            User user = null;
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT u.*, r.RoleName FROM Users u JOIN Roles r ON u.UserTypeID = r.RoleID WHERE u.EmailConfirmationToken = @Token";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Token", token);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                FirstName = reader["FirstName"].ToString(),
                                MiddleName = reader["MiddleName"] as string,
                                LastName = reader["LastName"].ToString(),
                                Email = reader["Email"].ToString(),
                                PasswordHash = reader["PasswordHash"].ToString(),
                                Salt = reader["Salt"].ToString(),
                                PhoneNo = reader["PhoneNumber"] as string, // DB column is PhoneNumber
                                Country = reader["CountryCode"] as string, // DB column is CountryCode
                                UserTypeID = Convert.ToInt32(reader["UserTypeID"]),
                                ProfilePictureURL = reader["ProfilePicture"] as string, // DB column is ProfilePicture
                                Gender = reader["Gender"] as string,
                                DateOfBirth = reader["DateOfBirth"] as DateTime?,
                                IsEmailConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]),
                                RegistrationDate = Convert.ToDateTime(reader["RegistrationDate"]),
                                LastLoginDate = reader["LastLoginDate"] as DateTime?,
                                ThemeColor = "", // Not in DB schema, set default
                                EmailConfirmationToken = reader["EmailConfirmationToken"] as string,
                                EmailConfirmationTokenExpiry = reader["TokenExpiry"] as DateTime?, // DB column is TokenExpiry
                                LastEmailConfirmationRequest = reader["ModifiedDate"] as DateTime?, // Use ModifiedDate as fallback
                                UserType = new Role { RoleID = Convert.ToInt32(reader["UserTypeID"]), RoleName = reader["RoleName"].ToString() }
                            };
                        }
                    }
                }
                return user;
            }

        }
        // ... existing methods ...

        public bool UpdateUserLastLoginDate(int userId, DateTime lastLoginDate)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = "UPDATE Users SET LastLoginDate = @LastLoginDate WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LastLoginDate", lastLoginDate);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    con.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // ... existing methods ...

        public List<User> GetAllUsers()
        {
            List<User> users = new List<User>();
            using (SqlConnection con = GetConnection())
            {
                // Join Users with Roles to get RoleName
                string query = "SELECT U.*, R.RoleName " +
                               "FROM Users U " +
                               "INNER JOIN Roles R ON U.UserTypeID = R.RoleID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            User user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                FirstName = reader["FirstName"].ToString(),
                                MiddleName = reader["MiddleName"] as string, // Nullable string
                                LastName = reader["LastName"].ToString(),
                                Email = reader["Email"].ToString(),
                                PasswordHash = reader["PasswordHash"].ToString(),
                                Salt = reader["Salt"].ToString(),
                                PhoneNo = reader["PhoneNumber"] as string, // DB column is PhoneNumber
                                Country = reader["CountryCode"] as string, // DB column is CountryCode
                                UserTypeID = Convert.ToInt32(reader["UserTypeID"]),
                                ProfilePictureURL = reader["ProfilePicture"] as string, // DB column is ProfilePicture
                                Gender = reader["Gender"] as string,
                                DateOfBirth = reader["DateOfBirth"] as DateTime?, // Nullable DateTime
                                IsEmailConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]),
                                RegistrationDate = Convert.ToDateTime(reader["RegistrationDate"]),
                                LastLoginDate = reader["LastLoginDate"] as DateTime?, // Nullable DateTime
                                ThemeColor = "", // Not in DB schema, set default
                                EmailConfirmationToken = reader["EmailConfirmationToken"] as string,
                                EmailConfirmationTokenExpiry = reader["TokenExpiry"] as DateTime?, // DB column is TokenExpiry
                                LastEmailConfirmationRequest = reader["ModifiedDate"] as DateTime? // Use ModifiedDate as fallback
                            };

                            // Populate the UserType object with role details
                            user.UserType = new Role
                            {
                                RoleID = user.UserTypeID,
                                RoleName = reader["RoleName"].ToString()
                            };

                            users.Add(user);
                        }
                    }
                }
            }
            return users;
        }
        // ... existing methods ...

        public bool DeleteUser(int userId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    // This query assumes no foreign key constraints preventing direct deletion,
                    // or that cascading deletes are set up in your DB.
                    // If you have related data (e.g., user profiles, orders), you'd need to
                    // delete those first or handle them appropriately.
                    string query = "DELETE FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0; // Returns true if at least one row was deleted
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting user {userId}: {ex.Message}");
                // Log the exception appropriately
                return false;
            }
        }
        // ... existing methods ...


        // ... existing methods ...

        public void StorePasswordResetToken(int userId, string token, DateTime expiry)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = @"
            UPDATE Users
            SET PasswordResetToken = @Token,
                PasswordResetTokenExpiry = @Expiry
            WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Token", token);
                    cmd.Parameters.AddWithValue("@Expiry", expiry);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }


        // ... existing methods ...

        public User GetUserByPasswordResetToken(string token)
        {
            User user = null;
            using (SqlConnection con = GetConnection())
            {
                // Fetch user and check token/expiry
                string query = "SELECT * FROM Users WHERE PasswordResetToken = @Token";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Token", token);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                FirstName = reader["FirstName"].ToString(),
                                Email = reader["Email"].ToString(),
                                // Ensure PasswordResetToken and Expiry are read, even if null
                                PasswordResetToken = reader["PasswordResetToken"] as string,
                                PasswordResetTokenExpiry = reader["PasswordResetTokenExpiry"] as DateTime?
                            };
                            // Note: Only essential fields for reset logic are populated here.
                            // If you need full user object, copy from GetUserByID.
                        }
                    }
                }
            }
            return user;
        }

        public bool UpdatePassword(int userId, string newPasswordHash, string newSalt)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                UPDATE Users
                SET
                    PasswordHash = @PasswordHash,
                    Salt = @Salt,
                    PasswordResetToken = NULL,          -- Clear token after successful reset
                    PasswordResetTokenExpiry = NULL     -- Clear expiry
                WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@PasswordHash", newPasswordHash);
                        cmd.Parameters.AddWithValue("@Salt", newSalt);
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating password for user {userId}: {ex.Message}");
                // Log the exception
                return false;
            }
        }
        // NEW: Get user by ID (needed for EditUser.aspx.cs)
        // --- THE PROBLEM AREA: GetUserByID Method ---

        // Existing: Method to update general user profile information
        public bool UpdateUserProfileDetails(User user)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        UPDATE Users SET
                            FirstName = @FirstName,
                            MiddleName = @MiddleName,
                            LastName = @LastName,
                            PhoneNumber = @PhoneNumber,
                            CountryCode = @CountryCode,
                            ProfilePicture = @ProfilePicture,
                            Gender = @Gender,
                            DateOfBirth = @DateOfBirth
                        WHERE UserID = @UserID"; // Still uses UserID in WHERE for update

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", user.UserID); // Use the UserID from the fetched User object
                        cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                        cmd.Parameters.AddWithValue("@MiddleName", (object)user.MiddleName ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@LastName", user.LastName);
                        cmd.Parameters.AddWithValue("@PhoneNumber", (object)user.PhoneNo ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@CountryCode", (object)user.Country ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)user.ProfilePictureURL ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Gender", (object)user.Gender ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DateOfBirth", (object)user.DateOfBirth ?? DBNull.Value);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating user profile details for {user.UserID}: {ex.Message}");
                return false;
            }
        }

        // Existing: Method to update admin-managed user details
        public bool UpdateUserAdminDetails(User user)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        UPDATE Users
                        SET
                            FirstName = @FirstName,
                            MiddleName = @MiddleName,
                            LastName = @LastName,
                            PhoneNo = @PhoneNo,
                            Country = @Country,
                            UserTypeID = @UserTypeID,
                            IsEmailConfirmed = @IsEmailConfirmed
                        WHERE UserID = @UserID"; // Still uses UserID in WHERE for update

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", user.UserID); // Use the UserID from the fetched User object
                        cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                        cmd.Parameters.AddWithValue("@MiddleName", (object)user.MiddleName ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@LastName", user.LastName);
                        cmd.Parameters.AddWithValue("@PhoneNo", (object)user.PhoneNo ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Country", (object)user.Country ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@UserTypeID", user.UserTypeID);
                        cmd.Parameters.AddWithValue("@IsEmailConfirmed", user.IsEmailConfirmed);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating user admin details for {user.UserID}: {ex.Message}");
                return false;
            }
        }

        // Existing: Method to update user's password specifically
        public bool UpdateUserPassword(int userId, string newPasswordHash, string newSalt)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        UPDATE Users SET
                            PasswordHash = @PasswordHash,
                            Salt = @Salt
                        WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@PasswordHash", newPasswordHash);
                        cmd.Parameters.AddWithValue("@Salt", newSalt);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating password for user {userId}: {ex.Message}");
                return false;
            }
        }

        // Existing: Method to update user's profile picture URL specifically
        public bool UpdateUserProfilePicture(int userId, string profilePictureUrl)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"
                        UPDATE Users SET
                            ProfilePicture = @ProfilePicture
                        WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@ProfilePicture", (object)profilePictureUrl ?? DBNull.Value);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating profile picture for user {userId}: {ex.Message}");
                return false;
            }
        }

        public bool RegisterUser(User user)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"INSERT INTO Users (FirstName, MiddleName, LastName, Email, PasswordHash, Salt, PhoneNo, Country, UserTypeID, ProfilePictureURL, Gender, DateOfBirth, IsEmailConfirmed, EmailConfirmationToken, TokenExpiry, RegistrationDate, LastLoginDate, ThemeColor)
                                     VALUES (@FirstName, @MiddleName, @LastName, @Email, @PasswordHash, @Salt, @PhoneNo, @Country, @UserTypeID, @ProfilePictureURL, @Gender, @DateOfBirth, @IsEmailConfirmed, @EmailConfirmationToken, @TokenExpiry, @RegistrationDate, @LastLoginDate, @ThemeColor)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                        cmd.Parameters.AddWithValue("@MiddleName", (object)user.MiddleName ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@LastName", user.LastName);
                        cmd.Parameters.AddWithValue("@Email", user.Email);
                        cmd.Parameters.AddWithValue("@PasswordHash", user.PasswordHash);
                        cmd.Parameters.AddWithValue("@Salt", user.Salt);
                        cmd.Parameters.AddWithValue("@PhoneNo", (object)user.PhoneNo ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Country", (object)user.Country ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@UserTypeID", user.UserTypeID);
                        cmd.Parameters.AddWithValue("@ProfilePictureURL", (object)user.ProfilePictureURL ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Gender", (object)user.Gender ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DateOfBirth", (object)user.DateOfBirth ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@IsEmailConfirmed", user.IsEmailConfirmed);
                        cmd.Parameters.AddWithValue("@EmailConfirmationToken", (object)user.EmailConfirmationToken ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@TokenExpiry", (object)user.EmailConfirmationTokenExpiry ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@RegistrationDate", user.RegistrationDate);
                        cmd.Parameters.AddWithValue("@LastLoginDate", (object)user.LastLoginDate ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@ThemeColor", (object)user.ThemeColor ?? DBNull.Value);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log SQL specific errors (e.g., unique constraint violation for email)
                System.Diagnostics.Debug.WriteLine($"SQL Error during user registration: {ex.Message}");
                if (ex.Number == 2627 || ex.Number == 2601) // Unique constraint violation error numbers
                {
                    // Handle duplicate email specifically if needed in UI
                    throw new Exception("This email is already registered.", ex);
                }
                return false;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error during user registration: {ex.Message}");
                return false;
            }
        }

        public List<User> GetUsersByUserType(int userTypeId)
        {
            List<User> users = new List<User>();
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT UserID, FirstName, MiddleName, LastName, Email, PhoneNo, Country, UserTypeID, IsEmailConfirmed, RegistrationDate
                                 FROM Users
                                 WHERE UserTypeID = @UserTypeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserTypeID", userTypeId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            users.Add(new User
                            {
                                // CORRECTED LINES (Lines 651, 654, 655 should be here or similar patterns)
                                UserID = Convert.ToInt32(reader["UserID"]), // Explicit conversion
                                FirstName = reader["FirstName"].ToString(),
                                MiddleName =  reader["MiddleName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                Email = reader["Email"].ToString(),
                                PhoneNo =  reader["PhoneNo"].ToString(),
                                Country =  reader["Country"].ToString(),
                                UserTypeID = Convert.ToInt32(reader["UserTypeID"]), // Explicit conversion
                                IsEmailConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]), // Explicit conversion
                                RegistrationDate = Convert.ToDateTime(reader["RegistrationDate"]) // Explicit conversion
                                // Populate other fields if needed for the specific use case
                            });
                        }
                    }
                }
            }
            return users;
        }

        public User GetUserById(int userId)
        {
            User user = null;
            using (SqlConnection con = GetConnection())
            {
                string query = @"SELECT UserID, FirstName, MiddleName, LastName, Email, PhoneNo, Country, UserTypeID, IsEmailConfirmed, RegistrationDate
                             FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                FirstName = reader["FirstName"].ToString(),
                                MiddleName = reader["MiddleName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                Email = reader["Email"].ToString(),
                                PhoneNo = reader["PhoneNo"].ToString(),
                                Country = reader["Country"].ToString(),
                                UserTypeID = Convert.ToInt32(reader["UserTypeID"]),
                                IsEmailConfirmed = Convert.ToBoolean(reader["IsEmailConfirmed"]),
                                RegistrationDate = Convert.ToDateTime(reader["RegistrationDate"]),
                                // PasswordHash and Salt are typically not retrieved for general user display
                            };
                        }
                    }
                }
            }
            return user;
        }

        // Confirm user email by updating IsEmailConfirmed to true
        public bool ConfirmUserEmail(int userId)
        {
            try
            {
                using (SqlConnection con = GetConnection())
                {
                    string query = @"UPDATE Users 
                                   SET IsEmailConfirmed = 1, 
                                       EmailConfirmationToken = NULL, 
                                       TokenExpiry = NULL 
                                   WHERE UserID = @UserID";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        
                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error (in production, use proper logging)
                System.Diagnostics.Debug.WriteLine($"Error confirming user email: {ex.Message}");
                return false;
            }
        }

    }
}

