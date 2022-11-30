using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;
namespace Business
{
    public class AlarmBusiness
    {
        public static List<AlarmEntity> GetAll()
        {
            return AlarmData.GetAll();
        }
        public static List<AlarmEntity> GetAllActive()
        {
            return AlarmData.GetAllActive();
        }
        public static AlarmEntity Save(AlarmEntity alarm)
        {
            if (alarm.id == null)
            {
                return AlarmData.Insert(alarm);
            }
            return AlarmData.Update(alarm);
        }
        public static AlarmEntity GetById(string id)
        {
            return AlarmData.GetById(id);        }
    }
}
