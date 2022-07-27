using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using RestSharp;
namespace Data
{
    public static class NotificationData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/notification";
       public static List<NotificationEntity> GetAll()
        {
            try
            {
                RestClient client = new RestClient(URL);
                List<NotificationEntity> notifications = client.Get<List<NotificationEntity>>(new RestRequest()).Data;
                return notifications;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static NotificationEntity GetById(string id)
        {
            try
            {
                RestRequest request = new RestRequest("/{id}");
                request.AddUrlSegment("id", id);
                RestClient client = new RestClient(URL);
                return client.Get<NotificationEntity>(request).Data;
            
            }
            catch (Exception e)
            {

                string error = e.Message;
                return null;
            }
        }
    }
}
