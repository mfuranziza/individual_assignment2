import 'package:flutter/material.dart';

class EditNoteDialog extends StatefulWidget {
  final String initialText;
  final Function(String) onUpdateNote;

  const EditNoteDialog({
    super.key,
    required this.initialText,
    required this.onUpdateNote,
  });

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
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
              widget.onUpdateNote(_textController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
