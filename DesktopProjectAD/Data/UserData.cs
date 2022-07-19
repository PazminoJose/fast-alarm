using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using RestSharp;
namespace Data
{
    public class UserData
    {
        private const string URL = "https://server-panic-button-ad.herokuapp.com/api/user";
        public static UserEntity Login(UserCredentials credentials)
        {
            try
            {
                RestRequest request = new RestRequest("login",Method.POST);
                request.AddJsonBody(credentials);
                RestClient client = new RestClient(URL);
                UserEntity user = client.Post<UserEntity>(request).Data;
                return user;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
    }
}
