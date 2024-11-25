# RBAC VRV Security App

This project is a Flutter-based Role-Based Access Control (RBAC) application designed to manage user roles and permissions for notes and groups within an organization. It allows users to create, edit, delete, and view notes in groups based on their roles (Admin, Editor, Member).

## Features

- **Role-Based Access Control**: Users can have different roles (Admin, Member, Editor) within a group, with specific permissions to perform actions on notes.
- **Admin Role**: Admin users can access all notes within their group and have the ability to manage members and their roles.
- **Note Management**: Users can create, update, and delete notes based on their role and permissions.
- **User Management**: Admin users can manage group memberships and user roles.
- **Group Management**: Users can see which groups they belong to and their associated role.

## Tech Stack

- **Flutter**: Used for building the mobile application interface.
- **Dart**: The programming language used for developing the app.
- **Mock Backend**: The app uses a mock backend with static data for user, group, and note management (simulating API calls).

## Project Structure

- `lib/` - Contains all the source code of the Flutter application.
    - `UI Components/` - Contains Flutter widgets for different UI elements like notes, groups, and user management.
    - `Mock Backend/` - Contains mock data and API logic to simulate backend operations for notes, groups, and users.
    - `main.dart` - Entry point of the app.
- `README.md` - Project documentation.

## Setup

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up a code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/rbac-vrv-security.git
   cd rbac-vrv-security

2. Install dependencies:

   ```bash
   flutter pub get
3. Run the app:
   ```bash
   flutter run
