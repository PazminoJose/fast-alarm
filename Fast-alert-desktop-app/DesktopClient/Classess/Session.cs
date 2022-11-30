using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;

namespace DesktopClient.Classess
{
    public static class Session
    {
        private static PoliceEntity ActuaPolice { get; set; }

        public static void SetCurrentPolice(PoliceEntity user)
        {
            ActuaPolice = user;
        }
        public static UserEntity GetCurrentUser()
        {
            return ActuaPolice.user;
        }
        public static UPCEntity GetCurrentUpc()
        {
            return ActuaPolice.upc;
        }
        public static PoliceEntity GetCurrentPolice()
        {
            return ActuaPolice;
        }
        public static void LogOut()
        {
            ActuaPolice = null;
        }
    }
}
