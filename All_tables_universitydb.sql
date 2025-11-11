
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

--  QUERIES

SELECT * FROM Colleges;
SELECT * FROM Departments;
SELECT * FROM Professors;
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;

SELECT COUNT(*) AS total_students FROM Students;

SELECT AVG(gpa) AS average_gpa FROM Students;

SELECT sum(credits) AS total_credits FROM Courses;

SELECT min(founding_year) AS oldest_college FROM Colleges;

SELECT max(credits) AS max_credits FROM Courses;

SELECT college_id, college_name FROM Colleges WHERE founding_year > 1900;

SELECT * FROM Students WHERE gpa BETWEEN 3.5 AND 4.0;

SELECT * FROM Professors WHERE last_name LIKE 'S%';

SELECT * FROM Courses WHERE credits >= 3 AND is_graduate_level = TRUE;

SELECT * FROM Departments WHERE dept_id IN (SELECT dept_id FROM Professors WHERE first_name = 'John');


SELECT p.first_name, p.last_name, d.dept_name
FROM Professors p
FULL JOIN Departments d 
ON p.dept_id = d.dept_id;

DELETE FROM Enrollments WHERE drop_date IS NOT NULL AND drop_date < CURRENT_DATE;



SELECT dept_name, COUNT(prof_id) AS num_professors
FROM Departments d
JOIN Professors p 
ON d.dept_id = p.dept_id
GROUP BY dept_name;

SELECT c.course_code, COUNT(e.enrollment_id) AS num_enrollments
FROM Courses c
LEFT JOIN Enrollments e 
ON c.course_id = e.course_id
GROUP BY c.course_code;

SELECT s.student_email, e.course_id, e.enroll_date
FROM Students s
RIGHT JOIN Enrollments e 
ON s.student_id = e.student_id;

SELECT DISTINCT enrollment_year, COUNT(student_id) AS num_students
FROM Students
GROUP BY enrollment_year;

SELECT DISTINCT enrollment_year, COUNT(student_id) AS num_students
FROM Students
GROUP BY enrollment_year
ORDER BY enrollment_year DESC;

SELECT p.first_name, p.last_name, c.course_code
FROM professors p
JOIN courses c 
ON p.dept_id = c.dept_id;

SELECT c.college_name, d.dept_name
FROM Colleges c
JOIN Departments d ON c.college_id = d.college_id;


SELECT d.dept_name, p.first_name, p.last_name
FROM Departments d
LEFT JOIN Professors p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, p.last_name;

SELECT co.course_code, co.credits, d.dept_name
FROM Courses co
JOIN Departments d ON co.dept_id = d.dept_id
WHERE co.is_graduate_level = TRUE;

SELECT s.student_email, s.gpa, d.dept_name AS major_department
FROM Students s
JOIN Departments d ON s.major_dept_id = d.dept_id
WHERE s.gpa > 3.8;

SELECT c.college_name, COUNT(d.dept_id) AS number_of_departments
FROM Colleges c
LEFT JOIN Departments d ON c.college_id = d.college_id
GROUP BY c.college_name
ORDER BY number_of_departments DESC
LIMIT 1
OFFSET 1;


SELECT co.course_code, co.credits
FROM Courses co
WHERE co.credits = 3 AND co.is_graduate_level = FALSE;

SELECT s.student_id, s.student_email, COUNT(e.enrollment_id) AS courses_enrolled
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_email
ORDER BY courses_enrolled ASC;

SELECT d.dept_name, AVG(s.gpa) AS average_gpa
FROM Departments d
LEFT JOIN Students s ON d.dept_id = s.major_dept_id
GROUP BY d.dept_name
HAVING AVG(s.gpa) IS NOT NULL
ORDER BY average_gpa DESC;

SELECT p.first_name, p.last_name, COUNT(c.course_id) AS courses_taught
FROM Professors p
LEFT JOIN Courses c ON p.dept_id = c.dept_id
GROUP BY p.prof_id, p.first_name, p.last_name
ORDER BY courses_taught DESC;

SELECT c.course_code, COUNT(e.enrollment_id) AS total_enrollments
FROM Courses c 
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_code
ORDER BY total_enrollments DESC;

SELECT s.student_email, s.gpa
FROM Students s
WHERE s.gpa = (SELECT MAX(gpa) FROM Students);

UPDATE Students
SET gpa = 4.0
WHERE student_id = 101;

SELECT * FROM Students;

SELECT c.college_name, d.dept_name
FROM colleges c
JOIN departments d ON c.college_id = d.college_id
UNION
SELECT d.dept_name, c.college_name
FROM departments d
JOIN colleges c ON d.college_id = c.college_id;

SELECT p.first_name, p.last_name, d.dept_name
FROM Professors p
JOIN Departments d ON p.dept_id = d.dept_id
INTERSECT
SELECT p.first_name, p.last_name, d.dept_name
FROM Professors p
JOIN Departments d ON p.dept_id = d.dept_id;

SELECT p.first_name, p.last_name, d.dept_name
FROM Professors p
JOIN Departments d ON p.dept_id = d.dept_id
INTERSECT
SELECT p.first_name, p.last_name, d.dept_name
FROM Professors p
JOIN Departments d ON p.dept_id = d.dept_id
WHERE d.dept_name LIKE 'S%';

SELECT c.course_code, c.credits
FROM Courses c
EXCEPT
SELECT c.course_code, c.credits
FROM Courses c
WHERE c.is_graduate_level = TRUE;

SELECT c.course_code, c.credits
FROM Courses c
EXCEPT
SELECT c.course_code, c.credits
FROM Courses c
WHERE c.credits IN (2, 4);

UPDATE Students
SET enrollment_year = enrollment_year + 1
WHERE enrollment_year < EXTRACT(YEAR FROM CURRENT_DATE);

SELECT * FROM Students;

ALTER TABLE Professors
ADD COLUMN hire_date DATE NOT NULL DEFAULT CURRENT_DATE;
SELECT * FROM Professors;

ALTER TABLE Professors
DROP COLUMN hire_date;
SELECT * FROM Professors;

ALTER TABLE Students
ADD COLUMN graduation_year INT;
SELECT * FROM Students;

ALTER TABLE Students
DROP COLUMN graduation_year;
SELECT * FROM Students;

ALTER TABLE Colleges
ADD constraint chk_founding_year CHECK (founding_year >= 1800);
SELECT * FROM Colleges;

