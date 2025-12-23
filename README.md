# Assets Dashboard

A comprehensive Flutter-based web application for managing organizational assets, employees, vendors, and branches with real-time Firebase integration.

## Overview

Assets Dashboard is a modern enterprise asset management system built with Flutter for cross-platform deployment. The application provides a centralized platform for tracking and managing company assets, employee assignments, vendor relationships, and branch operations with real-time data synchronization through Firebase Firestore.

## Features

### 📊 Dashboard & Analytics

- **Real-time Statistics**: Live dashboard displaying total assets, assigned assets, available assets, assets under repair, and upcoming warranty expirations
- **Branch Filtering**: Filter dashboard statistics by specific branches or view all branches
- **Visual Analytics**: Branch comparison charts and quick stats overview
- **Warranty Tracking**: Automatic monitoring of warranties expiring within 30 days

### 🏢 Asset Management

- **Comprehensive Asset Tracking**: Manage assets with detailed information including:
  - Asset ID, name, category, and cost
  - Assignment status (Available, Assigned, Under Repair)
  - Employee assignment tracking
  - Purchase date and warranty expiration
  - Asset condition monitoring
- **Advanced Filtering**: Filter assets by category, status, and assigned employee
- **Search Functionality**: Quick search by asset name
- **CRUD Operations**: Full create, read, update, and delete capabilities
- **Real-time Updates**: Live synchronization of asset data across all users

###  Branch Management

- **Multi-branch Support**: Manage multiple organizational branches
- **Branch Details**: Track branch name, location, manager, contact information, and employee count
- **Branch Analytics**: Monitor asset distribution across branches

### 👥 Employee Management

- **Employee Directory**: Comprehensive employee information management
- **Direct Operations**: Add new employees and delete existing records with confirmation dialogs
- **Employee Tracking**: Monitor employee details including name, designation, contact, and branch assignment

###  Vendor Management

- **Vendor Database**: Maintain vendor relationships and contact information
- **Vendor Details**: Track vendor name, contact person, email, phone, and associated branch
- **Quick Actions**: Add and delete vendors directly from the list view

###  Reports & Settings

- **Reporting Module**: Generate and view asset reports
- **Settings Management**: Configure application preferences and settings
- **Customizable Views**: Adjust display preferences and data views

## Technical Architecture

### Technology Stack

#### Frontend Framework

- **Flutter 3.9.2+**: Cross-platform UI framework for web, mobile, and desktop
- **Material Design**: Modern, responsive UI components
- **Google Fonts**: Custom typography using the Google Fonts package

#### State Management

- **Provider Pattern**: Efficient state management using the Provider package (v6.1.2)
- **Reactive Architecture**: Real-time UI updates based on data changes
- **Separation of Concerns**: Clean architecture with dedicated providers for each module:
  - `AssetProvider`: Asset state management
  - `BranchProvider`: Branch operations
  - `EmployeeProvider`: Employee data handling
  - `VendorProvider`: Vendor management
  - `DashboardProvider`: Dashboard statistics and analytics
  - `SettingsProvider`: Application settings

#### Backend & Database

- **Firebase Core (v3.8.1)**: Firebase initialization and configuration
- **Cloud Firestore (v5.5.0)**: NoSQL cloud database for real-time data storage
- **Real-time Synchronization**: Automatic data updates across all connected clients
- **Firestore Collections**:
  - `assets`: Asset records
  - `branches`: Branch information
  - `employees`: Employee data
  - `vendors`: Vendor details
  - `settings`: Application settings

#### Utilities

- **intl (v0.19.0)**: Internationalization and date formatting
- **uuid (v4.5.1)**: Unique identifier generation

### Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── firebase_config.dart          # Firebase configuration
│   ├── constants/
│   │   ├── app_colors.dart               # Color palette
│   │   └── app_sizes.dart                # Spacing and sizing constants
│   └── theme/
│       └── app_theme.dart                # Application theme
├── data/
│   ├── models/                           # Data models
│   │   ├── asset_model.dart
│   │   ├── branch_model.dart
│   │   ├── employee_model.dart
│   │   ├── vendor_model.dart
│   │   └── dashboard_stats.dart
│   ├── repositories/                     # Data access layer
│   │   ├── asset_repository.dart
│   │   ├── branch_repository.dart
│   │   ├── employee_repository.dart
│   │   ├── vendor_repository.dart
│   │   └── settings_repository.dart
│   └── services/
│       └── firestore_service.dart        # Firestore operations wrapper
├── providers/                            # State management
│   ├── asset_provider.dart
│   ├── branch_provider.dart
│   ├── employee_provider.dart
│   ├── vendor_provider.dart
│   ├── dashboard_provider.dart
│   └── settings_provider.dart
├── screens/                              # UI screens
│   ├── home/
│   │   └── home_screen.dart              # Dashboard
│   ├── assets/
│   │   ├── assets_screen.dart
│   │   ├── add_asset_screen.dart
│   │   └── edit_asset_screen.dart
│   ├── branches/
│   │   ├── branches_screen.dart
│   │   ├── add_branch_screen.dart
│   │   └── edit_branch_screen.dart
│   ├── employees/
│   │   ├── employees_screen.dart
│   │   └── add_employee_screen.dart
│   ├── vendors/
│   │   ├── vendors_screen.dart
│   │   └── add_vendor_screen.dart
│   ├── reports/
│   │   └── reports_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── widgets/                              # Reusable components
│   ├── sidebar_navigation.dart           # Navigation sidebar
│   ├── stat_card.dart                    # Statistics card widget
│   └── chart_placeholder.dart            # Chart component
└── main.dart                             # Application entry point
```

### Architecture Patterns

#### Repository Pattern

- Abstracts data access logic from business logic
- Provides a clean API for data operations
- Handles Firestore queries and transformations
- Implements error handling and data validation

#### Provider Pattern

- Manages application state efficiently
- Notifies UI of data changes automatically
- Separates business logic from presentation
- Enables reactive programming

#### Clean Architecture

- **Presentation Layer**: UI screens and widgets
- **Business Logic Layer**: Providers and state management
- **Data Layer**: Repositories and models
- **Service Layer**: Firebase and external service integrations

## Key Features Implementation

### Real-time Data Synchronization

The application uses Firestore's real-time listeners to automatically update the UI when data changes in the database, ensuring all users see the latest information without manual refreshes.

### Responsive Design

Built with a responsive layout that adapts to different screen sizes, featuring:

- Sidebar navigation for easy module access
- Responsive grid layouts for statistics
- Adaptive data tables
- Mobile-friendly UI components

### Data Validation

Comprehensive validation for all data inputs including:

- Required field validation
- Format validation (email, phone numbers)
- Date validation
- Cost and numeric field validation

### Search and Filter

Advanced filtering capabilities across all modules:

- Category-based filtering for assets
- Status-based filtering
- Employee assignment filtering
- Branch-specific filtering
- Text-based search functionality

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK
- Firebase account
- Web browser (for web deployment)

### Installation

1. Clone the repository
2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:

   - Update `lib/core/config/firebase_config.dart` with your Firebase project credentials
   - Ensure Firestore is enabled in your Firebase console

4. Run the application:
   ```bash
   flutter run -d chrome
   ```

### Firebase Configuration

The application requires the following Firebase configuration parameters:

- API Key
- Auth Domain
- Project ID
- Storage Bucket
- Messaging Sender ID
- App ID
- Measurement ID (optional)

## Usage

### Navigation

The application features a sidebar navigation with the following modules:

1. **Dashboard**: Overview and statistics
2. **Assets**: Asset management
3. **Branches**: Branch operations
4. **Employees**: Employee directory
5. **Vendors**: Vendor management
6. **Reports**: Reporting and analytics
7. **Settings**: Application configuration

### Asset Workflow

1. Navigate to the Assets screen
2. Click "Add Asset" to create a new asset
3. Fill in asset details (name, category, cost, warranty, etc.)
4. Assign to an employee if needed
5. Use filters to find specific assets
6. Edit or delete assets as required

### Dashboard Analytics

The dashboard automatically calculates and displays:

- Total asset count
- Assigned assets
- Available assets
- Assets under repair
- Upcoming warranty expirations (within 30 days)

## Platform Support

- ✅ Web (Primary target)
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Android
- ✅ iOS

## Version

**Current Version**: 1.0.0+1

## License

This project is private and not published to pub.dev.

## Future Enhancements

- Advanced reporting with charts and graphs
- Export functionality (PDF, Excel)
- User authentication and role-based access control
- Asset depreciation tracking
- Maintenance scheduling
- Document attachment support
- Mobile app optimization
- Push notifications for warranty expiration
- Audit trail and activity logs
