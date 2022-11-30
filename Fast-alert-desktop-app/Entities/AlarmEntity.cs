using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class AlarmEntity
    {
        [JsonProperty("_id")]
        public string id { get; set; }
        [JsonProperty("user")]
        public UserEntity user { get; set; }
        [JsonProperty("message")]
        public string message { get; set; }
        [JsonProperty("state")]
        public string state { get; set; }
        [JsonProperty("latitude")]
        public double latitude { get; set; }
        [JsonProperty("longitude")]
        public double longitude { get; set; }

        [JsonProperty("updatedAt")]
        public DateTime date { get; set; }

        public AlarmEntity()
        {

        }

        public AlarmEntity(string id, UserEntity user, string message, double latitude, double longitude, DateTime date)
        {
            this.id = id;
            this.user = user;
            this.message = message;
            this.latitude = latitude;
            this.longitude = longitude;
            this.date = date;
        }
    }
}
