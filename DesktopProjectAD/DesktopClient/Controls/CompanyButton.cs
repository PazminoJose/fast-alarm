using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Entities;

namespace DesktopClient.Controls
{
    class CompanyButton : Button
    {
        public CompanyEntity company;
        public CompanyButton(CompanyEntity company)
        {
            this.company = company;
            this.ForeColor = Color.White;
            this.BackColor = (company != null && company.state.Equals("normal")) ? Color.FromArgb(50, 205, 50) : Color.Crimson ;
            this.Text = String.Format("{0} \n ({1})", company.name,company.state);
        }

  

    
     
     
    }
}
