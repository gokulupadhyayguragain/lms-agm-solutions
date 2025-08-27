// App_Code/DAL/RoleDAL.cs
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.DAL
{
    public class RoleDAL : BaseDAL
    {
        public RoleDAL()
        {
        }

        // Assuming this is in App_Code/BLL/RoleManager.cs (or RoleDAL.cs)

        public int? GetRoleIdByName(string roleName)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT RoleID FROM Roles WHERE RoleName = @RoleName";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@RoleName", roleName);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        return Convert.ToInt32(result);
                    }
                }
            }
            return null;
        }

        public List<Role> GetAllRoles()
        {
            List<Role> roles = new List<Role>();
            using (SqlConnection con = GetConnection())
            {
                // CORRECTED LINE: Change 'UserTypes' to 'Roles' and 'UserTypeID' to 'RoleID'
                string query = "SELECT RoleID, RoleName FROM Roles";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            roles.Add(new Role
                            {
                                // CORRECTED LINE: Use 'RoleID' from the database
                                RoleID = Convert.ToInt32(reader["RoleID"]),
                                RoleName = reader["RoleName"].ToString()
                            });
                        }
                    }
                }
            }
            return roles;
        }

        public Role GetRoleById(int roleId)
        {
            using (SqlConnection con = GetConnection())
            {
                string query = "SELECT UserTypeID, RoleName FROM UserTypes WHERE UserTypeID = @RoleID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@RoleID", roleId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Role
                            {
                                RoleID = Convert.ToInt32(reader["UserTypeID"]),
                                RoleName = reader["RoleName"].ToString()
                            };
                        }
                    }
                }
            }
            return null;
        }
    }
}

