import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  ErrorResponse({required this.error, this.data});

  final String? error;
  final Response? data;

  factory ErrorResponse.fromJson(String? error, {Response? data}) {
    return ErrorResponse(
      data: data,
      error: error ?? "Something Went Wrong.",
    );
  }

  @override
  String toString() {
    return "$error";
  }

  @override
  List<Object?> get props => [error];
}

class Error extends Equatable {
  Error({
    required this.title,
    required this.message,
  });

  final List<String> title;
  final List<String> message;

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      title: json["title"] == null
          ? []
          : List<String>.from(json["title"]!.map((x) => x)),
      message: json["message"] == null
          ? []
          : List<String>.from(json["message"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title.map((x) => x).toList(),
        "message": message.map((x) => x).toList(),
      };

  @override
  String toString() {
    return "$title, $message";
  }

  @override
  List<Object?> get props => [title, message];
}
