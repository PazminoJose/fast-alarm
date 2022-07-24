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

        [JsonProperty("company")]
        public CompanyEntity company { get; set; }

        [JsonProperty("name")]
        public string name { get; set; }

        [JsonProperty("surname")]
        public string surname { get; set; }

        [JsonProperty("email")]
        public string email { get; set; }

        [JsonProperty("password")]
        public string password { get; set; }

        [JsonProperty("user_type")]
        public string user_type { get; set; }


        public UserEntity(string id, CompanyEntity company, string name, string surname, string email, string password, string userType)
        {
            this.id = id;
            this.company = company;
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.password = password;
            this.user_type = userType;
        }
        public UserEntity()
        {

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

