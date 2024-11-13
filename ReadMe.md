## SLED

#### SLED is an iOS app built with Swift, designed to provide a platform for users to create and book various activity listings. This README provides an overview of the project's folder structure, purpose of each directory, and guides to understanding the main components of the app.

### Folder Structure

1. Assets.xcassets:
    - Contains images, icons, and other assets used within the app's user interface.
    - Assets are organized here to ensure efficient management and consistent loading throughout the app.

2. Models:
    - This folder contains Swift files that define the app's data models. Models represent the structure of data that the app will manage and display.
    - Files:
        - Activities.swift: Defines data related to activities that users can create and book.
        - ActivityIconProvider.swift: Provides icons for different activities.
        - User.swift: Defines the user model, capturing details about each user of the app.

3. Preview Content:
    - Contains preview assets specifically for Xcode Previews.
    - Helps to render live previews of views in Xcode for design and layout testing.

4. Views:
    - This directory holds all the UI components and screens of the app. Each Swift file here corresponds to a view or screen that users interact with.
    - Subdirectories & Files:
        - Auth: Likely contains files for authentication-related views (e.g., login and signup).
    Main Files:
        - BookingsView.swift: Displays bookings made by the user.
        - ContentView.swift: The main content view, likely serves as the entry point for the app’s UI.
        - CreateListing.swift: Allows users to create new activity listings.
        - CurrentBookingView.swift: Shows details about the user’s current booking.
        - Listing.swift: Displays individual listings for activities.
        - ListingStore.swift: Manages and stores listings data.
        - LocationManager.swift: Manages location-related tasks, such as fetching and storing user coordinates.
        - SearchResultView.swift: Displays search results when users search for activities.
        - SeekerOverview.swift: Provides an overview of activities for users seeking new experiences.

5. SledApp.swift:
    - The main application file, which serves as the entry point of the app.
    - Sets up the app’s environment and initial configuration upon launch.

6. Sled.xcodeproj:
    - The Xcode project configuration file, which includes various project settings.
    - Subfolders:
        - project.xcworkspace: Workspace configuration for multi-project setups.
    - xcshareddata: Stores shared settings and schemes for team collaboration.
    - xcuserdata: Contains user-specific data, like layout preferences in Xcode.
    - project.pbxproj: The core project file containing build configurations, targets, and other essential settings.

7. SledTests:
    - Contains unit test files for testing individual components and functionalities.
    - Ensures that the app’s models, views, and controllers work as expected.

8. SledUITests
    - Contains UI test files to verify the app’s user interface and user interactions.
    - Files:
        - SledUITests.swift: Tests core UI flows to ensure a smooth user experience.
        - SledUITestsLaunchTests.swift: Tests the app’s launch behavior and initial setup.

### Additional Notes
- LocationManager.swift: This file is crucial as it handles location permissions and fetching the user’s coordinates, enabling location-based features in the app.
- ActivityIconProvider.swift: Helps maintain consistent and customizable icons for different activities, enhancing the user experience.
- Listings and Bookings: The app's core functionality revolves around creating and managing activity listings and bookings.
    - Files like CreateListing.swift and CurrentBookingView.swift are essential in enabling these features.

### Getting Started
- Clone the repository.
- Open Sled.xcodeproj in Xcode.
- Build and run the app on a simulator or a connected device.

### Prerequisites
- Xcode 12.0+
- Swift 5+