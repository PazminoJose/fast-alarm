using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;

namespace Business
{
    public class UserBusiness
    {
        public static List<UserEntity> GetAll()
        {
            return UserData.GetAll();
        }
        public static UserEntity Save(UserEntity user)
        {
            if (user.id == null) return UserData.Insert(user);
            return UserData.Update(user);
        }
        public static UserEntity GetById(string id)
        {
            return UserData.GetById(id);
        }
        public static bool Delete(string id)
        {
            return UserData.Delete(id);
        }
        public static UserEntity Login(UserCredentials credentials)
        {
            return UserData.Login(credentials);
        }
    }
}
