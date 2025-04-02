import 'package:fire_alarm_app/configs/enums.dart';

abstract interface class ConfigApp {
  static const String _developmentDomain01 = 'https://smarthome-api2.vconnex.vn/smarthome-api/';
  static const String _developmentDomain02 = 'https://smh-api-dev2.vconnex.vn/smarthome-api/';
  static const String _developmentDomain03 = 'https://smh-api-dev3.vconnex.vn/smarthome-api/';
  static const String _stagingDomain = 'https://smarthome-apigw-stg.vconnex.vn/';
  static const String _productionDomain = 'https://smarthome-apigw.vconnex.vn/';

  static const String _developmentBroker = 'broker-dev.vconnex.vn';
  static const String _stagingBroker = 'broker-stg.vconnex.vn';
  static const String _productionBroker = 'smarthome-broker.vconnex.vn';

  static const int _portMQTT_Development = 1884;
  static const int _portMQTT_Staging = 9002;
  static const int _portMQTT_Production = 1884;

  //Env
  static AppEnvironment? _environment;
  static const ENABLE_LOG = true;

  //Change env
  static void changeEnv(AppEnvironment env) => _environment = env; //Change env on main.dart

  // Dio config
  static const String API_VERSION = "v14"; //TODO: Change version api
  static const String AUTHORIZATION = 'X-Authorization';
  static const String HOME_ID = 'HomeID';
  static const String defaultUsername = '1';
  static const String defaultPassword = 'vhomenex';
  static const String REQUEST_MEDIA_TYPE = "application";
  static const String REQUEST_MEDIA_SUB_TYPE = "json";
  static const String CHARSET = "charset=UTF-8";
  static const String CONTENT_TYPE = "Content-Type";
  static const String CONTENT_TYPE_VALUE = "$REQUEST_MEDIA_TYPE/$REQUEST_MEDIA_SUB_TYPE;$CHARSET";
  static const String CONTENT_TYPE_VALUE_NO_CHARSET = "$REQUEST_MEDIA_TYPE/$REQUEST_MEDIA_SUB_TYPE";
  static const String APPLICATION_JSON = 'application/json';
  static const String DEFAULT_CHARSET = 'UTF-8';
  static const String REQUEST_MEDIA_FROM_DATA_TYPE = "form-data";
  static const String CONTENT_TYPE_FROM_DATA = "multipart/$REQUEST_MEDIA_FROM_DATA_TYPE";
  static const String SHARE_KEY = "29a49d844c009abb32bcb5094b327382fe260a2d";
  static const String SHARE_KEY_RESET_PASSWORD = '29a49d844c009abb32bcb5094b327382fe260a2dgth68mbncbjkebfjk9849328jnfkj';

