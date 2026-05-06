import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/member/prf_responsible_desk.dart';
import 'package:isar_community/isar.dart';

part 'shared_embeds.g.dart';

@embedded
class PRFLocalMember {
  PRFLocalMember({
    this.ulid,
    this.fullName,
    this.phoneNumber,
    this.profilePictureUrl,
    this.bio,
  });

  final String? ulid;
  final String? fullName;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? bio;
}

@embedded
class PRFLocalClassGroup {
  PRFLocalClassGroup({this.ulid, this.name});

  final String? ulid;
  final String? name;
}

@embedded
class PRFLocalMedia {
  PRFLocalMedia({
    this.temporaryURL,
    this.size,
    this.humanReadableSize,
    this.mimeType,
    this.name,
    this.fileName,
    this.collectionName,
    this.createdAt,
    this.updatedAt,
  });

  String? temporaryURL;
  int? size;
  String? humanReadableSize;
  String? mimeType;
  String? name;
  String? fileName;
  String? collectionName;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@embedded
class PRFLocalSchool {
  PRFLocalSchool({
    this.ulid,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.directions,
    this.distance,
    this.staticDuration,
    this.totalStudents,
    this.address,
    this.latitude,
    this.longitude,
    this.contacts,
    this.institutionType,
  });

  final String? ulid;
  final String? name;
  final String? description;
  final String? directions;
  final String? distance;
  final String? staticDuration;

  final int? totalStudents;
  final String? address;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PRFLocalContact>? contacts;
  @Enumerated(EnumType.ordinal32)
  final PRFInstitutionType? institutionType;
}

@embedded
class PRFLocalContact {
  PRFLocalContact({this.ulid, this.name, this.phone, this.contactType});

  final String? ulid;
  final String? name;
  final String? phone;
  final PRFLocalContactType? contactType;
}

@embedded
class PRFLocalContactType {
  PRFLocalContactType({this.ulid, this.name});

  final String? ulid;
  final String? name;
}

@embedded
class PRFLocalSchoolTerm {
  PRFLocalSchoolTerm({
    this.ulid,
    this.name,
    this.year,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;
  final String? name;
  final int? year;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

@embedded
class PRFLocalMissionType {
  PRFLocalMissionType({
    this.ulid,
    this.name,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;
  final String? name;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

@embedded
class PRFLocalWeatherForecast {
  PRFLocalWeatherForecast({
    this.ulid,
    this.forecastDate,
    this.weatherCodeDescription,
    this.temperature,
    this.visibility,
    this.precipitationProbability,
    this.humidity,
    this.dressingRecommendations,
    this.activityRecommendations,
  });

  String? ulid;
  String? forecastDate;
  String? weatherCodeDescription;
  PRFLocalTemperature? temperature;
  PRFLocalVisibility? visibility;
  PRFLocalPrecipitationProbability? precipitationProbability;
  PRFLocalHumidity? humidity;
  String? dressingRecommendations;
  String? activityRecommendations;
}

@embedded
class PRFLocalTemperature {
  PRFLocalTemperature({
    this.apparentAvg,
    this.apparentMax,
    this.apparentMin,
    this.avg,
    this.max,
    this.min,
  });
  String? apparentAvg;
  String? apparentMax;
  String? apparentMin;
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalVisibility {
  PRFLocalVisibility({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalPrecipitationProbability {
  PRFLocalPrecipitationProbability({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalHumidity {
  PRFLocalHumidity({this.avg, this.max, this.min});
  String? avg;
  String? max;
  String? min;
}

@embedded
class PRFLocalAccountingEvent {
  PRFLocalAccountingEvent({
    this.ulid,
    this.name,
    this.dueDate,
    this.responsibleDesk,
    this.credits,
    this.debits,
    this.balance,
    this.refundCharge,
    this.amountToRefund,
    this.createdAt,
    this.updatedAt,
    this.refunds,
    this.latestRefund,
  });

  final String? ulid;
  final String? name;
  final DateTime? dueDate;

  @Enumerated(EnumType.ordinal32)
  final PRFResponsibleDesk? responsibleDesk;

  final int? credits;
  final int? debits;
  final int? balance;
  final int? refundCharge;
  final int? amountToRefund;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<PRFLocalRefund>? refunds;
  final PRFLocalRefund? latestRefund;
}

@embedded
class PRFLocalRefund {
  PRFLocalRefund({
    this.ulid,
    this.amount,
    this.deficitAmount,
    this.confirmationMessage,
    this.createdAt,
    this.updatedAt,
  });

  final String? ulid;
  final int? amount;
  final int? deficitAmount;
  final String? confirmationMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
