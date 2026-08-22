// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing In ...';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get pleaseWaitBrief => 'Please wait ...';

  @override
  String get orDivider => 'OR';

  @override
  String get signInPanelBody =>
      'One home for the life of Parkroad Fellowship — serve missions together, give, pray for one another and stay close to the community wherever you are.';

  @override
  String get password => 'Password';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get missions => 'Missions';

  @override
  String get myAccount => 'My Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String get myProfile => 'My Profile';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get email => 'Email';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get viewProfileDetails => 'Your name and email address';

  @override
  String get byUsing => 'By using this app, you are agreeing to our\n';

  @override
  String get terms => ' Terms';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => ' Privacy Policy';

  @override
  String get noMissions => 'No missions';

  @override
  String get pleaseWait => 'Please wait for an update from the missions desk';

  @override
  String get missionsSearchHint => 'Search missions';

  @override
  String get activeNow => 'Active now';

  @override
  String get statusAvailable => 'Available';

  @override
  String missionStart(String missionDate, String missionTime) {
    return 'Starts on: $missionDate, $missionTime';
  }

  @override
  String missionEnd(String missionDate, String missionTime) {
    return 'Ends on: $missionDate, $missionTime';
  }

  @override
  String missionType(String missionType) {
    return 'Mission Type: $missionType';
  }

  @override
  String get missionDetails => 'Mission Details';

  @override
  String get sendMe => 'Send Me';

  @override
  String get going => 'Missioners';

  @override
  String get missionGround => 'Mission Ground';

  @override
  String get noSubscribers => 'No subscribers';

  @override
  String comingFrom(String residence) {
    return 'Coming from: $residence';
  }

  @override
  String get successfullySubscribed =>
      'Your request to service this mission has been received. Should there be any changes, you will be notified.';

  @override
  String get myMissions => 'My Missions';

  @override
  String get address => 'Address & Directions';

  @override
  String get missionPrepNotes => 'Preparation Notes';

  @override
  String get population => 'Population';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get noUpcomingMissions => 'No upcoming missions';

  @override
  String get past => 'Past';

  @override
  String get noPastMissions => 'No past missions';

  @override
  String get theme => 'Theme/Topic';

  @override
  String get souls => 'Souls';

  @override
  String get recordSoul => 'Record a Soul';

  @override
  String get fullName => 'Full Name';

  @override
  String get admissionNumber => 'Admission Number';

  @override
  String get enterAdmissionNumber => 'Enter Admission Number';

  @override
  String get classGroup => 'Class';

  @override
  String get record => 'Record';

  @override
  String get soulRecorded => 'Soul recorded';

  @override
  String get recording => 'Recording ...';

  @override
  String get selectClass => 'Select Class';

  @override
  String get debriefNotes => 'Debrief Notes';

  @override
  String get note => 'Notes';

  @override
  String get noteRecorded => 'Note recorded';

  @override
  String get contactPersons => 'Contact Persons';

  @override
  String get successfullyWithdrawn =>
      'You have successfully withdrawn from this mission';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get missionariesNeeded => 'Still Needed';

  @override
  String get missionariesRequested => 'Requested missioners';

  @override
  String get learn => 'Learn';

  @override
  String progress(int progress) {
    return 'Progress: $progress%';
  }

  @override
  String get courseDetails => 'Course Details';

  @override
  String get description => 'Description';

  @override
  String percentage(int progress) {
    return '$progress%';
  }

  @override
  String get modules => 'Modules';

  @override
  String get moduleDetails => 'Module Details';

  @override
  String get lessons => 'Lessons';

  @override
  String get lessonResources => 'Resources';

  @override
  String get lessonDetails => 'Lesson Details';

  @override
  String get content => 'Content';

  @override
  String get video => 'Video (Tap to play)';

  @override
  String get document => 'Document (Tap to view)';

  @override
  String get audio => 'Audio (Tap to play)';

  @override
  String get complete => 'Complete';

  @override
  String get completing => 'Completing ...';

  @override
  String get completed => 'Completed';

  @override
  String get noCourses => 'No courses';

  @override
  String get recentCourses => 'Recent Courses';

  @override
  String get yetToBeEnroled => 'You are yet to be enroled for a course';

  @override
  String get registerStudent => 'Register as a new student';

  @override
  String get registerNewStudent => 'Register a new student account';

  @override
  String get studentIntro =>
      'To keep your identity private, you get random credentials that you can use to access the app. Please ensure to save them somewhere if you want to come back to the app at another time or on a different device.';

  @override
  String get iAmReady => 'I am ready';

  @override
  String get registering => 'Registering ...';

  @override
  String get registered =>
      'You have been registered successfully. Please save your credentials somewhere safe.';

  @override
  String get iHaveWritten => 'I have written them down';

  @override
  String credentials(String email, int password) {
    return 'Your credentials\n\nEmail: $email\nPassword: $password\n\nPlease write them down, they will disappear once you log out';
  }

  @override
  String get faq => 'FAQs';

  @override
  String get recentFaqs => 'Recent FAQs';

  @override
  String get noFaqs => 'No FAQs';

  @override
  String get myQuestions => 'My Questions';

  @override
  String get noQuestions => 'No questions';

  @override
  String get replies => 'Replies';

  @override
  String get noReplies => 'No replies yet';

  @override
  String get yourQuestion => 'Your Question';

  @override
  String get createQuestion => 'Create Question';

  @override
  String get enquiry => 'Enquiry';

  @override
  String get enquiryRecorded =>
      'Your enquiry has been recorded. Please wait for a response';

  @override
  String get reply => 'Reply';

  @override
  String get replySent => 'Your reply has been sent';

  @override
  String get replying => 'Replying ...';

  @override
  String get rules =>
      'Don\'t share your contact information or any personal information in your questions or replies';

  @override
  String get studentEnquiries => 'Students';

  @override
  String get studentQuestions => 'Student Questions';

  @override
  String get askQuestion => 'to ask a question';

  @override
  String get announcements => 'Announcements';

  @override
  String get noAnnouncements => 'No announcements';

  @override
  String get pleaseWaitForOS =>
      'Please wait for an update from the organising secretary\'s desk';

  @override
  String publishedAt(String publishingDate) {
    return 'Date: $publishingDate';
  }

  @override
  String get missionQuestions => 'Mission Questions';

  @override
  String get missionQuestion => 'Mission Question';

  @override
  String get expenseTracking => 'Financials Tracking';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get addToken => 'Add Token';

  @override
  String get addExpense => 'Add an expense';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get addQuestion => 'Add a question';

  @override
  String get addQuestionSubTitle => 'Share any questions from learners';

  @override
  String get addQuestionSection => 'Question Details';

  @override
  String get addQuestionDesc => 'What did the students want to know?';

  @override
  String get questionRecorded => 'This question has been recorded';

  @override
  String get recordQuestion => 'Record question';

  @override
  String get noNotes => 'No notes';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get iWantTo => 'Right now, I want to';

  @override
  String get goToAMission => 'View missions';

  @override
  String get learnSomething => 'Learn something';

  @override
  String get ministerToAStudent => 'Minister to a student';

  @override
  String get all => 'All';

  @override
  String get subscribed => 'Subscribed';

  @override
  String version(String version) {
    return ' v$version';
  }

  @override
  String get faqs => 'for some answers';

  @override
  String get lookingFor => 'I am looking';

  @override
  String get askAQuestion => 'Ask a question';

  @override
  String get ask => 'Ask';

  @override
  String get questions => 'Questions';

  @override
  String get memberships => 'Memberships';

  @override
  String get prayerAlert => 'Prayer watch';

  @override
  String get amen => 'Weka tick ✅';

  @override
  String get viewCredentials => 'for my credentials';

  @override
  String get financials => 'Financials';

  @override
  String get confirmationMessage => 'Confirmation Message';

  @override
  String get expenseCategory => 'Expense Category';

  @override
  String get amountDetails => 'Amount Details';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get narration => 'Narration';

  @override
  String get amountSpent => 'Amount spent';

  @override
  String get selectExpenseCategory => 'Select the expense category';

  @override
  String get selectTransactionType => 'Select the transaction Type';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get enterCharge => 'Enter transaction cost';

  @override
  String get enterNarration => 'Describe what the money was used for';

  @override
  String get enterConfirmationMessage => 'Enter confirmation message';

  @override
  String get askMissionDeskToDisburseFunds =>
      'Ask the missions desk to disburse funds';

  @override
  String get amountReceived => 'Amount received (Token included)';

  @override
  String get tokenAmount => 'Token from institution';

  @override
  String get amountToRefund => 'Amount to refund \n(Charge removed)';

  @override
  String get refundedAmount => 'Refunded amount';

  @override
  String get fullyRefunded => 'Fully refunded?';

  @override
  String get balance => 'Balance';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get unitCost => 'Unit Cost';

  @override
  String get unitCostDesc => 'Enter cost per item';

  @override
  String get quantity => 'Quantity';

  @override
  String get charge => 'Transaction Charge';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentDesc => 'Describe what the money was used for...';

  @override
  String get confirmationMsg => 'Enter confirmation message (SMS)';

  @override
  String get recordExpense => 'Record Expense';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get subTotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get item => 'Item';

  @override
  String get unitCostAndQty => 'Unit x Qty';

  @override
  String get summary => 'Summary';

  @override
  String get breakdown => 'Breakdown';

  @override
  String get figure => 'Figure';

  @override
  String get refundCharge => 'Cost to refund';

  @override
  String get tokenRecorded => 'Token recorded';

  @override
  String get expenseRecorded => 'Expense recorded';

  @override
  String get studentFaqs => 'View student FAQs';

  @override
  String get weather => 'Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String visibility(String min, String max, String avg) {
    return 'Visibility: $min - $max ($avg)';
  }

  @override
  String get rain => 'Rain';

  @override
  String precipitationProbability(String min, String max, String avg) {
    return 'Precipitation Probability: $min - $max ($avg)';
  }

  @override
  String get dressingRecommendations => 'Dressing Recommendations';

  @override
  String day(int day, String summary) {
    return 'Day $day | $summary';
  }

  @override
  String get depaturePlanning => 'Depature Planning';

  @override
  String estimatedTravelTime(String time) {
    return 'Estimated Travel Time: $time';
  }

  @override
  String get estimatedDistance => 'Distance';

  @override
  String get estimationDisclaimer =>
      '* This estimate is made from Tumaini House to the mission ground and may not be accurate. Please plan accordingly.';

  @override
  String get gallery => 'Gallery';

  @override
  String get upload => 'Upload';

  @override
  String get willUpload =>
      'Your media will be uploaded as you continue to use the app';

  @override
  String get doneUploading =>
      'Your media has been uploaded, you can refresh the page to see them.';

  @override
  String get tapToAdd => 'Tap here to add';

  @override
  String get cancel => 'Cancel';

  @override
  String get noSessions => 'No sessions';

  @override
  String get sessions => 'Sessions';

  @override
  String get time => 'Start Time - End Time';

  @override
  String get facilitator => 'Facilitator';

  @override
  String get speaker => 'Speaker';

  @override
  String get notes => 'Preparation notes';

  @override
  String get selectFacilitator => 'Select Facilitator';

  @override
  String get selectSpeaker => 'Select Speaker';

  @override
  String get enterNotes => 'Enter preparation notes';

  @override
  String get addStartEnd => 'Add start and end time';

  @override
  String get sessionRecorded => 'Session recorded';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get blank => '';

  @override
  String get confirmDelete => 'Are you sure you want to delete this?';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get delete => 'Delete';

  @override
  String get sessionDeleted => 'Session deleted';

  @override
  String get noPhotos => 'No photos';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get suggestAMission => 'Suggest a mission';

  @override
  String get suggestMissionDescription =>
      'Suggest a mission ground for PRF to consider. This is not a request to service the mission, but rather a suggestion for future missions.';

  @override
  String get suggestMissionSubTitle =>
      'Share a mission ground with us and we will take it from there';

  @override
  String get noSuggestedMissionGrounds => 'No suggested mission grounds';

  @override
  String get recentSuggestions => 'Recent Suggestions';

  @override
  String missionGroundRecorded(String ground) {
    return 'Your suggested mission to $ground has been recorded';
  }

  @override
  String get enterMissionGround => 'Enter mission ground';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get enterContactPerson => 'Enter contact person\'s name';

  @override
  String get contactNumber => 'Contact\'s Phone Number';

  @override
  String get enterContactNumber => 'Enter contact person\'s number';

  @override
  String get suggest => 'Suggest';

  @override
  String get suggesting => 'Suggesting...';

  @override
  String get editMissionSuggestion => 'Edit Mission Suggestion';

  @override
  String get editMissionSuggestionSubTitle =>
      'You can edit your suggested mission ground details below';

  @override
  String get selectStatus => 'Select status';

  @override
  String get status => 'Status';

  @override
  String get comments => 'Notes';

  @override
  String get give => 'Give';

  @override
  String get considerGiving => 'Consider giving';

  @override
  String get amount => 'Amount';

  @override
  String get reasonForGiving => 'Reason for giving';

  @override
  String get selectReasonForGiving => 'Select reason for giving';

  @override
  String get categories => 'Categories';

  @override
  String get whatWouldYouLikeToKnow => 'What would you like to know?';

  @override
  String get sessionDetails => 'Session Details';

  @override
  String get edit => 'Edit';

  @override
  String get recordings => 'Recordings';

  @override
  String get noRecordings => 'No recordings';

  @override
  String get uploadRecording => 'Upload recording';

  @override
  String get addMore => 'Add more';

  @override
  String recordingItem(int index) {
    return 'Recording $index';
  }

  @override
  String get transcript => 'Transcript';

  @override
  String get viewTranscript => 'Transcript';

  @override
  String get transcriptProcessing => 'Transcript processing. Please wait.';

  @override
  String get inTesting => 'In testing';

  @override
  String downloadTeaching(String size) {
    return 'Download teaching: $size';
  }

  @override
  String get downloaded =>
      'Your download has started. Check your download folder once it\'s complete.';

  @override
  String get enterDebriefNote => 'Enter debrief notes';

  @override
  String get enterQuestion => 'Enter question';

  @override
  String get registerForEvent => 'Register for an event';

  @override
  String get events => 'Events';

  @override
  String get pleaseWaitOS =>
      'Please wait for an update from the organising secretary\'s desk';

  @override
  String get noEvents => 'No events';

  @override
  String get registeredEvent => 'Registered';

  @override
  String get eventDetails => 'Event Details';

  @override
  String get info => 'Information';

  @override
  String get capacity => 'Capacity';

  @override
  String capacityDesc(int count) {
    return '$count missioners';
  }

  @override
  String get duration => 'Duration';

  @override
  String durationDesc(int count) {
    return '$count days';
  }

  @override
  String subscriptionsNeeded(String count) {
    return 'Open registrations: $count';
  }

  @override
  String get tickets => 'Tickets';

  @override
  String get enterTickets => 'Enter number of tickets';

  @override
  String get register => 'Register';

  @override
  String get eventRegistrationRecorded =>
      'Your event subscription has been recorded';

  @override
  String get cancelRegistration => 'Cancel subscription';

  @override
  String get confirmCancellation => 'Confirm cancellation';

  @override
  String get subscriptionCancelled => 'Subscription cancelled';

  @override
  String get next => 'Confirm';

  @override
  String get unread => 'Unread';

  @override
  String get replied => 'Replied';

  @override
  String get noModules => 'No modules';

  @override
  String get recentModules => 'Recent Modules';

  @override
  String get noLessons => 'No lessons';

  @override
  String get recentLessons => 'Recent Lessons';

  @override
  String get noSouls => 'No souls';

  @override
  String get noSoulsDesc => 'Please record any decisions for Jesus here';

  @override
  String get joinWhatsApp => 'Join WhatsApp';

  @override
  String get navigate => 'Navigate';

  @override
  String get successfullyUpdated =>
      'Your profile picture has been successfully updated';

  @override
  String get bio => 'Bio';

  @override
  String get directed => 'Note: You will be redirected to the payment page';

  @override
  String get testing => 'This is a test. No real money will be charged.';

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get submitPrayerRequest => 'Share a prayer request';

  @override
  String get submitting => 'Submitting...';

  @override
  String get prayerRequests => 'Prayer requests';

  @override
  String get prayerRequest => 'Prayer request';

  @override
  String get recentPrayerRequests => 'Recent Prayer Requests';

  @override
  String get prayerRequestSubmitted =>
      'Your prayer request has been submitted.';

  @override
  String get submit => 'Submit';

  @override
  String get fillAllFields => 'Please fill in all fields.';

  @override
  String get title => 'Title';

  @override
  String get getNotified => 'Get Notified!';

  @override
  String get allowNotifications =>
      'Allow PRF Missions to send you prayer and mission notifications.';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get pleaseWaitForFunds =>
      'Please inform the mission desk to confirm funds were issued.';

  @override
  String get pleaseWaitForUpload => 'Please wait while we upload this file.';

  @override
  String get successfulUpload => 'Your file has been successfully uploaded.';

  @override
  String get receipts => 'Receipts:';

  @override
  String get addedOn => 'Added on';

  @override
  String get welcomeBack =>
      'Welcome back! Please sign in with your PRF organisation email to continue.';

  @override
  String get welcome => 'Welcome back!';

  @override
  String get longPressToEdit => 'Long press to edit';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get noPrayerRequests => 'No prayer requests';

  @override
  String get noPrayerRequestsDesc =>
      'You have not submitted any prayer requests yet. Tap the button below to submit one.';

  @override
  String get submitPrayerRequestDesc =>
      'Share your prayer request with the PRF community. We will pray for you.';

  @override
  String get addMissionPhotos => 'Add mission media';

  @override
  String get addMissionPhotosDesc =>
      'Share your mission moments with beautiful photos and videos';

  @override
  String areGoing(int number) {
    return '$number going';
  }

  @override
  String get missionIntelligence => 'Mission Intelligence';

  @override
  String get eventIntelligence => 'Event Intelligence';

  @override
  String get addEventPhotos => 'Add photos to share memories from this event';

  @override
  String get errorLoadingPhotos => 'Error loading photos';

  @override
  String get addNote => 'Add a debrief note';

  @override
  String get addSoul => 'Add a soul';

  @override
  String get addSession => 'Add a session';

  @override
  String get noNotesDesc =>
      'Notes will help you remember important details from this mission';

  @override
  String get sessionsWillAppearHere =>
      'Please use this section to schedule speakers and facilitators';

  @override
  String get questionsWillAppearHere =>
      'Please add any questions asked by students';

  @override
  String get soulsWillAppearHere =>
      'Souls will appear here when they are recorded';

  @override
  String get trackExpensesToStayOrganized =>
      'Track expenses to stay organized and accountable';

  @override
  String get noExpenses => 'No expenses yet';

  @override
  String get addDebriefNote => 'Add debrief note';

  @override
  String get addDebriefNoteSubTitle =>
      'Share your thoughts and observations from the mission';

  @override
  String get addDebriefNoteSection => 'Note Details';

  @override
  String get addDebriefNoteDesc => 'What are your thoughts so far?';

  @override
  String get addSoulSubTitle =>
      'Record a decision for Jesus made during this mission';

  @override
  String get studentInformation => 'Student Information';

  @override
  String get updateRegistration => 'Update Registration';

  @override
  String get refundInformation => 'Refund Information';

  @override
  String get refundDesc => 'Remaining balance and token needs to be refunded';

  @override
  String get refundDetails => 'Refund Payment Details';

  @override
  String get paybillNumber => 'Paybill Number';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get refundText =>
      'Please send the balance indicated above to the M-Pesa details and share the confirmation to complete the refund process.';

  @override
  String get financialOverview => 'Mission Financial Overview';

  @override
  String get transactionCost => 'Transaction Cost';

  @override
  String get member => 'Member';

  @override
  String get decisionType => 'Type of Decision';

  @override
  String get selectDecisionType =>
      'Select the decision this learner made today';

  @override
  String get addDecisionNote =>
      'What would you like to point out concerning this soul?';

  @override
  String get welcomeIntro => 'Welcome to PRF Missions';

  @override
  String get paymentActions => 'Payment Actions';

  @override
  String get completePayment => 'Complete Payment';

  @override
  String get openPaymentLink => 'Open payment link';

  @override
  String get refreshStatus => 'Refresh Status';

  @override
  String get checkPaymentStatus => 'Check payment status';

  @override
  String get longPressForActions => 'Long press for actions';

  @override
  String get startGiving => 'Start your giving journey today';

  @override
  String get tapForActions => 'Press for payment actions';

  @override
  String get recentPayments => 'Recent Payments';

  @override
  String get tapToStartRecording => 'Tap to start recording';

  @override
  String get recordingWillContinueInBackground =>
      'Recording will continue even when the app goes to background';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get liveRecording => 'Live recording';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get recordingPaused => 'Recording Paused';

  @override
  String get resume => 'Resume';

  @override
  String get recordingCompleted => 'Recording Completed';

  @override
  String get recordAnother => 'Record Another';

  @override
  String get recordingError => 'Recording Error';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get wrapped => 'View my impact';

  @override
  String get wrappedTagline => 'Missions Wrapped';

  @override
  String get wrappedSwipeHint => 'Swipe to feel your journey';

  @override
  String wrappedYourYear(int year) {
    return 'Your $year';
  }

  @override
  String get wrappedMissionsTitle => 'Your Mission Journey';

  @override
  String get wrappedTotalMissions => 'Total Missions';

  @override
  String get wrappedSchoolsReached => 'Schools Reached';

  @override
  String get wrappedCompletion => 'Completion';

  @override
  String wrappedMissionStreakTitle(int count) {
    return '$count mission streak';
  }

  @override
  String get wrappedMissionStreakSubtitle => 'Consistency looks great on you';

  @override
  String get wrappedImpactTitle => 'Your Impact';

  @override
  String get wrappedSoulsTouched => 'Souls Touched';

  @override
  String wrappedMostImpactfulMissionSubtitle(int soulsCount) {
    return 'Your most impactful mission reached $soulsCount souls';
  }

  @override
  String get wrappedDecisionTypes => 'Decision Types';

  @override
  String get wrappedDecisionTypesSubtitle =>
      'Top categories from your mission impact';

  @override
  String get wrappedLearningTitle => 'Your Learning Growth';

  @override
  String get wrappedCoursesCompleted => 'Courses Completed';

  @override
  String get wrappedLessonsCompleted => 'Lessons Completed';

  @override
  String get wrappedOverallProgress => 'Overall Progress';

  @override
  String wrappedLearningStreakTitle(int count) {
    return '$count day learning streak';
  }

  @override
  String get wrappedLearningStreakSubtitle => 'Keep the momentum alive';

  @override
  String get wrappedPrayerTitle => 'Your Prayer Journey';

  @override
  String get wrappedPrayerResponses => 'Prayer Responses';

  @override
  String wrappedPrayerConsistencyTitle(int count) {
    return '$count days of prayer';
  }

  @override
  String get wrappedPrayerConsistencySubtitle => 'Your faith journey continues';

  @override
  String get wrappedEventsTitle => 'Your Event Participation';

  @override
  String get wrappedEventsAttended => 'Events Attended';

  @override
  String get wrappedUpcomingEvents => 'Upcoming Events';

  @override
  String get wrappedActiveParticipantTitle => 'Active Participant';

  @override
  String get wrappedActiveParticipantSubtitle =>
      'Thank you for being part of this community';

  @override
  String get wrappedSummaryTitle => 'What a Year!';

  @override
  String wrappedHighlightsTitle(int year) {
    return '$year highlights';
  }

  @override
  String get wrappedHighlightsSubtitle => 'A snapshot of your impact this year';

  @override
  String get wrappedMissionsLabel => 'Missions';

  @override
  String get wrappedCoursesLabel => 'Courses';

  @override
  String get wrappedEventsLabel => 'Events';

  @override
  String wrappedThankYouSubtitle(int year) {
    return 'Thank you for making an impact in $year!';
  }

  @override
  String get wrappedNextYearCta => 'Let\'s make next year even better!';

  @override
  String get wrappedNoImpactDataTitle => 'No Impact Data Yet';

  @override
  String get wrappedNoImpactDataDescription =>
      'Start participating in missions and activities to see your impact wrapped!';

  @override
  String get wrappedGoBack => 'Go Back';

  @override
  String get wrappedSomethingWentWrong => 'Something Went Wrong';

  @override
  String get wrappedTryAgain => 'Try Again';

  @override
  String get wrappedCloseSemantics => 'Close wrapped';

  @override
  String get wrappedSkipToSummary => 'Skip';

  @override
  String get wrappedSkipToSummarySemantics => 'Skip to summary page';

  @override
  String wrappedPageSemantics(int pageNumber, String title) {
    return 'Page $pageNumber: $title';
  }

  @override
  String wrappedProgressSemantics(int currentPage, int totalPages) {
    return 'Wrapped page $currentPage of $totalPages';
  }

  @override
  String impact(int year) {
    return '$year Review';
  }

  @override
  String get unknownCategory => 'Unknown Category';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'Using system setting';

  @override
  String get lightMode => 'Light mode enabled';

  @override
  String get darkModeEnabled => 'Dark mode enabled';

  @override
  String get answerFaqs => 'Answer FAQs';

  @override
  String get receiptPdf => 'Receipt PDF';

  @override
  String get venue => 'Venue';

  @override
  String get dateRange => 'Date Range';

  @override
  String get date => 'Date';

  @override
  String get time_2 => 'Time';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get updateSubscription => 'Update Subscription';

  @override
  String get addMedia => 'Add Media';

  @override
  String get addEventPhotos_2 => 'Add Event Photos';

  @override
  String get sharePhotosAndMemoriesFromThisEvent =>
      'Share photos and memories from this event';

  @override
  String get recordAudio => 'Record audio';

  @override
  String get recordEventAudio => 'Record event audio';

  @override
  String get photos => 'Photos';

  @override
  String get missionsCompleted => 'missions completed';

  @override
  String get soulsTouched => 'souls touched';

  @override
  String get coursesCompleted => 'courses completed';

  @override
  String get prayerResponses => 'prayer responses';

  @override
  String get eventsAttended => 'events attended';

  @override
  String get recordAnswer => 'Record answer';

  @override
  String get noAnswersYet => 'No answers yet';

  @override
  String get answers => 'Answers';

  @override
  String get searchQuestions => 'Search questions';

  @override
  String get loadingQuestions => 'Loading questions';

  @override
  String get debriefNoteDeleted => 'Debrief note deleted';

  @override
  String get feedbackData => 'Feedback Data';

  @override
  String get questionsCapturedAndPostMissionDebriefReflections =>
      'Questions captured and post-mission debrief reflections.';

  @override
  String get finances => 'Finances';

  @override
  String get requisitionsAndExpenseTrackingForThisMission =>
      'Requisitions and expense tracking for this mission.';

  @override
  String get overview => 'Overview';

  @override
  String get missionContextTeamMembersAndSessions =>
      'Mission context, team members, and sessions.';

  @override
  String get receiptUploadedSuccessfully => 'Receipt uploaded successfully';

  @override
  String get noExpensesYet => 'No Expenses Yet';

  @override
  String get error => 'Error';

  @override
  String get receiptDeletedSuccessfully => 'Receipt deleted successfully';

  @override
  String get deleteReceipt => 'Delete Receipt';

  @override
  String get addExpense_2 => 'Add Expense';

  @override
  String get editExpense => 'Edit Expense';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get addRefund => 'Add Refund';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String copiedToClipboard_2(Object value) {
    return 'Copied \"$value\" to clipboard';
  }

  @override
  String get refundAmount => 'Refund Amount';

  @override
  String get addRefundEntry => 'Add Refund Entry';

  @override
  String get tokenAmount_2 => 'Token Amount';

  @override
  String get updateExpense => 'Update Expense';

  @override
  String get mediaDeleted => 'Media deleted';

  @override
  String get savedToDevice => 'Saved to device';

  @override
  String get failedToSave => 'Failed to save';

  @override
  String get retry => 'Retry';

  @override
  String get questionUpdated => 'Question updated';

  @override
  String get questionDeleted => 'Question deleted';

  @override
  String get update => 'Update';

  @override
  String get requisitions => 'Requisitions';

  @override
  String get noRequisitions => 'No Requisitions';

  @override
  String get queued => 'Queued';

  @override
  String get retryAll => 'Retry all';

  @override
  String get download => 'Download';

  @override
  String get processing => 'Processing';

  @override
  String get open => 'Open';

  @override
  String get sessionInformation => 'Session information';

  @override
  String get soulDeleted => 'Soul deleted';

  @override
  String get missionSubscribers => 'Mission Subscribers';

  @override
  String get membersSubscribedToThisMission =>
      'Members subscribed to this mission.';

  @override
  String get viewDetails => 'View details';

  @override
  String get callMember => 'Call Member';

  @override
  String get eGCoolHighSchool => 'e.g., Cool High School';

  @override
  String get eGTrJohn => 'e.g., Tr John';

  @override
  String students(Object school_totalStudents) {
    return '$school_totalStudents students';
  }

  @override
  String missions_2(Object school_missions_length) {
    return '$school_missions_length missions';
  }

  @override
  String get camera => 'Camera';

  @override
  String get unableToPlayAudio => 'Unable to play audio';

  @override
  String get view => 'View';

  @override
  String get retryNow => 'Retry now';

  @override
  String get pendingUploads => 'Pending uploads';

  @override
  String get useAppWhileRecording => 'Use app while recording';

  @override
  String get useAppWhilePaused => 'Use app while paused';

  @override
  String get answerUploaded => 'Answer uploaded';

  @override
  String get viewAll => 'View All';

  @override
  String get noPendingUploads => 'No pending uploads';

  @override
  String get pendingUploads_2 => 'Pending Uploads';

  @override
  String uploadedSuccessfully(Object upload_name) {
    return '$upload_name uploaded successfully';
  }

  @override
  String get retryFailed => 'Retry failed';

  @override
  String get dashboardTitle => 'Mission Dashboard';

  @override
  String get dashboardSubtitle =>
      'Explore and suggest missions, make giving contributions, and check the latest answers and announcements.';

  @override
  String get prayerPrompt => 'Prayer prompt';

  @override
  String get emptyActionsTitle => 'Nothing here yet';

  @override
  String get emptyActionsBody =>
      'Fellowship actions will appear here once they are published.';

  @override
  String get allPast => 'All Past';

  @override
  String get yourNextMission => 'Your next mission';

  @override
  String get missionsIntroBody =>
      'Choose a mission to serve in — or catch up on the grounds we have already visited.';

  @override
  String upcomingCount(int count) {
    return '$count Upcoming';
  }

  @override
  String subscribedCount(int count) {
    return '$count Subscribed';
  }

  @override
  String get noUnreadQuestionsDesc =>
      'No unread questions right now. New questions from students will appear here.';

  @override
  String get noRepliedQuestionsDesc =>
      'No replied questions yet. Answers you send to students will collect here.';

  @override
  String get noAnnouncementsDesc =>
      'Announcements and publications from the fellowship will appear here.';

  @override
  String get schoolPastMissions => 'School Past Missions';

  @override
  String get spiritualLegacy => 'Spiritual Legacy';

  @override
  String get schoolLegacyBody =>
      'Explore all historical missions carried out by PRF at this school. Touch lives, follow up with student enquiries, and review past statistics.';

  @override
  String get noPastMissionsForSchool => 'No past missions for this school.';

  @override
  String get groundSuggestions => 'Ground Suggestions';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get suggestGroundsTitle => 'Suggest Mission Grounds';

  @override
  String get suggestGroundsPanelBody =>
      'Suggest new schools or centers that need spiritual interventions. The fellowship review board evaluates all entries to establish new missions.';

  @override
  String get noQuestionsYet => 'No questions yet';

  @override
  String get noQuestionsFound => 'No questions found';

  @override
  String get questionsFromMissionsBody =>
      'Questions from missions will appear here';

  @override
  String get tryDifferentSearchTerm => 'Try a different search term';

  @override
  String get missionsFaqHub => 'Missions FAQ Hub';

  @override
  String get faqHubIntro =>
      'Record audio answers to student questions, which are transcribed into text automatically.';

  @override
  String get answerTranscribeTitle => 'Answer & Transcribe';

  @override
  String get faqHubPanelBody =>
      'Review incoming student questions on the left. Tap \"Record Answer\" to capture your audio feedback, which is transcribed by AI to serve the fellowship.';

  @override
  String get awaitingAnswers => 'Awaiting answers';

  @override
  String answersCount(int count) {
    return 'Answers ($count)';
  }

  @override
  String missionThemeLabel(Object theme) {
    return 'Mission theme: $theme';
  }

  @override
  String recordAnswerSemantic(Object question) {
    return 'Record answer to: $question';
  }

  @override
  String get overviewTab => 'Overview';

  @override
  String get feedbackDataTab => 'Feedback Data';

  @override
  String get financeTab => 'Finance';

  @override
  String get missionOverview => 'Mission Overview';

  @override
  String get schoolNotSpecified => 'School not specified';

  @override
  String get generalMission => 'General Mission';

  @override
  String get interactiveActions => 'Interactive Actions';

  @override
  String get missionActionsGuidance =>
      'The button below dynamically adapts to your current selected tab. Add sessions, write debriefs, register souls, or report expenses seamlessly.';

  @override
  String get latestCampaign => 'Latest Campaign';

  @override
  String get announcementsPanelIntro =>
      'Announcements and publications received recently from the Fellowship admin.';

  @override
  String get stayUpToDate => 'Stay Up to Date';

  @override
  String get announcementsPanelBody =>
      'Keep track of important announcements, spiritual years publications, events alerts, and news directly shared by Park Road Fellowship.';

  @override
  String publicationsCount(int count) {
    return '$count Publications';
  }

  @override
  String get prayerSummaryTitle => 'Prayer Summary';

  @override
  String get prayerPanelBody =>
      'Submit your prayer needs directly to the fellowship. Together in one spirit, we stand in prayer watch and lift up our requests.';

  @override
  String get enquiryDashboard => 'Enquiry Dashboard';

  @override
  String get unreadQuestions => 'Unread Questions';

  @override
  String get repliedQuestions => 'Replied Questions';

  @override
  String get ministerToStudents => 'Minister to Students';

  @override
  String get enquiriesPanelBody =>
      'Answer enquiries submitted by students. Share wisdom and feedback on spiritual matters, or guide them through their doubts.';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get findQuickAnswers => 'Find Quick Answers';

  @override
  String get faqsPanelBody =>
      'Search through compiled FAQs or filter by categories on the left panel to find immediate guidelines about PRF Missions and fellowship rules.';

  @override
  String get noFaqsDesc =>
      'Browse categories or search to find answers about PRF Missions and fellowship life.';

  @override
  String get givingSummary => 'Giving Summary';

  @override
  String get supportFellowshipMissions => 'Support Fellowship Missions';

  @override
  String get givingPanelBody =>
      'Your giving enables spiritual growth and supports critical missions, local requisitions, and fellowship operations.';

  @override
  String get fellowshipEvents => 'Fellowship Events';

  @override
  String get eventsPanelIntro =>
      'Join fellowship gatherings, teachings, conferences and local spiritual events.';

  @override
  String get participateLearn => 'Participate & Learn';

  @override
  String get eventsPanelBody =>
      'Tap any event from the left list to subscribe and secure your slot, view attendees lists, and read schedules and timelines.';

  @override
  String availableCount(int count) {
    return '$count Available';
  }

  @override
  String get venueNotSpecified => 'Venue not specified';

  @override
  String get addRecordings => 'Add recordings';

  @override
  String get recordingsCaptureBody =>
      'Record audio to capture event highlights.';

  @override
  String get growInKnowledge => 'Grow in Knowledge';

  @override
  String get lmsPanelBody =>
      'Acquire wisdom and understanding through structured learning courses. Take courses, complete modules, and learn at your own pace.';

  @override
  String get noCoursesDesc =>
      'New courses will appear here as the fellowship publishes them.';

  @override
  String get completeAllModules => 'Complete all Modules';

  @override
  String get modulesPanelBody =>
      'Each module has specific learning content and lessons. View and study module actions on the left panel.';

  @override
  String get noModulesDesc =>
      'Modules will appear here once the course content is published.';

  @override
  String get studyYourLessons => 'Study your Lessons';

  @override
  String get lessonsPanelBody =>
      'Each lesson includes informative texts and resources to grow. Tap lessons on the left list to begin studying.';

  @override
  String get noLessonsDesc =>
      'Lessons will appear here once the module content is published.';

  @override
  String get noLessonResources =>
      'No learning resources are attached to this lesson yet.';

  @override
  String get noMissionsDesc =>
      'Upcoming missions will appear here once the missions desk announces them.';

  @override
  String get noRepliesYet =>
      'No replies yet. Responses from the desk will appear here.';

  @override
  String get noSubscribersDesc =>
      'Subscriptions will appear here as members join this mission.';

  @override
  String get question => 'Question';

  @override
  String fieldRequired(Object field) {
    return '$field is required';
  }

  @override
  String get fixHighlightedFields =>
      'Please fix the highlighted fields and try again.';

  @override
  String get ticketsRequired => 'Number of tickets is required';

  @override
  String get noPaymentTypesFound => 'No payment types found';

  @override
  String get noSubscribersFound => 'No subscribers found';

  @override
  String get noClassGroupsFound => 'No class groups found';

  @override
  String get updateSessionTitle => 'Update Session';

  @override
  String get updateQuestionTitle => 'Update Question';

  @override
  String get updateNoteTitle => 'Update Note';

  @override
  String get updateSoulTitle => 'Update Soul';

  @override
  String failedUploadReceipt(Object message) {
    return 'Failed to upload receipt: $message';
  }

  @override
  String failedSelectImage(Object error) {
    return 'Failed to select image: $error';
  }

  @override
  String failedSelectPdf(Object error) {
    return 'Failed to select PDF: $error';
  }

  @override
  String get startAddingExpense => 'Start by adding your first expense';

  @override
  String get tapToHideDetails => 'Tap to hide details';

  @override
  String tapToViewTransactions(int count) {
    return 'Tap to view $count transactions';
  }

  @override
  String get deleteReceiptConfirm =>
      'Are you sure you want to delete this receipt? This action cannot be undone.';

  @override
  String get deleteExpenseConfirm =>
      'Are you sure you want to delete this expense?';

  @override
  String get attachReceiptOrDocumentation => 'Attach receipt or documentation';

  @override
  String get receiptMissing => 'Receipt Missing';

  @override
  String get transactionBreakdown => 'Transaction Breakdown';

  @override
  String get refundEntries => 'Refund Entries';

  @override
  String get deficitAmount => 'Deficit Amount';

  @override
  String get confirmationLabel => 'Confirmation';

  @override
  String get imageLabel => 'Image';

  @override
  String attachmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Attachments',
      one: '$count Attachment',
    );
    return '$_temp0';
  }

  @override
  String get continueConfirm => 'Are you sure you want to continue?';

  @override
  String get editDebriefTooltip => 'Edit debrief note';

  @override
  String get deleteDebriefTooltip => 'Delete debrief note';

  @override
  String get removeNotImplemented => 'Remove functionality not implemented';

  @override
  String get debriefNoteRequired => 'Note is required';

  @override
  String get sessionNotesRequired => 'Preparation notes are required';

  @override
  String get prayerRequestRequired => 'Prayer request is required';

  @override
  String get viewSubscriberTooltip => 'View subscriber';

  @override
  String get callSubscriberTooltip => 'Call subscriber';

  @override
  String get selectedPhotos => 'Selected Photos';

  @override
  String get debriefNotesTitle => 'Debrief Notes';

  @override
  String get untitledNote => 'Untitled note';

  @override
  String get travelTime => 'Travel Time';

  @override
  String get deleteMediaConfirm =>
      'Are you sure you want to delete this media?';

  @override
  String get errorLoadingMedia => 'Error loading media';

  @override
  String tapToSelectMedia(Object mediaType) {
    return 'Tap to select $mediaType';
  }

  @override
  String chooseMultipleToShare(Object mediaType) {
    return 'Choose multiple $mediaType to share';
  }

  @override
  String get groundNameRequired => 'Mission ground name is required';

  @override
  String get contactPersonRequired => 'Contact person is required';

  @override
  String get contactNumberRequired => 'Contact number is required';

  @override
  String get statusRequired => 'Status is required';

  @override
  String get noStatusesFound => 'No statuses found';

  @override
  String get editSoulTooltip => 'Edit soul';

  @override
  String get deleteSoulTooltip => 'Delete soul';

  @override
  String recordingSaved(Object duration) {
    return 'Recording saved ($duration)';
  }

  @override
  String get queuedRecordingsForSession => 'Queued recordings for this session';

  @override
  String get syncingRecording => 'Syncing recording...';

  @override
  String get recorderIdle => 'Recorder idle';

  @override
  String get recorderReady => 'Recorder ready';

  @override
  String get recordingInProgress => 'Recording in progress';

  @override
  String get savedLocally => 'Saved locally';

  @override
  String get recorderNeedsAttention => 'Recorder needs attention';

  @override
  String get noNotesAvailable => 'No notes available';

  @override
  String get missionQuestionsTitle => 'Mission Questions';

  @override
  String get untitledQuestion => 'Untitled question';

  @override
  String get editQuestionTooltip => 'Edit question';

  @override
  String get deleteQuestionTooltip => 'Delete question';

  @override
  String get queuedRecordings => 'Queued recordings';

  @override
  String get offlineRecordingNotice =>
      'You are offline. The app will retry when you are back online. You can continue using the app.';

  @override
  String get backgroundRecording => 'Recording continues in the background.';

  @override
  String get confirmationMessageRequired => 'Confirmation message is required';

  @override
  String get enterConfirmationHint =>
      'Enter confirmation message or reference number';

  @override
  String get addTokenTitle => 'Add Token';

  @override
  String get addTokenDesc => 'Add funds as a credit entry to the allocation';

  @override
  String get enterTokenAmount => 'Enter token amount';

  @override
  String get editExpenseTitle => 'Edit Expense';

  @override
  String get editExpenseDesc => 'Update expense details and receipts';

  @override
  String get addNewExpenseTitle => 'Add New Expense';

  @override
  String get addNewExpenseDesc =>
      'Fill in the details below to record a new expense';

  @override
  String get addRefundEntryTitle => 'Add Refund Entry';

  @override
  String get addRefundEntryDesc =>
      'Record a new refund entry for this accounting event';

  @override
  String get enterRefundAmount => 'Enter refund amount';

  @override
  String get refundAddedSuccessfully => 'Refund entry added successfully';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String capturedAt(Object date) {
    return 'Captured $date';
  }

  @override
  String get soulsTitle => 'Souls';

  @override
  String dayLabel(int day) {
    return 'Day $day';
  }
}
