using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;

namespace Business
{
    public class PoliceBusiness
    {

        public static List<PoliceEntity> GetAll()
        {
            return PoliceData.GetAll();
        }
        public static PoliceEntity Save(PoliceEntity police)
        {
            if (police.id == null)
            {
                return PoliceData.Insert(police);
            }
            return PoliceData.Update(police);
        }
        public static bool Delete(string id)
        {
            return PoliceData.Delete(id);
        }

        public static PoliceEntity GetById(string id)
        {
            return PoliceData.GetById(id);
        }
        public static PoliceEntity GetByUserId(string id)
        {
            return PoliceData.GetByUserId(id);
        }
    }
}
