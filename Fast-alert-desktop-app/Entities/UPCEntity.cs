using GMap.NET;
using Newtonsoft.Json;

namespace Entities
{

    public class UPCEntity
    {
   
        [JsonProperty("_id")]
        public string id { get; set; }
        [JsonProperty("name")]
        public string name { get; set; }

        [JsonProperty("address")]
        public string address { get; set; }

        [JsonProperty("ipAddress")]
        public string ipAddress { get; set; }

        [JsonProperty("contact")]
        public string contact { get; set; }
        [JsonProperty("state")]
        public string state { get; set; }

        [JsonProperty("latitude")]
        public double latitude { get; set; }

        [JsonProperty("longitude")]
        public double longitude { get; set; }
     
        public UPCEntity()
        {

        }

        public PointLatLng getPosition()
        {
            return new PointLatLng(this.latitude, this.longitude);
        }

        public UPCEntity(string id, string name, string address, string ipAddress, string contact, string state, double latitude, double longitude)
        {
            this.id = id;
            this.name = name;
            this.address = address;
            this.ipAddress = ipAddress;
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
