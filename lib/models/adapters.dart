import 'dart:convert';

import 'package:app/models/auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PRFUserAdapter extends TypeAdapter<PRFUser> {
  @override
  final typeId = 0;

  @override
  PRFUser read(BinaryReader reader) {
    return PRFUser.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, PRFUser obj) {
    writer.write(json.encode(obj.toJson()));
  }
}
