# CashFlow - Income Expense Tracker

A production-ready, clean architecture Flutter app to track personal income and expenses. Uses BLoC (flutter_bloc), SQLite (sqflite), Material 3 UI, charts (fl_chart), and Google Fonts. Includes JSON import/export and robust filtering.

## features:
- Clean Architecture with domain/data/presentation layers
- BLoC state management, Equatable states
- SQLite local persistence with migration-safe init
- CRUD: add, edit, delete transactions
- Filters: type, date range, category, search (combined)
- Balance summary: total income, total expense, net balance
- Analysis charts (monthly line, pie bars)
- Import/Export JSON (merge on id; keep latest by date)
- Material 3 design, dark, Google Fonts
- Responsive with `flutter_screenutil` for all sizes (text, paddings, icons)
- Animated notch bottom navigation (Home, Transactions / Analysis / Add)
- Error/empty/loading views and Snackbar notifications

## technologies:
- Flutter (stable, null-safety)
- flutter_bloc, equatable
- sqflite, path_provider
- fl_chart, intl, uuid, google_fonts, json_serializable
- bloc_test, flutter_test

## getting_started:

1) Install Flutter SDK and platform toolchains.

2) Create platform scaffolding (if you cloned only this source): flutter create .

3) Fetch dependencies: flutter pub get

4) Run: flutter run


5) Build: flutter build apk   

## json_export_import:
- Export: Transactions are serialized to prettified JSON. Use the export action (Transactions page menu) or programmatically via `ExportJson` use case. The app provides clipboard copy and save-to-file utilities (Documents directory).
- Import: Paste JSON string or load from file. The import merges by `id` and keeps the latest by `date` when a duplicate exists. Invalid records are skipped. An imported count is shown.

## folder_structure:

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
        bloc/{transaction, filter, balance}
        pages/{home, transactions, analysis, add}
        widgets/
  app.dart
  main.dart

## navigation:
- The app uses `animated_notch_bottom_bar` with four primary tabs:
  - Home
  - Transactions
  - Analysis
  - Add 
  You can still access the edit form via the list item actions.

## linting:
Uses `flutter_lints` via `analysis_options.yaml`.

## testing
- Unit tests for use cases and BLoC flows with bloc_test.
- Widget tests for UI components and pages.
- Integration tests simulate full app flow (add, list, filter).
  • All tests pass (check by flutter test)

