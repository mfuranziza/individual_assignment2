import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:individual_assignment2/domain/entities/note.dart';

import '../../data/repositories/notes_respository.dart';

// Events
abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

class NotesFetched extends NotesEvent {
  final String userId;
  const NotesFetched({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class NoteAdded extends NotesEvent {
  final String text;
  final String userId;
  const NoteAdded({required this.text, required this.userId});
  @override
  List<Object?> get props => [text, userId];
}

// Update NoteUpdated event
class NoteUpdated extends NotesEvent {
  final String id;
  final String text;
  final String userId; // Add this

  const NoteUpdated({
    required this.id,
    required this.text,
    required this.userId, // Add this
  });

  @override
  List<Object?> get props => [id, text, userId]; // Add userId to props
}

// Update NoteDeleted event
class NoteDeleted extends NotesEvent {
  final String id;
  final String userId; // Add this

  const NoteDeleted({
    required this.id,
    required this.userId, // Add this
  });

  @override
  List<Object?> get props => [id, userId]; // Add userId to props
}

// States
abstract class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  const NotesLoaded({required this.notes});
  @override
  List<Object?> get props => [notes];
}

class NotesError extends NotesState {
  final String message;
  const NotesError({required this.message});
  @override
  List<Object?> get props => [message];
}

class NotesOperationSuccess extends NotesState {
  final String message;
  final List<Note> notes;
  const NotesOperationSuccess({required this.message, required this.notes});
  @override
  List<Object?> get props => [message, notes];
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(NotesInitial()) {
    on<NotesFetched>(_onNotesFetched);
    on<NoteAdded>(_onNoteAdded);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
  }

  Future<void> _onNotesFetched(
      NotesFetched event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onNoteAdded(NoteAdded event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.addNote(event.text, event.userId);
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesOperationSuccess(
          message: 'Note added successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  // Update _onNoteUpdated method
  Future<void> _onNoteUpdated(
      NoteUpdated event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.updateNote(event.id, event.text);
      // Use the userId from the event instead of trying to get it from state
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesOperationSuccess(
          message: 'Note updated successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

// Update _onNoteDeleted method
  Future<void> _onNoteDeleted(
      NoteDeleted event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.deleteNote(event.id);
      // Use the userId from the event instead of trying to get it from state
      final notes = await _notesRepository.fetchNotes(event.userId);
      emit(NotesOperationSuccess(
          message: 'Note deleted successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
