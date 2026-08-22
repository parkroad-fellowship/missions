import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In ...'**
  String get signingIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @pleaseWaitBrief.
  ///
  /// In en, this message translates to:
  /// **'Please wait ...'**
  String get pleaseWaitBrief;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @signInPanelBody.
  ///
  /// In en, this message translates to:
  /// **'One home for the life of Parkroad Fellowship — serve missions together, give, pray for one another and stay close to the community wherever you are.'**
  String get signInPanelBody;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @viewProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Your name and email address'**
  String get viewProfileDetails;

  /// No description provided for @byUsing.
  ///
  /// In en, this message translates to:
  /// **'By using this app, you are agreeing to our\n'**
  String get byUsing;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **' Terms'**
  String get terms;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **' Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @noMissions.
  ///
  /// In en, this message translates to:
  /// **'No missions'**
  String get noMissions;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the missions desk'**
  String get pleaseWait;

  /// No description provided for @missionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search missions'**
  String get missionsSearchHint;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @statusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusAvailable;

  /// No description provided for @missionStart.
  ///
  /// In en, this message translates to:
  /// **'Starts on: {missionDate}, {missionTime}'**
  String missionStart(String missionDate, String missionTime);

  /// No description provided for @missionEnd.
  ///
  /// In en, this message translates to:
  /// **'Ends on: {missionDate}, {missionTime}'**
  String missionEnd(String missionDate, String missionTime);

  /// No description provided for @missionType.
  ///
  /// In en, this message translates to:
  /// **'Mission Type: {missionType}'**
  String missionType(String missionType);

  /// No description provided for @missionDetails.
  ///
  /// In en, this message translates to:
  /// **'Mission Details'**
  String get missionDetails;

  /// No description provided for @sendMe.
  ///
  /// In en, this message translates to:
  /// **'Send Me'**
  String get sendMe;

  /// No description provided for @going.
  ///
  /// In en, this message translates to:
  /// **'Missioners'**
  String get going;

  /// No description provided for @missionGround.
  ///
  /// In en, this message translates to:
  /// **'Mission Ground'**
  String get missionGround;

  /// No description provided for @noSubscribers.
  ///
  /// In en, this message translates to:
  /// **'No subscribers'**
  String get noSubscribers;

  /// No description provided for @comingFrom.
  ///
  /// In en, this message translates to:
  /// **'Coming from: {residence}'**
  String comingFrom(String residence);

  /// No description provided for @successfullySubscribed.
  ///
  /// In en, this message translates to:
  /// **'Your request to service this mission has been received. Should there be any changes, you will be notified.'**
  String get successfullySubscribed;

  /// No description provided for @myMissions.
  ///
  /// In en, this message translates to:
  /// **'My Missions'**
  String get myMissions;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address & Directions'**
  String get address;

  /// No description provided for @missionPrepNotes.
  ///
  /// In en, this message translates to:
  /// **'Preparation Notes'**
  String get missionPrepNotes;

  /// No description provided for @population.
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noUpcomingMissions.
  ///
  /// In en, this message translates to:
  /// **'No upcoming missions'**
  String get noUpcomingMissions;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noPastMissions.
  ///
  /// In en, this message translates to:
  /// **'No past missions'**
  String get noPastMissions;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme/Topic'**
  String get theme;

  /// No description provided for @souls.
  ///
  /// In en, this message translates to:
  /// **'Souls'**
  String get souls;

  /// No description provided for @recordSoul.
  ///
  /// In en, this message translates to:
  /// **'Record a Soul'**
  String get recordSoul;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @admissionNumber.
  ///
  /// In en, this message translates to:
  /// **'Admission Number'**
  String get admissionNumber;

  /// No description provided for @enterAdmissionNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Admission Number'**
  String get enterAdmissionNumber;

  /// No description provided for @classGroup.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classGroup;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @soulRecorded.
  ///
  /// In en, this message translates to:
  /// **'Soul recorded'**
  String get soulRecorded;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording ...'**
  String get recording;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selectClass;

  /// No description provided for @debriefNotes.
  ///
  /// In en, this message translates to:
  /// **'Debrief Notes'**
  String get debriefNotes;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get note;

  /// No description provided for @noteRecorded.
  ///
  /// In en, this message translates to:
  /// **'Note recorded'**
  String get noteRecorded;

  /// No description provided for @contactPersons.
  ///
  /// In en, this message translates to:
  /// **'Contact Persons'**
  String get contactPersons;

  /// No description provided for @successfullyWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'You have successfully withdrawn from this mission'**
  String get successfullyWithdrawn;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @missionariesNeeded.
  ///
  /// In en, this message translates to:
  /// **'Still Needed'**
  String get missionariesNeeded;

  /// No description provided for @missionariesRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested missioners'**
  String get missionariesRequested;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {progress}%'**
  String progress(int progress);

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'{progress}%'**
  String percentage(int progress);

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @moduleDetails.
  ///
  /// In en, this message translates to:
  /// **'Module Details'**
  String get moduleDetails;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @lessonResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get lessonResources;

  /// No description provided for @lessonDetails.
  ///
  /// In en, this message translates to:
  /// **'Lesson Details'**
  String get lessonDetails;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video (Tap to play)'**
  String get video;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document (Tap to view)'**
  String get document;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio (Tap to play)'**
  String get audio;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @completing.
  ///
  /// In en, this message translates to:
  /// **'Completing ...'**
  String get completing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses'**
  String get noCourses;

  /// No description provided for @recentCourses.
  ///
  /// In en, this message translates to:
  /// **'Recent Courses'**
  String get recentCourses;

  /// No description provided for @yetToBeEnroled.
  ///
  /// In en, this message translates to:
  /// **'You are yet to be enroled for a course'**
  String get yetToBeEnroled;

  /// No description provided for @registerStudent.
  ///
  /// In en, this message translates to:
  /// **'Register as a new student'**
  String get registerStudent;

  /// No description provided for @registerNewStudent.
  ///
  /// In en, this message translates to:
  /// **'Register a new student account'**
  String get registerNewStudent;

  /// No description provided for @studentIntro.
  ///
  /// In en, this message translates to:
  /// **'To keep your identity private, you get random credentials that you can use to access the app. Please ensure to save them somewhere if you want to come back to the app at another time or on a different device.'**
  String get studentIntro;

  /// No description provided for @iAmReady.
  ///
  /// In en, this message translates to:
  /// **'I am ready'**
  String get iAmReady;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering ...'**
  String get registering;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'You have been registered successfully. Please save your credentials somewhere safe.'**
  String get registered;

  /// No description provided for @iHaveWritten.
  ///
  /// In en, this message translates to:
  /// **'I have written them down'**
  String get iHaveWritten;

  /// No description provided for @credentials.
  ///
  /// In en, this message translates to:
  /// **'Your credentials\n\nEmail: {email}\nPassword: {password}\n\nPlease write them down, they will disappear once you log out'**
  String credentials(String email, int password);

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faq;

  /// No description provided for @recentFaqs.
  ///
  /// In en, this message translates to:
  /// **'Recent FAQs'**
  String get recentFaqs;

  /// No description provided for @noFaqs.
  ///
  /// In en, this message translates to:
  /// **'No FAQs'**
  String get noFaqs;

  /// No description provided for @myQuestions.
  ///
  /// In en, this message translates to:
  /// **'My Questions'**
  String get myQuestions;

  /// No description provided for @noQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions'**
  String get noQuestions;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @noReplies.
  ///
  /// In en, this message translates to:
  /// **'No replies yet'**
  String get noReplies;

  /// No description provided for @yourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your Question'**
  String get yourQuestion;

  /// No description provided for @createQuestion.
  ///
  /// In en, this message translates to:
  /// **'Create Question'**
  String get createQuestion;

  /// No description provided for @enquiry.
  ///
  /// In en, this message translates to:
  /// **'Enquiry'**
  String get enquiry;

  /// No description provided for @enquiryRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your enquiry has been recorded. Please wait for a response'**
  String get enquiryRecorded;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replySent.
  ///
  /// In en, this message translates to:
  /// **'Your reply has been sent'**
  String get replySent;

  /// No description provided for @replying.
  ///
  /// In en, this message translates to:
  /// **'Replying ...'**
  String get replying;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Don\'t share your contact information or any personal information in your questions or replies'**
  String get rules;

  /// No description provided for @studentEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentEnquiries;

  /// No description provided for @studentQuestions.
  ///
  /// In en, this message translates to:
  /// **'Student Questions'**
  String get studentQuestions;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'to ask a question'**
  String get askQuestion;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @noAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'No announcements'**
  String get noAnnouncements;

  /// No description provided for @pleaseWaitForOS.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the organising secretary\'s desk'**
  String get pleaseWaitForOS;

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Date: {publishingDate}'**
  String publishedAt(String publishingDate);

  /// No description provided for @missionQuestions.
  ///
  /// In en, this message translates to:
  /// **'Mission Questions'**
  String get missionQuestions;

  /// No description provided for @missionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Mission Question'**
  String get missionQuestion;

  /// No description provided for @expenseTracking.
  ///
  /// In en, this message translates to:
  /// **'Financials Tracking'**
  String get expenseTracking;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @addToken.
  ///
  /// In en, this message translates to:
  /// **'Add Token'**
  String get addToken;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add an expense'**
  String get addExpense;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add a question'**
  String get addQuestion;

  /// No description provided for @addQuestionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share any questions from learners'**
  String get addQuestionSubTitle;

  /// No description provided for @addQuestionSection.
  ///
  /// In en, this message translates to:
  /// **'Question Details'**
  String get addQuestionSection;

  /// No description provided for @addQuestionDesc.
  ///
  /// In en, this message translates to:
  /// **'What did the students want to know?'**
  String get addQuestionDesc;

  /// No description provided for @questionRecorded.
  ///
  /// In en, this message translates to:
  /// **'This question has been recorded'**
  String get questionRecorded;

  /// No description provided for @recordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Record question'**
  String get recordQuestion;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @iWantTo.
  ///
  /// In en, this message translates to:
  /// **'Right now, I want to'**
  String get iWantTo;

  /// No description provided for @goToAMission.
  ///
  /// In en, this message translates to:
  /// **'View missions'**
  String get goToAMission;

  /// No description provided for @learnSomething.
  ///
  /// In en, this message translates to:
  /// **'Learn something'**
  String get learnSomething;

  /// No description provided for @ministerToAStudent.
  ///
  /// In en, this message translates to:
  /// **'Minister to a student'**
  String get ministerToAStudent;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **' v{version}'**
  String version(String version);

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'for some answers'**
  String get faqs;

  /// No description provided for @lookingFor.
  ///
  /// In en, this message translates to:
  /// **'I am looking'**
  String get lookingFor;

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askAQuestion;

  /// No description provided for @ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get ask;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @memberships.
  ///
  /// In en, this message translates to:
  /// **'Memberships'**
  String get memberships;

  /// No description provided for @prayerAlert.
  ///
  /// In en, this message translates to:
  /// **'Prayer watch'**
  String get prayerAlert;

  /// No description provided for @amen.
  ///
  /// In en, this message translates to:
  /// **'Weka tick ✅'**
  String get amen;

  /// No description provided for @viewCredentials.
  ///
  /// In en, this message translates to:
  /// **'for my credentials'**
  String get viewCredentials;

  /// No description provided for @financials.
  ///
  /// In en, this message translates to:
  /// **'Financials'**
  String get financials;

  /// No description provided for @confirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Message'**
  String get confirmationMessage;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense Category'**
  String get expenseCategory;

  /// No description provided for @amountDetails.
  ///
  /// In en, this message translates to:
  /// **'Amount Details'**
  String get amountDetails;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @narration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get narration;

  /// No description provided for @amountSpent.
  ///
  /// In en, this message translates to:
  /// **'Amount spent'**
  String get amountSpent;

  /// No description provided for @selectExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Select the expense category'**
  String get selectExpenseCategory;

  /// No description provided for @selectTransactionType.
  ///
  /// In en, this message translates to:
  /// **'Select the transaction Type'**
  String get selectTransactionType;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get enterQuantity;

  /// No description provided for @enterCharge.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction cost'**
  String get enterCharge;

  /// No description provided for @enterNarration.
  ///
  /// In en, this message translates to:
  /// **'Describe what the money was used for'**
  String get enterNarration;

  /// No description provided for @enterConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation message'**
  String get enterConfirmationMessage;

  /// No description provided for @askMissionDeskToDisburseFunds.
  ///
  /// In en, this message translates to:
  /// **'Ask the missions desk to disburse funds'**
  String get askMissionDeskToDisburseFunds;

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received (Token included)'**
  String get amountReceived;

  /// No description provided for @tokenAmount.
  ///
  /// In en, this message translates to:
  /// **'Token from institution'**
  String get tokenAmount;

  /// No description provided for @amountToRefund.
  ///
  /// In en, this message translates to:
  /// **'Amount to refund \n(Charge removed)'**
  String get amountToRefund;

  /// No description provided for @refundedAmount.
  ///
  /// In en, this message translates to:
  /// **'Refunded amount'**
  String get refundedAmount;

  /// No description provided for @fullyRefunded.
  ///
  /// In en, this message translates to:
  /// **'Fully refunded?'**
  String get fullyRefunded;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @unitCost.
  ///
  /// In en, this message translates to:
  /// **'Unit Cost'**
  String get unitCost;

  /// No description provided for @unitCostDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter cost per item'**
  String get unitCostDesc;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Transaction Charge'**
  String get charge;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe what the money was used for...'**
  String get paymentDesc;

  /// No description provided for @confirmationMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation message (SMS)'**
  String get confirmationMsg;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Expense'**
  String get recordExpense;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subTotal;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @unitCostAndQty.
  ///
  /// In en, this message translates to:
  /// **'Unit x Qty'**
  String get unitCostAndQty;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @breakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// No description provided for @figure.
  ///
  /// In en, this message translates to:
  /// **'Figure'**
  String get figure;

  /// No description provided for @refundCharge.
  ///
  /// In en, this message translates to:
  /// **'Cost to refund'**
  String get refundCharge;

  /// No description provided for @tokenRecorded.
  ///
  /// In en, this message translates to:
  /// **'Token recorded'**
  String get tokenRecorded;

  /// No description provided for @expenseRecorded.
  ///
  /// In en, this message translates to:
  /// **'Expense recorded'**
  String get expenseRecorded;

  /// No description provided for @studentFaqs.
  ///
  /// In en, this message translates to:
  /// **'View student FAQs'**
  String get studentFaqs;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility: {min} - {max} ({avg})'**
  String visibility(String min, String max, String avg);

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @precipitationProbability.
  ///
  /// In en, this message translates to:
  /// **'Precipitation Probability: {min} - {max} ({avg})'**
  String precipitationProbability(String min, String max, String avg);

  /// No description provided for @dressingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Dressing Recommendations'**
  String get dressingRecommendations;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day {day} | {summary}'**
  String day(int day, String summary);

  /// No description provided for @depaturePlanning.
  ///
  /// In en, this message translates to:
  /// **'Depature Planning'**
  String get depaturePlanning;

  /// No description provided for @estimatedTravelTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated Travel Time: {time}'**
  String estimatedTravelTime(String time);

  /// No description provided for @estimatedDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get estimatedDistance;

  /// No description provided for @estimationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'* This estimate is made from Tumaini House to the mission ground and may not be accurate. Please plan accordingly.'**
  String get estimationDisclaimer;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @willUpload.
  ///
  /// In en, this message translates to:
  /// **'Your media will be uploaded as you continue to use the app'**
  String get willUpload;

  /// No description provided for @doneUploading.
  ///
  /// In en, this message translates to:
  /// **'Your media has been uploaded, you can refresh the page to see them.'**
  String get doneUploading;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add'**
  String get tapToAdd;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get noSessions;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Start Time - End Time'**
  String get time;

  /// No description provided for @facilitator.
  ///
  /// In en, this message translates to:
  /// **'Facilitator'**
  String get facilitator;

  /// No description provided for @speaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get speaker;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Preparation notes'**
  String get notes;

  /// No description provided for @selectFacilitator.
  ///
  /// In en, this message translates to:
  /// **'Select Facilitator'**
  String get selectFacilitator;

  /// No description provided for @selectSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Select Speaker'**
  String get selectSpeaker;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter preparation notes'**
  String get enterNotes;

  /// No description provided for @addStartEnd.
  ///
  /// In en, this message translates to:
  /// **'Add start and end time'**
  String get addStartEnd;

  /// No description provided for @sessionRecorded.
  ///
  /// In en, this message translates to:
  /// **'Session recorded'**
  String get sessionRecorded;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @blank.
  ///
  /// In en, this message translates to:
  /// **''**
  String get blank;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sessionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Session deleted'**
  String get sessionDeleted;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos'**
  String get noPhotos;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @suggestAMission.
  ///
  /// In en, this message translates to:
  /// **'Suggest a mission'**
  String get suggestAMission;

  /// No description provided for @suggestMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Suggest a mission ground for PRF to consider. This is not a request to service the mission, but rather a suggestion for future missions.'**
  String get suggestMissionDescription;

  /// No description provided for @suggestMissionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share a mission ground with us and we will take it from there'**
  String get suggestMissionSubTitle;

  /// No description provided for @noSuggestedMissionGrounds.
  ///
  /// In en, this message translates to:
  /// **'No suggested mission grounds'**
  String get noSuggestedMissionGrounds;

  /// No description provided for @recentSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Recent Suggestions'**
  String get recentSuggestions;

  /// No description provided for @missionGroundRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your suggested mission to {ground} has been recorded'**
  String missionGroundRecorded(String ground);

  /// No description provided for @enterMissionGround.
  ///
  /// In en, this message translates to:
  /// **'Enter mission ground'**
  String get enterMissionGround;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @enterContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Enter contact person\'s name'**
  String get enterContactPerson;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact\'s Phone Number'**
  String get contactNumber;

  /// No description provided for @enterContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter contact person\'s number'**
  String get enterContactNumber;

  /// No description provided for @suggest.
  ///
  /// In en, this message translates to:
  /// **'Suggest'**
  String get suggest;

  /// No description provided for @suggesting.
  ///
  /// In en, this message translates to:
  /// **'Suggesting...'**
  String get suggesting;

  /// No description provided for @editMissionSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Mission Suggestion'**
  String get editMissionSuggestion;

  /// No description provided for @editMissionSuggestionSubTitle.
  ///
  /// In en, this message translates to:
  /// **'You can edit your suggested mission ground details below'**
  String get editMissionSuggestionSubTitle;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get comments;

  /// No description provided for @give.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get give;

  /// No description provided for @considerGiving.
  ///
  /// In en, this message translates to:
  /// **'Consider giving'**
  String get considerGiving;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @reasonForGiving.
  ///
  /// In en, this message translates to:
  /// **'Reason for giving'**
  String get reasonForGiving;

  /// No description provided for @selectReasonForGiving.
  ///
  /// In en, this message translates to:
  /// **'Select reason for giving'**
  String get selectReasonForGiving;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @whatWouldYouLikeToKnow.
  ///
  /// In en, this message translates to:
  /// **'What would you like to know?'**
  String get whatWouldYouLikeToKnow;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @recordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get recordings;

  /// No description provided for @noRecordings.
  ///
  /// In en, this message translates to:
  /// **'No recordings'**
  String get noRecordings;

  /// No description provided for @uploadRecording.
  ///
  /// In en, this message translates to:
  /// **'Upload recording'**
  String get uploadRecording;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get addMore;

  /// No description provided for @recordingItem.
  ///
  /// In en, this message translates to:
  /// **'Recording {index}'**
  String recordingItem(int index);

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @viewTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get viewTranscript;

  /// No description provided for @transcriptProcessing.
  ///
  /// In en, this message translates to:
  /// **'Transcript processing. Please wait.'**
  String get transcriptProcessing;

  /// No description provided for @inTesting.
  ///
  /// In en, this message translates to:
  /// **'In testing'**
  String get inTesting;

  /// No description provided for @downloadTeaching.
  ///
  /// In en, this message translates to:
  /// **'Download teaching: {size}'**
  String downloadTeaching(String size);

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Your download has started. Check your download folder once it\'s complete.'**
  String get downloaded;

  /// No description provided for @enterDebriefNote.
  ///
  /// In en, this message translates to:
  /// **'Enter debrief notes'**
  String get enterDebriefNote;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question'**
  String get enterQuestion;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register for an event'**
  String get registerForEvent;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @pleaseWaitOS.
  ///
  /// In en, this message translates to:
  /// **'Please wait for an update from the organising secretary\'s desk'**
  String get pleaseWaitOS;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get noEvents;

  /// No description provided for @registeredEvent.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get registeredEvent;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @capacityDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} missioners'**
  String capacityDesc(int count);

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @durationDesc.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String durationDesc(int count);

  /// No description provided for @subscriptionsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Open registrations: {count}'**
  String subscriptionsNeeded(String count);

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @enterTickets.
  ///
  /// In en, this message translates to:
  /// **'Enter number of tickets'**
  String get enterTickets;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @eventRegistrationRecorded.
  ///
  /// In en, this message translates to:
  /// **'Your event subscription has been recorded'**
  String get eventRegistrationRecorded;

  /// No description provided for @cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get cancelRegistration;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancellation'**
  String get confirmCancellation;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled'**
  String get subscriptionCancelled;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get next;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @replied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get replied;

  /// No description provided for @noModules.
  ///
  /// In en, this message translates to:
  /// **'No modules'**
  String get noModules;

  /// No description provided for @recentModules.
  ///
  /// In en, this message translates to:
  /// **'Recent Modules'**
  String get recentModules;

  /// No description provided for @noLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons'**
  String get noLessons;

  /// No description provided for @recentLessons.
  ///
  /// In en, this message translates to:
  /// **'Recent Lessons'**
  String get recentLessons;

  /// No description provided for @noSouls.
  ///
  /// In en, this message translates to:
  /// **'No souls'**
  String get noSouls;

  /// No description provided for @noSoulsDesc.
  ///
  /// In en, this message translates to:
  /// **'Please record any decisions for Jesus here'**
  String get noSoulsDesc;

  /// No description provided for @joinWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Join WhatsApp'**
  String get joinWhatsApp;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @successfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your profile picture has been successfully updated'**
  String get successfullyUpdated;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @directed.
  ///
  /// In en, this message translates to:
  /// **'Note: You will be redirected to the payment page'**
  String get directed;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'This is a test. No real money will be charged.'**
  String get testing;

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @submitPrayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Share a prayer request'**
  String get submitPrayerRequest;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @prayerRequests.
  ///
  /// In en, this message translates to:
  /// **'Prayer requests'**
  String get prayerRequests;

  /// No description provided for @prayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Prayer request'**
  String get prayerRequest;

  /// No description provided for @recentPrayerRequests.
  ///
  /// In en, this message translates to:
  /// **'Recent Prayer Requests'**
  String get recentPrayerRequests;

  /// No description provided for @prayerRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your prayer request has been submitted.'**
  String get prayerRequestSubmitted;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @getNotified.
  ///
  /// In en, this message translates to:
  /// **'Get Notified!'**
  String get getNotified;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow PRF Missions to send you prayer and mission notifications.'**
  String get allowNotifications;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @pleaseWaitForFunds.
  ///
  /// In en, this message translates to:
  /// **'Please inform the mission desk to confirm funds were issued.'**
  String get pleaseWaitForFunds;

  /// No description provided for @pleaseWaitForUpload.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we upload this file.'**
  String get pleaseWaitForUpload;

  /// No description provided for @successfulUpload.
  ///
  /// In en, this message translates to:
  /// **'Your file has been successfully uploaded.'**
  String get successfulUpload;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts:'**
  String get receipts;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on'**
  String get addedOn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please sign in with your PRF organisation email to continue.'**
  String get welcomeBack;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcome;

  /// No description provided for @longPressToEdit.
  ///
  /// In en, this message translates to:
  /// **'Long press to edit'**
  String get longPressToEdit;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @noPrayerRequests.
  ///
  /// In en, this message translates to:
  /// **'No prayer requests'**
  String get noPrayerRequests;

  /// No description provided for @noPrayerRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'You have not submitted any prayer requests yet. Tap the button below to submit one.'**
  String get noPrayerRequestsDesc;

  /// No description provided for @submitPrayerRequestDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your prayer request with the PRF community. We will pray for you.'**
  String get submitPrayerRequestDesc;

  /// No description provided for @addMissionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add mission media'**
  String get addMissionPhotos;

  /// No description provided for @addMissionPhotosDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your mission moments with beautiful photos and videos'**
  String get addMissionPhotosDesc;

  /// No description provided for @areGoing.
  ///
  /// In en, this message translates to:
  /// **'{number} going'**
  String areGoing(int number);

  /// No description provided for @missionIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Mission Intelligence'**
  String get missionIntelligence;

  /// No description provided for @eventIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Event Intelligence'**
  String get eventIntelligence;

  /// No description provided for @addEventPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos to share memories from this event'**
  String get addEventPhotos;

  /// No description provided for @errorLoadingPhotos.
  ///
  /// In en, this message translates to:
  /// **'Error loading photos'**
  String get errorLoadingPhotos;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add a debrief note'**
  String get addNote;

  /// No description provided for @addSoul.
  ///
  /// In en, this message translates to:
  /// **'Add a soul'**
  String get addSoul;

  /// No description provided for @addSession.
  ///
  /// In en, this message translates to:
  /// **'Add a session'**
  String get addSession;

  /// No description provided for @noNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Notes will help you remember important details from this mission'**
  String get noNotesDesc;

  /// No description provided for @sessionsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Please use this section to schedule speakers and facilitators'**
  String get sessionsWillAppearHere;

  /// No description provided for @questionsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Please add any questions asked by students'**
  String get questionsWillAppearHere;

  /// No description provided for @soulsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Souls will appear here when they are recorded'**
  String get soulsWillAppearHere;

  /// No description provided for @trackExpensesToStayOrganized.
  ///
  /// In en, this message translates to:
  /// **'Track expenses to stay organized and accountable'**
  String get trackExpensesToStayOrganized;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpenses;

  /// No description provided for @addDebriefNote.
  ///
  /// In en, this message translates to:
  /// **'Add debrief note'**
  String get addDebriefNote;

  /// No description provided for @addDebriefNoteSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts and observations from the mission'**
  String get addDebriefNoteSubTitle;

  /// No description provided for @addDebriefNoteSection.
  ///
  /// In en, this message translates to:
  /// **'Note Details'**
  String get addDebriefNoteSection;

  /// No description provided for @addDebriefNoteDesc.
  ///
  /// In en, this message translates to:
  /// **'What are your thoughts so far?'**
  String get addDebriefNoteDesc;

  /// No description provided for @addSoulSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Record a decision for Jesus made during this mission'**
  String get addSoulSubTitle;

  /// No description provided for @studentInformation.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get studentInformation;

  /// No description provided for @updateRegistration.
  ///
  /// In en, this message translates to:
  /// **'Update Registration'**
  String get updateRegistration;

  /// No description provided for @refundInformation.
  ///
  /// In en, this message translates to:
  /// **'Refund Information'**
  String get refundInformation;

  /// No description provided for @refundDesc.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance and token needs to be refunded'**
  String get refundDesc;

  /// No description provided for @refundDetails.
  ///
  /// In en, this message translates to:
  /// **'Refund Payment Details'**
  String get refundDetails;

  /// No description provided for @paybillNumber.
  ///
  /// In en, this message translates to:
  /// **'Paybill Number'**
  String get paybillNumber;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @refundText.
  ///
  /// In en, this message translates to:
  /// **'Please send the balance indicated above to the M-Pesa details and share the confirmation to complete the refund process.'**
  String get refundText;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Mission Financial Overview'**
  String get financialOverview;

  /// No description provided for @transactionCost.
  ///
  /// In en, this message translates to:
  /// **'Transaction Cost'**
  String get transactionCost;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @decisionType.
  ///
  /// In en, this message translates to:
  /// **'Type of Decision'**
  String get decisionType;

  /// No description provided for @selectDecisionType.
  ///
  /// In en, this message translates to:
  /// **'Select the decision this learner made today'**
  String get selectDecisionType;

  /// No description provided for @addDecisionNote.
  ///
  /// In en, this message translates to:
  /// **'What would you like to point out concerning this soul?'**
  String get addDecisionNote;

  /// No description provided for @welcomeIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PRF Missions'**
  String get welcomeIntro;

  /// No description provided for @paymentActions.
  ///
  /// In en, this message translates to:
  /// **'Payment Actions'**
  String get paymentActions;

  /// No description provided for @completePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// No description provided for @openPaymentLink.
  ///
  /// In en, this message translates to:
  /// **'Open payment link'**
  String get openPaymentLink;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get refreshStatus;

  /// No description provided for @checkPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Check payment status'**
  String get checkPaymentStatus;

  /// No description provided for @longPressForActions.
  ///
  /// In en, this message translates to:
  /// **'Long press for actions'**
  String get longPressForActions;

  /// No description provided for @startGiving.
  ///
  /// In en, this message translates to:
  /// **'Start your giving journey today'**
  String get startGiving;

  /// No description provided for @tapForActions.
  ///
  /// In en, this message translates to:
  /// **'Press for payment actions'**
  String get tapForActions;

  /// No description provided for @recentPayments.
  ///
  /// In en, this message translates to:
  /// **'Recent Payments'**
  String get recentPayments;

  /// No description provided for @tapToStartRecording.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording'**
  String get tapToStartRecording;

  /// No description provided for @recordingWillContinueInBackground.
  ///
  /// In en, this message translates to:
  /// **'Recording will continue even when the app goes to background'**
  String get recordingWillContinueInBackground;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecording;

  /// No description provided for @liveRecording.
  ///
  /// In en, this message translates to:
  /// **'Live recording'**
  String get liveRecording;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @recordingPaused.
  ///
  /// In en, this message translates to:
  /// **'Recording Paused'**
  String get recordingPaused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @recordingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recording Completed'**
  String get recordingCompleted;

  /// No description provided for @recordAnother.
  ///
  /// In en, this message translates to:
  /// **'Record Another'**
  String get recordAnother;

  /// No description provided for @recordingError.
  ///
  /// In en, this message translates to:
  /// **'Recording Error'**
  String get recordingError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @wrapped.
  ///
  /// In en, this message translates to:
  /// **'View my impact'**
  String get wrapped;

  /// No description provided for @wrappedTagline.
  ///
  /// In en, this message translates to:
  /// **'Missions Wrapped'**
  String get wrappedTagline;

  /// No description provided for @wrappedSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe to feel your journey'**
  String get wrappedSwipeHint;

  /// No description provided for @wrappedYourYear.
  ///
  /// In en, this message translates to:
  /// **'Your {year}'**
  String wrappedYourYear(int year);

  /// No description provided for @wrappedMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Mission Journey'**
  String get wrappedMissionsTitle;

  /// No description provided for @wrappedTotalMissions.
  ///
  /// In en, this message translates to:
  /// **'Total Missions'**
  String get wrappedTotalMissions;

  /// No description provided for @wrappedSchoolsReached.
  ///
  /// In en, this message translates to:
  /// **'Schools Reached'**
  String get wrappedSchoolsReached;

  /// No description provided for @wrappedCompletion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get wrappedCompletion;

  /// No description provided for @wrappedMissionStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} mission streak'**
  String wrappedMissionStreakTitle(int count);

  /// No description provided for @wrappedMissionStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consistency looks great on you'**
  String get wrappedMissionStreakSubtitle;

  /// No description provided for @wrappedImpactTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Impact'**
  String get wrappedImpactTitle;

  /// No description provided for @wrappedSoulsTouched.
  ///
  /// In en, this message translates to:
  /// **'Souls Touched'**
  String get wrappedSoulsTouched;

  /// No description provided for @wrappedMostImpactfulMissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your most impactful mission reached {soulsCount} souls'**
  String wrappedMostImpactfulMissionSubtitle(int soulsCount);

  /// No description provided for @wrappedDecisionTypes.
  ///
  /// In en, this message translates to:
  /// **'Decision Types'**
  String get wrappedDecisionTypes;

  /// No description provided for @wrappedDecisionTypesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top categories from your mission impact'**
  String get wrappedDecisionTypesSubtitle;

  /// No description provided for @wrappedLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Learning Growth'**
  String get wrappedLearningTitle;

  /// No description provided for @wrappedCoursesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Courses Completed'**
  String get wrappedCoursesCompleted;

  /// No description provided for @wrappedLessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lessons Completed'**
  String get wrappedLessonsCompleted;

  /// No description provided for @wrappedOverallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get wrappedOverallProgress;

  /// No description provided for @wrappedLearningStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} day learning streak'**
  String wrappedLearningStreakTitle(int count);

  /// No description provided for @wrappedLearningStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the momentum alive'**
  String get wrappedLearningStreakSubtitle;

  /// No description provided for @wrappedPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Prayer Journey'**
  String get wrappedPrayerTitle;

  /// No description provided for @wrappedPrayerResponses.
  ///
  /// In en, this message translates to:
  /// **'Prayer Responses'**
  String get wrappedPrayerResponses;

  /// No description provided for @wrappedPrayerConsistencyTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} days of prayer'**
  String wrappedPrayerConsistencyTitle(int count);

  /// No description provided for @wrappedPrayerConsistencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your faith journey continues'**
  String get wrappedPrayerConsistencySubtitle;

  /// No description provided for @wrappedEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Event Participation'**
  String get wrappedEventsTitle;

  /// No description provided for @wrappedEventsAttended.
  ///
  /// In en, this message translates to:
  /// **'Events Attended'**
  String get wrappedEventsAttended;

  /// No description provided for @wrappedUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get wrappedUpcomingEvents;

  /// No description provided for @wrappedActiveParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Participant'**
  String get wrappedActiveParticipantTitle;

  /// No description provided for @wrappedActiveParticipantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for being part of this community'**
  String get wrappedActiveParticipantSubtitle;

  /// No description provided for @wrappedSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'What a Year!'**
  String get wrappedSummaryTitle;

  /// No description provided for @wrappedHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'{year} highlights'**
  String wrappedHighlightsTitle(int year);

  /// No description provided for @wrappedHighlightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A snapshot of your impact this year'**
  String get wrappedHighlightsSubtitle;

  /// No description provided for @wrappedMissionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get wrappedMissionsLabel;

  /// No description provided for @wrappedCoursesLabel.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get wrappedCoursesLabel;

  /// No description provided for @wrappedEventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get wrappedEventsLabel;

  /// No description provided for @wrappedThankYouSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for making an impact in {year}!'**
  String wrappedThankYouSubtitle(int year);

  /// No description provided for @wrappedNextYearCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make next year even better!'**
  String get wrappedNextYearCta;

  /// No description provided for @wrappedNoImpactDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No Impact Data Yet'**
  String get wrappedNoImpactDataTitle;

  /// No description provided for @wrappedNoImpactDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Start participating in missions and activities to see your impact wrapped!'**
  String get wrappedNoImpactDataDescription;

  /// No description provided for @wrappedGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get wrappedGoBack;

  /// No description provided for @wrappedSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get wrappedSomethingWentWrong;

  /// No description provided for @wrappedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get wrappedTryAgain;

  /// No description provided for @wrappedCloseSemantics.
  ///
  /// In en, this message translates to:
  /// **'Close wrapped'**
  String get wrappedCloseSemantics;

  /// No description provided for @wrappedSkipToSummary.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get wrappedSkipToSummary;

  /// No description provided for @wrappedSkipToSummarySemantics.
  ///
  /// In en, this message translates to:
  /// **'Skip to summary page'**
  String get wrappedSkipToSummarySemantics;

  /// No description provided for @wrappedPageSemantics.
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber}: {title}'**
  String wrappedPageSemantics(int pageNumber, String title);

  /// No description provided for @wrappedProgressSemantics.
  ///
  /// In en, this message translates to:
  /// **'Wrapped page {currentPage} of {totalPages}'**
  String wrappedProgressSemantics(int currentPage, int totalPages);

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'{year} Review'**
  String impact(int year);

  /// No description provided for @unknownCategory.
  ///
  /// In en, this message translates to:
  /// **'Unknown Category'**
  String get unknownCategory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'Using system setting'**
  String get systemDefault;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode enabled'**
  String get lightMode;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode enabled'**
  String get darkModeEnabled;

  /// No description provided for @answerFaqs.
  ///
  /// In en, this message translates to:
  /// **'Answer FAQs'**
  String get answerFaqs;

  /// No description provided for @receiptPdf.
  ///
  /// In en, this message translates to:
  /// **'Receipt PDF'**
  String get receiptPdf;

  /// No description provided for @venue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venue;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time_2.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time_2;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @updateSubscription.
  ///
  /// In en, this message translates to:
  /// **'Update Subscription'**
  String get updateSubscription;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Media'**
  String get addMedia;

  /// No description provided for @addEventPhotos_2.
  ///
  /// In en, this message translates to:
  /// **'Add Event Photos'**
  String get addEventPhotos_2;

  /// No description provided for @sharePhotosAndMemoriesFromThisEvent.
  ///
  /// In en, this message translates to:
  /// **'Share photos and memories from this event'**
  String get sharePhotosAndMemoriesFromThisEvent;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record audio'**
  String get recordAudio;

  /// No description provided for @recordEventAudio.
  ///
  /// In en, this message translates to:
  /// **'Record event audio'**
  String get recordEventAudio;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @missionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'missions completed'**
  String get missionsCompleted;

  /// No description provided for @soulsTouched.
  ///
  /// In en, this message translates to:
  /// **'souls touched'**
  String get soulsTouched;

  /// No description provided for @coursesCompleted.
  ///
  /// In en, this message translates to:
  /// **'courses completed'**
  String get coursesCompleted;

  /// No description provided for @prayerResponses.
  ///
  /// In en, this message translates to:
  /// **'prayer responses'**
  String get prayerResponses;

  /// No description provided for @eventsAttended.
  ///
  /// In en, this message translates to:
  /// **'events attended'**
  String get eventsAttended;

  /// No description provided for @recordAnswer.
  ///
  /// In en, this message translates to:
  /// **'Record answer'**
  String get recordAnswer;

  /// No description provided for @noAnswersYet.
  ///
  /// In en, this message translates to:
  /// **'No answers yet'**
  String get noAnswersYet;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @searchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Search questions'**
  String get searchQuestions;

  /// No description provided for @loadingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Loading questions'**
  String get loadingQuestions;

  /// No description provided for @debriefNoteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Debrief note deleted'**
  String get debriefNoteDeleted;

  /// No description provided for @feedbackData.
  ///
  /// In en, this message translates to:
  /// **'Feedback Data'**
  String get feedbackData;

  /// No description provided for @questionsCapturedAndPostMissionDebriefReflections.
  ///
  /// In en, this message translates to:
  /// **'Questions captured and post-mission debrief reflections.'**
  String get questionsCapturedAndPostMissionDebriefReflections;

  /// No description provided for @finances.
  ///
  /// In en, this message translates to:
  /// **'Finances'**
  String get finances;

  /// No description provided for @requisitionsAndExpenseTrackingForThisMission.
  ///
  /// In en, this message translates to:
  /// **'Requisitions and expense tracking for this mission.'**
  String get requisitionsAndExpenseTrackingForThisMission;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @missionContextTeamMembersAndSessions.
  ///
  /// In en, this message translates to:
  /// **'Mission context, team members, and sessions.'**
  String get missionContextTeamMembersAndSessions;

  /// No description provided for @receiptUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Receipt uploaded successfully'**
  String get receiptUploadedSuccessfully;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No Expenses Yet'**
  String get noExpensesYet;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @receiptDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Receipt deleted successfully'**
  String get receiptDeletedSuccessfully;

  /// No description provided for @deleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Delete Receipt'**
  String get deleteReceipt;

  /// No description provided for @addExpense_2.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense_2;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @addRefund.
  ///
  /// In en, this message translates to:
  /// **'Add Refund'**
  String get addRefund;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copiedToClipboard_2.
  ///
  /// In en, this message translates to:
  /// **'Copied \"{value}\" to clipboard'**
  String copiedToClipboard_2(Object value);

  /// No description provided for @refundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund Amount'**
  String get refundAmount;

  /// No description provided for @addRefundEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Refund Entry'**
  String get addRefundEntry;

  /// No description provided for @tokenAmount_2.
  ///
  /// In en, this message translates to:
  /// **'Token Amount'**
  String get tokenAmount_2;

  /// No description provided for @updateExpense.
  ///
  /// In en, this message translates to:
  /// **'Update Expense'**
  String get updateExpense;

  /// No description provided for @mediaDeleted.
  ///
  /// In en, this message translates to:
  /// **'Media deleted'**
  String get mediaDeleted;

  /// No description provided for @savedToDevice.
  ///
  /// In en, this message translates to:
  /// **'Saved to device'**
  String get savedToDevice;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get failedToSave;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @questionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Question updated'**
  String get questionUpdated;

  /// No description provided for @questionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted'**
  String get questionDeleted;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @requisitions.
  ///
  /// In en, this message translates to:
  /// **'Requisitions'**
  String get requisitions;

  /// No description provided for @noRequisitions.
  ///
  /// In en, this message translates to:
  /// **'No Requisitions'**
  String get noRequisitions;

  /// No description provided for @queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// No description provided for @retryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry all'**
  String get retryAll;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @sessionInformation.
  ///
  /// In en, this message translates to:
  /// **'Session information'**
  String get sessionInformation;

  /// No description provided for @soulDeleted.
  ///
  /// In en, this message translates to:
  /// **'Soul deleted'**
  String get soulDeleted;

  /// No description provided for @missionSubscribers.
  ///
  /// In en, this message translates to:
  /// **'Mission Subscribers'**
  String get missionSubscribers;

  /// No description provided for @membersSubscribedToThisMission.
  ///
  /// In en, this message translates to:
  /// **'Members subscribed to this mission.'**
  String get membersSubscribedToThisMission;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @callMember.
  ///
  /// In en, this message translates to:
  /// **'Call Member'**
  String get callMember;

  /// No description provided for @eGCoolHighSchool.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cool High School'**
  String get eGCoolHighSchool;

  /// No description provided for @eGTrJohn.
  ///
  /// In en, this message translates to:
  /// **'e.g., Tr John'**
  String get eGTrJohn;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'{school_totalStudents} students'**
  String students(Object school_totalStudents);

  /// No description provided for @missions_2.
  ///
  /// In en, this message translates to:
  /// **'{school_missions_length} missions'**
  String missions_2(Object school_missions_length);

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @unableToPlayAudio.
  ///
  /// In en, this message translates to:
  /// **'Unable to play audio'**
  String get unableToPlayAudio;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @retryNow.
  ///
  /// In en, this message translates to:
  /// **'Retry now'**
  String get retryNow;

  /// No description provided for @pendingUploads.
  ///
  /// In en, this message translates to:
  /// **'Pending uploads'**
  String get pendingUploads;

  /// No description provided for @useAppWhileRecording.
  ///
  /// In en, this message translates to:
  /// **'Use app while recording'**
  String get useAppWhileRecording;

  /// No description provided for @useAppWhilePaused.
  ///
  /// In en, this message translates to:
  /// **'Use app while paused'**
  String get useAppWhilePaused;

  /// No description provided for @answerUploaded.
  ///
  /// In en, this message translates to:
  /// **'Answer uploaded'**
  String get answerUploaded;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noPendingUploads.
  ///
  /// In en, this message translates to:
  /// **'No pending uploads'**
  String get noPendingUploads;

  /// No description provided for @pendingUploads_2.
  ///
  /// In en, this message translates to:
  /// **'Pending Uploads'**
  String get pendingUploads_2;

  /// No description provided for @uploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{upload_name} uploaded successfully'**
  String uploadedSuccessfully(Object upload_name);

  /// No description provided for @retryFailed.
  ///
  /// In en, this message translates to:
  /// **'Retry failed'**
  String get retryFailed;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Mission Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore and suggest missions, make giving contributions, and check the latest answers and announcements.'**
  String get dashboardSubtitle;

  /// No description provided for @prayerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Prayer prompt'**
  String get prayerPrompt;

  /// No description provided for @emptyActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyActionsTitle;

  /// No description provided for @emptyActionsBody.
  ///
  /// In en, this message translates to:
  /// **'Fellowship actions will appear here once they are published.'**
  String get emptyActionsBody;

  /// No description provided for @allPast.
  ///
  /// In en, this message translates to:
  /// **'All Past'**
  String get allPast;

  /// No description provided for @yourNextMission.
  ///
  /// In en, this message translates to:
  /// **'Your next mission'**
  String get yourNextMission;

  /// No description provided for @missionsIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a mission to serve in — or catch up on the grounds we have already visited.'**
  String get missionsIntroBody;

  /// No description provided for @upcomingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Upcoming'**
  String upcomingCount(int count);

  /// No description provided for @subscribedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Subscribed'**
  String subscribedCount(int count);

  /// No description provided for @noUnreadQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'No unread questions right now. New questions from students will appear here.'**
  String get noUnreadQuestionsDesc;

  /// No description provided for @noRepliedQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'No replied questions yet. Answers you send to students will collect here.'**
  String get noRepliedQuestionsDesc;

  /// No description provided for @noAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Announcements and publications from the fellowship will appear here.'**
  String get noAnnouncementsDesc;

  /// No description provided for @schoolPastMissions.
  ///
  /// In en, this message translates to:
  /// **'School Past Missions'**
  String get schoolPastMissions;

  /// No description provided for @spiritualLegacy.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Legacy'**
  String get spiritualLegacy;

  /// No description provided for @schoolLegacyBody.
  ///
  /// In en, this message translates to:
  /// **'Explore all historical missions carried out by PRF at this school. Touch lives, follow up with student enquiries, and review past statistics.'**
  String get schoolLegacyBody;

  /// No description provided for @noPastMissionsForSchool.
  ///
  /// In en, this message translates to:
  /// **'No past missions for this school.'**
  String get noPastMissionsForSchool;

  /// No description provided for @groundSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Ground Suggestions'**
  String get groundSuggestions;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @suggestGroundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggest Mission Grounds'**
  String get suggestGroundsTitle;

  /// No description provided for @suggestGroundsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Suggest new schools or centers that need spiritual interventions. The fellowship review board evaluates all entries to establish new missions.'**
  String get suggestGroundsPanelBody;

  /// No description provided for @noQuestionsYet.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get noQuestionsYet;

  /// No description provided for @noQuestionsFound.
  ///
  /// In en, this message translates to:
  /// **'No questions found'**
  String get noQuestionsFound;

  /// No description provided for @questionsFromMissionsBody.
  ///
  /// In en, this message translates to:
  /// **'Questions from missions will appear here'**
  String get questionsFromMissionsBody;

  /// No description provided for @tryDifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// No description provided for @missionsFaqHub.
  ///
  /// In en, this message translates to:
  /// **'Missions FAQ Hub'**
  String get missionsFaqHub;

  /// No description provided for @faqHubIntro.
  ///
  /// In en, this message translates to:
  /// **'Record audio answers to student questions, which are transcribed into text automatically.'**
  String get faqHubIntro;

  /// No description provided for @answerTranscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer & Transcribe'**
  String get answerTranscribeTitle;

  /// No description provided for @faqHubPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Review incoming student questions on the left. Tap \"Record Answer\" to capture your audio feedback, which is transcribed by AI to serve the fellowship.'**
  String get faqHubPanelBody;

  /// No description provided for @awaitingAnswers.
  ///
  /// In en, this message translates to:
  /// **'Awaiting answers'**
  String get awaitingAnswers;

  /// No description provided for @answersCount.
  ///
  /// In en, this message translates to:
  /// **'Answers ({count})'**
  String answersCount(int count);

  /// No description provided for @missionThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mission theme: {theme}'**
  String missionThemeLabel(Object theme);

  /// No description provided for @recordAnswerSemantic.
  ///
  /// In en, this message translates to:
  /// **'Record answer to: {question}'**
  String recordAnswerSemantic(Object question);

  /// No description provided for @overviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTab;

  /// No description provided for @feedbackDataTab.
  ///
  /// In en, this message translates to:
  /// **'Feedback Data'**
  String get feedbackDataTab;

  /// No description provided for @financeTab.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTab;

  /// No description provided for @missionOverview.
  ///
  /// In en, this message translates to:
  /// **'Mission Overview'**
  String get missionOverview;

  /// No description provided for @schoolNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'School not specified'**
  String get schoolNotSpecified;

  /// No description provided for @generalMission.
  ///
  /// In en, this message translates to:
  /// **'General Mission'**
  String get generalMission;

  /// No description provided for @interactiveActions.
  ///
  /// In en, this message translates to:
  /// **'Interactive Actions'**
  String get interactiveActions;

  /// No description provided for @missionActionsGuidance.
  ///
  /// In en, this message translates to:
  /// **'The button below dynamically adapts to your current selected tab. Add sessions, write debriefs, register souls, or report expenses seamlessly.'**
  String get missionActionsGuidance;

  /// No description provided for @latestCampaign.
  ///
  /// In en, this message translates to:
  /// **'Latest Campaign'**
  String get latestCampaign;

  /// No description provided for @announcementsPanelIntro.
  ///
  /// In en, this message translates to:
  /// **'Announcements and publications received recently from the Fellowship admin.'**
  String get announcementsPanelIntro;

  /// No description provided for @stayUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Stay Up to Date'**
  String get stayUpToDate;

  /// No description provided for @announcementsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Keep track of important announcements, spiritual years publications, events alerts, and news directly shared by Park Road Fellowship.'**
  String get announcementsPanelBody;

  /// No description provided for @publicationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Publications'**
  String publicationsCount(int count);

  /// No description provided for @prayerSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Summary'**
  String get prayerSummaryTitle;

  /// No description provided for @prayerPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Submit your prayer needs directly to the fellowship. Together in one spirit, we stand in prayer watch and lift up our requests.'**
  String get prayerPanelBody;

  /// No description provided for @enquiryDashboard.
  ///
  /// In en, this message translates to:
  /// **'Enquiry Dashboard'**
  String get enquiryDashboard;

  /// No description provided for @unreadQuestions.
  ///
  /// In en, this message translates to:
  /// **'Unread Questions'**
  String get unreadQuestions;

  /// No description provided for @repliedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Replied Questions'**
  String get repliedQuestions;

  /// No description provided for @ministerToStudents.
  ///
  /// In en, this message translates to:
  /// **'Minister to Students'**
  String get ministerToStudents;

  /// No description provided for @enquiriesPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Answer enquiries submitted by students. Share wisdom and feedback on spiritual matters, or guide them through their doubts.'**
  String get enquiriesPanelBody;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @findQuickAnswers.
  ///
  /// In en, this message translates to:
  /// **'Find Quick Answers'**
  String get findQuickAnswers;

  /// No description provided for @faqsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Search through compiled FAQs or filter by categories on the left panel to find immediate guidelines about PRF Missions and fellowship rules.'**
  String get faqsPanelBody;

  /// No description provided for @noFaqsDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse categories or search to find answers about PRF Missions and fellowship life.'**
  String get noFaqsDesc;

  /// No description provided for @givingSummary.
  ///
  /// In en, this message translates to:
  /// **'Giving Summary'**
  String get givingSummary;

  /// No description provided for @supportFellowshipMissions.
  ///
  /// In en, this message translates to:
  /// **'Support Fellowship Missions'**
  String get supportFellowshipMissions;

  /// No description provided for @givingPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Your giving enables spiritual growth and supports critical missions, local requisitions, and fellowship operations.'**
  String get givingPanelBody;

  /// No description provided for @fellowshipEvents.
  ///
  /// In en, this message translates to:
  /// **'Fellowship Events'**
  String get fellowshipEvents;

  /// No description provided for @eventsPanelIntro.
  ///
  /// In en, this message translates to:
  /// **'Join fellowship gatherings, teachings, conferences and local spiritual events.'**
  String get eventsPanelIntro;

  /// No description provided for @participateLearn.
  ///
  /// In en, this message translates to:
  /// **'Participate & Learn'**
  String get participateLearn;

  /// No description provided for @eventsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Tap any event from the left list to subscribe and secure your slot, view attendees lists, and read schedules and timelines.'**
  String get eventsPanelBody;

  /// No description provided for @availableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Available'**
  String availableCount(int count);

  /// No description provided for @venueNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Venue not specified'**
  String get venueNotSpecified;

  /// No description provided for @addRecordings.
  ///
  /// In en, this message translates to:
  /// **'Add recordings'**
  String get addRecordings;

  /// No description provided for @recordingsCaptureBody.
  ///
  /// In en, this message translates to:
  /// **'Record audio to capture event highlights.'**
  String get recordingsCaptureBody;

  /// No description provided for @growInKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Grow in Knowledge'**
  String get growInKnowledge;

  /// No description provided for @lmsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Acquire wisdom and understanding through structured learning courses. Take courses, complete modules, and learn at your own pace.'**
  String get lmsPanelBody;

  /// No description provided for @noCoursesDesc.
  ///
  /// In en, this message translates to:
  /// **'New courses will appear here as the fellowship publishes them.'**
  String get noCoursesDesc;

  /// No description provided for @completeAllModules.
  ///
  /// In en, this message translates to:
  /// **'Complete all Modules'**
  String get completeAllModules;

  /// No description provided for @modulesPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Each module has specific learning content and lessons. View and study module actions on the left panel.'**
  String get modulesPanelBody;

  /// No description provided for @noModulesDesc.
  ///
  /// In en, this message translates to:
  /// **'Modules will appear here once the course content is published.'**
  String get noModulesDesc;

  /// No description provided for @studyYourLessons.
  ///
  /// In en, this message translates to:
  /// **'Study your Lessons'**
  String get studyYourLessons;

  /// No description provided for @lessonsPanelBody.
  ///
  /// In en, this message translates to:
  /// **'Each lesson includes informative texts and resources to grow. Tap lessons on the left list to begin studying.'**
  String get lessonsPanelBody;

  /// No description provided for @noLessonsDesc.
  ///
  /// In en, this message translates to:
  /// **'Lessons will appear here once the module content is published.'**
  String get noLessonsDesc;

  /// No description provided for @noLessonResources.
  ///
  /// In en, this message translates to:
  /// **'No learning resources are attached to this lesson yet.'**
  String get noLessonResources;

  /// No description provided for @noMissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Upcoming missions will appear here once the missions desk announces them.'**
  String get noMissionsDesc;

  /// No description provided for @noRepliesYet.
  ///
  /// In en, this message translates to:
  /// **'No replies yet. Responses from the desk will appear here.'**
  String get noRepliesYet;

  /// No description provided for @noSubscribersDesc.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions will appear here as members join this mission.'**
  String get noSubscribersDesc;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(Object field);

  /// No description provided for @fixHighlightedFields.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields and try again.'**
  String get fixHighlightedFields;

  /// No description provided for @ticketsRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of tickets is required'**
  String get ticketsRequired;

  /// No description provided for @noPaymentTypesFound.
  ///
  /// In en, this message translates to:
  /// **'No payment types found'**
  String get noPaymentTypesFound;

  /// No description provided for @noSubscribersFound.
  ///
  /// In en, this message translates to:
  /// **'No subscribers found'**
  String get noSubscribersFound;

  /// No description provided for @noClassGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'No class groups found'**
  String get noClassGroupsFound;

  /// No description provided for @updateSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Session'**
  String get updateSessionTitle;

  /// No description provided for @updateQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Question'**
  String get updateQuestionTitle;

  /// No description provided for @updateNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Note'**
  String get updateNoteTitle;

  /// No description provided for @updateSoulTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Soul'**
  String get updateSoulTitle;

  /// No description provided for @failedUploadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload receipt: {message}'**
  String failedUploadReceipt(Object message);

  /// No description provided for @failedSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image: {error}'**
  String failedSelectImage(Object error);

  /// No description provided for @failedSelectPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to select PDF: {error}'**
  String failedSelectPdf(Object error);

  /// No description provided for @startAddingExpense.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first expense'**
  String get startAddingExpense;

  /// No description provided for @tapToHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to hide details'**
  String get tapToHideDetails;

  /// No description provided for @tapToViewTransactions.
  ///
  /// In en, this message translates to:
  /// **'Tap to view {count} transactions'**
  String tapToViewTransactions(int count);

  /// No description provided for @deleteReceiptConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this receipt? This action cannot be undone.'**
  String get deleteReceiptConfirm;

  /// No description provided for @deleteExpenseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense?'**
  String get deleteExpenseConfirm;

  /// No description provided for @attachReceiptOrDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Attach receipt or documentation'**
  String get attachReceiptOrDocumentation;

  /// No description provided for @receiptMissing.
  ///
  /// In en, this message translates to:
  /// **'Receipt Missing'**
  String get receiptMissing;

  /// No description provided for @transactionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Transaction Breakdown'**
  String get transactionBreakdown;

  /// No description provided for @refundEntries.
  ///
  /// In en, this message translates to:
  /// **'Refund Entries'**
  String get refundEntries;

  /// No description provided for @deficitAmount.
  ///
  /// In en, this message translates to:
  /// **'Deficit Amount'**
  String get deficitAmount;

  /// No description provided for @confirmationLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmationLabel;

  /// No description provided for @imageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageLabel;

  /// No description provided for @attachmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Attachment} other{{count} Attachments}}'**
  String attachmentsCount(int count);

  /// No description provided for @continueConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to continue?'**
  String get continueConfirm;

  /// No description provided for @editDebriefTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit debrief note'**
  String get editDebriefTooltip;

  /// No description provided for @deleteDebriefTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete debrief note'**
  String get deleteDebriefTooltip;

  /// No description provided for @removeNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Remove functionality not implemented'**
  String get removeNotImplemented;

  /// No description provided for @debriefNoteRequired.
  ///
  /// In en, this message translates to:
  /// **'Note is required'**
  String get debriefNoteRequired;

  /// No description provided for @sessionNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Preparation notes are required'**
  String get sessionNotesRequired;

  /// No description provided for @prayerRequestRequired.
  ///
  /// In en, this message translates to:
  /// **'Prayer request is required'**
  String get prayerRequestRequired;

  /// No description provided for @viewSubscriberTooltip.
  ///
  /// In en, this message translates to:
  /// **'View subscriber'**
  String get viewSubscriberTooltip;

  /// No description provided for @callSubscriberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Call subscriber'**
  String get callSubscriberTooltip;

  /// No description provided for @selectedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Selected Photos'**
  String get selectedPhotos;

  /// No description provided for @debriefNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Debrief Notes'**
  String get debriefNotesTitle;

  /// No description provided for @untitledNote.
  ///
  /// In en, this message translates to:
  /// **'Untitled note'**
  String get untitledNote;

  /// No description provided for @travelTime.
  ///
  /// In en, this message translates to:
  /// **'Travel Time'**
  String get travelTime;

  /// No description provided for @deleteMediaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this media?'**
  String get deleteMediaConfirm;

  /// No description provided for @errorLoadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error loading media'**
  String get errorLoadingMedia;

  /// No description provided for @tapToSelectMedia.
  ///
  /// In en, this message translates to:
  /// **'Tap to select {mediaType}'**
  String tapToSelectMedia(Object mediaType);

  /// No description provided for @chooseMultipleToShare.
  ///
  /// In en, this message translates to:
  /// **'Choose multiple {mediaType} to share'**
  String chooseMultipleToShare(Object mediaType);

  /// No description provided for @groundNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Mission ground name is required'**
  String get groundNameRequired;

  /// No description provided for @contactPersonRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact person is required'**
  String get contactPersonRequired;

  /// No description provided for @contactNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact number is required'**
  String get contactNumberRequired;

  /// No description provided for @statusRequired.
  ///
  /// In en, this message translates to:
  /// **'Status is required'**
  String get statusRequired;

  /// No description provided for @noStatusesFound.
  ///
  /// In en, this message translates to:
  /// **'No statuses found'**
  String get noStatusesFound;

  /// No description provided for @editSoulTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit soul'**
  String get editSoulTooltip;

  /// No description provided for @deleteSoulTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete soul'**
  String get deleteSoulTooltip;

  /// No description provided for @recordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Recording saved ({duration})'**
  String recordingSaved(Object duration);

  /// No description provided for @queuedRecordingsForSession.
  ///
  /// In en, this message translates to:
  /// **'Queued recordings for this session'**
  String get queuedRecordingsForSession;

  /// No description provided for @syncingRecording.
  ///
  /// In en, this message translates to:
  /// **'Syncing recording...'**
  String get syncingRecording;

  /// No description provided for @recorderIdle.
  ///
  /// In en, this message translates to:
  /// **'Recorder idle'**
  String get recorderIdle;

  /// No description provided for @recorderReady.
  ///
  /// In en, this message translates to:
  /// **'Recorder ready'**
  String get recorderReady;

  /// No description provided for @recordingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress'**
  String get recordingInProgress;

  /// No description provided for @savedLocally.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get savedLocally;

  /// No description provided for @recorderNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Recorder needs attention'**
  String get recorderNeedsAttention;

  /// No description provided for @noNotesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No notes available'**
  String get noNotesAvailable;

  /// No description provided for @missionQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mission Questions'**
  String get missionQuestionsTitle;

  /// No description provided for @untitledQuestion.
  ///
  /// In en, this message translates to:
  /// **'Untitled question'**
  String get untitledQuestion;

  /// No description provided for @editQuestionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit question'**
  String get editQuestionTooltip;

  /// No description provided for @deleteQuestionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete question'**
  String get deleteQuestionTooltip;

  /// No description provided for @queuedRecordings.
  ///
  /// In en, this message translates to:
  /// **'Queued recordings'**
  String get queuedRecordings;

  /// No description provided for @offlineRecordingNotice.
  ///
  /// In en, this message translates to:
  /// **'You are offline. The app will retry when you are back online. You can continue using the app.'**
  String get offlineRecordingNotice;

  /// No description provided for @backgroundRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording continues in the background.'**
  String get backgroundRecording;

  /// No description provided for @confirmationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirmation message is required'**
  String get confirmationMessageRequired;

  /// No description provided for @enterConfirmationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation message or reference number'**
  String get enterConfirmationHint;

  /// No description provided for @addTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Token'**
  String get addTokenTitle;

  /// No description provided for @addTokenDesc.
  ///
  /// In en, this message translates to:
  /// **'Add funds as a credit entry to the allocation'**
  String get addTokenDesc;

  /// No description provided for @enterTokenAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter token amount'**
  String get enterTokenAmount;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpenseTitle;

  /// No description provided for @editExpenseDesc.
  ///
  /// In en, this message translates to:
  /// **'Update expense details and receipts'**
  String get editExpenseDesc;

  /// No description provided for @addNewExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Expense'**
  String get addNewExpenseTitle;

  /// No description provided for @addNewExpenseDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below to record a new expense'**
  String get addNewExpenseDesc;

  /// No description provided for @addRefundEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Refund Entry'**
  String get addRefundEntryTitle;

  /// No description provided for @addRefundEntryDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a new refund entry for this accounting event'**
  String get addRefundEntryDesc;

  /// No description provided for @enterRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter refund amount'**
  String get enterRefundAmount;

  /// No description provided for @refundAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Refund entry added successfully'**
  String get refundAddedSuccessfully;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @capturedAt.
  ///
  /// In en, this message translates to:
  /// **'Captured {date}'**
  String capturedAt(Object date);

  /// No description provided for @soulsTitle.
  ///
  /// In en, this message translates to:
  /// **'Souls'**
  String get soulsTitle;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayLabel(int day);

  /// No description provided for @loadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Loading video...'**
  String get loadingVideo;

  /// No description provided for @errorLoadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error loading video'**
  String get errorLoadingVideo;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// No description provided for @missionGroundTab.
  ///
  /// In en, this message translates to:
  /// **'Mission Ground'**
  String get missionGroundTab;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;

  /// No description provided for @noFinancialDataForMission.
  ///
  /// In en, this message translates to:
  /// **'No financial data available for this mission.'**
  String get noFinancialDataForMission;

  /// No description provided for @noRequisitionsCreated.
  ///
  /// In en, this message translates to:
  /// **'No requisitions have been created for this mission.'**
  String get noRequisitionsCreated;

  /// No description provided for @noLineItems.
  ///
  /// In en, this message translates to:
  /// **'No line items'**
  String get noLineItems;

  /// No description provided for @subscribers.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get subscribers;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
