# TaskMate

TaskMate is a Flutter-based task management application designed to help users efficiently manage their tasks. The app implements the MVVM architecture and utilizes Riverpod for state management, SQLite for persistent data storage, and Hive for user preferences.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Task Management**: 
  - Add, edit, delete, and view tasks.
  - Mark tasks as "Completed" or "Pending."
  
- **Data Storage**:
  - **SQLite**: Store task details and persist data across app launches.
  - **Hive**: Store user preferences such as app theme and default sort order.

- **State Management**: 
  - Use Riverpod for managing app state, including task management and user preferences.

- **MVVM Architecture**: 
  - Follow the MVVM pattern for clean separation of concerns.

- **Responsive Design**: 
  - Adapt the layout for mobile and tablet devices.

- **Additional Features** (Optional):
  - Search and filter functionality for tasks.
  - Local notifications for task reminders.

## Technologies Used

- **Framework**: Flutter
- **State Management**: Riverpod
- **Local Storage**: SQLite and Hive
- **Architecture**: MVVM (Model-View-ViewModel)

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/UMESH-042/Task-Management.git
   ```

2. **Navigate to the Project Directory**:

   ```bash
   cd Task-Management
   ```

3. **Get the Dependencies**:

   ```bash
   flutter pub get
   ```

4. **Run the App**:

   ```bash
   flutter run
   ```

## Usage

- **Adding a Task**: Tap the "Add Task" button to create a new task. Fill in the details and save.
- **Editing a Task**: Tap on an existing task to edit its details.
- **Deleting a Task**: Swipe left on a task to delete it.
- **Filtering Tasks**: Use the filter options to view tasks based on their status (Completed/Pending).
- **Changing Theme**: Toggle between light and dark modes in the settings.

## Architecture

The app follows the MVVM architecture:

- **Model**: Represents the data structure for tasks and user preferences.
- **ViewModel**: Contains the business logic and manages the state of the application.
- **View**: The UI components that display data and handle user interactions.

## Contributing

Contributions are welcome! If you would like to contribute, please fork the repository and submit a pull request. Ensure that your code adheres to the project's coding standards.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Thank you for checking out TaskMate! We hope you find it useful for managing your tasks efficiently.