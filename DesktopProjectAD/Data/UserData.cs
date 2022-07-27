using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Entities;
using RestSharp;
using System.IO;
using System.Runtime.Serialization.Json;


namespace Data
{
    public class UserData
    {
        private static string URL = $"{Properties.Settings.Default.URL_API}/api/user";
        public static UserEntity Login(UserCredentials credentials)
        {
            try
            {
                RestRequest request = new RestRequest("login", Method.POST);
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
        public static List<UserEntity> GetAll()
        {
            try
            {
                RestClient client = new RestClient(URL);
                List<UserEntity> users = client.Get<List<UserEntity>>(new RestRequest()).Data;

                return users;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static UserEntity Insert(UserEntity user)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest(Method.POST);
                request.AddJsonBody(user);

                user = client.Post<UserEntity>(request).Data;

                return user;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static UserEntity Update(UserEntity user)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.PUT);
                request.AddJsonBody(user);
                request.AddUrlSegment("id", user.id);

                user = client.Put<UserEntity>(request).Data;
                return user;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static UserEntity GetById(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.GET);
                request.AddUrlSegment("id", id);

                return  client.Get<UserEntity>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return null;
            }
        }
        public static bool Delete(string id)
        {
            try
            {
                RestClient client = new RestClient(URL);
                RestRequest request = new RestRequest("/{id}", Method.DELETE);
                request.AddUrlSegment("id", id);
                return client.Delete<bool>(request).Data;
            }
            catch (Exception e)
            {
                string error = e.Message;
                return false;
            }
        }
    }


}
