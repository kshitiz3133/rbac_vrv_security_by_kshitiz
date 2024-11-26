
# RBAC VRV Security App

This project is a **Flutter-based Role-Based Access Control (RBAC)** application designed to manage user roles and permissions within an organization. The app allows users to create, edit, delete, and view notes in groups based on their roles, which can be **Admin**, **Editor**, or **Member**.

## Features

- **Role-Based Access Control (RBAC)**: Users can have different roles (Admin, Member, Editor) within a group, with specific permissions to perform actions on notes.

- **Admin Role**:
    - Admin users can **access all notes** within their group.
    - Admins can **manage members** within the group, including adding/removing members and assigning/editing roles.
    - Admins have the ability to create, update, and delete **group notes**.

- **Editor Role**:
    - Editors can **edit and update notes** in the group but cannot delete notes or manage group memberships.

- **Member Role**:
    - Members can **view and create notes** but cannot update, or delete them.

- **Group Management**: Users can view which **groups** they belong to, their associated role within each group, and interact with group notes based on their role.

- **Note Management**:
    - Users can **create** new notes, **update** existing notes, and **delete** notes depending on their role.
    - **Editors** and **Admins** can edit notes, while **Members** can only view them.

## Tech Stack

- **Flutter**: Used for building the mobile application interface.
- **Dart**: The programming language used for developing the app.
- **Mock Backend**: A mock backend simulating API calls for user, group, and note management using static data.

## Mock Backend

The app uses a **mock backend** to simulate data retrieval and storage, allowing us to manage users, groups, and notes without a real server. The mock backend consists of:

- **Users**: Simulated data representing individual users, including their roles and assigned groups.
- **Groups**: A list of groups to which users can belong, with roles such as Admin, Editor, or Member.
- **Notes**: Notes created within each group, which can be managed based on the user's role in the group.

The mock backend stores data in static lists, and interactions (adding/removing members, editing notes) are simulated as API calls in the app.

### Mock API Operations

1. **getUsers()** - Fetches all users from the mock backend.
2. **getGroups()** - Fetches all groups from the mock backend.
3. **getNotes()** - Fetches all notes within a specific group.
4. **getUserRoles()** - Retrieves a user's role in a particular group.
5. **addGroupMember()** - Simulates adding a member to a group.
6. **removeGroupMember()** - Simulates removing a member from a group.
7. **addNote()** - Adds a note to the group.
8. **editNote()** - Edits an existing note.
9. **deleteNote()** - Deletes a note from the group.

## Users and Roles

### ITAdmin (Super Admin)

- The **ITAdmin** role is a special admin role that has full access to manage users, groups, and notes across the entire system.
- The **ITAdmin** can:
    - Manage users (create, update, delete users).
    - Assign roles to users (Admin, Editor, or Member).
    - View and edit all notes in all groups.

### Group Admin

- **Group Admins** are admins for a specific group. They can:
    - Manage members within their group.
    - Assign roles (Admin, Editor, Member) to users within their group.
    - Create, edit, and delete notes within their group.
    - View and manage all notes in the group.

### Editor

- **Editors** are users with permission to edit existing notes within a group. They can:
    - Edit notes.
    - View notes.
    - Cannot delete notes or manage group memberships.

### Member

- **Members** are users with limited permissions. They can:
    - View notes within their group.
    - Cannot edit, or delete notes.
    - Cannot manage members or change roles within the group.

## Group and Role Management

- Each **Group** has a set of users, and each user in a group has a specific role.
- Users can be assigned one of the following roles in a group:
    - **Admin**: Full control over notes and members within the group.
    - **Editor**: Can edit existing notes but cannot manage members or create new notes.
    - **Member**: Can only view notes within the group.
    - **If a Member creates a note, they become one of the Editors.**

Admins can assign and manage roles within the group. Only Admins and ITAdmins have the ability to add/remove members and change their roles.

## Project Structure

- **lib/**
    - `main.dart`: The entry point of the application.
    - `UI Components/`: Contains Flutter widgets that manage the UI for notes, groups, and user management.
    - `Mock Backend/`: Contains mock data and API logic to simulate backend operations for notes, groups, and users.

### Key Files:
- **`Roles`**: Contains mock user data and their roles.
- **`Groups`**: Contains mock group data and associated roles for each group.
- **`notes.dart,new_note,dart,notes_expanded.dart`**: Contains mock notes data, along with methods for creating, editing, and deleting notes.
- **`mock_backend.dart`**: Contains methods to simulate API calls to interact with the mock data (add members, delete notes, etc.).

## Setup

### Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up a code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/rbac-vrv-security.git
   cd rbac-vrv-security
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## App Workflow

1. **Login/Authentication**: The app simulates a login process where users are authenticated based on their `userdata`. Once authenticated, users are assigned a role and associated with a group.

2. **Group and Note Management**:
    - **Admins**: Can add/remove members, assign roles, and manage notes in the group.
    - **Editors**: Can edit and view notes, but cannot manage other members or create new notes.
    - **Members**: Can only view notes and cannot modify them.

3. **Role Management**: Admins can view and assign roles to users within a group. Users can see which group they belong to and their role.

4. **Note Interaction**: Based on the user’s role, they can create, edit, delete, or simply view notes.

## Future Improvements

- **Real Backend Integration**: Currently, the app uses a mock backend with static data. In the future, this can be replaced with real API calls to a backend server for user and data management.
- **Authentication**: Implement actual authentication using Firebase or another authentication service.
- **Dynamic Role Management**: Improve the role management system with more granular permissions and access controls.

# VIDEO SAMPLE

https://github.com/user-attachments/assets/3f90072d-9805-4f4d-bc37-514b3bc41627

