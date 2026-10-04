import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
    Locale('fi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rocketbot'**
  String get appName;

  /// Rocketbot app
  ///
  /// In en, this message translates to:
  /// **'Rocketbot'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @e_mail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get e_mail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @conf_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get conf_password;

  /// No description provided for @forgot_pass.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_pass;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @sign_in_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get sign_in_google;

  /// No description provided for @sign_in_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get sign_in_apple;

  /// No description provided for @enter_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter code from the e-mail'**
  String get enter_code;

  /// No description provided for @enter_code_hint.
  ///
  /// In en, this message translates to:
  /// **'E-mail code'**
  String get enter_code_hint;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @succ.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get succ;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @agreed_to.
  ///
  /// In en, this message translates to:
  /// **'Agreed to'**
  String get agreed_to;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get terms;

  /// No description provided for @forgot_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgot_email;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get fees;

  /// No description provided for @min_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Min amount'**
  String get min_withdraw;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentTo;

  /// No description provided for @txid.
  ///
  /// In en, this message translates to:
  /// **'TX id:'**
  String get txid;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get all;

  /// No description provided for @onew.
  ///
  /// In en, this message translates to:
  /// **'1W'**
  String get onew;

  /// No description provided for @oned.
  ///
  /// In en, this message translates to:
  /// **'1D'**
  String get oned;

  /// No description provided for @twelveh.
  ///
  /// In en, this message translates to:
  /// **'12H'**
  String get twelveh;

  /// No description provided for @no_tx.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get no_tx;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorer;

  /// No description provided for @txdet.
  ///
  /// In en, this message translates to:
  /// **'Transaction Detail'**
  String get txdet;

  /// No description provided for @tx.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get tx;

  /// No description provided for @txcopy.
  ///
  /// In en, this message translates to:
  /// **'TX id copied to clipboard'**
  String get txcopy;

  /// No description provided for @confirmations.
  ///
  /// In en, this message translates to:
  /// **'confirmations'**
  String get confirmations;

  /// No description provided for @history_popup.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get history_popup;

  /// No description provided for @settings_popup.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings_popup;

  /// No description provided for @socials_popup.
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get socials_popup;

  /// No description provided for @about_popup.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about_popup;

  /// No description provided for @choose_coin.
  ///
  /// In en, this message translates to:
  /// **'Choose coin'**
  String get choose_coin;

  /// No description provided for @or_scan_qr.
  ///
  /// In en, this message translates to:
  /// **'or receive via QR-code'**
  String get or_scan_qr;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @or_send_scan_qr.
  ///
  /// In en, this message translates to:
  /// **'or send via QR-code'**
  String get or_send_scan_qr;

  /// No description provided for @graph_no_data.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we couldn\'t get the data for the graph'**
  String get graph_no_data;

  /// No description provided for @settings_screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_screen;

  /// No description provided for @settings_main.
  ///
  /// In en, this message translates to:
  /// **'Main Settings'**
  String get settings_main;

  /// No description provided for @settings_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get settings_privacy;

  /// No description provided for @qr_scan_flash.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get qr_scan_flash;

  /// No description provided for @qr_scan_on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get qr_scan_on;

  /// No description provided for @qr_scan_off.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get qr_scan_off;

  /// No description provided for @qr_scan_back.
  ///
  /// In en, this message translates to:
  /// **'Back Camera'**
  String get qr_scan_back;

  /// No description provided for @qr_scan_front.
  ///
  /// In en, this message translates to:
  /// **'Fron Camera'**
  String get qr_scan_front;

  /// No description provided for @sc_headline.
  ///
  /// In en, this message translates to:
  /// **'APP Security'**
  String get sc_headline;

  /// No description provided for @sc_auth_headline.
  ///
  /// In en, this message translates to:
  /// **'Authentication Settings'**
  String get sc_auth_headline;

  /// No description provided for @sc_auth_type.
  ///
  /// In en, this message translates to:
  /// **'Authenticate by:'**
  String get sc_auth_type;

  /// No description provided for @sc_pin_settings.
  ///
  /// In en, this message translates to:
  /// **'PIN settings'**
  String get sc_pin_settings;

  /// No description provided for @sc_change_pin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get sc_change_pin;

  /// No description provided for @sc_remove_pin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get sc_remove_pin;

  /// No description provided for @sc_change_succ.
  ///
  /// In en, this message translates to:
  /// **'PIN change successful'**
  String get sc_change_succ;

  /// No description provided for @sc_change_fuck.
  ///
  /// In en, this message translates to:
  /// **'PIN change unsuccessful'**
  String get sc_change_fuck;

  /// No description provided for @sc_pin_removed.
  ///
  /// In en, this message translates to:
  /// **'PIN removed successfully'**
  String get sc_pin_removed;

  /// No description provided for @sc_pin_removed_fucked.
  ///
  /// In en, this message translates to:
  /// **'PIN hasn\'t been removed'**
  String get sc_pin_removed_fucked;

  /// No description provided for @sc_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sc_security;

  /// No description provided for @as_enter_pin.
  ///
  /// In en, this message translates to:
  /// **'Please enter PIN'**
  String get as_enter_pin;

  /// No description provided for @as_wrong_pin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN, please try again'**
  String get as_wrong_pin;

  /// No description provided for @as_enter_desired_pin.
  ///
  /// In en, this message translates to:
  /// **'Please enter desired PIN'**
  String get as_enter_desired_pin;

  /// No description provided for @as_enter_desired_confirm_pin.
  ///
  /// In en, this message translates to:
  /// **'Please confirm desired PIN'**
  String get as_enter_desired_confirm_pin;

  /// No description provided for @dl_log_out.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out of the app?'**
  String get dl_log_out;

  /// No description provided for @dl_soc_log_out.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to unlink {number1} from Rocketbot?'**
  String dl_soc_log_out(Object number1);

  /// No description provided for @about_rocket.
  ///
  /// In en, this message translates to:
  /// **'RocketBot Wallet App, uses cryptocurrencies for micropayments on social media platforms(Twitter, Telegram & Discord).'**
  String get about_rocket;

  /// No description provided for @about_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get about_terms;

  /// No description provided for @about_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get about_policy;

  /// No description provided for @about_visit.
  ///
  /// In en, this message translates to:
  /// **'Visit our website'**
  String get about_visit;

  /// No description provided for @about_merge.
  ///
  /// In en, this message translates to:
  /// **'Project Merge '**
  String get about_merge;

  /// No description provided for @about_devs.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get about_devs;

  /// No description provided for @about_develop.
  ///
  /// In en, this message translates to:
  /// **'Development site'**
  String get about_develop;

  /// No description provided for @about_licences.
  ///
  /// In en, this message translates to:
  /// **'View licences'**
  String get about_licences;

  /// No description provided for @dp_error.
  ///
  /// In en, this message translates to:
  /// **'Error: Withdrawal Disabled'**
  String get dp_error;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @username_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid surname name'**
  String get username_invalid;

  /// No description provided for @username_invalid_message.
  ///
  /// In en, this message translates to:
  /// **'The surname has to be at least 1 characters long'**
  String get username_invalid_message;

  /// No description provided for @password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get password_invalid;

  /// No description provided for @password_invalid_message.
  ///
  /// In en, this message translates to:
  /// **'The password should be at least 8 characters long'**
  String get password_invalid_message;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid e-mail'**
  String get email_invalid;

  /// No description provided for @email_invalid_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid e-mail address'**
  String get email_invalid_message;

  /// No description provided for @name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid name'**
  String get name_invalid;

  /// No description provided for @name_invalid_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter name which is longer than 1 character'**
  String get name_invalid_message;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get password_mismatch;

  /// No description provided for @password_mismatch_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter same password to password and password confirmation box'**
  String get password_mismatch_message;

  /// No description provided for @coin_sent.
  ///
  /// In en, this message translates to:
  /// **'Transaction executed successfully'**
  String get coin_sent;

  /// No description provided for @reg_succ.
  ///
  /// In en, this message translates to:
  /// **'Please check your email inbox, for register confirmation'**
  String get reg_succ;

  /// No description provided for @terms_agree.
  ///
  /// In en, this message translates to:
  /// **'You need to agree with terms and conditions'**
  String get terms_agree;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deflt.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get deflt;

  /// No description provided for @by_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get by_amount;

  /// No description provided for @alphabeticall.
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get alphabeticall;

  /// No description provided for @by_value.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get by_value;

  /// No description provided for @less_than.
  ///
  /// In en, this message translates to:
  /// **'Less than'**
  String get less_than;

  /// No description provided for @tx_problem.
  ///
  /// In en, this message translates to:
  /// **'Can\'t load transactions'**
  String get tx_problem;

  /// No description provided for @hide_zeros.
  ///
  /// In en, this message translates to:
  /// **'Hide zeros'**
  String get hide_zeros;

  /// No description provided for @social_accounts.
  ///
  /// In en, this message translates to:
  /// **'Social Accounts'**
  String get social_accounts;

  /// No description provided for @join_discord.
  ///
  /// In en, this message translates to:
  /// **'Join Rocketbot Discord'**
  String get join_discord;

  /// No description provided for @send_discord.
  ///
  /// In en, this message translates to:
  /// **'Send DM to Rocket(bot)'**
  String get send_discord;

  /// No description provided for @socials_info.
  ///
  /// In en, this message translates to:
  /// **'By linking your social media accounts, all tokens will be combined by RocketBot.pro. This secures your balances in the event your social media account is suspended. One account for all, powered by Merge.'**
  String get socials_info;

  /// No description provided for @socials_info_add.
  ///
  /// In en, this message translates to:
  /// **'RocketBot.pro & Merge need to be linked to web'**
  String get socials_info_add;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink {number1}'**
  String unlink(Object number1);

  /// No description provided for @stake_get_all.
  ///
  /// In en, this message translates to:
  /// **'Remove all Tokens'**
  String get stake_get_all;

  /// No description provided for @stake_get_reward.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Rewards'**
  String get stake_get_reward;

  /// No description provided for @stake_swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe to stake'**
  String get stake_swipe;

  /// No description provided for @send_swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe to send'**
  String get send_swipe;

  /// No description provided for @stake_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount to stake'**
  String get stake_amount;

  /// No description provided for @stake_wait.
  ///
  /// In en, this message translates to:
  /// **'Might take a while!'**
  String get stake_wait;

  /// No description provided for @stake_reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get stake_reward;

  /// No description provided for @stake_unconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Unconfirmed stake amount'**
  String get stake_unconfirmed;

  /// No description provided for @stake_staked_amount.
  ///
  /// In en, this message translates to:
  /// **'Staked amount'**
  String get stake_staked_amount;

  /// No description provided for @stake_available.
  ///
  /// In en, this message translates to:
  /// **'Available amount'**
  String get stake_available;

  /// No description provided for @stake_label.
  ///
  /// In en, this message translates to:
  /// **'Staking'**
  String get stake_label;

  /// No description provided for @staking_not_enough.
  ///
  /// In en, this message translates to:
  /// **'Not enough enough coins to complete the operation!'**
  String get staking_not_enough;

  /// No description provided for @staking_please_enter.
  ///
  /// In en, this message translates to:
  /// **'Staking amount cannot be empty! Please enter amount which will be sent to staking.'**
  String get staking_please_enter;

  /// No description provided for @staking_not_min.
  ///
  /// In en, this message translates to:
  /// **'Fail! \n Minimal amount to send:\n{number1} {number2}'**
  String staking_not_min(Object number1, Object number2);

  /// No description provided for @staking_with_info.
  ///
  /// In en, this message translates to:
  /// **'Your tokens have been sent, please allow {number1} confirmation before they become available'**
  String staking_with_info(Object number1);

  /// No description provided for @staking_lock_coins.
  ///
  /// In en, this message translates to:
  /// **'Coins will be locked for 24 hours'**
  String get staking_lock_coins;

  /// No description provided for @dl_not_close.
  ///
  /// In en, this message translates to:
  /// **'Do not exit the app!'**
  String get dl_not_close;

  /// No description provided for @dl_pls_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get dl_pls_wait;

  /// No description provided for @staking_total_tokens.
  ///
  /// In en, this message translates to:
  /// **'Total tokens in the pool'**
  String get staking_total_tokens;

  /// No description provided for @staking_monetary_value.
  ///
  /// In en, this message translates to:
  /// **'Monetary value'**
  String get staking_monetary_value;

  /// No description provided for @staking_contrib.
  ///
  /// In en, this message translates to:
  /// **'Your contribution'**
  String get staking_contrib;

  /// No description provided for @staking_est.
  ///
  /// In en, this message translates to:
  /// **'Your estimated reward'**
  String get staking_est;

  /// No description provided for @staking_day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get staking_day;

  /// No description provided for @st_less.
  ///
  /// In en, this message translates to:
  /// **'Show less details'**
  String get st_less;

  /// No description provided for @st_more.
  ///
  /// In en, this message translates to:
  /// **'Show more details'**
  String get st_more;

  /// No description provided for @referral.
  ///
  /// In en, this message translates to:
  /// **'Referral'**
  String get referral;

  /// No description provided for @ref_code.
  ///
  /// In en, this message translates to:
  /// **'Rocketbot referral code'**
  String get ref_code;

  /// No description provided for @ref_invite.
  ///
  /// In en, this message translates to:
  /// **'You have not been invited by anyone, enter or scan Rocketbot referral code to receive {number1} Merge! Referral bonus will be credited after you stake at least 10 Merge tokens.'**
  String ref_invite(Object number1);

  /// No description provided for @ref_unvite.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already used the invite promotion, keep an eye on our future ones'**
  String get ref_unvite;

  /// No description provided for @ref_hint.
  ///
  /// In en, this message translates to:
  /// **'Just scan the similar looking QR code and stake 10 Merge (in any order) and you are all set. \nUser is eligible for this promotion only once!'**
  String get ref_hint;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @mn_your_mns.
  ///
  /// In en, this message translates to:
  /// **'Your masternodes'**
  String get mn_your_mns;

  /// No description provided for @mn_total.
  ///
  /// In en, this message translates to:
  /// **'Number of active {number1} MNs'**
  String mn_total(Object number1);

  /// No description provided for @mn_day_reward.
  ///
  /// In en, this message translates to:
  /// **'Daily reward of 1 active {number1} MN'**
  String mn_day_reward(Object number1);

  /// No description provided for @mn_average_payrate.
  ///
  /// In en, this message translates to:
  /// **'MN average payrate'**
  String get mn_average_payrate;

  /// No description provided for @mn_average_start.
  ///
  /// In en, this message translates to:
  /// **'Average time to start MN'**
  String get mn_average_start;

  /// No description provided for @mn_time_to_start.
  ///
  /// In en, this message translates to:
  /// **'Average time to get 1st reward'**
  String get mn_time_to_start;

  /// No description provided for @mn_lock.
  ///
  /// In en, this message translates to:
  /// **'Tokens will be locked for 1 week'**
  String get mn_lock;

  /// No description provided for @mn_start.
  ///
  /// In en, this message translates to:
  /// **'Swipe to start MN'**
  String get mn_start;

  /// No description provided for @mn_manage.
  ///
  /// In en, this message translates to:
  /// **'Manage your MNs'**
  String get mn_manage;

  /// No description provided for @mn_reward.
  ///
  /// In en, this message translates to:
  /// **'Available reward'**
  String get mn_reward;

  /// No description provided for @mn_collateral.
  ///
  /// In en, this message translates to:
  /// **'Cost of masternode'**
  String get mn_collateral;

  /// No description provided for @mn_uncofirmed.
  ///
  /// In en, this message translates to:
  /// **'Pending Masternodes'**
  String get mn_uncofirmed;

  /// No description provided for @mn_roi.
  ///
  /// In en, this message translates to:
  /// **'Annual ROI'**
  String get mn_roi;

  /// No description provided for @mn_free.
  ///
  /// In en, this message translates to:
  /// **'Available MN nodes to start'**
  String get mn_free;

  /// No description provided for @settings_socials.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get settings_socials;

  /// No description provided for @mn_withdraw_box.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to withdraw MN #{number1}?'**
  String mn_withdraw_box(Object number1);

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'income'**
  String get income;

  /// No description provided for @st_adjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust staking balance'**
  String get st_adjust;

  /// No description provided for @st_amount.
  ///
  /// In en, this message translates to:
  /// **'Subtract amount'**
  String get st_amount;

  /// No description provided for @qr_scan.
  ///
  /// In en, this message translates to:
  /// **'QR scanner'**
  String get qr_scan;

  /// No description provided for @qr_scan_error.
  ///
  /// In en, this message translates to:
  /// **'QR code is not valid for this app'**
  String get qr_scan_error;

  /// No description provided for @web_login.
  ///
  /// In en, this message translates to:
  /// **'Rocket.art login'**
  String get web_login;
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
      <String>['cs', 'en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
    case 'fi':
      return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
