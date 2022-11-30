using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;
namespace Business
{
    public static class UPCBusiness
    {
        public static List<UPCEntity> GetAll()
        {
            return UPCData.GetAll();   
        }
        public static UPCEntity Save(UPCEntity company)
        {
            if(company.id == null)
            {
                return UPCData.Insert(company);
            }
            return UPCData.Update(company);
        }
        public static bool Delete(string id)
        {
            return UPCData.Delete(id);
        }

        public static UPCEntity GetById(string id)
        {
            return UPCData.GetById(id);
        }
    }
}
