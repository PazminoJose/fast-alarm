using Business;
using DesktopClient.Classess;
using Entities;
using System;
using System.Windows.Forms;
using DesktopClient.Utils;
namespace DesktopClient.Forms
{
    public partial class FormLogin : Form
    {

        public FormLogin()
        {
            InitializeComponent();
        }
        private bool Login()
        {
            string email = textBoxEmail.Text;
            string password = textBoxPassword.Text;
            UserEntity user = UserBusiness.Login(new UserCredentials(email, password));
            if (user == null)
            {
                this.showError(Constants.CONECCTION_ERROR);
                return false;
            }
            if (user.id == null)
            {
                this.showError(Constants.CREDENTIAL_ERROR);
                return false;
            }
            Session.actualUser = user;
            return true;

        }
        private void GetIntoApp()
        {
            if (!Login()) return;
            FormDesktopApp app = new FormDesktopApp();
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

    }
}
