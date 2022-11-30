using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Entities
{
    public class UserEntity
    {
        [JsonProperty("_id")]
        public string id { get; set; }

        [JsonProperty("name")]
        public string name { get; set; }

        [JsonProperty("surname")]
        public string surname { get; set; }

        [JsonProperty("idCard")]
        public string idCard { get; set; }

        [JsonProperty("phone")]
        public string phone { get; set; }


        [JsonProperty("email")]
        public string email { get; set; }


        [JsonProperty("password")]
        public string password { get; set; }


        [JsonProperty("userType")]
        public string userType { get; set; }


       
        public UserEntity()
        {

        }

        public UserEntity(string id, string name, string surname, string idCard, string email, string password, string userType)
        {
            this.id = id;
            this.name = name;
            this.surname = surname;
            this.idCard = idCard;
            this.email = email;
            this.password = password;
            this.userType = userType;
        }

        public override string ToString()
        {
            return String.Format("{0} {1}",this.name,this.surname);
        }

    }
    public class UserCredentials
    {
        public string email { get; set; }
        public string password { get; set; }
        public UserCredentials()
        {

        }
        public UserCredentials(string email, string password)
        {
            this.email = email;
            this.password = password;
        }

    }

}

