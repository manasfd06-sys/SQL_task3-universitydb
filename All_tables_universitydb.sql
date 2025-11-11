
--Colleges Table

CREATE TABLE Colleges (
    college_id INT PRIMARY KEY,
    college_name VARCHAR(100) NOT NULL UNIQUE,
    dean_id INT UNIQUE, 
    founding_year INT NOT NULL 
        CHECK (founding_year >= 1800), -- CHECK 1
    main_building VARCHAR(50) NOT NULL
);

select * from colleges;

--Departments Table

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    college_id INT NOT NULL REFERENCES Colleges(college_id),
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    office_number VARCHAR(10) NOT NULL,
    phone_extension VARCHAR(5) NOT NULL UNIQUE
        CHECK (LENGTH(phone_extension) = 5) -- CHECK 2
);

select * from Departments;

--Professors Table

CREATE TABLE Professors (
    prof_id INT PRIMARY KEY,
    dept_id INT NOT NULL REFERENCES Departments(dept_id),
    email VARCHAR(100) NOT NULL UNIQUE
        CHECK (email ~ '^[A-Za-z0-9._%+-]+@university\.edu$'), -- CHECK 3
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

select * from Professors;

--Students Table

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    major_dept_id INT NOT NULL REFERENCES Departments(dept_id),
    student_email VARCHAR(100) NOT NULL UNIQUE,
    gpa DECIMAL(3, 2) NOT NULL 
        CHECK (gpa BETWEEN 0.0 AND 4.0), -- CHECK 4
    enrollment_year INT NOT NULL
);

select * from Students;

--Courses Table

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    dept_id INT NOT NULL REFERENCES Departments(dept_id),
    course_code VARCHAR(10) NOT NULL UNIQUE,
    credits INT NOT NULL,
    is_graduate_level BOOLEAN NOT NULL 
        CHECK (is_graduate_level IN (TRUE, FALSE)), -- CHECK 5
    UNIQUE(dept_id, course_code)
);

select * from Courses;

--Enrollments Table

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL REFERENCES Students(student_id),
    course_id INT NOT NULL REFERENCES Courses(course_id),
    enroll_date DATE NOT NULL DEFAULT CURRENT_DATE,
    drop_date DATE,
    -- UNIQUE constraint
    UNIQUE(student_id, course_id),
    CHECK (drop_date IS NULL OR drop_date > enroll_date) --CHECK 6
);

select * from Enrollments;


