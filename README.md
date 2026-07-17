# InetHRM 🚀

A modern, high-fidelity Human Resource Management (HRM) system built with Flutter and Cloud Firestore, designed to simplify employee operations and developer management.

InetHRM features a stunning dark-themed glassmorphic design system, real-time synchronization, and a modular architecture.

---

## Key Features

### 1. Modern Glassmorphic Landing Page
* Sleek dark interface using **Google Fonts (Outfit)**.
* Interactive Hero section with active action triggers.
* Live-scrolling navigation.

### 2. Interactive Portal Mockup
* Simulated mock window previewing the employee workspace dashboard.
* **Shift Tracker & Timer**: Support for clocking-in/out, live shift duration calculations, and logging.
* **Leave Manager**: Request leaves with interactive date ranges, view current leave balances, and track leave application status in real-time.
* **Shift History**: Interactive timeline view capturing historical work shifts.
* **Tasks Summary**: Mock card displaying task status counts with a launcher to the full workspace.

### 3. Developer Tasks Board (Kanban Workspace)
* A dedicated **full-screen project management dashboard**.
* Three visual columns (**To Do**, **In Progress**, and **Completed**) sorted in real-time.
* Priority indicators (High, Medium, Low) for task assignments.
* Instant action buttons to transition card statuses.
* **Auto-Seeding**: Automatically seeds three default task entries for fresh users on initial access.

---

## Technical Stack
* **Frontend**: Flutter Web (Material 3, Google Fonts)
* **Backend Database**: Google Cloud Firestore (NoSQL)
* **Authentication**: Firebase Authentication
* **Security**: Granular Firestore Security Rules (`firestore.rules`)

---

## Database Schema (Firestore Collections)

### 1. `users`
* Path: `/users/{uid}`
* Fields:
  * `name`: String
  * `role`: String
  * `department`: String
  * `leavesLeft`: Integer
  * `attendanceRate`: Double
  * `createdAt`: ServerTimestamp

### 2. `attendance_logs`
* Path: `/attendance_logs/{logId}`
* Fields:
  * `userId`: String
  * `action`: String (`clock_in` | `clock_out`)
  * `timestamp`: Timestamp

### 3. `leave_requests`
* Path: `/leave_requests/{requestId}`
* Fields:
  * `userId`: String
  * `name`: String
  * `leaveType`: String (`Annual` | `Sick` | `Casual`)
  * `startDate`: Timestamp
  * `endDate`: Timestamp
  * `reason`: String
  * `status`: String (`pending` | `approved` | `rejected`)
  * `createdAt`: ServerTimestamp

### 4. `tasks`
* Path: `/tasks/{taskId}`
* Fields:
  * `userId`: String
  * `title`: String
  * `description`: String
  * `status`: String (`todo` | `in_progress` | `done`)
  * `priority`: String (`high` | `medium` | `low`)
  * `createdAt`: ServerTimestamp

---

## Security Configuration (`firestore.rules`)
Firestore security rules are maintained in [firestore.rules](file:///Users/akilakeshara/Desktop/inethrm/firestore.rules) in the project root:
* **Users**: Users can only read/write their own profiles.
* **Attendance Logs**: Log entries are append-only (immutable) to prevent modification.
* **Leave Requests & Tasks**: Fully restricted to authorized users corresponding to their `userId`.

---

## Getting Started

### Prerequisites
* Flutter SDK (Stable Channel)
* Firebase CLI (optional, for deploying rules)

### Local Development Setup

1. **Clone the Repository**
   ```bash
   git clone <repository_url>
   cd inethrm
   ```

2. **Navigate to Flutter app**
   ```bash
   cd hrm_mobile
   ```

3. **Get dependencies**
   ```bash
   flutter pub get
   ```

4. **Deploy Firestore Rules**
   * Copy contents of the root `firestore.rules` file.
   * Paste and publish them directly in your **Firebase Console -> Firestore Database -> Rules** panel.

5. **Run the Web Application**
   ```bash
   flutter run -d chrome
   ```
