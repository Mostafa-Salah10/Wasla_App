class RealTimeMsgModel {
  final int id;
  final int chatId;
  final String senderId;
  final String receiverId;
  final String? nameReceiver;
  final String? nameSender;
  final String? profileReceiver;
  final String? profileSender;
  final String? messageText;
  final String? audio;
  final int type;
  final bool isMine;
  final DateTime sentAt;
  final DateTime? readAt;
  final bool isSent;
  final bool isEdited;
  final List<String> files;
  final String? localId;

  RealTimeMsgModel({
    this.localId,
    this.nameSender,
    this.profileSender,
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    this.nameReceiver,
    this.profileReceiver,
    this.messageText,
    this.audio,
    required this.type,
    required this.isMine,
    required this.sentAt,
    this.readAt,
    required this.isSent,
    required this.isEdited,
    required this.files,
  });

  factory RealTimeMsgModel.fromJson(Map<String, dynamic> map) {
    return RealTimeMsgModel(
      nameSender: map['nameSender'],
      profileSender: map['profileSender'],
      id: map['id'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      nameReceiver: map['nameReceiver'],
      profileReceiver: map['profileReceiver'],
      messageText: map['messageText'],
      audio: map['audio'],
      type: map['type'],
      isMine: map['isMine'],
      sentAt: DateTime.parse(map['sentAt']),
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      isSent: map['isSent'],
      isEdited: map['isEdited'],
      localId: map['localId'],
      files: List<String>.from(map['files'] ?? []),
    );
  }
}
