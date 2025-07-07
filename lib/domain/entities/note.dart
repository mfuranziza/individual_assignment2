import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Note copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Note(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, text, createdAt, updatedAt, userId];
}
