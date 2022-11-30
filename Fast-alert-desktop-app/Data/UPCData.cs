using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http;
using System.Net.Http.Handlers;
using Entities;
using RestSharp;

namespace Data
{
    public class UPCData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/company";

        public static List<UPCEntity> GetAll()
        {
            try
            {
                List<UPCEntity> companies = new List<UPCEntity>();
                RestClient client = new RestClient(URL);
                companies = client.Get<List<UPCEntity>>(new RestRequest()).Data;
                return companies;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static UPCEntity Insert(UPCEntity company)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest(Method.POST);
                request.AddJsonBody(company);

                company = client.Post<UPCEntity>(request).Data;

                return company;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static UPCEntity Update(UPCEntity company)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.PUT);
                request.AddJsonBody(company);
                request.AddUrlSegment("id", company.id);

                company = client.Put<UPCEntity>(request).Data;
                return company;
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
        public static UPCEntity GetById(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}");
                request.AddUrlSegment("id", id);

                return client.Get<UPCEntity>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }


    }

}
