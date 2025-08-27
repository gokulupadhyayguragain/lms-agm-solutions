# 🎓 LMS AGM Solutions - Learning Management System

A comprehensive ASP.NET web application designed to manage educational institutions' learning processes and Annual General Meeting (AGM) operations. This system provides a complete solution for administrators, lecturers, and students to manage courses, assignments, quizzes, and institutional meetings.

## 🌟 Key Features

### 👨‍💼 Admin Management
- **User Management**: Create, edit, and manage admin, lecturer, and student accounts
- **Course Management**: Add, edit, assign courses to lecturers
- **System Analytics**: Monitor system usage, performance metrics, and user activities
- **Role-based Access Control**: Secure permission management
- **System Monitoring**: Real-time system health and performance tracking

### 👨‍🏫 Lecturer Features
- **Course Management**: Manage assigned courses and course content
- **Assignment Management**: Create, edit, and grade assignments
- **Quiz Management**: Design and manage quizzes with multiple question types
- **Student Submissions**: Review and grade student work
- **Progress Tracking**: Monitor student performance and engagement
- **Communication Tools**: Send notices and announcements

### 👨‍🎓 Student Features
- **Course Enrollment**: Browse and enroll in available courses
- **Assignment Submission**: Submit assignments with file uploads
- **Quiz Taking**: Interactive quiz interface with timer functionality
- **Grade Tracking**: View grades and performance analytics
- **Certificate Generation**: Download completion certificates
- **Real-time Chat**: Communication with peers and instructors
- **Mobile App Integration**: Access learning materials on mobile devices

### 🔧 Advanced Features
- **PDF Report Generation**: Automated report creation using iTextSharp
- **Real-time Communication**: Live chat and discussion forums
- **Global Search**: Search across courses, assignments, and content
- **Notifications System**: Email and in-app notifications
- **Timetable Management**: Schedule and calendar integration
- **Live Classes**: Virtual classroom integration
- **Collaboration Tools**: Group projects and team assignments

## 🏗️ System Architecture

