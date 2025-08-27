using System.Configuration;
using System.Data.SqlClient;

namespace AGMSolutions.App_Code.DAL
{
    public abstract class BaseDAL
    {
        protected SqlConnection GetConnection()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AGMDBConnection"].ConnectionString;
            return new SqlConnection(connectionString);
        }
    }
}

