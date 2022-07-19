using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Entities;
using Business;
using DesktopClient.Classess;

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
            if (user == null) return false;
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
    }
}
