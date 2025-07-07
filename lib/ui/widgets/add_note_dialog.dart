import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  final Function(String) onAddNote;

  const AddNoteDialog({super.key, required this.onAddNote});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: 'Enter your note...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_textController.text.trim().isNotEmpty) {
              widget.onAddNote(_textController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
