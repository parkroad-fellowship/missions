enum PRFMediaModel {
  missionPhotos,
  missionVideos,
  missionFitChecks,
  missionSessionAudios,
  missionSessionLiveRecordings,
  eventPhotos,
  memberProfilePictures,
  allocationEntryReceipts
  ;

  String get collection {
    switch (this) {
      case PRFMediaModel.missionPhotos:
        return 'mission-photos';
      case PRFMediaModel.missionVideos:
        return 'mission-videos';
      case PRFMediaModel.missionFitChecks:
        return 'mission-fit-checks';
      case PRFMediaModel.missionSessionAudios:
        return 'session-audios';
      case PRFMediaModel.missionSessionLiveRecordings:
        return 'session-live-recordings';
      case PRFMediaModel.eventPhotos:
        return 'event-photos';
      case PRFMediaModel.memberProfilePictures:
        return 'profile-pictures';
      case PRFMediaModel.allocationEntryReceipts:
        return 'allocation-entry-receipts';
    }
  }
}
