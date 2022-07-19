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
        public static UserEntity Login(UserCredentials credentials)
        {
            return UserData.Login(credentials);
        }
    }
}
