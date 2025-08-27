// App_Code/BLL/RoleManager.cs
using System.Collections.Generic;
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL
{
    public class RoleManager
    {
        private RoleDAL _roleDAL; // Assuming you have a RoleDAL

        public RoleManager()
        {
            _roleDAL = new RoleDAL(); // Initialize RoleDAL
        }

        public List<Role> GetAllRoles()
        {
            return _roleDAL.GetAllRoles();
        }

        public int? GetRoleIdByName(string roleName)
        {
            return _roleDAL.GetRoleIdByName(roleName); // Assuming RoleDAL has this method
        }

        public Role GetRoleById(int roleId)
        {
            return _roleDAL.GetRoleById(roleId);
        }
    }
}

