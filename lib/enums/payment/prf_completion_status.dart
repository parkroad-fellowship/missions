import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum PRFCompletionStatus {
  @JsonValue(1)
  incomplete(1, 'Incomplete', Icons.watch_later_outlined),
  @JsonValue(2)
  complete(2, 'Complete', Icons.check)
  ;

  const PRFCompletionStatus(this.apiKey, this.name, this.icon);

  final int apiKey;
  final String name;
  final IconData icon;
}
