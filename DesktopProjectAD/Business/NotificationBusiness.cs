using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;
namespace Business
{
    public class NotificationBusiness
    {
        public static List<NotificationEntity> GetAll()
        {
            return NotificationData.GetAll();
        }
        public static NotificationEntity GetById(string id)
        {
            return NotificationData.GetById(id);        }
    }
}
