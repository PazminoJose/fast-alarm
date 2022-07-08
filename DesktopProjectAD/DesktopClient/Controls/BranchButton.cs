using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DesktopClient.Classes
{
    class BranchButton : Button
    {
        public int id { get; set; }
        public BranchButton(int id)
        {
            this.id = id;
        }
     
    }
}
