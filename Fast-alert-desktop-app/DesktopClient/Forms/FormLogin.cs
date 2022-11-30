using Business;
using DesktopClient.Classess;
using Entities;
using System;
using System.Windows.Forms;
using DesktopClient.Utils;
using System.Threading.Tasks;
using SocketIOClient;

namespace DesktopClient.Forms
{
    public partial class FormLogin : Form
    {
        const string USERT_TYPE = "admin";
        public FormLogin()
        {
            InitializeComponent();
            SetPasswordTextBox();
            //Task task = this.GetNotificationAsync();
        }
        private bool Login()
        {
            string email = textBoxEmail.Text;
            string password = textBoxPassword.Text;
            PoliceEntity police = UserBusiness.Login(new UserCredentials(email, password));
            if (police == null)
            {
                this.showError(Constants.CONECCTION_ERROR);
                return false;
            }
            if (police.id == null)
            {
                this.showError(Constants.CREDENTIAL_ERROR);
                return false;
            }
            if (!police.user.userType.Equals(USERT_TYPE))
            {
                this.showError(Constants.USER_TYPE_ERROR);
                return false;
            }
            Session.SetCurrentPolice(police);
            return true;

        }
        private void GetIntoApp()
        {
            if (!Login()) return;
            FormMainApp app = new FormMainApp();
            app.Show();
            this.Hide();
        }

        private void buttonLogin_Click(object sender, EventArgs e)
        {
            GetIntoApp();
        }
        private void showError(string msg)
        {
            this.labelError.Visible = true;
            this.labelError.Text = msg;
        }
        private void SetPasswordTextBox()
        {
            textBoxPassword.PasswordChar = '*';
            textBoxPassword.MaxLength = 8;
        }
        //public async Task GetNotificationAsync()
        //{

        //    var client = new SocketIO(Properties.Settings.Default.URL_API);

        //    client.On("alert", (response) =>
        //    {
        //        string msg = response.GetValue<string>();
        //        this.Invoke(new Action(() => {
        //            Helpers.Alert(msg, FormAlert.enmType.error, false);
        //        }));
        //    });

        //    await client.ConnectAsync();

        //}
    }
}
