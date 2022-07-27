using DesktopClient.Classess;
using DesktopClient.Utils;
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
            this.labelTitle.Text = Constants.COMPANIES;
            Task task = this.GetNotificationAsync();
            this.labelUserName.Text = $"{Session.actualUser.name} {Session.actualUser.surname}";
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
                        Helpers.Alert(msg,FormAlert.enmType.error,false);
                    }));       
            });

            await client.ConnectAsync();


        }

        private void buttonCompanies_Click(object sender, EventArgs e)
        {
            this.labelTitle.Text = Constants.COMPANIES;
            OpenChildForm(new FormCompaniesLocation());
        }

        private void buttonUsers_Click(object sender, EventArgs e)
        {
            this.labelTitle.Text = Constants.USERS;
            OpenChildForm(new FormUsers());
        }

        private void buttonNotifications_Click(object sender, EventArgs e)
        {
            this.labelTitle.Text = Constants.NOTIFICATIONS;
            OpenChildForm(new FormNotifications());
        }

        private void buttonLogout_Click(object sender, EventArgs e)
        {
            Session.actualUser = null;
            FormLogin fm = new FormLogin();
            fm.Show();
            this.Dispose();
        }
    }
}
