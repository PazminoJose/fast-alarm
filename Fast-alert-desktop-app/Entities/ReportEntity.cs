using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class ReportEntity
    {
       
        public Dictionary<string, Dictionary<string, int>> report { get; set; }
        public ReportEntity()
        {

        }
        public ReportEntity(Dictionary<string, Dictionary<string, int>> report)
        {
            this.report = report;
        }

    }
}
