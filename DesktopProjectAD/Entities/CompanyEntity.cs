using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Entities
{

    public class CompanyEntity
    {
   
        [JsonProperty("_id")]
        public string id { get; set; }

        [JsonProperty("name")]
        public string name { get; set; }

        [JsonProperty("address")]
        public string address { get; set; }

        [JsonProperty("contact")]
        public string contact { get; set; }

        [JsonProperty("latitude")]
        public double latitude { get; set; }

        [JsonProperty("longitude")]
        public double longitude { get; set; }

        [JsonProperty("headOffice")]
        public CompanyEntity headOffice { get; set; }

        [JsonProperty("__v")]
        public long v { get; set; }

        public static List<CompanyEntity> FromJson(string json) => JsonConvert.DeserializeObject<List<CompanyEntity>>(json, Entities.Converter.Settings);
        public CompanyEntity(CompanyEntity headOffice,string id, string name, string address, string contact, double latitude, double longitude)
        {
            this.id = id;
            this.name = name;
            this.address = address;
            this.contact = contact;
            this.latitude = latitude;
            this.longitude = longitude;
            this.headOffice = headOffice;

        }
        public CompanyEntity()
        {

        }

    }


    public static class SerializeCompanyEntity
    {
        public static string ToJson(this CompanyEntity self) => JsonConvert.SerializeObject(self, Entities.Converter.Settings);
    }

    internal static class Converter
    {
        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            DateParseHandling = DateParseHandling.None,
            Converters =
            {
                new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.AssumeUniversal }
            },
        };
    }
}
