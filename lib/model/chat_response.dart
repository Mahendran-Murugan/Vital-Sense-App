class Chat {
  final String message;
  Chat({
    required this.message,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        message: json['message'],
      );
}
