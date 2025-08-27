<%@ Page Title="Advanced Search" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="AGMSolutions.Students.Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .search-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
        }
        .search-header {
            background: var(--gradient-primary);
            color: white;
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        .search-box {
            position: relative;
            max-width: 600px;
            margin: 0 auto 20px;
        }
        .search-input {
            width: 100%;
            padding: 15px 60px 15px 20px;
            font-size: 1.1rem;
            border: 3px solid white;
            border-radius: 50px;
            outline: none;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #ffd700;
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.3);
        }
        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #ffd700;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            background: #ffed4e;
            transform: translateY(-50%) scale(1.1);
        }
        .filter-panel {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        .filter-group {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid var(--primary-color);
        }
        .filter-label {
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--dark-color);
        }
        .filter-options {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .filter-checkbox {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 5px 0;
        }
        .filter-checkbox input {
            margin-right: 10px;
            transform: scale(1.2);
        }
        .quick-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
        }
        .quick-filter {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .quick-filter:hover,
        .quick-filter.active {
            background: white;
            color: var(--primary-color);
            border-color: white;
        }
        .results-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .sort-options {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .sort-select {
            padding: 8px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            outline: none;
            cursor: pointer;
        }
        .result-item {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            border-left: 5px solid transparent;
        }
        .result-item:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-left-color: var(--primary-color);
        }
        .result-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        .result-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
            color: #666;
            font-size: 0.9rem;
        }
        .result-description {
            color: var(--dark-color);
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .result-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .tag {
            background: var(--primary-color);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        .tag.course { background: #28a745; }
        .tag.assignment { background: #ffc107; color: #333; }
        .tag.quiz { background: #dc3545; }
        .tag.material { background: #17a2b8; }
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        .no-results i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ddd;
        }
        .search-suggestions {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        .suggestion-item {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            margin: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .suggestion-item:hover {
            background: white;
            color: var(--primary-color);
        }
        .advanced-search {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .search-field {
            margin-bottom: 20px;
        }
        .search-field label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-color);
        }
        .search-field input,
        .search-field select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        .search-field input:focus,
        .search-field select:focus {
            border-color: var(--primary-color);
        }
        .search-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .recent-searches {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        .recent-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
            cursor: pointer;
        }
        .recent-item:last-child {
            border-bottom: none;
        }
        .recent-item:hover {
            color: var(--primary-color);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="search-container">
        <!-- Search Header -->
        <div class="search-header">
            <h1><i class="fas fa-search"></i> Advanced Search</h1>
            <p>Find courses, assignments, materials, and more across the entire platform</p>
            
            <!-- Main Search Box -->
            <div class="search-box">
                <input type="text" class="search-input" id="mainSearchInput" placeholder="Search for anything..." onkeypress="handleSearchKeyPress(event)">
                <button class="search-btn" onclick="performSearch()">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            
            <!-- Quick Filters -->
            <div class="quick-filters">
                <div class="quick-filter active" onclick="setQuickFilter('all')">All Results</div>
                <div class="quick-filter" onclick="setQuickFilter('courses')">Courses</div>
                <div class="quick-filter" onclick="setQuickFilter('assignments')">Assignments</div>
                <div class="quick-filter" onclick="setQuickFilter('quizzes')">Quizzes</div>
                <div class="quick-filter" onclick="setQuickFilter('materials')">Materials</div>
                <div class="quick-filter" onclick="setQuickFilter('discussions')">Discussions</div>
            </div>
            
            <!-- Search Suggestions -->
            <div class="search-suggestions">
                <h6>Popular Searches:</h6>
                <span class="suggestion-item" onclick="searchFor('computer science')">Computer Science</span>
                <span class="suggestion-item" onclick="searchFor('calculus')">Calculus</span>
                <span class="suggestion-item" onclick="searchFor('data structures')">Data Structures</span>
                <span class="suggestion-item" onclick="searchFor('assignments due')">Assignments Due</span>
                <span class="suggestion-item" onclick="searchFor('upcoming quizzes')">Upcoming Quizzes</span>
            </div>
        </div>

        <!-- Advanced Search Form -->
        <div class="advanced-search" id="advancedSearch" style="display: none;">
            <h4><i class="fas fa-sliders-h"></i> Advanced Search Options</h4>
            <div class="row">
                <div class="col-md-6">
                    <div class="search-field">
                        <label>Keywords</label>
                        <input type="text" id="advKeywords" placeholder="Enter keywords...">
                    </div>
                    <div class="search-field">
                        <label>Course</label>
                        <select id="advCourse">
                            <option value="">All Courses</option>
                            <option value="cs101">Computer Science 101</option>
                            <option value="math201">Mathematics 201</option>
                            <option value="eng101">English 101</option>
                            <option value="phys101">Physics 101</option>
                        </select>
                    </div>
                    <div class="search-field">
                        <label>Content Type</label>
                        <select id="advType">
                            <option value="">All Types</option>
                            <option value="course">Courses</option>
                            <option value="assignment">Assignments</option>
                            <option value="quiz">Quizzes</option>
                            <option value="material">Study Materials</option>
                            <option value="discussion">Discussions</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="search-field">
                        <label>Date Range</label>
                        <select id="advDate">
                            <option value="">Any Time</option>
                            <option value="today">Today</option>
                            <option value="week">This Week</option>
                            <option value="month">This Month</option>
                            <option value="semester">This Semester</option>
                        </select>
                    </div>
                    <div class="search-field">
                        <label>Difficulty Level</label>
                        <select id="advDifficulty">
                            <option value="">Any Level</option>
                            <option value="beginner">Beginner</option>
                            <option value="intermediate">Intermediate</option>
                            <option value="advanced">Advanced</option>
                        </select>
                    </div>
                    <div class="search-field">
                        <label>Status</label>
                        <select id="advStatus">
                            <option value="">Any Status</option>
                            <option value="available">Available</option>
                            <option value="due-soon">Due Soon</option>
                            <option value="completed">Completed</option>
                            <option value="in-progress">In Progress</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="search-actions">
                <button class="btn btn-primary" onclick="performAdvancedSearch()">
                    <i class="fas fa-search"></i> Advanced Search
                </button>
                <button class="btn btn-secondary" onclick="clearAdvancedSearch()">
                    <i class="fas fa-times"></i> Clear Filters
                </button>
                <button class="btn btn-outline-primary" onclick="toggleAdvancedSearch()">
                    <i class="fas fa-arrow-up"></i> Hide Advanced
                </button>
            </div>
        </div>

        <!-- Filter Panel -->
        <div class="filter-panel">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5><i class="fas fa-filter"></i> Filter Results</h5>
                <button class="btn btn-outline-primary btn-sm" onclick="toggleAdvancedSearch()">
                    <i class="fas fa-cog"></i> Advanced Search
                </button>
            </div>
            
            <div class="filter-grid">
                <div class="filter-group">
                    <div class="filter-label">Subject Area</div>
                    <div class="filter-options">
                        <label class="filter-checkbox">
                            <input type="checkbox" value="computer-science" onchange="updateFilters()"> Computer Science
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="mathematics" onchange="updateFilters()"> Mathematics
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="english" onchange="updateFilters()"> English
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="physics" onchange="updateFilters()"> Physics
                        </label>
                    </div>
                </div>
                
                <div class="filter-group">
                    <div class="filter-label">Resource Type</div>
                    <div class="filter-options">
                        <label class="filter-checkbox">
                            <input type="checkbox" value="video" onchange="updateFilters()"> Video Lectures
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="pdf" onchange="updateFilters()"> PDF Documents
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="interactive" onchange="updateFilters()"> Interactive Content
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="assignment" onchange="updateFilters()"> Assignments
                        </label>
                    </div>
                </div>
                
                <div class="filter-group">
                    <div class="filter-label">Availability</div>
                    <div class="filter-options">
                        <label class="filter-checkbox">
                            <input type="checkbox" value="available" onchange="updateFilters()"> Currently Available
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="upcoming" onchange="updateFilters()"> Coming Soon
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="archived" onchange="updateFilters()"> Archived
                        </label>
                    </div>
                </div>
                
                <div class="filter-group">
                    <div class="filter-label">Duration</div>
                    <div class="filter-options">
                        <label class="filter-checkbox">
                            <input type="checkbox" value="short" onchange="updateFilters()"> Under 30 minutes
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="medium" onchange="updateFilters()"> 30-60 minutes
                        </label>
                        <label class="filter-checkbox">
                            <input type="checkbox" value="long" onchange="updateFilters()"> Over 1 hour
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Container -->
        <div class="results-container">
            <div class="results-header">
                <div>
                    <h5 id="resultsCount">Showing 12 results for "data structures"</h5>
                    <small class="text-muted">Search completed in 0.03 seconds</small>
                </div>
                <div class="sort-options">
                    <label>Sort by:</label>
                    <select class="sort-select" onchange="sortResults(this.value)">
                        <option value="relevance">Relevance</option>
                        <option value="date-new">Newest First</option>
                        <option value="date-old">Oldest First</option>
                        <option value="name-az">Name A-Z</option>
                        <option value="name-za">Name Z-A</option>
                        <option value="difficulty">Difficulty</option>
                    </select>
                </div>
            </div>
            
            <div id="searchResults">
                <!-- Sample Results -->
                <div class="result-item">
                    <div class="result-title">Introduction to Data Structures</div>
                    <div class="result-meta">
                        <span><i class="fas fa-book"></i> Computer Science 101</span>
                        <span><i class="fas fa-clock"></i> 2 hours</span>
                        <span><i class="fas fa-calendar"></i> Updated 2 days ago</span>
                        <span><i class="fas fa-users"></i> 24 students</span>
                    </div>
                    <div class="result-description">
                        Learn the fundamentals of data structures including arrays, linked lists, stacks, and queues. This comprehensive course covers both theory and practical implementation.
                    </div>
                    <div class="result-tags">
                        <span class="tag course">Course</span>
                        <span class="tag">Beginner</span>
                        <span class="tag">Programming</span>
                    </div>
                </div>
                
                <div class="result-item">
                    <div class="result-title">Data Structures Assignment - Binary Trees</div>
                    <div class="result-meta">
                        <span><i class="fas fa-tasks"></i> Assignment</span>
                        <span><i class="fas fa-calendar-alt"></i> Due in 3 days</span>
                        <span><i class="fas fa-star"></i> 10 points</span>
                    </div>
                    <div class="result-description">
                        Implement a binary search tree with insertion, deletion, and traversal operations. Submit your code with proper documentation and test cases.
                    </div>
                    <div class="result-tags">
                        <span class="tag assignment">Assignment</span>
                        <span class="tag">Intermediate</span>
                        <span class="tag">Due Soon</span>
                    </div>
                </div>
                
                <div class="result-item">
                    <div class="result-title">Quiz: Array Algorithms</div>
                    <div class="result-meta">
                        <span><i class="fas fa-question-circle"></i> Quiz</span>
                        <span><i class="fas fa-clock"></i> 30 minutes</span>
                        <span><i class="fas fa-chart-bar"></i> 15 questions</span>
                    </div>
                    <div class="result-description">
                        Test your knowledge of array algorithms including sorting, searching, and manipulation techniques. Covers bubble sort, binary search, and more.
                    </div>
                    <div class="result-tags">
                        <span class="tag quiz">Quiz</span>
                        <span class="tag">Beginner</span>
                        <span class="tag">Available</span>
                    </div>
                </div>
                
                <div class="result-item">
                    <div class="result-title">Algorithm Complexity Analysis - Study Guide</div>
                    <div class="result-meta">
                        <span><i class="fas fa-file-pdf"></i> Study Material</span>
                        <span><i class="fas fa-download"></i> 1,234 downloads</span>
                        <span><i class="fas fa-star"></i> 4.8/5 rating</span>
                    </div>
                    <div class="result-description">
                        Comprehensive study guide covering Big O notation, time and space complexity analysis, and algorithmic efficiency principles.
                    </div>
                    <div class="result-tags">
                        <span class="tag material">Study Material</span>
                        <span class="tag">Advanced</span>
                        <span class="tag">Theory</span>
                    </div>
                </div>
            </div>
            
            <!-- Pagination -->
            <div class="text-center mt-4">
                <nav>
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <span class="page-link">Previous</span>
                        </li>
                        <li class="page-item active">
                            <span class="page-link">1</span>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#" onclick="loadPage(2)">2</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#" onclick="loadPage(3)">3</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#" onclick="loadPage(2)">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- Recent Searches -->
        <div class="recent-searches">
            <h6><i class="fas fa-history"></i> Recent Searches</h6>
            <div class="recent-item" onclick="searchFor('algorithms')">
                <span>algorithms</span>
                <small class="text-muted">2 hours ago</small>
            </div>
            <div class="recent-item" onclick="searchFor('calculus derivatives')">
                <span>calculus derivatives</span>
                <small class="text-muted">1 day ago</small>
            </div>
            <div class="recent-item" onclick="searchFor('assignment help')">
                <span>assignment help</span>
                <small class="text-muted">3 days ago</small>
            </div>
        </div>
    </div>

    <script>
        let currentFilters = {
            type: 'all',
            subjects: [],
            resources: [],
            availability: [],
            duration: []
        };

        function handleSearchKeyPress(event) {
            if (event.key === 'Enter') {
                performSearch();
            }
        }

        function performSearch() {
            const query = document.getElementById('mainSearchInput').value.trim();
            if (query) {
                searchFor(query);
            }
        }

        function searchFor(query) {
            document.getElementById('mainSearchInput').value = query;
            
            // Simulate search
            document.getElementById('resultsCount').textContent = `Showing 12 results for "${query}"`;
            
            // Add to recent searches
            addToRecentSearches(query);
            
            // Scroll to results
            document.querySelector('.results-container').scrollIntoView({ behavior: 'smooth' });
        }

        function setQuickFilter(type) {
            // Update active state
            document.querySelectorAll('.quick-filter').forEach(f => f.classList.remove('active'));
            event.target.classList.add('active');
            
            currentFilters.type = type;
            updateResults();
        }

        function updateFilters() {
            // Collect all checked filters
            const checkboxes = document.querySelectorAll('.filter-checkbox input:checked');
            
            currentFilters.subjects = [];
            currentFilters.resources = [];
            currentFilters.availability = [];
            currentFilters.duration = [];
            
            checkboxes.forEach(cb => {
                const value = cb.value;
                const group = cb.closest('.filter-group');
                const label = group.querySelector('.filter-label').textContent;
                
                switch(label) {
                    case 'Subject Area':
                        currentFilters.subjects.push(value);
                        break;
                    case 'Resource Type':
                        currentFilters.resources.push(value);
                        break;
                    case 'Availability':
                        currentFilters.availability.push(value);
                        break;
                    case 'Duration':
                        currentFilters.duration.push(value);
                        break;
                }
            });
            
            updateResults();
        }

        function updateResults() {
            // Simulate filtered results
            const totalResults = Math.floor(Math.random() * 50) + 5;
            document.getElementById('resultsCount').textContent = 
                `Showing ${totalResults} results with applied filters`;
        }

        function sortResults(sortBy) {
            // Simulate sorting
            alert(`Results sorted by: ${sortBy}`);
        }

        function loadPage(page) {
            // Simulate pagination
            alert(`Loading page ${page}...`);
        }

        function toggleAdvancedSearch() {
            const advancedPanel = document.getElementById('advancedSearch');
            if (advancedPanel.style.display === 'none') {
                advancedPanel.style.display = 'block';
                advancedPanel.scrollIntoView({ behavior: 'smooth' });
            } else {
                advancedPanel.style.display = 'none';
            }
        }

        function performAdvancedSearch() {
            const keywords = document.getElementById('advKeywords').value;
            const course = document.getElementById('advCourse').value;
            const type = document.getElementById('advType').value;
            const date = document.getElementById('advDate').value;
            const difficulty = document.getElementById('advDifficulty').value;
            const status = document.getElementById('advStatus').value;
            
            // Simulate advanced search
            let query = `Advanced search: ${keywords || 'all content'}`;
            if (course) query += ` in ${course}`;
            if (type) query += ` (${type})`;
            
            document.getElementById('resultsCount').textContent = `Advanced search results: ${query}`;
            document.querySelector('.results-container').scrollIntoView({ behavior: 'smooth' });
        }

        function clearAdvancedSearch() {
            document.getElementById('advKeywords').value = '';
            document.getElementById('advCourse').value = '';
            document.getElementById('advType').value = '';
            document.getElementById('advDate').value = '';
            document.getElementById('advDifficulty').value = '';
            document.getElementById('advStatus').value = '';
        }

        function addToRecentSearches(query) {
            // In a real implementation, this would save to localStorage or database
            console.log(`Added to recent searches: ${query}`);
        }

        // Auto-suggest functionality
        document.getElementById('mainSearchInput').addEventListener('input', function() {
            const value = this.value.toLowerCase();
            if (value.length > 2) {
                // In a real implementation, this would show autocomplete suggestions
                console.log(`Searching for suggestions: ${value}`);
            }
        });
    </script>
</asp:Content>
