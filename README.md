# MonHeure

An elegant cross-platform personal punch-in/punch-out tracker built with Flutter.

## Features

- Simple and intuitive time tracking
- Material 3 design with light & dark theme support
- Local storage with Hive
- Statistics and reporting
- PDF export functionality
- Calendar view for time entries
- Beautiful charts and visualizations

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK (>=3.2.0)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/MonHeure.git
cd MonHeure
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Architecture

The project follows Clean Architecture principles:

- **Presentation**: UI components and state management
- **Application**: Use cases and business logic
- **Domain**: Entities and repository interfaces
- **Data**: Repository implementations and data sources

### Data Models

The project uses a dual-model approach for data persistence:

- **PunchSession**: A Freezed model for business logic and JSON serialization
- **PunchSessionEntity**: A Hive model for local storage

This separation ensures:
- Type-safe business logic with immutable models
- Efficient local storage with Hive
- Clear separation of concerns between storage and business logic

## Dependencies

### Main Dependencies
- `hooks_riverpod`: State management
- `flutter_hooks`: React hooks for Flutter
- `hive`: Local storage
- `fl_chart`: Data visualization
- `pdf` & `printing`: Report generation
- `intl`: Internationalization
- `freezed`: Code generation for immutable models
- `table_calendar`: Calendar widget for time entry visualization

### Development Dependencies
- `build_runner`: Code generation
- `freezed`: Immutable model generation
- `json_serializable`: JSON serialization
- `hive_generator`: Hive model generation
- `flutter_launcher_icons`: App icon generation
- `flutter_lints`: Linting rules

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 

## Testing

To run the tests, use the following command:
```bash
flutter test
```

## Project Structure

```
lib/
├── features/
│   └── time_tracking/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── core/
└── main.dart
```

## Building

To build the app for different platforms:

```bash
# For Android
flutter build apk

# For iOS
flutter build ios

# For Web
flutter build web
``` 