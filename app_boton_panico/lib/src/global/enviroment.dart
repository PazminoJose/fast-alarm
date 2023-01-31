class Environments {
  static String url = "206.189.224.140";
  static String apiGoogle = "AIzaSyCfK3Fp-ScPOOhLGtTki7nejALoQXZs96o";

  static String getUser = "/api/user/login";
  static String getDevices = "/api/GetDevices";
  static String getAlertsByUser = "/api/alert/getbyUser/";
  static String getUsersAlertsByPersson = "/api/family-group/person";
  static String getImage = "$url/public/images";

  static String postPerson = "/api/person";
  static String postUser = "/api/user";
  static String postIdOneSignal = "/api/user/register-onesignal";
  static String postChangePassword = "/api/user/change-password";
  static String postSendEmailChangePassword = "/api/user/recovery-password";
  static String postSendNotificationPushAllDevices =
      "/api/SendNotificationAllDevices";
  static String postNotification = "/api/alert";

  static String putStateByUser = "/api/family-group/user-state";
  static String sendNotificationFamilyGroup =
      "/api/notification/SendNotificationFamilyGroup";
}
