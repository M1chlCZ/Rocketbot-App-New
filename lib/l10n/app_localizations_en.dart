// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rocketbot';

  @override
  String get appTitle => 'Rocketbot';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get register_button => 'Register';

  @override
  String get e_mail => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get conf_password => 'Confirm Password';

  @override
  String get forgot_pass => 'Forgot Password?';

  @override
  String get or => 'or';

  @override
  String get sign_in => 'Sign in';

  @override
  String get sign_in_google => 'Sign in with Google';

  @override
  String get sign_in_apple => 'Sign in with Apple';

  @override
  String get enter_code => 'Please enter code from the e-mail';

  @override
  String get enter_code_hint => 'E-mail code';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get succ => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get alert => 'Alert';

  @override
  String get close => 'Close';

  @override
  String get agreed_to => 'Agreed to';

  @override
  String get terms => 'Terms and conditions';

  @override
  String get forgot_email => 'Please enter your email';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get about => 'About';

  @override
  String get receive => 'Receive';

  @override
  String get fees => 'Fees';

  @override
  String get min_withdraw => 'Min amount';

  @override
  String get send => 'Send';

  @override
  String get sentTo => 'Sent to';

  @override
  String get txid => 'TX id:';

  @override
  String get all => 'ALL';

  @override
  String get onew => '1W';

  @override
  String get oned => '1D';

  @override
  String get twelveh => '12H';

  @override
  String get no_tx => 'No transactions';

  @override
  String get copy => 'Copy';

  @override
  String get explorer => 'Explorer';

  @override
  String get txdet => 'Transaction Detail';

  @override
  String get tx => 'Transactions';

  @override
  String get txcopy => 'TX id copied to clipboard';

  @override
  String get confirmations => 'confirmations';

  @override
  String get history_popup => 'HISTORY';

  @override
  String get settings_popup => 'SETTINGS';

  @override
  String get socials_popup => 'CONNECT';

  @override
  String get about_popup => 'ABOUT';

  @override
  String get choose_coin => 'Choose coin';

  @override
  String get or_scan_qr => 'or receive via QR-code';

  @override
  String get address => 'Address';

  @override
  String get amount => 'Amount';

  @override
  String get or_send_scan_qr => 'or send via QR-code';

  @override
  String get graph_no_data => 'Sorry, we couldn\'t get the data for the graph';

  @override
  String get settings_screen => 'Settings';

  @override
  String get settings_main => 'Main Settings';

  @override
  String get settings_privacy => 'Privacy Settings';

  @override
  String get qr_scan_flash => 'Flash';

  @override
  String get qr_scan_on => 'on';

  @override
  String get qr_scan_off => 'off';

  @override
  String get qr_scan_back => 'Back Camera';

  @override
  String get qr_scan_front => 'Fron Camera';

  @override
  String get sc_headline => 'APP Security';

  @override
  String get sc_auth_headline => 'Authentication Settings';

  @override
  String get sc_auth_type => 'Authenticate by:';

  @override
  String get sc_pin_settings => 'PIN settings';

  @override
  String get sc_change_pin => 'Change PIN';

  @override
  String get sc_remove_pin => 'Remove PIN';

  @override
  String get sc_change_succ => 'PIN change successful';

  @override
  String get sc_change_fuck => 'PIN change unsuccessful';

  @override
  String get sc_pin_removed => 'PIN removed successfully';

  @override
  String get sc_pin_removed_fucked => 'PIN hasn\'t been removed';

  @override
  String get sc_security => 'Security';

  @override
  String get as_enter_pin => 'Please enter PIN';

  @override
  String get as_wrong_pin => 'Wrong PIN, please try again';

  @override
  String get as_enter_desired_pin => 'Please enter desired PIN';

  @override
  String get as_enter_desired_confirm_pin => 'Please confirm desired PIN';

  @override
  String get dl_log_out => 'Do you really want to log out of the app?';

  @override
  String dl_soc_log_out(Object number1) {
    return 'Do you really want to unlink $number1 from Rocketbot?';
  }

  @override
  String get about_rocket =>
      'RocketBot Wallet App, uses cryptocurrencies for micropayments on social media platforms(Twitter, Telegram & Discord).';

  @override
  String get about_terms => 'Terms of Use';

  @override
  String get about_policy => 'Privacy Policy';

  @override
  String get about_visit => 'Visit our website';

  @override
  String get about_merge => 'Project Merge ';

  @override
  String get about_devs => 'Development';

  @override
  String get about_develop => 'Development site';

  @override
  String get about_licences => 'View licences';

  @override
  String get dp_error => 'Error: Withdrawal Disabled';

  @override
  String get log_out => 'Log out';

  @override
  String get error => 'Error';

  @override
  String get username_invalid => 'Invalid surname name';

  @override
  String get username_invalid_message =>
      'The surname has to be at least 1 characters long';

  @override
  String get password_invalid => 'Invalid Password';

  @override
  String get password_invalid_message =>
      'The password should be at least 8 characters long';

  @override
  String get email_invalid => 'Invalid e-mail';

  @override
  String get email_invalid_message => 'Please enter valid e-mail address';

  @override
  String get name_invalid => 'Invalid name';

  @override
  String get name_invalid_message =>
      'Please enter name which is longer than 1 character';

  @override
  String get password_mismatch => 'Passwords don\'t match';

  @override
  String get password_mismatch_message =>
      'Please enter same password to password and password confirmation box';

  @override
  String get coin_sent => 'Transaction executed successfully';

  @override
  String get reg_succ =>
      'Please check your email inbox, for register confirmation';

  @override
  String get terms_agree => 'You need to agree with terms and conditions';

  @override
  String get language => 'Language';

  @override
  String get deflt => 'Rank';

  @override
  String get by_amount => 'Amount';

  @override
  String get alphabeticall => 'Alphabet';

  @override
  String get by_value => 'Total Value';

  @override
  String get less_than => 'Less than';

  @override
  String get tx_problem => 'Can\'t load transactions';

  @override
  String get hide_zeros => 'Hide zeros';

  @override
  String get social_accounts => 'Social Accounts';

  @override
  String get join_discord => 'Join Rocketbot Discord';

  @override
  String get send_discord => 'Send DM to Rocket(bot)';

  @override
  String get socials_info =>
      'By linking your social media accounts, all tokens will be combined by RocketBot.pro. This secures your balances in the event your social media account is suspended. One account for all, powered by Merge.';

  @override
  String get socials_info_add =>
      'RocketBot.pro & Merge need to be linked to web';

  @override
  String unlink(Object number1) {
    return 'Unlink $number1';
  }

  @override
  String get stake_get_all => 'Remove all Tokens';

  @override
  String get stake_get_reward => 'Withdraw Rewards';

  @override
  String get stake_swipe => 'Swipe to stake';

  @override
  String get send_swipe => 'Swipe to send';

  @override
  String get stake_amount => 'Enter amount to stake';

  @override
  String get stake_wait => 'Might take a while!';

  @override
  String get stake_reward => 'Reward';

  @override
  String get stake_unconfirmed => 'Unconfirmed stake amount';

  @override
  String get stake_staked_amount => 'Staked amount';

  @override
  String get stake_available => 'Available amount';

  @override
  String get stake_label => 'Staking';

  @override
  String get staking_not_enough =>
      'Not enough enough coins to complete the operation!';

  @override
  String get staking_please_enter =>
      'Staking amount cannot be empty! Please enter amount which will be sent to staking.';

  @override
  String staking_not_min(Object number1, Object number2) {
    return 'Fail! \n Minimal amount to send:\n$number1 $number2';
  }

  @override
  String staking_with_info(Object number1) {
    return 'Your tokens have been sent, please allow $number1 confirmation before they become available';
  }

  @override
  String get staking_lock_coins => 'Coins will be locked for 24 hours';

  @override
  String get dl_not_close => 'Do not exit the app!';

  @override
  String get dl_pls_wait => 'Please wait';

  @override
  String get staking_total_tokens => 'Total tokens in the pool';

  @override
  String get staking_monetary_value => 'Monetary value';

  @override
  String get staking_contrib => 'Your contribution';

  @override
  String get staking_est => 'Your estimated reward';

  @override
  String get staking_day => 'day';

  @override
  String get st_less => 'Show less details';

  @override
  String get st_more => 'Show more details';

  @override
  String get referral => 'Referral';

  @override
  String get ref_code => 'Rocketbot referral code';

  @override
  String ref_invite(Object number1) {
    return 'You have not been invited by anyone, enter or scan Rocketbot referral code to receive $number1 Merge! Referral bonus will be credited after you stake at least 10 Merge tokens.';
  }

  @override
  String get ref_unvite =>
      'You\'ve already used the invite promotion, keep an eye on our future ones';

  @override
  String get ref_hint =>
      'Just scan the similar looking QR code and stake 10 Merge (in any order) and you are all set. \nUser is eligible for this promotion only once!';

  @override
  String get balance => 'Balance';

  @override
  String get mn_your_mns => 'Your masternodes';

  @override
  String mn_total(Object number1) {
    return 'Number of active $number1 MNs';
  }

  @override
  String mn_day_reward(Object number1) {
    return 'Daily reward of 1 active $number1 MN';
  }

  @override
  String get mn_average_payrate => 'MN average payrate';

  @override
  String get mn_average_start => 'Average time to start MN';

  @override
  String get mn_time_to_start => 'Average time to get 1st reward';

  @override
  String get mn_lock => 'Tokens will be locked for 1 week';

  @override
  String get mn_start => 'Swipe to start MN';

  @override
  String get mn_manage => 'Manage your MNs';

  @override
  String get mn_reward => 'Available reward';

  @override
  String get mn_collateral => 'Cost of masternode';

  @override
  String get mn_uncofirmed => 'Pending Masternodes';

  @override
  String get mn_roi => 'Annual ROI';

  @override
  String get mn_free => 'Available MN nodes to start';

  @override
  String get settings_socials => 'Social Media';

  @override
  String mn_withdraw_box(Object number1) {
    return 'Do you really want to withdraw MN #$number1?';
  }

  @override
  String get income => 'income';

  @override
  String get st_adjust => 'Adjust staking balance';

  @override
  String get st_amount => 'Subtract amount';

  @override
  String get qr_scan => 'QR scanner';

  @override
  String get qr_scan_error => 'QR code is not valid for this app';

  @override
  String get web_login => 'Rocket.art login';
}
