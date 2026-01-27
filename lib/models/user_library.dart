class UserLibrary {
  final String id;
  final String userId;
  final int groupId;
  final String? dialogueId; // Added for Phase 11
  final String? speaker;    // Added for Phase 11
  final int? sequenceOrder; // Added for Phase 11
  final String? personalNote;
  final Map<String, dynamic> reviewStats;
  final DateTime createdAt;

  UserLibrary({
    required this.id,
    required this.userId,
    required this.groupId,
    this.dialogueId,
    this.speaker,
    this.sequenceOrder,
    this.personalNote,
    this.reviewStats = const {},
    required this.createdAt,
  });

  factory UserLibrary.fromJson(Map<String, dynamic> json) {
    return UserLibrary(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      groupId: json['group_id'] as int,
      dialogueId: json['dialogue_id'] as String?,
      speaker: json['speaker'] as String?,
      sequenceOrder: json['sequence_order'] as int?,
      personalNote: json['personal_note'] as String?,
      reviewStats: json['review_stats'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
      'dialogue_id': dialogueId,
      'speaker': speaker,
      'sequence_order': sequenceOrder,
      'personal_note': personalNote,
      'review_stats': reviewStats,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
