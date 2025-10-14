# Income Expense Tracker

A production-ready, clean architecture Flutter app to track personal income and expenses. Uses BLoC (flutter_bloc), SQLite (sqflite), Material 3 UI, charts (fl_chart), and Google Fonts. Includes JSON import/export and robust filtering.

## Features
- Clean Architecture with domain/data/presentation layers
- BLoC state management, Equatable states
- SQLite local persistence with migration-safe init
- CRUD: add, edit, delete transactions
- Filters: type, date range, category, search (combined)
- Balance summary: total income, total expense, net balance
- Analysis charts (monthly bars)
- Import/Export JSON (merge on id; keep latest by date)
- Material 3 design, light/dark, Google Fonts
- Responsive with `flutter_screenutil` for all sizes (text, paddings, icons)
- Animated notch bottom navigation (Transactions / Analysis / Add)
- Error/empty/loading views and Snackbar notifications

## Tech Stack
- Flutter (stable, null-safety)
- flutter_bloc, equatable
- sqflite, path_provider
- fl_chart, intl, uuid, google_fonts, json_serializable
- bloc_test, flutter_test

## Getting Started

1) Install Flutter SDK and platform toolchains.

2) Create platform scaffolding (if you cloned only this source):
```
flutter create .
```

3) Fetch dependencies:
```
flutter pub get
```

4) Run:
```
flutter run
```

5) Build:
```
flutter build apk   # or ios, macos, windows, linux, web
```

## JSON Import/Export
- Export: Transactions are serialized to prettified JSON. Use the export action (Transactions page menu) or programmatically via `ExportJson` use case. The app provides clipboard copy and save-to-file utilities (Documents directory).
- Import: Paste JSON string or load from file. The import merges by `id` and keeps the latest by `date` when a duplicate exists. Invalid records are skipped. An imported count is shown.

## Folder Structure
```
lib/
  core/
    errors/
    usecase/
    utils/
  features/
    transactions/
      data/
        datasources/local/transaction_local_datasource.dart
        models/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/{transaction,filter,balance}
        pages/{home,transactions,transaction_form,analysis}
        widgets/
  app.dart
  main.dart
```

## Navigation
- The app uses `animated_notch_bottom_bar` with three primary tabs:
  - Transactions
  - Analysis
  - Add (embedded transaction form)
  You can still access the edit form via the list item actions.

## Linting
Uses `flutter_lints` via `analysis_options.yaml`.

## Testing
- Unit tests for use cases and BLoC flows with `bloc_test`.
- Example commands:
```
flutter test
```

## Recording a GIF (optional)
- Use any screen recorder (e.g., Android Studio emulator recorder or macOS Screenshot).
- Record 1–2 minutes showcasing add/edit/delete, filters, and analysis.
- Convert to GIF via tools like `ffmpeg` or online converters.

## Notes
- Seeder is enabled in debug builds to populate demo data on first launch.
- `json_serializable` is included; if you change models, run:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
