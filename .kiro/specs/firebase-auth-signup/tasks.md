# Implementation Plan

- [x] 1. Update UserModel to support new role values and optional name


  - Modify UserRole enum to include 'patient' and 'doctor' values instead of 'user'
  - Make name field optional in User class constructor
  - Update factory methods to handle missing name field
  - _Requirements: 2.3, 2.4_

- [x] 2. Create AuthResult model for service responses


  - Create AuthResult class with success, errorMessage, and user fields
  - Implement proper constructors and helper methods for success/error states
  - _Requirements: 4.1, 4.4_

- [x] 3. Enhance FirestoreService with user document existence checks


  - Add userDocumentExists method to check if user document already exists
  - Add createUserDocumentIfNotExists method that prevents data overwrites
  - Update existing addUser method to use UID as document ID and remove name requirement
  - _Requirements: 3.5, 3.6_



- [ ] 4. Create AuthService for Firebase Authentication operations
  - Implement signUpWithEmailAndPassword method that handles both auth and Firestore creation
  - Add Firebase Auth error handling with user-friendly error messages
  - Integrate with FirestoreService for automatic user document creation
  - Add helper methods for error formatting and validation

  - _Requirements: 1.1, 1.2, 1.3, 1.4, 3.1, 3.2, 3.3, 3.4, 4.1, 4.2, 4.3, 4.4_

- [x] 5. Create SignupScreen widget with form validation

  - Build signup form with email, password, and role selection fields
  - Implement form validation for email format, password strength, and role selection
  - Add radio buttons for patient/doctor role selection
  - Implement loading states and error/success message display
  - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 6. Integrate SignupScreen with AuthService

  - Connect form submission to AuthService.signUpWithEmailAndPassword
  - Handle success and error responses from AuthService
  - Display appropriate user feedback messages
  - Implement proper error handling and retry functionality
  - _Requirements: 1.5, 3.7, 4.5, 5.1, 5.2, 5.3_

- [x] 7. Update main application to use SignupScreen


  - Replace the current FirestoreTestPage with SignupScreen in simple_main.dart
  - Remove the separate test "addUser()" button and related functionality
  - Update app routing and navigation to use the new signup flow
  - _Requirements: 6.1, 6.2, 6.3_

- [x] 8. Add comprehensive error handling and user feedback


  - Implement specific error messages for different Firebase Auth error codes
  - Add visual styling for success (green) and error (red) messages
  - Ensure form data persistence during error states
  - Add loading indicators during async operations
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 5.4, 5.5_

- [ ] 9. Write unit tests for AuthService
  - Test successful signup flow with valid credentials
  - Test Firebase Auth error handling scenarios
  - Test Firestore integration and document creation
  - Test existing user document handling (no overwrite)
  - _Requirements: 1.1, 1.4, 3.6, 4.1_

- [ ] 10. Write unit tests for enhanced FirestoreService
  - Test userDocumentExists method functionality
  - Test createUserDocumentIfNotExists method
  - Test error handling for Firestore operations
  - Test document creation with proper field structure
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_

- [ ] 11. Write widget tests for SignupScreen
  - Test form rendering and input field validation
  - Test role selection radio buttons functionality
  - Test loading states and message display
  - Test form submission and error handling
  - _Requirements: 2.1, 2.2, 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ] 12. Create integration tests for complete signup flow
  - Test end-to-end signup with valid user data
  - Verify Firebase Auth account creation
  - Verify Firestore document creation with correct structure
  - Test duplicate signup prevention functionality
  - _Requirements: 1.1, 2.4, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_