enum AppEnvironment { DEVELOPMENT, STAGING, PRODUCTION }

enum LoginProviderType { apple, email, google, facebook, phone }

enum ConnectHubState {
  ConnectHubStateNew,
  ConnectHubStateRinging,
  ConnectHubStateInvite,
  ConnectHubStateAnswer,
  ConnectHubStateConnecting,
  ConnectHubStateConnected,
  ConnectHubStateDisconnected,
  ConnectHubStateClosed,
  ConnectHubStateFailed,
  ConnectHubStateBye,
}

enum ShowCameraType { none, vconnexCam, otherCam }

enum DataSource {
  OK,
  CREATED,
  ACCEPTED,
  BAD_REQUEST,
  UNAUTHORISED,
  FORBIDDEN,
  NOT_FOUND,
  NOT_ACCEPTABLE,
  CONFLICT,
  UNSUPPORTED_MEDIA_TYPE,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}
