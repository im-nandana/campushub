# Campus Resource Management System

A full-featured academic desktop application built with **Java (OOP)**, **Java Swing**, and **MySQL JDBC**, designed to enable seamless resource sharing, borrowing, and return tracking across university students and faculty.

---

## 🌟 Core Features & Highlights

- **Four Pillars of OOP Demonstrated:**
  - **Encapsulation:** Private model attributes, validated getters/setters, state machine transitions.
  - **Inheritance:** `Student`, `Faculty`, and `Admin` extend `User`; `Book`, `Equipment`, and `StudyMaterial` extend `Resource`.
  - **Polymorphism:** Dynamic method overriding (`getUserRole()`, `getDisplayDetails()`, capability tests) and polymorphic DAO hydration.
  - **Abstraction:** Abstract base classes and layered separation between Presentation (Swing), Business Logic (Services), Data Access (DAOs), and Database.
- **Three User Roles:**
  - **Student:** Browse resources, category/keyword filters, submit borrow requests, track active loans, request returns, view history.
  - **Faculty:** List and share equipment/textbooks, review incoming requests (Approve/Reject), track loan deadlines, confirm item returns.
  - **Administrator:** Complete oversight of users and catalog, account activation/deactivation, real-time KPI metrics, transaction monitoring, CSV export, and audit trails.
- **Robust Concurrency & Transactions:**
  - Database transactions protect physical inventory stock.
  - Double-borrowing and overlapping loan prevention.
  - Student loan limit enforcement (max 3 concurrent loans).
- **Security & Data Integrity:**
  - Passwords hashed using **BCrypt** with salt.
  - All queries execute through parameterized **PreparedStatements** (zero SQL injection vulnerabilities).
  - Role-based authorization checks in both presentation and service layers.
- **Dual-Mode Database Architecture:**
  - Designed for **MySQL 8.x** with provided schema and sample data.
  - Includes **automatic embedded H2 fallback** with auto-provisioned schema and demo records if local MySQL is offline.

---

## 🏗️ Project Architecture

```
c:\B\
├── database/
│   ├── schema.sql                      # Normalized MySQL table schema
│   └── sample_data.sql                 # Sample accounts, resources, and loans
├── docs/
│   ├── OOP_EXPLANATION.md              # Detailed mapping of all 4 OOP pillars
│   ├── DATABASE_DESIGN.md              # Relational schema, ER diagram, and transactions
│   └── USER_GUIDE.md                   # Step-by-step role guides and demo credentials
├── src/
│   ├── main/
│   │   ├── java/com/campusresource/
│   │   │   ├── Main.java               # Application bootstrap & L&F initialization
│   │   │   ├── model/                  # Domain models (User, Resource, Loan, etc.)
│   │   │   ├── dao/                    # JDBC Data Access Objects with PreparedStatements
│   │   │   ├── service/                # Business logic, transactions, state rules
│   │   │   ├── database/               # DatabaseConnection & DatabaseInitializer
│   │   │   ├── ui/                     # Java Swing UI dashboards, frames, and dialogs
│   │   │   └── util/                   # BCrypt, validation, date formatters, CSV exporter
│   │   └── resources/
│   │       ├── db.properties           # Active database configuration
│   │       └── db.properties.example   # Example credentials template
│   └── test/
│       └── java/com/campusresource/    # JUnit 5 unit tests for OOP and services
├── pom.xml                             # Maven build configuration
└── README.md
```

---

## 🚀 Getting Started

### 1. Database Configuration (MySQL)

1. Open your MySQL client (e.g., MySQL Workbench or CLI).
2. Execute the schema script:
   ```bash
   mysql -u root -p < database/schema.sql
   mysql -u root -p < database/sample_data.sql
   ```
3. Update `src/main/resources/db.properties` with your MySQL user and password:
   ```properties
   db.mode=mysql
   db.url=jdbc:mysql://localhost:3306/campus_resource_management?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
   db.username=root
   db.password=your_password
   ```

*(Note: If MySQL is not installed or unreachable, the application automatically boots into embedded H2 mode with pre-seeded demo accounts!)*

### 2. Compilation and Execution

Compile and test using Maven:
```bash
# Run unit tests
mvn test

# Compile and package application
mvn clean package

# Run application directly with Maven
mvn exec:java
```

Or run the compiled executable JAR:
```bash
java -jar target/campus-resource-management-1.0.0.jar
```

---

## 🔑 Demo Login Accounts

| Role | Email | Password |
| :--- | :--- | :--- |
| **Admin** | `admin@campus.edu` | `Admin@123` |
| **Faculty** | `prof.smith@campus.edu` | `Faculty@123` |
| **Student** | `john.doe@campus.edu` | `Student@123` |

*(Quick-fill buttons are provided directly on the Login screen for instant testing.)*
