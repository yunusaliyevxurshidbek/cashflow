import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/transaction/transaction_bloc.dart';
import '../../../bloc/transaction/transaction_event.dart';
import '../../../widgets/custom_snacbar.dart';

class JsonDialogs {

  void showExportDialog(BuildContext context, String jsonString) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: SingleChildScrollView(
          child: SelectableText(jsonString),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              CustomSnacbar.show(
                context,
                isError: false,
                text: 'JSON copied to clipboard',
              );
              Navigator.of(context).pop();
            },
            child:  const Text('Copy to Clipboard'),
          ),
        ],
      ),
    );
  }

  void showImportDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Paste JSON here',
            border: OutlineInputBorder(),
          ),
          maxLines: 10,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final json = controller.text.trim();
              if (json.isNotEmpty) {
                context.read<TransactionBloc>().add(ImportJsonRequested(json, source: 'home'));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}