<%@ Page Title="Global Search" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="GlobalSearch.aspx.cs" Inherits="AGMSolutions.Students.GlobalSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .search-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .search-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
        }
        .search-box {
            background: white;
            border-radius: 50px;
            padding: 5px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            max-width: 600px;
            margin: 20px auto;
        }
        .search-input {
            border: none;
            outline: none;
            flex: 1;
            padding: 15px 25px;
            font-size: 1.1rem;
            border-radius: 50px;
        }
        .search-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 15px 25px;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            background: #0056b3;
            transform: scale(1.05);
        }
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .filter-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .filter-item {
            display: flex;
            flex-direction: column;
        }
        .filter-label {
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }
        .filter-select {
            padding: 10px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }
        .filter-select:focus {
            border-color: #007bff;
            outline: none;
        }
        .results-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .result-item {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .result-item:hover {
            border-color: #007bff;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .result-type {
            display: inline-block;
            background: #007bff;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .result-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .result-description {
            color: #666;
            margin-bottom: 10px;
        }
        .result-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            color: #888;
        }
        .search-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .quick-filters {
            display: flex;
            gap: 10px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        .quick-filter {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            color: #495057;
            padding: 8px 16px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quick-filter.active, .quick-filter:hover {
            background: #007bff;
            border-color: #007bff;
            color: white;
        }
        .no-results {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .loading {
            text-align: center;
            padding: 50px;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="search-container">
        <!-- Search Header -->
        <div class="search-header">
            <h1><i class="fas fa-search"></i> Global Search</h1>
            <p>Find courses, assignments, quizzes, documents, and more across the entire platform</p>
            
            <!-- Main Search Box -->
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" placeholder="Search for anything..." onkeypress="handleSearchKeyPress(event)">
                <button class="search-btn" onclick="performSearch()">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>
        </div>

        <!-- Quick Filters -->
        <div class="quick-filters">
            <div class="quick-filter active" data-type="all" onclick="setQuickFilter('all')">
                <i class="fas fa-globe"></i> All Results
            </div>
            <div class="quick-filter" data-type="courses" onclick="setQuickFilter('courses')">
                <i class="fas fa-book"></i> Courses
            </div>
            <div class="quick-filter" data-type="assignments" onclick="setQuickFilter('assignments')">
                <i class="fas fa-tasks"></i> Assignments
            </div>
            <div class="quick-filter" data-type="quizzes" onclick="setQuickFilter('quizzes')">
                <i class="fas fa-question-circle"></i> Quizzes
            </div>
            <div class="quick-filter" data-type="documents" onclick="setQuickFilter('documents')">
                <i class="fas fa-file-alt"></i> Documents
            </div>
            <div class="quick-filter" data-type="people" onclick="setQuickFilter('people')">
                <i class="fas fa-users"></i> People
            </div>
        </div>

        <!-- Advanced Filters -->
        <div class="filter-section">
            <h5><i class="fas fa-filter"></i> Advanced Filters</h5>
            <div class="filter-group">
                <div class="filter-item">
                    <label class="filter-label">Subject</label>
                    <select class="filter-select" id="subjectFilter" onchange="applyFilters()">
                        <option value="">All Subjects</option>
                        <option value="computer-science">Computer Science</option>
                        <option value="mathematics">Mathematics</option>
                        <option value="english">English</option>
                        <option value="physics">Physics</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="filter-label">Date Range</label>
                    <select class="filter-select" id="dateFilter" onchange="applyFilters()">
                        <option value="">Any Time</option>
                        <option value="today">Today</option>
                        <option value="week">This Week</option>
                        <option value="month">This Month</option>
                        <option value="semester">This Semester</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="filter-label">Difficulty</label>
                    <select class="filter-select" id="difficultyFilter" onchange="applyFilters()">
                        <option value="">Any Difficulty</option>
                        <option value="beginner">Beginner</option>
                        <option value="intermediate">Intermediate</option>
                        <option value="advanced">Advanced</option>
                    </select>
                </div>
                <div class="filter-item">
                    <label class="filter-label">Status</label>
                    <select class="filter-select" id="statusFilter" onchange="applyFilters()">
                        <option value="">Any Status</option>
                        <option value="available">Available</option>
                        <option value="enrolled">Enrolled</option>
                        <option value="completed">Completed</option>
                        <option value="overdue">Overdue</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Search Results -->
        <div class="results-container">
            <div class="search-stats" id="searchStats" style="display: none;">
                <span><strong id="resultCount">0</strong> results found</span>
                <span>Search time: <strong id="searchTime">0</strong> ms</span>
            </div>

            <!-- Loading State -->
            <div class="loading" id="loadingState" style="display: none;">
                <div class="spinner"></div>
                <p>Searching across all content...</p>
            </div>

            <!-- Results List -->
            <div id="searchResults">
                <!-- Default state - show popular content -->
                <h5><i class="fas fa-fire"></i> Popular Content</h5>
                
                <div class="result-item" onclick="openResult('course', 'cs101')">
                    <div class="result-type" style="background: #28a745;">Course</div>
                    <div class="result-title">Computer Science 101 - Introduction to Programming</div>
                    <div class="result-description">Learn the fundamentals of programming with hands-on exercises and real-world projects.</div>
                    <div class="result-meta">
                        <span><i class="fas fa-user"></i> Dr. John Smith</span>
                        <span><i class="fas fa-users"></i> 245 students enrolled</span>
                        <span><i class="fas fa-star"></i> 4.8/5</span>
                    </div>
                </div>

                <div class="result-item" onclick="openResult('assignment', 'binary-search')">
                    <div class="result-type" style="background: #007bff;">Assignment</div>
                    <div class="result-title">Binary Search Algorithm Implementation</div>
                    <div class="result-description">Implement and analyze the binary search algorithm with complexity analysis.</div>
                    <div class="result-meta">
                        <span><i class="fas fa-calendar"></i> Due: Tomorrow</span>
                        <span><i class="fas fa-clock"></i> 2 hours estimated</span>
                        <span><i class="fas fa-signal"></i> Intermediate</span>
                    </div>
                </div>

                <div class="result-item" onclick="openResult('quiz', 'data-structures')">
                    <div class="result-type" style="background: #ffc107;">Quiz</div>
                    <div class="result-title">Data Structures and Algorithms Quiz</div>
                    <div class="result-description">Test your knowledge of arrays, linked lists, trees, and sorting algorithms.</div>
                    <div class="result-meta">
                        <span><i class="fas fa-questions"></i> 15 questions</span>
                        <span><i class="fas fa-clock"></i> 30 minutes</span>
                        <span><i class="fas fa-trophy"></i> Best: 87%</span>
                    </div>
                </div>

                <div class="result-item" onclick="openResult('document', 'python-guide')">
                    <div class="result-type" style="background: #17a2b8;">Document</div>
                    <div class="result-title">Python Programming Guide</div>
                    <div class="result-description">Comprehensive guide covering Python syntax, data structures, and best practices.</div>
                    <div class="result-meta">
                        <span><i class="fas fa-file-pdf"></i> PDF</span>
                        <span><i class="fas fa-download"></i> 1,234 downloads</span>
                        <span><i class="fas fa-clock"></i> Updated 2 days ago</span>
                    </div>
                </div>

                <div class="result-item" onclick="openResult('person', 'sarah-johnson')">
                    <div class="result-type" style="background: #6f42c1;">Instructor</div>
                    <div class="result-title">Prof. Sarah Johnson</div>
                    <div class="result-description">Mathematics Department - Specializes in Calculus and Linear Algebra</div>
                    <div class="result-meta">
                        <span><i class="fas fa-graduation-cap"></i> PhD Mathematics</span>
                        <span><i class="fas fa-book"></i> 8 courses</span>
                        <span><i class="fas fa-star"></i> 4.9/5 rating</span>
                    </div>
                </div>
            </div>

            <!-- No Results State -->
            <div class="no-results" id="noResults" style="display: none;">
                <i class="fas fa-search" style="font-size: 3rem; color: #ccc; margin-bottom: 20px;"></i>
                <h4>No results found</h4>
                <p>Try adjusting your search terms or filters</p>
            </div>
        </div>
    </div>

    <script>
        let currentFilter = 'all';
        let searchTimeout;

        function handleSearchKeyPress(event) {
            if (event.key === 'Enter') {
                performSearch();
            } else {
                // Debounced search
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(performSearch, 500);
            }
        }

        function performSearch() {
            const query = document.getElementById('searchInput').value.trim();
            
            if (query.length === 0) {
                showDefaultContent();
                return;
            }

            // Show loading state
            showLoading();

            // Simulate search delay
            setTimeout(() => {
                const results = simulateSearch(query);
                displayResults(results, query);
            }, 800);
        }

        function simulateSearch(query) {
            // Simulate search results based on query
            const allResults = [
                {
                    type: 'course',
                    title: 'Advanced Python Programming',
                    description: 'Deep dive into Python with advanced concepts and frameworks.',
                    meta: ['Dr. Alice Brown', '156 students', '4.7/5'],
                    id: 'python-advanced'
                },
                {
                    type: 'assignment',
                    title: 'Machine Learning Project',
                    description: 'Build and train a machine learning model for data classification.',
                    meta: ['Due: Next week', '8 hours estimated', 'Advanced'],
                    id: 'ml-project'
                },
                {
                    type: 'quiz',
                    title: 'JavaScript Fundamentals',
                    description: 'Test your knowledge of JavaScript basics and ES6 features.',
                    meta: ['20 questions', '45 minutes', 'Best: 92%'],
                    id: 'js-quiz'
                },
                {
                    type: 'document',
                    title: 'Web Development Handbook',
                    description: 'Complete guide to modern web development technologies.',
                    meta: ['PDF', '2,567 downloads', 'Updated yesterday'],
                    id: 'web-handbook'
                }
            ];

            // Filter based on query and current filter
            return allResults.filter(result => {
                const matchesQuery = result.title.toLowerCase().includes(query.toLowerCase()) ||
                                   result.description.toLowerCase().includes(query.toLowerCase());
                const matchesFilter = currentFilter === 'all' || result.type === currentFilter;
                return matchesQuery && matchesFilter;
            });
        }

        function displayResults(results, query) {
            const container = document.getElementById('searchResults');
            const stats = document.getElementById('searchStats');
            const noResults = document.getElementById('noResults');
            const loading = document.getElementById('loadingState');

            // Hide loading
            loading.style.display = 'none';

            if (results.length === 0) {
                container.style.display = 'none';
                stats.style.display = 'none';
                noResults.style.display = 'block';
                return;
            }

            // Show stats
            stats.style.display = 'flex';
            document.getElementById('resultCount').textContent = results.length;
            document.getElementById('searchTime').textContent = Math.random() * 100 + 50;

            // Build results HTML
            let html = `<h5><i class="fas fa-search"></i> Search Results for "${query}"</h5>`;
            
            results.forEach(result => {
                const typeColors = {
                    course: '#28a745',
                    assignment: '#007bff',
                    quiz: '#ffc107',
                    document: '#17a2b8',
                    person: '#6f42c1'
                };

                html += `
                    <div class="result-item" onclick="openResult('${result.type}', '${result.id}')">
                        <div class="result-type" style="background: ${typeColors[result.type]};">${result.type.charAt(0).toUpperCase() + result.type.slice(1)}</div>
                        <div class="result-title">${result.title}</div>
                        <div class="result-description">${result.description}</div>
                        <div class="result-meta">
                            ${result.meta.map(item => `<span><i class="fas fa-info-circle"></i> ${item}</span>`).join('')}
                        </div>
                    </div>
                `;
            });

            container.innerHTML = html;
            container.style.display = 'block';
            noResults.style.display = 'none';
        }

        function showLoading() {
            document.getElementById('loadingState').style.display = 'block';
            document.getElementById('searchResults').style.display = 'none';
            document.getElementById('searchStats').style.display = 'none';
            document.getElementById('noResults').style.display = 'none';
        }

        function showDefaultContent() {
            document.getElementById('loadingState').style.display = 'none';
            document.getElementById('searchResults').style.display = 'block';
            document.getElementById('searchStats').style.display = 'none';
            document.getElementById('noResults').style.display = 'none';
        }

        function setQuickFilter(type) {
            currentFilter = type;
            
            // Update active state
            document.querySelectorAll('.quick-filter').forEach(filter => {
                filter.classList.remove('active');
            });
            document.querySelector(`[data-type="${type}"]`).classList.add('active');

            // Re-run search if there's a query
            const query = document.getElementById('searchInput').value.trim();
            if (query.length > 0) {
                performSearch();
            }
        }

        function applyFilters() {
            // Re-run search with current filters
            const query = document.getElementById('searchInput').value.trim();
            if (query.length > 0) {
                performSearch();
            }
        }

        function openResult(type, id) {
            // Navigate to the appropriate page based on result type
            const routes = {
                course: '../Students/Courses.aspx',
                assignment: '../Students/Assignments.aspx',
                quiz: '../Students/Quizzes.aspx',
                document: '../Students/MyCourses.aspx',
                person: '../Students/Profile.aspx'
            };

            if (routes[type]) {
                window.location.href = routes[type];
            }
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            showDefaultContent();
            
            // Focus search input
            document.getElementById('searchInput').focus();
        });
    </script>
</asp:Content>
