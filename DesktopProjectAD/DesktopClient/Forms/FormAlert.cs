using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DesktopClient.Forms
{
    public partial class FormAlert : Form
    {
        private int x, y;
        public FormAlert()
        {
            InitializeComponent();
           
        }
        public enum enmActions
        {
            wait,
            start,
            close
        }
        private FormAlert.enmActions action;

        private void timerMessage_Tick(object sender, EventArgs e)
        {
            switch (this.action)
            {
                case enmActions.wait:
                    //timerMessage.Interval = 50000;
                    //action = enmActions.close;
                    break;
                case enmActions.start:
                    timerMessage.Interval = 1;
                    this.Opacity += 0.1;
                    if(this.x < this.Location.X)
                    {
                        this.Left--;
                    }
                    else
                    {
                        if(this.Opacity == 1.0)
                        {
                            action = enmActions.wait;
                        }
                    }
                    break;
                case enmActions.close:
                    timerMessage.Interval = 1;
                    this.Opacity -= 0.1;
                    this.Left -= 3;
                    if(base.Opacity == 0.0)
                    {
                        base.Close();
                    }
                    break;
            }
        }

        private void buttonClose_Click(object sender, EventArgs e)
        {
            timerMessage.Interval = 1;
            this.action = enmActions.close;
        }
        public void ShowAlert(string msg)
        {
            this.Opacity = 0.0;
            this.StartPosition = FormStartPosition.Manual;
            string fname;
            for (int i = 1; i < 11; i++)
            {
                fname = "alert" + i.ToString();
                FormAlert frm = (FormAlert)Application.OpenForms[fname];
                if (frm == null)
                {
                    this.Name = fname;
                    this.x = Screen.PrimaryScreen.WorkingArea.Width - this.Width + 15;
                    this.y = (Screen.PrimaryScreen.WorkingArea.Height) - this.Height * i;
                    this.Location = new Point(this.x, this.y);
                    break;
                }
            }
            this.x = Screen.PrimaryScreen.WorkingArea.Width - base.Width - 5;
            labelMessage.Text = msg;
            this.Show();
            this.action = enmActions.start;
            timerMessage.Interval = 1;
            timerMessage.Start();
        }

       
    }
}
