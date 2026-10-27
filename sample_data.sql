-- ==========================================================
-- Campus Resource Management System
-- Sample Data for Demonstration and Testing
-- Database: campus_resource_management
-- ==========================================================

USE campus_resource_management;

-- 1. SEED CATEGORIES
INSERT INTO categories (name, description) VALUES
('Textbooks & Literature', 'Academic textbooks, reference manuals, and literary resources'),
('Laboratory Equipment', 'Microscopes, multimeters, oscilloscopes, and testing kits'),
('Electronics & Calculators', 'Graphing calculators, microcontrollers, Arduino, Raspberry Pi'),
('Digital Study Materials', 'Lecture slides, lecture summaries, problem sets, and digital exam prep'),
('Project Hardware', 'Sensors, robotics components, 3D printer filaments, and tools')
ON DUPLICATE KEY UPDATE description=VALUES(description);

-- 2. SEED USERS
-- Default passwords:
-- Admin: Admin@123 ($2a$10$wE96w2T7wV1tVz82k4311O68lJvhz.7V0.x/F40n2wB3wW7L9g5xK)
-- Faculty: Faculty@123 ($2a$10$5xK8w2T7wV1tVz82k4311O68lJvhz.7V0.x/F40n2wB3wW7L9g5xK)
-- Student: Student@123 ($2a$10$9zP8w2T7wV1tVz82k4311O68lJvhz.7V0.x/F40n2wB3wW7L9g5xK)
-- (Note: The application DatabaseInitializer will also ensure valid bcrypt hashes are initialized on first startup)

