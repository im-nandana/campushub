-- ==========================================================
-- Campus Resource Management System
-- Database Schema for MySQL
-- Database Name: campus_resource_management
-- ==========================================================

CREATE DATABASE IF NOT EXISTS campus_resource_management;
USE campus_resource_management;

-- Drop tables in reverse order of foreign key dependencies
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS borrow_requests;
DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- 1. USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'FACULTY', 'ADMIN') NOT NULL,
    department VARCHAR(100) DEFAULT 'General',
    phone VARCHAR(25),
    active_status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email),
    INDEX idx_user_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. RESOURCES TABLE
CREATE TABLE resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    resource_type ENUM('PHYSICAL', 'DIGITAL') NOT NULL,
    subtype ENUM('BOOK', 'EQUIPMENT', 'STUDY_MATERIAL') NOT NULL,
    owner_id INT NOT NULL,
    availability_status ENUM('AVAILABLE', 'BORROWED', 'MAINTENANCE', 'RESERVED', 'INACTIVE') NOT NULL DEFAULT 'AVAILABLE',
    quantity INT NOT NULL DEFAULT 1,
    available_quantity INT NOT NULL DEFAULT 1,
    image_path VARCHAR(255),
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Subtype specific fields (Polymorphic persistence)
    author VARCHAR(100) DEFAULT NULL,
    isbn VARCHAR(30) DEFAULT NULL,
    condition_state VARCHAR(50) DEFAULT NULL,
    asset_identifier VARCHAR(100) DEFAULT NULL,
    subject VARCHAR(100) DEFAULT NULL,
    file_location VARCHAR(255) DEFAULT NULL,
    format VARCHAR(20) DEFAULT NULL,

    FOREIGN KEY (owner_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_res_name (name),
    INDEX idx_res_category (category),
    INDEX idx_res_status (availability_status),
    INDEX idx_res_owner (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. BORROW REQUESTS TABLE
CREATE TABLE borrow_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    borrower_id INT NOT NULL,
    resource_id INT NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    requested_return_date DATE NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    notes TEXT,
    reviewer_id INT DEFAULT NULL,
    review_date TIMESTAMP NULL DEFAULT NULL,
    review_notes VARCHAR(255) DEFAULT NULL,

    FOREIGN KEY (borrower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_req_borrower (borrower_id),
    INDEX idx_req_resource (resource_id),
    INDEX idx_req_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. LOANS TABLE
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    resource_id INT NOT NULL,
    borrower_id INT NOT NULL,
    checkout_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date TIMESTAMP NULL DEFAULT NULL,
    loan_status ENUM('ACTIVE', 'RETURN_REQUESTED', 'RETURNED', 'OVERDUE') NOT NULL DEFAULT 'ACTIVE',
    return_confirmed_by INT DEFAULT NULL,
    return_notes VARCHAR(255) DEFAULT NULL,

    FOREIGN KEY (request_id) REFERENCES borrow_requests(request_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE,
    FOREIGN KEY (borrower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (return_confirmed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_loan_resource (resource_id),
    INDEX idx_loan_borrower (borrower_id),
    INDEX idx_loan_status (loan_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. AUDIT LOGS TABLE
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(50) DEFAULT '127.0.0.1',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_log_action (action),
    INDEX idx_log_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
