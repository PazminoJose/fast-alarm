using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class PoliceEntity
    {
     
        [JsonProperty("_id")]
        public string id { get; set; }
        [JsonProperty("upc")]
        public UPCEntity upc { get; set; }
        [JsonProperty("user")]
        public UserEntity user { get; set; }
        [JsonProperty("rank")]
        public string rank { get; set; }
        public PoliceEntity(string id, UPCEntity upc, UserEntity user, string rank)
        {
            this.id = id;
            this.upc = upc;
            this.user = user;
            this.rank = rank;
        }
        public PoliceEntity()
        {

        }
    }
}
