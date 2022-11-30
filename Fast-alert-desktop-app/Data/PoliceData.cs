using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using RestSharp;

namespace Data
{
    public class PoliceData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/police";

        public static List<PoliceEntity> GetAll()
        {
            try
            {
                List<PoliceEntity> policemen = new List<PoliceEntity>();
                RestClient client = new RestClient(URL);
                policemen = client.Get<List<PoliceEntity>>(new RestRequest()).Data;
                return policemen;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static PoliceEntity Insert(PoliceEntity police)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest(Method.POST);
                request.AddJsonBody(police);

                police = client.Post<PoliceEntity>(request).Data;

                return police;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static PoliceEntity Update(PoliceEntity police)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.PUT);
                request.AddJsonBody(police);
                request.AddUrlSegment("id", police.id);

                police = client.Put<PoliceEntity>(request).Data;
                return police;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static bool Delete(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.DELETE);
                request.AddUrlSegment("id", id);
                return client.Delete<bool>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return false;
            }
        }
        public static PoliceEntity GetById(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}");
                request.AddUrlSegment("id", id);

                return client.Get<PoliceEntity>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static PoliceEntity GetByUserId(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/user/{userId}");
                request.AddUrlSegment("userId", id);

                return client.Get<PoliceEntity>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }

    }
}
