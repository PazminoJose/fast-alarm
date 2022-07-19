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
        public string Id { get; set; }

        [JsonProperty("company")]
        public CompanyEntity Company { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("surname")]
        public string Surname { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("password")]
        public string Password { get; set; }

        [JsonProperty("user_type")]
        public string UserType { get; set; }

        [JsonProperty("__v")]
        public long V { get; set; }

        public static List<UserEntity> FromJson(string json) => JsonConvert.DeserializeObject<List<UserEntity>>(json, Entities.Converter.Settings);
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
    public static class SerializeUserEntity
    {
        public static string ToJson(this UserEntity self) => JsonConvert.SerializeObject(self, Entities.Converter.Settings);
    }

}

