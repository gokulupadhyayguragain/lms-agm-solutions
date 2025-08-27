using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.BLL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.Lecturers
{
    public partial class ManageQuizzes : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["UserID"] == null || Session["UserType"].ToString() != "Lecturer")
            {
                Response.Redirect("~/Common/Login.aspx");
                return;
            }
            
            LoadCourses();
            LoadQuizzes();
        }
    }

    private void LoadCourses()
    {
        try
        {
            int lecturerID = Convert.ToInt32(Session["UserID"]);
            AGMSolutions.App_Code.BLL.CourseManager courseManager = new AGMSolutions.App_Code.BLL.CourseManager();
            List<Course> courses = courseManager.GetCoursesByLecturerId(lecturerID);
            
            ddlCourse.DataSource = courses;
            ddlCourse.DataTextField = "CourseName";
            ddlCourse.DataValueField = "CourseID";
            ddlCourse.DataBind();
            
            ddlCourse.Items.Insert(0, new ListItem("Select Course", ""));
        }
        catch (Exception ex)
        {
            ShowError("Error loading courses: " + ex.Message);
        }
    }

    private void LoadQuizzes()
    {
        try
        {
            int lecturerID = Convert.ToInt32(Session["UserID"]);
            AGMSolutions.App_Code.BLL.QuizManager quizManager = new AGMSolutions.App_Code.BLL.QuizManager();
            DataTable quizzes = quizManager.GetQuizzesByLecturer(lecturerID);
            
            gvQuizzes.DataSource = quizzes;
            gvQuizzes.DataBind();
        }
        catch (Exception ex)
        {
            ShowError("Error loading quizzes: " + ex.Message);
        }
    }

    protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Auto-generate quiz title based on course selection
        if (!string.IsNullOrEmpty(ddlCourse.SelectedValue))
        {
            string courseCode = ddlCourse.SelectedItem.Text.Split('-')[0].Trim();
            txtQuizTitle.Text = courseCode + "-QUIZ-" + DateTime.Now.ToString("MMdd");
        }
    }

    protected void btnUploadQuiz_Click(object sender, EventArgs e)
    {
        try
        {
            // Validation
            if (string.IsNullOrEmpty(ddlCourse.SelectedValue))
            {
                ShowError("Please select a course.");
                return;
            }

            if (string.IsNullOrEmpty(txtQuizTitle.Text.Trim()))
            {
                ShowError("Please enter a quiz title.");
                return;
            }

            if (!fuQuizFile.HasFile)
            {
                ShowError("Please select a JSON file to upload.");
                return;
            }

            if (Path.GetExtension(fuQuizFile.FileName).ToLower() != ".json")
            {
                ShowError("Please upload a valid JSON file.");
                return;
            }

            // Read and validate JSON content
            string jsonContent = "";
            using (StreamReader reader = new StreamReader(fuQuizFile.PostedFile.InputStream))
            {
                jsonContent = reader.ReadToEnd();
            }

            // Validate JSON format
            QuizData quizData = JsonConvert.DeserializeObject<QuizData>(jsonContent);
            if (quizData == null || quizData.questions == null || quizData.questions.Count == 0)
            {
                ShowError("Invalid JSON format. Please check the quiz structure.");
                return;
            }

            // Create quiz directory if it doesn't exist
            string quizDirectory = Server.MapPath("~/Uploads/Quizzes/");
            if (!Directory.Exists(quizDirectory))
            {
                Directory.CreateDirectory(quizDirectory);
            }

            // Generate unique filename
            string fileName = Path.GetFileNameWithoutExtension(fuQuizFile.FileName) + "_" + 
                            DateTime.Now.ToString("yyyyMMddHHmmss") + ".json";
            string filePath = Path.Combine(quizDirectory, fileName);

            // Save file
            fuQuizFile.SaveAs(filePath);

            // Save quiz to database
            QuizManager quizManager = new QuizManager();
            int quizID = quizManager.CreateQuiz(
                courseID: Convert.ToInt32(ddlCourse.SelectedValue),
                lecturerID: Convert.ToInt32(Session["UserID"]),
                quizTitle: txtQuizTitle.Text.Trim(),
                fileName: fileName,
                jsonContent: jsonContent,
                totalQuestions: quizData.questions.Count,
                timeLimit: Convert.ToInt32(txtTimeLimit.Text),
                passingScore: Convert.ToInt32(txtPassingScore.Text),
                enableProctoring: chkEnableProctoring.Checked
            );

            if (quizID > 0)
            {
                ShowSuccess("Quiz uploaded successfully! Quiz ID: " + quizID);
                ClearForm();
                LoadQuizzes();
            }
            else
            {
                ShowError("Failed to save quiz to database.");
            }
        }
        catch (JsonException)
        {
            ShowError("Invalid JSON format. Please check your file structure.");
        }
        catch (Exception ex)
        {
            ShowError("Error uploading quiz: " + ex.Message);
        }
    }

    protected void gvQuizzes_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int quizID = Convert.ToInt32(e.CommandArgument);
        
        switch (e.CommandName)
        {
            case "EditQuiz":
                Response.Redirect("EditQuiz.aspx?id=" + quizID);
                break;
                
            case "ViewResults":
                Response.Redirect("QuizResults.aspx?id=" + quizID);
                break;
                
            case "DeleteQuiz":
                DeleteQuiz(quizID);
                break;
        }
    }

    private void DeleteQuiz(int quizID)
    {
        try
        {
            QuizManager quizManager = new QuizManager();
            bool success = quizManager.DeleteQuiz(quizID);
            
            if (success)
            {
                ShowSuccess("Quiz deleted successfully.");
                LoadQuizzes();
            }
            else
            {
                ShowError("Failed to delete quiz.");
            }
        }
        catch (Exception ex)
        {
            ShowError("Error deleting quiz: " + ex.Message);
        }
    }

    private void ClearForm()
    {
        ddlCourse.SelectedIndex = 0;
        txtQuizTitle.Text = "";
        txtTimeLimit.Text = "30";
        txtPassingScore.Text = "70";
        chkEnableProctoring.Checked = false;
    }

    private void ShowSuccess(string message)
    {
        lblSuccess.Text = message;
        pnlSuccess.Visible = true;
        pnlError.Visible = false;
    }

    private void ShowError(string message)
    {
        lblError.Text = message;
        pnlError.Visible = true;
        pnlSuccess.Visible = false;
    }
}

// JSON Data Classes
public class QuizData
{
    public string quizTitle { get; set; }
    public int totalQuestions { get; set; }
    public int timeLimit { get; set; }
    public List<QuestionData> questions { get; set; }
}

public class QuestionData
{
    public int id { get; set; }
    public string type { get; set; }
    public string question { get; set; }
    public List<string> options { get; set; }
    public object correct { get; set; }
    public List<string> items { get; set; }
    public List<string> targets { get; set; }
}
