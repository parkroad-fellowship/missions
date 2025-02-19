enum PRFMediaModel {
  missionPhotos,
  missionFitChecks,
  missionSessionAudios,
  eventPhotos;

  String get collection {
    switch (this) {
      case PRFMediaModel.missionPhotos:
        return 'mission-photos';
      case PRFMediaModel.missionFitChecks:
        return 'mission-fit-checks';
      case PRFMediaModel.missionSessionAudios:
        return 'session-audios';
      case PRFMediaModel.eventPhotos:
        return 'event-photos';
    }
  }
}