  //Get base URL
  static String getBaseUrl() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        // return _developmentDomain01 + API_VERSION;
        return _developmentDomain02 + API_VERSION;
        // return _developmentDomain03 + API_VERSION;
      case AppEnvironment.STAGING:
        return _stagingDomain + API_VERSION;
      case AppEnvironment.PRODUCTION:
        return _productionDomain + API_VERSION;
      default:
        return _developmentDomain01 + API_VERSION;
    }
  }

  //Broker
  static String getMQTTBroker() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        return _developmentBroker;
      case AppEnvironment.STAGING:
        return _stagingBroker;
      case AppEnvironment.PRODUCTION:
        return _productionBroker;
      default:
        return _productionBroker;
    }
  }

  //Port MQTT
  static int getMQTTPort() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        return _portMQTT_Development;
      case AppEnvironment.STAGING:
        return _portMQTT_Staging;
      case AppEnvironment.PRODUCTION:
        return _portMQTT_Development;
      case null:
        return _portMQTT_Production;
    }
  }

  //NoSSL MQTT Broker
  static String getNoSSLMQTTBroker() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        return 'broker-dev.vconnex.vn';
      case AppEnvironment.STAGING:
        return 'broker-dev.vconnex.vn';
      case AppEnvironment.PRODUCTION:
        return 'smarthome-broker.vconnex.vn';
      default:
        return 'smarthome-broker.vconnex.vn';
    }
  }

  //NoSSL MQTT Port
  static int getNoSSLMQTTPort() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        return 9001;
      case AppEnvironment.STAGING:
        return 9001;
      case AppEnvironment.PRODUCTION:
        return 1883;
      default:
        return 1883;
    }
  }

  //Fork Update Link
  static String getForkUpdateLink() {
    switch (_environment) {
      case AppEnvironment.DEVELOPMENT:
        return 'https://smarthome-api2.vconnex.vn/smarthome-api/api/device/check-ota-folkupdate';
      case AppEnvironment.STAGING:
        return 'https://smarthome-apigw-stg.vconnex.vn/smarthome-api/api/device/check-ota-folkupdate';
      case AppEnvironment.PRODUCTION:
        return 'https://smarthome-apigw.vconnex.vn/smarthome-api/api/device/check-ota-folkupdate';
      default:
        return 'https://smarthome-apigw.vconnex.vn/smarthome-api/api/device/check-ota-folkupdate';
    }
  }

  static const YEE_LIGHT_BASE_API = "https://yeelight-partner-api-dev.vconnex.vn/";

  static const String username = 'VKX-SmartHome';
  static const String passwd = 'Sm@rtH0me!2020';
  static final String clientIdentifier = 'vconnex_smarthome_flutter ${DateTime.now().millisecondsSinceEpoch}';

  //
  static const String SMART_LOCK_ADMIN_CODE_TYPE = 'security';
  static const String SMART_LOCK_HISTORY_TYPE = 'history';
  static const String SMART_LOCK_KEY_UNLOCK_TYPE = 'additional_info_smart_lock';

  static const String SMART_LOCK_ADD_TYPE = 'element';
  static const String SMART_LOCK_SYNC_TYPE = 'synchronize';
  static const String SMART_LOCK_DELETE_TYPE = 'delete';

  static const String PROVIDER_LOGIN_PHONE_TYPE = 'phone';
  static const String PROVIDER_LOGIN_EMAIL_TYPE = 'email';
  static const String PROVIDER_LOGIN_FACEBOOK_TYPE = 'facebook';
  static const String PROVIDER_LOGIN_GOOGLE_TYPE = 'google';
  static const String PROVIDER_LOGIN_APPLE_TYPE = 'apple';

  static const int ESM_CUSTOMER_STANDARD_TYPE = 1;
  static const int ESM_CUSTOMER_BUSINESS_TYPE = 2;
  static const int ESM_CUSTOMER_PRODUCT_TYPE = 3;

  static const int ESM_CUSTOMER_STANDARD_RETAIL_OBJECT = 1;
  static const int ESM_CUSTOMER_STANDARD_PREPAY_OBJECT = 2;

  static const String ESM_KEY_POWER_METER_TYPE = 'additional_info_power_meter';

  static const String SMART_SWITCH_ADD_REFERENCE_TYPE = 'additional_info_reference';
  static const String SMART_SWITCH_FROM_REFERENCE_PAGE = 'from_reference';

  static const String CURTAIN_OPEN_LEVEL_ONE_PARAM = 'open_level';
  static const String CURTAIN_OPEN_LEVEL_TWO_PARAM = 'open_2_level';

  static const String SUPPORT_PHONE_NUMBER = '086 826 6639';
  static const String SUPPORT_EMAIL = 'customer-care@vconnex.vn';
  // static const String SUPPORT_WEBSITE = 'https://vconnex.vn';
  static const String SUPPORT_WEBSITE = 'https://vconnex.vn/?utm_source=Vhomenex&utm_medium=Click&utm_campaign=Menu_App';
  static const String PRIVACY_URL = 'http://smarthome.vconnex.vn/product/privacy/vi';
  static const String TERMS_URL = 'http://smarthome.vconnex.vn/product/terms';
  static const String SUPPORT_URL = 'https://vconnex.vn/?page_id=4534';
  static const String OPEN_STORE_URL = 'http://smarthome.vconnex.vn/download';

  static const int NOTIFY_USER_SETTING_TYPE = 1;
  static const int NOTIFY_HAS_SCHEDULE_TYPE = 2;
  static const int NOTIFY_NOTIFI_DEVICE_RECONNECT_TYPE = 3;
  static const int NOTIFY_PIN_WEAK_TYPE = 4;
  static const String NOTIFY_SHARE_DEVICE_TYPE = "5";
  static const String NOTIFY_DELETE_SHARE_DEVICE_TYPE = "6";
  static const int NOTIFY_HAS_NEW_OTA_TYPE = 7;
  static const int NOTIFY_HAS_NEW_APP_TYPE = 8;
  static const int NOTIFY_GATEWAY_DISCONNECT_TYPE = 11;
  static const String NOTIFY_AUTOMATION_EXECUTE = "29";
  static const String NOTIFY_DELETE_ACCOUNT = "13";

  static const String NOTIFY_REQUEST_OPEN_LOCK_TYPE = "31";
  static const String NOTYFY_CRITICAL_SMOKE_ALERT = "NOTYFY_IMPORTANT_SMOKE";
  static const String NOTIFY_RESET_DEFAULT_SMART_LOCK_TYPE = "35";
  static const String NOTIFY_ADD_OTHER_ACCOUNT_SMART_LOCK_TYPE = "36";
  static const String NOTIFY_CAMERA_ALERT = '46';

  static const String NOTIFY_SHARE_SCENE = '47';
  static const String NOTIFY_UN_SHARE_SCENE = '48';

  static const String NOTIFY_SHARE_HOME = "49";
  static const String NOTIFY_UPDATE_SHARE_HOME = "51";
  static const String NOTIFY_UN_SHARE_HOME = "50";
  static const String NOTIFY_REMOVE_HOME = '52';
  static const String NOTIFY_EXPIRED_SHARE_HOME = '53';
  static const String NOTIFY_REQUEST_SSG = '55';
  static const String NOTIFY_MANUAL = '59';

  static const String RADA_SUPPORT_PHONE_NUMBER = '0395911911';

  static const String tempratureUnit = '°C';

  static const int cameraHikvisionBrandId = 1;
  static const int cameraEzvizBrandId = 2;
  static const int cameraDahuaBrandId = 3;
  static const int cameraVconnexBrandId = 4;

  static const String homeConfigMeshKey = "homeConfigMeshKey";
  static const String usbConfigMeshKey = "usbConfigMeshKey";

  static const String cameraProductKey = 'a1BxN4TY5nN';

  static const int RESET_PIN_CODE = 0;
  static const int CREATE_PIN_CODE = 1;
  static const int VERIFY_PIN_CODE = 2;

  static const int ACTIVE_PIN_CODE = 2;
  static const int NOT_ACTIVE_PIN_CODE = 3;

  static const int ACTIVATE_SECURITY_CODE = 1;
  static const int NOT_ACTIVATE_SECURITY_CODE = 0;

  static const String gatewayVersionForceUpdate = '3.2.0';

  static const int PAIRING_MODE_AUTOMATION = 1;
  static const int PAIRING_MODE_MANUAL = 2;

  static const int MEMBER_TYPE_HOUSE_OWNER = 1;
  static const int MEMBER_TYPE_RELATIVE = 2;
  static const int MEMBER_TYPE_GUEST = 3;

  static const int HOME_PAGE_WITH_PARAM_GROUP = 1;
  static const int HOME_PAGE_WITH_DEVICE_LIST = 2;

  static const int ACTIVE = 1;
  static const int NOT_ACTIVE = 0;

  static const int HIGH_PRIORITY_NOTIFICATION = 1;

  static const String DOOR_NO_GAP = 'door_no_gap';
  static const String DOOR_HAVE_GAP = 'door_have_gap';

  static const String GATE_1 = "gate_1";
  static const String GATE_2 = "gate_2";
  static const String GATE_3 = "gate_3";

  static const int HOUR_TYPE = 0;
  static const int DAY_TYPE = 1;
  static const int MONTH_TYPE = 2;
  static const int YEAR_LIST_TYPE = 3;
  static const int MONTH_LIST_TYPE = 4;
  static const int DAY_LIST_TYPE = 5;
  static const int HOUR_LIST_TYPE = 6;
}
