using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DesktopClient.Controls;

namespace DesktopClient.Forms
{
    public partial class FormDesktopApp : Form
    {
        private Form activeForm;
        public FormDesktopApp()
        {
            InitializeComponent();
            OpenChildForm(new FormBranchesLocation());
        }


        private void OpenChildForm(Form childForm)
        {
            if (activeForm != null)
            {
                activeForm.Close();
            }
            activeForm = childForm;
            childForm.TopLevel = false;
            childForm.FormBorderStyle = FormBorderStyle.None;
            childForm.Dock = DockStyle.Fill;
            this.panelContent.Controls.Add(childForm);
            this.panelContent.Tag = childForm;
            childForm.BringToFront();
            childForm.Show();

        }
        private void Alert(string msg)
        {
            FormAlert frm = new FormAlert();
            frm.ShowAlert(msg);
        }

        private void buttonCompanies_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormBranchesLocation());
            this.Alert("ayuda prro");
        }
    }
}
