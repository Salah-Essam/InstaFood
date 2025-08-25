# Onboarding Feature - Clean Architecture

This directory contains the refactored onboarding feature following clean architecture principles with proper separation of concerns.

## Architecture Overview

```
onboarding/
├── logic/
│   ├── constants/
│   │   └── onboarding_constants.dart      # Centralized constants and configuration
│   ├── cubit/
│   │   ├── onboarding_cubit.dart          # Business logic controller
│   │   └── onboarding_state.dart          # State management
│   └── services/
│       └── onboarding_service.dart        # Business logic service layer
├── view/
│   ├── widgets/
│   │   ├── onb_bottom_sheet.dart          # Bottom sheet UI component
│   │   ├── onb_images_text.dart           # Image and text display component (legacy)
│   │   └── onb_skip_button.dart           # Skip button component
│   └── onboarding_screen.dart             # Main screen orchestrator
└── README.md                              # This file
```

## Key Principles Applied

### 1. **Separation of Concerns**
- **UI Layer**: Pure presentation widgets with no business logic
- **Business Logic Layer**: Cubit and services handle all business rules
- **Data Layer**: Shared preferences service manages persistence

### 2. **Single Responsibility**
- Each widget has a single, focused purpose
- Services handle specific business operations
- Constants centralize configuration

### 3. **Dependency Inversion**
- UI depends on abstractions (cubit, services)
- Services depend on abstractions (shared preferences)
- Easy to test and mock dependencies

### 4. **Clean Widget Structure**
- `onboarding_screen.dart`: Main orchestrator with efficient Stack for layering
- `onb_bottom_sheet.dart`: Handles bottom sheet UI and interactions
- `onb_skip_button.dart`: Skip button functionality using Overlay
- `onb_images_text.dart`: Legacy component (kept for reference)

## Current Implementation

### **Efficient Stack Usage**
- **Full Background Images**: Images extend to full screen height
- **Layered Bottom Sheet**: Bottom sheet positioned on top of images
- **Skip Button**: Uses Overlay for lightweight positioning
- **Performance**: Minimal Stack overhead, only for essential layering

### **Layout Structure**
```
Stack
├── PageView (full screen background images)
│   ├── Full Image 1
│   ├── Full Image 2
│   └── Full Image 3
└── Positioned Bottom Sheet (overlayed on images)
    └── OnbBottomSheet (338px height, 20px radius)
```

## Service Layer

### SharedPrefsService (Core)
- Singleton service for all shared preferences operations
- Generic methods for type-safe preference handling
- Onboarding-specific methods for state management

### OnboardingService
- Business logic for onboarding flow
- Coordinates with SharedPrefsService
- Handles onboarding completion, step tracking, etc.

## State Management

### OnboardingCubit
- Manages page controller and navigation
- Handles user interactions (next, skip, goTo)
- Coordinates with OnboardingService for persistence

### OnboardingState
- Immutable state representation
- Tracks current page index
- Uses Equatable for efficient state comparison

## Constants

### OnboardingConstants
- Centralized configuration values
- Asset paths, dimensions, durations
- Page indices and content
- Easy to modify and maintain

## Benefits of This Architecture

1. **Maintainability**: Clear separation makes code easier to understand and modify
2. **Testability**: Each layer can be tested independently
3. **Reusability**: Widgets can be reused in other parts of the app
4. **Scalability**: Easy to add new features or modify existing ones
5. **Consistency**: Follows established patterns used throughout the app
6. **Performance**: Efficient Stack usage only where necessary
7. **Visual Appeal**: Full background images with layered bottom sheet

## Usage Example

```dart
// The main screen now efficiently layers full images with bottom sheet
class OnboardingScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(/* full background images */),
        Positioned(
          bottom: 0,
          child: OnbBottomSheet(onDone: () => navigateToHome()),
        ),
      ],
    );
  }
}
```

## Future Enhancements

- Add unit tests for each layer
- Implement dependency injection for better testability
- Add analytics tracking service
- Create onboarding data models for dynamic content
- Optimize image loading and caching
