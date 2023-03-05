library konjungate.globals;

bool isLoggedIn = false;
// const String serverUrl = 'http://51.195.102.171:3000';
const String username = "username";
const String id = "idUser";
const String adr = "adr";
const String nickname = "nickname";
const String locale = "locale";
const String level = "level";
const String udid = "udid";
const String token = "jwt";
const String pin = "PIN";
const String adminpriv = "admin";
const String fireToken = "firetoken";
const String login = "login";
const String pass = "pass";
const String authType = "AUTH_TYPE";
const String countdown = "countdownTime";
const String localeApp = 'locale_app';
const String sortType = 'sortby';

const String dbName = "databazia";

const String appNot = 'showMessages';

const List<String> languages = ['English','Finnish','Czech'];
const List<String> languageCodes = ['en', 'fi_FI', 'cs_CZ'];

const String TABLE_STAKE = "tableStake";
const String TS_ID = "id";
const String TS_PWG = "pwg";
const String TS_FINISHED = "txFinish";
const String TS_COINID = "idCoin";
const String TS_ADDR = "depAddr";
const String TS_AMOUNT = "amount";
const String TS_MASTERNODE = "masternode";

const String TABLE_COIN = "tableCoin";
const String TC_ID = "id";
const String TC_RANK = "rank";
const String TC_NAME = "name";
const String TC_TICKER = "ticker";
const String TC_CRYPTO_ID = "cryptoId";
const String TC_IS_TOKEN = "isToken";
const String TC_CONTRACT_ADDR = "contractAddress";
const String TC_FEE_PERCENT = "feePercent";
const String TC_BLOCKCHAIN = "blockchain";
const String TC_MIN_WITHDRAW = "minWithdraw";
const String TC_IMAGE_BIG = "imageBig";
const String TC_IMAGE_SMALL = "imageSmall";
const String TC_IMAGE_BIG_ID = "smallImageId";
const String TC_IMAGE_SMALL_ID = "bigImageId";
const String TC_IS_ACTIVE = "isActive";
const String TC_EXPLORER_URL = "explorerUrl";
const String TC_REQUIRED_CONF = "requiredConfirmations";
const String TC_FULL_NAME = "fullName";
const String TC_TOKEN_STANDARD = "tokenStandart";
const String TC_ALLOW_WITH = "allowWithdraws";
const String TC_ALLOW_DEP = "allowDeposits";

const String TABLE_NOT = "tableNot";
const String TN_ID = "id";
const String TN_IDUSER = "idUser";
const String TN_TITLE = "title";
const String TN_BODY = "body";
const String TN_LINK = "link";
const String TN_DATE = "datePosted";
const String TN_READ = "read";



// ['English', 'Bosnian', 'Croatian', 'Czech', 'Finnish', 'German', 'Hindi', 'Japanese', 'Russian', 'Serbian Latin', 'Serbian Цyриллиц', 'Spanish', 'Panjabi'];
// ['en', 'bs_BA', 'hr_HR', 'cs_CZ', 'fi_FI', 'de_DE', 'hi_IN', 'ja_JP', 'ru_RU', 'sr_Latn_RS', 'sr_Cyrl_RS', 'es_ES' 'pa_IN'];
bool reloadData = false;