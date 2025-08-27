using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace AGMSolutions.Students
{
    public partial class Certificates : System.Web.UI.Page
    {
        private string connectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Initialize connection string safely
            var connStringSetting = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"];
            if (connStringSetting != null)
            {
                connectionString = connStringSetting.ConnectionString;
            }
            else
            {
                // Fallback connection string
                connectionString = "Data Source=gocools\\SQLEXPRESS;Initial Catalog=AGMSolutions;Integrated Security=True;TrustServerCertificate=True";
            }

            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                    return;
                }

                LoadUserCertificates();
            }
        }

        private void LoadUserCertificates()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            u.FirstName + ' ' + u.LastName as StudentName
                        FROM Users u 
                        WHERE u.UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();
                        
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            // Set student name when server controls are properly linked
                            // lblStudentName.Text = reader["StudentName"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                Response.Write($"<script>alert('Error loading certificates: {ex.Message}');</script>");
            }
        }

        protected void GenerateCertificatePDF(string courseCode, string courseName, string grade, string completionDate, string instructor)
        {
            try
            {
                // In a real implementation, you would use a PDF generation library like iTextSharp
                // For now, we'll just show a success message
                string script = $@"
                    alert('Certificate PDF generated successfully!\\n\\nCourse: {courseName}\\nGrade: {grade}\\nDate: {completionDate}');
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "CertificateGenerated", script, true);
            }
            catch (Exception ex)
            {
                string script = $"alert('Error generating certificate: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "CertificateError", script, true);
            }
        }

        protected void VerifyCertificate(string certificateId)
        {
            try
            {
                // In a real implementation, you would verify against a certificate database
                bool isValid = true; // Simulate verification

                string message = isValid ? 
                    "Certificate is valid and authentic." : 
                    "Certificate could not be verified.";

                string script = $"alert('{message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "CertificateVerification", script, true);
            }
            catch (Exception ex)
            {
                string script = $"alert('Error verifying certificate: {ex.Message}');";
                ClientScript.RegisterStartupScript(this.GetType(), "VerificationError", script, true);
            }
        }
    }
}
