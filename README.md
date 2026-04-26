# HR Connect

> A modern Human Resource Management System built with Flutter.

Hello! Welcome to the HR Connect. We've been building some cool stuff to handle employee operations. Here's a quick breakdown of what's been done, what's happening right now, and what's coming next.

---

## Project Overview

This project focuses on a clean architecture for a mobile app (likely for HR/Internal Management). We moved away from legacy Firebase dependencies to build a solid foundation using modern Flutter patterns.

---

## Architecture & Foundation (Done)

We've sorted out the messy bits from the old code. Here's what's currently stable:

- [x] **Cleanup:** Removed legacy Firebase dependencies.
- [x] **Architecture:** Set up a clean architecture with:
  - Dependency Injection (via `get_it`)
  - Responsive Design (via `flutter_screenutil`)
  - Custom Theme System (System, Light, and Dark modes)
- [x] **Navigation:** Implemented **GoRouter** with role-based action controls (RBAC).
- [x] **Error Handling:** Added a global error layer for network/server failures.
- [x] **Mock Data:** Created dummy users to simulate backend responses (`USE_MOCK_DATA` support).
- [x] **UI Polish:** Responsive Login screen (with Email/Password) and dynamic Main Dashboard based on user roles.
- [x] **Settings:** App-level settings (About, Theme settings, Support dialog).

---

## Core State Management (Done)

We've got the heavy lifting done for user and auth logic.

- [x] **Auth System:** Full Auth Model, Remote DataSource, Repository Implementation, and Provider.
- [x] **User Management:** Implemented User Model, Repositories, and Provider for user data handling.

---

## User Experience

- [x] **Splash Screen:** Added a simple splash screen to handle initial loading and auth checks.
- [x] **Role-Based Dashboard:** The main dashboard dynamically shows different options based on the user's role (Admin, Director, Supervisor, Staff).

## Work in Progress & Roadmap (In Progress)

We're cooking up some more features right now and Here is the plan for the next update.

- **Admin User Management:**
  - [x] **Read:** View all users with pagination, searching, and role filtering.
  - [ ] **Create/Update/Delete:** Building the UI and logic for modifying user data in the admin panel.

### Modules

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Dashboard             |      | Admin     | [x]           | [x]               | Done         |
|                       |      | Director  | [ ]           | [ ]               | To Do        |
|                       |      | Manager   | [ ]           | [ ]               | To Do        |
|                       |      | Supervisor| [ ]           | [ ]               | To Do        |
|                       |      | Staff     | [ ]           | [ ]               | To Do        |

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Attendance            |      | Admin     | [ ]           | [ ]               | To Do        |
|                       |      | Director  | [ ]           | [ ]               | To Do        |
|                       |      | Manager   | [ ]           | [ ]               | To Do        |
|                       |      | Supervisor| [ ]           | [ ]               | To Do        |
|                       |      | Staff     | [ ]           | [ ]               | To Do        |

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Leave Management      |      | Admin     | [x]           | [ ]               | In Progress  |
|                       |      | Director  | [x]           | [ ]               | In Progress  |
|                       |      | Manager   | [x]           | [ ]               | In Progress  |
|                       |      | Supervisor| [x]           | [ ]               | In Progress  |
|                       |      | Staff     | [x]           | [ ]               | In Progress  |

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Overtime Reimbursment |      | Admin     | [ ]           | [ ]               | To Do        |
|                       |      | Director  | [ ]           | [ ]               | To Do        |
|                       |      | Manager   | [ ]           | [ ]               | To Do        |
|                       |      | Supervisor| [ ]           | [ ]               | To Do        |
|                       |      | Staff     | [ ]           | [ ]               | To Do        |

### User & Personal

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Personal Info         |      | Admin     | [x]           | [x]               | Done         |
|                       |      | Director  | [x]           | [ ]               | In Progress  |
|                       |      | Manager   | [x]           | [ ]               | In Progress  |
|                       |      | Supervisor| [x]           | [ ]               | In Progress  |
|                       |      | Staff     | [x]           | [ ]               | In Progress  |

| Feature               |      | Role      | Backend Logic | UI Implementation | Status       |
| :-------------------- | :--- | :-------- | :------------ | :---------------- | :----------- |
| Personal Report       |      | Admin     | [ ]           | [ ]               | To Do        |
|                       |      | Director  | [ ]           | [ ]               | To Do        |
|                       |      | Manager   | [ ]           | [ ]               | To Do        |
|                       |      | Supervisor| [ ]           | [ ]               | To Do        |
|                       |      | Staff     | [ ]           | [ ]               | To Do        |

    *(Note: Includes views for hierarchy reports: Staff -> Supervisor -> Manager or Admin -> Director)*

---

## Testing

- [x] **Mock Data Implementation:** We've got testing dummy data ready (`UserDummyRemote` and `AuthDummyRemote`) so the dashboard UI can run smoothly without the backend API live.

---

## Running the App

To run the app, make sure you have Flutter installed and set up. Then, follow these steps:

1. Clone the repository:

        git clone https://github.com/Fizryan/HR-Connect.git

1. Navigate to the project directory:

        cd HR-Connect

1. Install dependencies:

        flutter pub get

1. Run the app:

        flutter run

---

## Tech Stack

Here are the main tools we're using:

- **Flutter**
- **Provider** (State Management with Freezed)
- **GoRouter** (Navigation & Route Guarding)
- **GetIt** (Dependency Injection)
- **ScreenUtil** (Responsive UI)
- **Shared Preferences & Flutter Secure Storage** (Local Storage)

---

## Reporting Issues

If you encounter any issues or have suggestions for improvements, please feel free to open an issue on the GitHub repository. We appreciate your feedback!

---
