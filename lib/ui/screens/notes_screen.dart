import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_assignment2/domain/entities/user.dart';
import 'package:individual_assignment2/ui/bloc/notes_bloc.dart';
import 'package:individual_assignment2/ui/screens/auth_screen.dart';
import 'package:individual_assignment2/ui/widgets/add_note_dialog.dart';
import 'package:individual_assignment2/ui/widgets/edit_note_dialog.dart';
import 'package:individual_assignment2/ui/widgets/note_card.dart';

import '../bloc/auth_bloc.dart';

class NotesScreen extends StatefulWidget {
  final User user;

  const NotesScreen({super.key, required this.user});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(NotesFetched(userId: widget.user.id));
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        onAddNote: (text) {
          context.read<NotesBloc>().add(
                NoteAdded(text: text, userId: widget.user.id),
              );
        },
      ),
    );
  }

  void _showEditNoteDialog(String noteId, String currentText) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(
        initialText: currentText,
        onUpdateNote: (text) {
          context.read<NotesBloc>().add(
                NoteUpdated(
                  id: noteId,
                  text: text,
                  userId: widget.user.id, // Add this line
                ),
              );
        },
      ),
    );
  }

  void _deleteNote(String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotesBloc>().add(
                    NoteDeleted(
                      id: noteId,
                      userId: widget.user.id, // Add this line
                    ),
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotesOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoaded || state is NotesOperationSuccess) {
              final notes = state is NotesLoaded
                  ? state.notes
                  : (state as NotesOperationSuccess).notes;

              if (notes.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nothing here yet—tap ➕ to add a note.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onEdit: () => _showEditNoteDialog(note.id, note.text),
                    onDelete: () => _deleteNote(note.id),
                  );
                },
              );
            } else if (state is NotesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotesBloc>().add(
                              NotesFetched(userId: widget.user.id),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
