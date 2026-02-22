class ChatParticipant {
  final String id;
  final String dialogueId;
  String name;
  final String role; // 'user' or 'ai'
  String gender; // 'male', 'female'
  String langCode; // 'en-US', 'ko-KR'
  int? avatarColor; // 0xFF...

  ChatParticipant({
    required this.id,
    required this.dialogueId,
    required this.name,
    required this.role,
    this.gender = 'female',
    this.langCode = 'en-US',
    this.avatarColor,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] as String,
      dialogueId: json['dialogue_id'] as String? ?? '', // dialogue_id가 없는 Master 레코드 대응
      name: json['name'] as String,
      role: json['role'] as String,
      gender: json['gender'] as String? ?? 'female',
      langCode: json['lang_code'] as String? ?? 'en-US',
      avatarColor: json['avatar_color'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dialogue_id': dialogueId,
      'name': name,
      'role': role,
      'gender': gender,
      'lang_code': langCode,
      'avatar_color': avatarColor,
    };
  }

  ChatParticipant copyWith({
    String? id,
    String? dialogueId,
    String? name,
    String? role,
    String? gender,
    String? langCode,
    int? avatarColor,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      dialogueId: dialogueId ?? this.dialogueId,
      name: name ?? this.name,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      langCode: langCode ?? this.langCode,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}
