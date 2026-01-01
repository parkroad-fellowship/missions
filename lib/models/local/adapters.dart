import 'dart:convert';

import 'package:app/models/remote/auth.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

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

class PRFExpenseCategoryResponseAdapter
    extends TypeAdapter<PRFExpenseCategoryResponse> {
  @override
  final typeId = 3;

  @override
  PRFExpenseCategoryResponse read(BinaryReader reader) {
    return PRFExpenseCategoryResponse.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, PRFExpenseCategoryResponse obj) {
    writer.write(json.encode(obj.toJson()));
  }
}

class PRFPaymentTypeResponseAdapter
    extends TypeAdapter<PRFPaymentTypeResponse> {
  @override
  final typeId = 5;

  @override
  PRFPaymentTypeResponse read(BinaryReader reader) {
    return PRFPaymentTypeResponse.fromJson(
      Map<String, dynamic>.of(
        json.decode(reader.read() as String) as Map<String, dynamic>,
      ),
    );
  }

  @override
  void write(BinaryWriter writer, PRFPaymentTypeResponse obj) {
    writer.write(json.encode(obj.toJson()));
  }
}
