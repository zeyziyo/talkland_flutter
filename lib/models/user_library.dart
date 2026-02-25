class UserLibrary {
  final String id;
  final String userId;
  final int groupId;
  final String? sourceLang;
  final String? targetLang;
  final String? notebookTitle;
  final String? caption;
  final List<String> tags;
  final int isMemorized;
  final int reviewCount;
  final DateTime? lastReviewed;
  final DateTime createdAt;

  UserLibrary({
    required this.id,
    required this.userId,
    required this.groupId,
    this.sourceLang,
    this.targetLang,
    this.notebookTitle,
    this.caption,
    this.tags = const [],
    this.isMemorized = 0,
    this.reviewCount = 0,
    this.lastReviewed,
    required this.createdAt,
  });

  factory UserLibrary.fromJson(Map<String, dynamic> json) {
    return UserLibrary(
      id: json['id']?.toString() ?? '',
      userId: json['user_id'] as String,
      groupId: json['group_id'] as int,
      sourceLang: json['source_lang'] as String?,
      targetLang: json['target_lang'] as String?,
      notebookTitle: json['notebook_title'] as String?,
      caption: json['caption'] as String? ?? json['personal_note'] as String?, // Legacy fallback
      tags: (json['tags'] is List) 
          ? List<String>.from(json['tags'] as List) 
          : (json['tags'] as String?)?.split(',').where((t) => t.isNotEmpty).toList() ?? [],
      isMemorized: json['is_memorized'] as int? ?? (json['review_stats']?['is_memorized'] == true ? 1 : 0),
      reviewCount: json['review_count'] as int? ?? json['review_stats']?['count'] as int? ?? 0,
      lastReviewed: json['last_reviewed'] != null ? DateTime.parse(json['last_reviewed'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'group_id': groupId,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'notebook_title': notebookTitle,
      'caption': caption,
      'tags': tags,
      'is_memorized': isMemorized,
      'review_count': reviewCount,
      'last_reviewed': lastReviewed?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
