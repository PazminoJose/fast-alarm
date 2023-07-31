/// This class is used to store the endpoints of the API
class Environments {
  static String url = "vivo-vivo-server-production.up.railway.app";

  static String getUser = "/api/user/login";
  static String getDevices = "/api/GetDevices";
  static String getAlertsByUser = "/api/alert/getbyUser/";
  static String getUsersAlertsByPersson = "/api/family-group/person";
  static String getfamilyGropuByUser = "/api/family-group/user";
  static String getImage = "$url/public/images";
  static String event = "update-alarms";

  static String postPerson = "/api/person";
  static String postUser = "/api/user";
  static String postIdOneSignal = "/api/user/register-onesignal";
  static String postChangePassword = "/api/user/change-password";
  static String postSendEmailChangePassword = "/api/user/recovery-password";
  static String postSendNotificationPushAllDevices =
      "/api/SendNotificationAllDevices";
  static String postAlarm = "/api/alarm";
  static String putAlarm = "/api/alarm";

  static String putStateByUser = "/api/family-group/user-state";
  static String sendNotificationFamilyGroup =
      "/api/notification/SendNotificationFamilyGroup";
}
