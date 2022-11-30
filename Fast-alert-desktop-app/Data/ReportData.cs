using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Entities;
using Newtonsoft.Json;
using RestSharp;
namespace Data
{
    public class ReportData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/report";
        public static ReportEntity GetReport()
        {
            try
            {
                RestClient client = new RestClient(URL);
                string json = client.Get(new RestRequest()).Content;
                Dictionary<string, Dictionary<string, int>> report = JsonConvert.DeserializeObject<Dictionary<string, Dictionary<string, int>>>(json);
                ReportEntity reportEntity = new ReportEntity(report);
                return reportEntity;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }

        }
    }
}
