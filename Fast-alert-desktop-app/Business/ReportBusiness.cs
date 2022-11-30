using Data;
using Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class ReportBusiness
    {
        public static ReportEntity GetReport()
        {
            return ReportData.GetReport();
        }
    }
}
