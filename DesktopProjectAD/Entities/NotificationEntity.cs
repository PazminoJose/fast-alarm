using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class NotificationEntity
    {
        [JsonProperty("_id")]
        public string id { get; set; }

        [JsonProperty("user")]
        public UserEntity user { get; set; }

        [JsonProperty("message")]
        public string message { get; set; }

        [JsonProperty("date")]
        public DateTimeOffset date { get; set; }

        public NotificationEntity()
        {

        }

        public NotificationEntity(string id, UserEntity user, string message, DateTimeOffset date)
        {
            this.id = id;
            this.user = user;
            this.message = message;
            this.date = date;
        }
    }
}
