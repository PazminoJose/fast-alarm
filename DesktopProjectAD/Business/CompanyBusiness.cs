using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entities;
using Data;
namespace Business
{
    public static class CompanyBusiness
    {
        public static List<CompanyEntity> GetAll()
        {
            return CompanyData.GetAll();   
        }
        public static CompanyEntity Save(CompanyEntity company)
        {
            if(company.id == null)
            {
                return CompanyData.Insert(company);
            }
            return CompanyData.Update(company);
        }
        public static bool Delete(string id)
        {
            return CompanyData.Delete(id);
        }

        public static CompanyEntity GetById(string id)
        {
            return CompanyData.GetById(id);
        }
    }
}
