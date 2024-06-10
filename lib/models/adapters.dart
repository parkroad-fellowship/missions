import 'dart:convert';

import 'package:app/models/auth.dart';
import 'package:app/models/prf_class_group.dart';
import 'package:app/models/prf_soul.dart';
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

class PRFClassGroupResponseAdapter extends TypeAdapter<PRFClassGroupResponse> {
  @override
  final typeId = 1;

  @override
  PRFClassGroupResponse read(BinaryReader reader) {
    return PRFClassGroupResponse.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, PRFClassGroupResponse obj) {
    writer.write(json.encode(obj.toJson()));
  }
}

class PRFSoulsAdapter extends TypeAdapter<PRFSoulResponse> {
  @override
  final typeId = 2;

  @override
  PRFSoulResponse read(BinaryReader reader) {
    return PRFSoulResponse.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, PRFSoulResponse obj) {
    writer.write(json.encode(obj.toJson()));
  }
}
