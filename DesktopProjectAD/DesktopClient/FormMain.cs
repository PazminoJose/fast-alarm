using DesktopClient.Forms;
using System;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace DesktopClient
{
    public partial class FormMain : Form
    {
        private Form activeForm;
       
        public FormMain()
        {
            InitializeComponent();
           
        }
        
     
        private void OpenChildForm(Form childForm, object btnSender)
        {
            if(activeForm != null)
            {
                activeForm.Close();
            }
            activeForm = childForm;
            childForm.TopLevel = false;
            childForm.FormBorderStyle = FormBorderStyle.None;
            childForm.Dock = DockStyle.Fill;
            this.panelMain.Controls.Add(childForm);
            this.panelMain.Tag = childForm;
            childForm.BringToFront();
            childForm.Show();

        }

        private void buttonBranches_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormBranchesLocation(), sender);
            this.Alert("ayuda prro");
        }
        private void Alert(string msg)
        {
            FormAlert frm = new FormAlert();
            frm.ShowAlert(msg);
        }

    }
}
