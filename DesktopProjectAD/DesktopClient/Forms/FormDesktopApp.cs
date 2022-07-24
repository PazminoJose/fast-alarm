using DesktopClient.Classess;
using SocketIOClient;
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
    public partial class FormDesktopApp : Form
    {
        private Form activeForm;
        public FormDesktopApp()
        {
            InitializeComponent();
            OpenChildForm(new FormCompaniesLocation());
            Task task = this.GetNotificationAsync();
        }


        private void OpenChildForm(Form childForm)
        {
            if (activeForm != null) activeForm.Close();
            activeForm = childForm;
            childForm.TopLevel = false;
            childForm.FormBorderStyle = FormBorderStyle.None;
            childForm.Dock = DockStyle.Fill;
            this.panelContent.Controls.Add(childForm);
            this.panelContent.Tag = childForm;
            childForm.BringToFront();
            childForm.Show();

        }
        public async Task GetNotificationAsync()
        {

            var client = new SocketIO(Properties.Settings.Default.URL_API);

            client.On("alert", (response) =>
            {
                string msg = response.GetValue<string>();
                    this.Invoke(new Action(() => {
                        Notification.Alert(msg);
                    }));       
            });

            await client.ConnectAsync();


        }

        private void buttonCompanies_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormCompaniesLocation());
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormUsers());
        }
    }
}
