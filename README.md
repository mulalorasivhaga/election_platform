# Election Platform

A web-based election platform built with Flutter and Firebase, designed to facilitate secure voter registration and management.

## Features

### Completed Features
- User Registration System
    - Email and password authentication
    - South African ID validation
    - Provincial selection
    - Form validation and error handling
    - Real-time data persistence with Firebase
- Responsive Design
    - Mobile-friendly layout
    - Desktop optimization
    - Dynamic form adjustments

### Technical Stack
- Frontend: Flutter Web
- Backend: Firebase
    - Authentication
    - Firestore Database
- State Management: Provider

## Project Structure
```
lib/
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user.dart
│   │   ├── screens/
│   │   │   └── reg_screen.dart
│   │   └── services/
│   │       └── auth_service.dart
│   └── home/
│       └── screens/
│           └── home_screen.dart
├── shared/
│   └── widgets/
│       └── main_navigator.dart
└── main.dart
```

## Setup and Installation

### Prerequisites
- Flutter (latest version)
- Firebase CLI
- Web browser (Chrome recommended for development)

### Firebase Configuration
1. Create a Firebase project
2. Enable Authentication and Firestore
3. Add Firebase configuration to your project
4. Set up Firestore security rules

### Getting Started
1. Clone the repository
```bash
git clone [https://github.com/mulalorasivhaga/election_platform]
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run -d chrome
```

## Testing
### Form Validation Tests
- Email format validation
- Password strength requirements
- South African ID number validation
- Required field validation

### Firebase Integration Tests
- User authentication
- Data persistence
- Security rules validation

## Current Progress
✅ Completed:
- Basic project setup
- Firebase integration
- Registration form UI
- Form validation
- User authentication
- Firestore integration

🔄 In Progress:
- Security rules implementation
- Error handling improvements
- User data management

📝 Planned Features:
- Login functionality
- Email verification
- Password reset
- User profile management
- Admin dashboard

## Contributing
[Your contribution guidelines here]

## License
[Your license information here]

## Contact
[Your contact information here]