# MonHeure

An elegant cross-platform personal punch-in/punch-out tracker built with Flutter.

## Features

- Simple and intuitive time tracking
- Material 3 design with light & dark theme support
- Local storage with Hive
- Statistics and reporting
- PDF export functionality

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
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

- `hooks_riverpod`: State management
- `hive`: Local storage
- `fl_chart`: Data visualization
- `pdf` & `printing`: Report generation
- `intl`: Internationalization
- `freezed`: Code generation for immutable models

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
flutter test test/features/time_tracking/data/repositories/hive_punch_session_repository_test.dart
``` 