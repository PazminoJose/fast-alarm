class Environments {
  static String url = "192.168.100.89:3000";

  static String getUser = "/api/user/login";
  static String getDevices = "/api/GetDevices";
  static String getAlertsByUser = "/api/alert/getbyUser/";

  static String postPerson = "/api/person";
  static String postUser = "/api/user";
  static String postIdOneSignal = "/api/user/register-onesignal";
  static String postChangePassword = "/api/user/change-password";
  static String postSendEmailChangePassword = "/api/user/recovery-password";
  static String postSendNotificationPushAllDevices =
      "/api/SendNotificationAllDevices";
  static String postNotification = "/api/alert";
}
