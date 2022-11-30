using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using RestSharp;
namespace Data
{
    public static class AlarmData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/alert";
       public static List<AlarmEntity> GetAll()
        {
            try
            {
                RestClient client = new RestClient(URL);
                List<AlarmEntity> alarm = client.Get<List<AlarmEntity>>(new RestRequest()).Data;
                return alarm;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static List<AlarmEntity> GetAllActive()
        {
            try
            {
                RestClient client = new RestClient(URL+"/active");
                List<AlarmEntity> alarm = client.Get<List<AlarmEntity>>(new RestRequest()).Data;
                return alarm;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static AlarmEntity Insert(AlarmEntity alarm)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest(Method.POST);
                request.AddJsonBody(alarm);

                alarm = client.Post<AlarmEntity>(request).Data;

                return alarm;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static AlarmEntity Update(AlarmEntity alarm)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.PUT);
                request.AddJsonBody(alarm);
                request.AddUrlSegment("id", alarm.id);

                alarm = client.Put<AlarmEntity>(request).Data;
                return alarm;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static AlarmEntity GetById(string id)
        {
            try
            {
                RestRequest request = new RestRequest("/{id}");
                request.AddUrlSegment("id", id);
                RestClient client = new RestClient(URL);
                return client.Get<AlarmEntity>(request).Data;
            
            }
            catch (Exception e)
            {

                string error = e.Message;
                return null;
            }
        }
    }
}
