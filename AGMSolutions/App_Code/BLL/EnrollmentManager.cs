// App_Code/BLL/EnrollmentManager.cs
using System;
using System.Collections.Generic;
using System.Linq; // <--- ADD THIS LINE
using AGMSolutions.App_Code.DAL;
using AGMSolutions.App_Code.Models;

namespace AGMSolutions.App_Code.BLL // <--- THIS LINE MUST BE EXACT!
{
    public class EnrollmentManager
    {
        private EnrollmentDAL _enrollmentDAL;
        private CourseManager _courseManager; // To fetch available courses
        private UserManager _userManager; // To get student user details

        public EnrollmentManager()
        {
            _enrollmentDAL = new EnrollmentDAL();
            _courseManager = new CourseManager();
            _userManager = new UserManager();
        }

        public bool EnrollStudentInCourse(int studentId, int courseId)
        {
            // Basic business logic: check if student exists, course exists
            User student = _userManager.GetUserById(studentId);
            Course course = _courseManager.GetCourseById(courseId);

            if (student == null || _userManager.GetRoleNameById(student.UserTypeID) != "Student")
            {
                throw new Exception("Invalid Student ID.");
            }
            if (course == null || !course.IsActive)
            {
                throw new Exception("Invalid or inactive Course ID.");
            }

            // Check if already enrolled
            if (_enrollmentDAL.IsStudentEnrolled(studentId, courseId))
            {
                throw new Exception("Student is already enrolled in this course.");
            }

            Enrollment newEnrollment = new Enrollment
            {
                StudentID = studentId,
                CourseID = courseId,
                EnrollmentDate = DateTime.Now,
                IsActive = true // Active enrollment by default
            };

            return _enrollmentDAL.EnrollStudentInCourse(newEnrollment);
        }

        public bool UnenrollStudentFromCourse(int enrollmentId)
        {
            return _enrollmentDAL.UnenrollStudentFromCourse(enrollmentId);
        }

        public bool UpdateEnrollmentStatus(int enrollmentId, bool isActive)
        {
            return _enrollmentDAL.UpdateEnrollmentStatus(enrollmentId, isActive);
        }

        public Enrollment GetEnrollmentById(int enrollmentId)
        {
            return _enrollmentDAL.GetEnrollmentById(enrollmentId);
        }

        public List<Enrollment> GetEnrollmentsByStudentId(int studentId)
        {
            return _enrollmentDAL.GetEnrollmentsByStudentId(studentId);
        }

        // Method to get all available courses for enrollment (not just enrolled ones)
        // This will be used by the student's "Browse Courses" page
        public List<Course> GetAvailableCoursesForEnrollment(int studentId)
        {
            List<Course> allCourses = _courseManager.GetAllCourses(); // Get all active courses
            List<Enrollment> studentEnrollments = GetEnrollmentsByStudentId(studentId);

            // Filter out courses the student is already actively enrolled in
            var enrolledCourseIds = studentEnrollments
                                    .Where(e => e.IsActive)
                                    .Select(e => e.CourseID)
                                    .ToHashSet(); // Using HashSet for efficient lookups

            return allCourses.Where(c => c.IsActive && !enrolledCourseIds.Contains(c.CourseID)).ToList();
        }

        // Method to get courses already enrolled by the student
        public List<Enrollment> GetStudentEnrolledCourses(int studentId)
        {
            return _enrollmentDAL.GetEnrollmentsByStudentId(studentId);
        }

        public bool IsStudentEnrolledInCourse(int studentId, int courseId)
        {
            return _enrollmentDAL.IsStudentEnrolled(studentId, courseId);
        }
    }
}

