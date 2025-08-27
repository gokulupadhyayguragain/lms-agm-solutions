// App_Code/BLL/CourseManager.cs
using System;
using System.Collections.Generic;
using System.Linq;
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL
{
    public class CourseManager
    {
        private CourseDAL _courseDAL;
        private UserManager _userManager; // To get list of lecturers

        public CourseManager()
        {
            _courseDAL = new CourseDAL();
            _userManager = new UserManager(); // Initialize UserManager
        }

        public bool AddCourse(Course course)
        {
            return _courseDAL.AddCourse(course);
        }

        public Course GetCourseById(int courseId)
        {
            return _courseDAL.GetCourseById(courseId);
        }

        public List<Course> GetAllCourses()
        {
            return _courseDAL.GetAllCourses();
        }

        public bool UpdateCourse(Course course)
        {
            return _courseDAL.UpdateCourse(course);
        }

        public bool DeleteCourse(int courseId)
        {
            return _courseDAL.DeleteCourse(courseId);
        }

        // Helper method to get all lecturers for dropdowns
        public List<User> GetAllLecturers()
        {
            return _userManager.GetUsersByType("Lecturer");
        }

        public List<Course> GetCoursesByLecturerId(int lecturerId)
        {
            return _courseDAL.GetCoursesByLecturerId(lecturerId);
        }

        // --- CORRECTED/ADDED METHOD FOR STUDENT COURSES (Calls DAL) ---
        public List<Course> GetCoursesByStudentId(int studentId)
        {
            return _courseDAL.GetCoursesByStudentId(studentId);
        }
        // ---------------------------------------------------------------
    }
}



