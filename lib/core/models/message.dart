import 'package:equatable/equatable.dart';

class Message extends Equatable {
  Message({
    required this.message,
  });

  final String? message;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
      };

  @override
  String toString() {
    return "$message, ";
  }

  @override
  List<Object?> get props => [message];
}

/*
{
	"message": "Logged out Successfully"
}*/