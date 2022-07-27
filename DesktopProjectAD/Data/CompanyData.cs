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
    public class CompanyData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/company";

        public static List<CompanyEntity> GetAll()
        {
            try
            {
                List<CompanyEntity> companies = new List<CompanyEntity>();
                RestClient client = new RestClient(URL);
                companies = client.Get<List<CompanyEntity>>(new RestRequest()).Data;
                return companies;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
        public static CompanyEntity Insert(CompanyEntity company)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest(Method.POST);
                request.AddJsonBody(company);

                company = client.Post<CompanyEntity>(request).Data;

                return company;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static CompanyEntity Update(CompanyEntity company)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.PUT);
                request.AddJsonBody(company);
                request.AddUrlSegment("id", company.id);

                company = client.Put<CompanyEntity>(request).Data;
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
        public static CompanyEntity GetById(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}");
                request.AddUrlSegment("id", id);

                return client.Get<CompanyEntity>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }


    }

}
