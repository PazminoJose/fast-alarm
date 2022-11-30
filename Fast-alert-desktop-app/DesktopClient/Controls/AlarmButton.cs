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
    class AlarmButton : Button
    {
        public AlarmEntity alarm;
        public string address;
        private const string ALERT_MSG = "Alerta de auxilio en: ";
        public AlarmButton(AlarmEntity alarm, string address)
        {
            this.alarm = alarm;
            this.address = address;
            this.ForeColor = Color.White;
            this.BackColor =  Color.Crimson ;
            this.Text = String.Format("{0} \n ({1})", ALERT_MSG, this.address);
        }

  

    
     
     
    }
}