### Technology Stack
- **Backend**: ASP.NET Web Forms (C#)
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5.2.3
- **Database**: SQL Server with Entity Framework
- **Libraries**: jQuery 3.7.0, iTextSharp 5.5.13, Newtonsoft.Json
- **Authentication**: Custom authentication with role-based authorization

### Project Structure
```
lms-agm-solutions/
├── AGMSolutions.sln                    # Visual Studio solution file
├── AGMSolutions/                       # Main application project
│   ├── App_Code/                      # Business logic and data access
│   │   ├── BLL/                       # Business Logic Layer
│   │   │   ├── UserManager.cs         # User management operations
│   │   │   ├── CourseManager.cs       # Course management logic
│   │   │   ├── AssignmentManager.cs   # Assignment handling
│   │   │   ├── QuizManager.cs         # Quiz management
│   │   │   ├── EnrollmentManager.cs   # Student enrollment logic
│   │   │   ├── ReportingManager.cs    # Report generation
│   │   │   └── CommunicationManager.cs # Messaging and notifications
│   │   ├── DAL/                       # Data Access Layer
│   │   │   ├── BaseDAL.cs             # Base data access class
│   │   │   ├── UserDAL.cs             # User data operations
│   │   │   ├── CourseDAL.cs           # Course data operations
│   │   │   ├── AssignmentDAL.cs       # Assignment data operations
│   │   │   └── QuizDAL.cs             # Quiz data operations
│   │   ├── Models/                    # Data models
│   │   │   ├── User.cs                # User entity model
│   │   │   ├── Course.cs              # Course entity model
│   │   │   ├── Assignment.cs          # Assignment entity model
│   │   │   ├── Quiz.cs                # Quiz entity model
│   │   │   └── Enrollment.cs          # Enrollment entity model
│   │   └── Services/                  # External services
│   │       ├── EmailService.cs        # Email notifications
│   │       ├── PasswordService.cs     # Password management
│   │       └── TokenService.cs        # Authentication tokens
│   ├── Admins/                        # Admin-specific pages
│   │   ├── Dashboard.aspx             # Admin dashboard
│   │   ├── AddUser.aspx               # User creation
│   │   ├── Courses.aspx               # Course management
│   │   ├── Analytics.aspx             # System analytics
│   │   └── SystemMonitoring.aspx      # System health monitoring
│   ├── Lecturers/                     # Lecturer-specific pages
│   │   ├── Dashboard.aspx             # Lecturer dashboard
│   │   ├── MyCourses.aspx             # Course management
│   │   ├── ManageAssignments.aspx     # Assignment creation/grading
│   │   ├── ManageQuizzes.aspx         # Quiz management
│   │   └── ViewSubmissions.aspx       # Student submission review
│   ├── Students/                      # Student-specific pages
│   │   ├── Dashboard.aspx             # Student dashboard
│   │   ├── Courses.aspx               # Course browsing
│   │   ├── Assignments.aspx           # Assignment viewing/submission
│   │   ├── Quizzes.aspx               # Available quizzes
│   │   ├── TakeQuiz.aspx              # Quiz taking interface
│   │   ├── Grades.aspx                # Grade viewing
│   │   ├── Chat.aspx                  # Communication interface
│   │   ├── Certificates.aspx          # Certificate downloads
│   │   └── Analytics.aspx             # Performance analytics
│   ├── Common/                        # Shared pages
│   │   ├── Login.aspx                 # Authentication
│   │   ├── Signup.aspx                # User registration
│   │   ├── ForgotPassword.aspx        # Password recovery
│   │   └── HomePage.aspx              # Landing page
│   ├── MasterPages/                   # Master page templates
│   │   ├── Site.Master                # Main site template
│   │   ├── HeaderAdmin.ascx           # Admin header
│   │   ├── HeaderLecturer.ascx        # Lecturer header
│   │   └── HeaderStudent.ascx         # Student header
│   ├── Content/                       # Static assets
│   │   ├── css/                       # Stylesheets
│   │   ├── js/                        # JavaScript files
│   │   ├── fonts/                     # Font files
│   │   └── Images/                    # Image assets
│   ├── Scripts/                       # JavaScript libraries
│   └── Uploads/                       # File upload storage
├── Database/                          # Database scripts
│   ├── 00_CreateDatabase.sql          # Database creation
│   ├── 01_Schema_And_SampleData.sql   # Schema and initial data
│   ├── 02_BasicData.sql               # Basic configuration data
│   └── 03_QuizAttempts.sql            # Quiz tracking tables
└── packages/                          # NuGet packages
```

## 🚀 Getting Started

### Prerequisites
- **Visual Studio 2019** or later with ASP.NET development workload
- **SQL Server 2016** or later (Express edition supported)
- **.NET Framework 4.7.2** or later
- **IIS Express** (included with Visual Studio)

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/gokulupadhyayguragain/lms-agm-solutions.git
   cd lms-agm-solutions
   ```

2. **Database Setup**
   ```sql
   -- Execute scripts in order:
   -- 1. Database/00_CreateDatabase.sql
   -- 2. Database/01_Schema_And_SampleData.sql
   -- 3. Database/02_BasicData.sql
   -- 4. Database/03_QuizAttempts.sql
   ```

3. **Configure Connection String**
   - Open `AGMSolutions/Web.config`
   - Update the connection string to match your SQL Server instance:
   ```xml
   <connectionStrings>
     <add name="DefaultConnection" 
          connectionString="Server=localhost;Database=AGMSolutions;Integrated Security=true;" 
          providerName="System.Data.SqlClient" />
   </connectionStrings>
   ```

4. **Build and Run**
   - Open `AGMSolutions.sln` in Visual Studio
   - Restore NuGet packages (Build → Restore NuGet Packages)
   - Build the solution (Build → Build Solution)
   - Run the application (F5 or Debug → Start Debugging)

### Default Login Credentials
- **Admin**: Username: `admin`, Password: `admin123`
- **Lecturer**: Username: `lecturer`, Password: `lec123`
- **Student**: Username: `student`, Password: `stu123`

## 📊 Database Schema

### Core Tables
- **Users**: User accounts and authentication
- **Roles**: User role definitions
- **Courses**: Course information and metadata
- **Enrollments**: Student course registrations
- **Assignments**: Assignment details and requirements
- **Submissions**: Student assignment submissions
- **Quizzes**: Quiz definitions and questions
- **QuizAttempts**: Student quiz attempts and scores
- **Notifications**: System notifications and messages

### Key Relationships
- Users → Roles (Many-to-One)
- Courses → Users (Many-to-One, Lecturer assignment)
- Enrollments → Users + Courses (Many-to-Many bridge)
- Assignments → Courses (Many-to-One)
- Submissions → Assignments + Users (Many-to-Many bridge)
- Quizzes → Courses (Many-to-One)
- QuizAttempts → Quizzes + Users (Many-to-Many bridge)

## 🔒 Security Features

- **Role-based Authorization**: Different access levels for admin, lecturer, and student
- **Input Validation**: Server-side validation for all user inputs
- **SQL Injection Prevention**: Parameterized queries throughout the application
- **XSS Protection**: Output encoding and validation
- **Session Management**: Secure session handling with timeouts
- **Password Security**: Hashed passwords with salt
- **File Upload Security**: Restricted file types and size limits

## 📱 Mobile Responsiveness

- **Bootstrap Framework**: Responsive grid system
- **Mobile-first Design**: Optimized for mobile devices
- **Touch-friendly Interface**: Large buttons and touch targets
- **Adaptive Layout**: Adjusts to different screen sizes
- **Mobile App Integration**: APIs for mobile app connectivity

## 🧪 Testing

### Unit Testing
- Business Logic Layer tests
- Data Access Layer tests
- Service layer tests

### Integration Testing
- Database integration tests
- External service integration tests
- End-to-end workflow tests

### Manual Testing
- Cross-browser compatibility
- Mobile device testing
- User acceptance testing

## 🚀 Deployment

### IIS Deployment
1. Publish the application from Visual Studio
2. Configure IIS application pool (.NET Framework 4.7.2)
3. Set up database connection on production server
4. Configure SSL certificates for HTTPS
5. Set appropriate folder permissions

### Cloud Deployment
- **Azure**: Deploy to Azure Web Apps with SQL Database
- **AWS**: Deploy to Elastic Beanstalk with RDS
- **Google Cloud**: Deploy to App Engine with Cloud SQL

## 🔧 Configuration

### Application Settings
```xml
<appSettings>
  <add key="EmailServerHost" value="smtp.gmail.com" />
  <add key="EmailServerPort" value="587" />
  <add key="MaxFileUploadSize" value="5242880" /> <!-- 5MB -->
  <add key="SessionTimeoutMinutes" value="30" />
  <add key="EnableEmailNotifications" value="true" />
</appSettings>
```

### Custom Themes
- Admin theme: `css/custom-admin-theme.css`
- Lecturer theme: `css/custom-lecturer-theme.css`
- Student theme: `css/custom-student-theme.css`

## 📈 Performance Optimization

- **Caching**: Output caching for static content
- **Database Indexing**: Optimized database queries
- **Image Optimization**: Compressed images and sprites
- **Minification**: Minified CSS and JavaScript
- **CDN Support**: Content delivery network integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Gokul Upadhyay Guragain**
- GitHub: [@gokulupadhyayguragain](https://github.com/gokulupadhyayguragain)
- Project: [LMS AGM Solutions](https://github.com/gokulupadhyayguragain/lms-agm-solutions)

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: [your-email@example.com]
- Documentation: Check the wiki section

---

*Empowering education through technology* 🎓