INSERT INTO users (user_id, name, email, password_hash, role, department, phone, active_status) VALUES
(1, 'System Administrator', 'admin@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'ADMIN', 'IT Services', '+1-555-0100', TRUE),
(2, 'Prof. Robert Smith', 'prof.smith@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'FACULTY', 'Computer Science', '+1-555-0201', TRUE),
(3, 'Dr. Sarah Johnson', 'dr.sarah@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'FACULTY', 'Physics & Electronics', '+1-555-0202', TRUE),
(4, 'John Doe', 'john.doe@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'STUDENT', 'Computer Science', '+1-555-0301', TRUE),
(5, 'Alice Wong', 'alice.wong@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'STUDENT', 'Electrical Engineering', '+1-555-0302', TRUE),
(6, 'Michael Brown', 'mike.brown@campus.edu', '$2a$10$lV4v7w1V6a8dO1q0fE3.A.B7r2L4l3k7Q2V8s0hY4R6t2wP9u0o7S', 'STUDENT', 'Mechanical Engineering', '+1-555-0303', TRUE)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 3. SEED RESOURCES
INSERT INTO resources (
    resource_id, name, category, description, resource_type, subtype, owner_id,
    availability_status, quantity, available_quantity, image_path,
    author, isbn, condition_state, asset_identifier, subject, file_location, format
) VALUES
-- Books (Physical)
(1, 'Introduction to Algorithms (CLRS)', 'Textbooks & Literature', 'Comprehensive foundational textbook on algorithms and data structures.', 'PHYSICAL', 'BOOK', 2, 'AVAILABLE', 2, 2, NULL, 'Cormen, Leiserson, Rivest, Stein', '978-0262033848', NULL, NULL, NULL, NULL, NULL),
(2, 'Clean Architecture: A Craftsman''s Guide', 'Textbooks & Literature', 'Guide to software architecture and design patterns for maintainable systems.', 'PHYSICAL', 'BOOK', 2, 'AVAILABLE', 1, 1, NULL, 'Robert C. Martin', '978-0134494166', NULL, NULL, NULL, NULL, NULL),
(3, 'Principles of Physics 11th Edition', 'Textbooks & Literature', 'Calculus-based university physics reference textbook.', 'PHYSICAL', 'BOOK', 3, 'AVAILABLE', 1, 1, NULL, 'Halliday & Resnick', '978-1119454014', NULL, NULL, NULL, NULL, NULL),

-- Equipment (Physical)
(4, 'Texas Instruments TI-84 Plus CE Calculator', 'Electronics & Calculators', 'Color screen graphing calculator suitable for advanced mathematics and engineering exams.', 'PHYSICAL', 'EQUIPMENT', 2, 'AVAILABLE', 3, 3, NULL, NULL, NULL, 'EXCELLENT', 'TI84-CS-0042', NULL, NULL, NULL),
(5, 'Rigol DS1054Z Digital Oscilloscope', 'Laboratory Equipment', '50 MHz 4-channel digital oscilloscope for electronics laboratory experiments.', 'PHYSICAL', 'EQUIPMENT', 3, 'AVAILABLE', 1, 1, NULL, NULL, NULL, 'EXCELLENT', 'OSC-PHY-2024-01', NULL, NULL, NULL),
(6, 'Arduino Mega 2560 Prototyping Kit', 'Project Hardware', 'Microcontroller development board with sensor bundle and breadboard.', 'PHYSICAL', 'EQUIPMENT', 2, 'AVAILABLE', 4, 4, NULL, NULL, NULL, 'GOOD', 'ARD-KIT-109', NULL, NULL, NULL),

-- Digital Study Materials
(7, 'Distributed Systems Lecture Notes & Cheatsheet', 'Digital Study Materials', 'Curated course lecture notes with consensus algorithm diagrams and proofs.', 'DIGITAL', 'STUDY_MATERIAL', 2, 'AVAILABLE', 999, 999, NULL, NULL, NULL, NULL, NULL, 'CS401: Distributed Computing', 'materials/cs401_notes.pdf', 'PDF'),
(8, 'Quantum Mechanics Exam Preparation Bank', 'Digital Study Materials', 'Past 5 years solved problem sets and exam walkthroughs.', 'DIGITAL', 'STUDY_MATERIAL', 3, 'AVAILABLE', 999, 999, NULL, NULL, NULL, NULL, NULL, 'PHY302: Quantum Mechanics', 'materials/phy302_problems.pdf', 'PDF')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 4. SEED SAMPLE REQUESTS & LOANS
-- Request 1: Approved and converted to Active Loan
INSERT INTO borrow_requests (request_id, borrower_id, resource_id, request_date, requested_return_date, status, notes, reviewer_id, review_date, review_notes)
VALUES (1, 4, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(CURRENT_DATE(), INTERVAL 9 DAY), 'APPROVED', 'Needed for CS Algorithms project', 2, DATE_SUB(NOW(), INTERVAL 4 DAY), 'Approved. Please handle with care.');

INSERT INTO loans (loan_id, request_id, resource_id, borrower_id, checkout_date, due_date, return_date, loan_status, return_confirmed_by, return_notes)
VALUES (1, 1, 1, 4, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(CURRENT_DATE(), INTERVAL 9 DAY), NULL, 'ACTIVE', NULL, NULL);

-- Update available quantity for resource 1
UPDATE resources SET available_quantity = 1 WHERE resource_id = 1;

-- Request 2: Completed Request and Returned Loan
INSERT INTO borrow_requests (request_id, borrower_id, resource_id, request_date, requested_return_date, status, notes, reviewer_id, review_date, review_notes)
VALUES (2, 5, 4, DATE_SUB(NOW(), INTERVAL 14 DAY), DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY), 'COMPLETED', 'Needed for semester midterm test', 2, DATE_SUB(NOW(), INTERVAL 13 DAY), 'Approved.');

INSERT INTO loans (loan_id, request_id, resource_id, borrower_id, checkout_date, due_date, return_date, loan_status, return_confirmed_by, return_notes)
VALUES (2, 2, 4, 5, DATE_SUB(NOW(), INTERVAL 13 DAY), DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 'RETURNED', 2, 'Returned in perfect condition.');

-- Request 3: Pending Request for Dr. Sarah's Oscilloscope
INSERT INTO borrow_requests (request_id, borrower_id, resource_id, request_date, requested_return_date, status, notes, reviewer_id, review_date, review_notes)
VALUES (3, 6, 5, NOW(), DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'PENDING', 'Requesting for senior year capstone circuit measurements.', NULL, NULL, NULL);

-- 5. AUDIT LOGS
INSERT INTO audit_logs (user_id, action, details) VALUES
(1, 'SYSTEM_INIT', 'Initial system seeding completed.'),
(4, 'BORROW_REQUEST', 'Submitted request #1 for Introduction to Algorithms'),
(2, 'REQUEST_APPROVE', 'Approved request #1 and initiated active loan #1'),
(5, 'BORROW_REQUEST', 'Submitted request #2 for TI-84 Plus CE Calculator'),
(2, 'RETURN_CONFIRM', 'Confirmed return for loan #2. Item checked and verified.');
