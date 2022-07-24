using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DesktopClient.Forms;
using Newtonsoft.Json;
using SocketIOClient;

namespace DesktopClient.Classess
{
    public static class Notification
    {
        public static void Alert(string msg)
        {
            FormAlert fm = new FormAlert();
            fm.ShowAlert(msg);
        }
    }
}
