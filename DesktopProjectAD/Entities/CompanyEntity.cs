using Newtonsoft.Json;

namespace Entities
{

    public class CompanyEntity
    {
   
        [JsonProperty("_id")]
        public string id { get; set; }

        [JsonProperty("headOffice")]
        public CompanyEntity headOffice { get; set; }

        [JsonProperty("name")]
        public string name { get; set; }

        [JsonProperty("address")]
        public string address { get; set; }

        [JsonProperty("contact")]
        public string contact { get; set; }
        [JsonProperty("state")]
        public string state { get; set; }

        [JsonProperty("latitude")]
        public double latitude { get; set; }

        [JsonProperty("longitude")]
        public double longitude { get; set; }
     
        public CompanyEntity()
        {

        }

        public CompanyEntity(string id, CompanyEntity headOffice, string name, string address, string contact, string state, double latitude, double longitude)
        {
            this.id = id;
            this.headOffice = headOffice;
            this.name = name;
            this.address = address;
            this.contact = contact;
            this.state = state;
            this.latitude = latitude;
            this.longitude = longitude;
        }
        public override string ToString()
        {
            return this.name;
        }
    }

}
