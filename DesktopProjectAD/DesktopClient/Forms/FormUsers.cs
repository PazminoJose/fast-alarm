using DesktopClient.Utils;
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

using System.Reflection;

namespace DesktopClient.Forms
{
    public partial class FormUsers : Form
    {
        DataTable usersTable = null;
        UserEntity user = null;
        bool isEditing = false;
        public FormUsers()
        {
            InitializeComponent();
            InitTheme();
            LoadUsers();
            SetPasswordTextBox();
            LoadComboCompanies();
            BlockFormUser();


        }
        private void InitTheme()
        {
            this.BackColor = ThemeColor.background;
            this.dataGridViewUsers.BackgroundColor = ThemeColor.background;
            this.label2.ForeColor = ThemeColor.text;
            this.label3.ForeColor = ThemeColor.text;
            this.label4.ForeColor = ThemeColor.text;
            this.label5.ForeColor = ThemeColor.text;
            this.label6.ForeColor = ThemeColor.text;
            this.label7.ForeColor = ThemeColor.text;
            this.groupBox1.ForeColor = ThemeColor.text;
            this.groupBox2.ForeColor = ThemeColor.text;
            this.buttonNew.BackColor = ThemeColor.buttonNew;
            this.buttonSave.BackColor = ThemeColor.buttonSave;
            this.buttonDelete.BackColor = ThemeColor.buttonDelete;
            this.buttonEdit.BackColor = ThemeColor.buttonEdit;
            this.buttonEdit.ForeColor = ThemeColor.text;
            this.buttonNew.ForeColor = ThemeColor.text;
            this.buttonSave.ForeColor = ThemeColor.text;
            this.buttonDelete.ForeColor = ThemeColor.text;
            this.labelError.ForeColor = ThemeColor.error;
            this.radioButtonAdmin.ForeColor = ThemeColor.text;
            this.radioButtonUser.ForeColor = ThemeColor.text;
            this.dataGridViewUsers.DefaultCellStyle.ForeColor = ThemeColor.black;

        }
        private void LoadUsers()
        {
            this.dataGridViewUsers.ReadOnly = true;
            this.dataGridViewUsers.AllowUserToAddRows = false;
            List<UserEntity> users = UserBusiness.GetAll();
            if(users!=null) this.usersTable = Helpers.ToDataTable(users);
            this.dataGridViewUsers.DataSource = usersTable;

        }

        private void dataGridViewUsers_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            this.CellClick(e.RowIndex);
        }
        private void CellClick(int row)
        {
            if (row == -1) return;
            var id = dataGridViewUsers.Rows[row].Cells["Id"].Value.ToString();
            this.LoadUserById(id);
            this.textBoxName.Enabled = false;
            this.textBoxSurname.Enabled = false;
            this.textBoxEmail.Enabled = false;
            this.textBoxPassword.Enabled = false;
            this.radioButtonAdmin.Enabled = false;
            this.radioButtonUser.Enabled = false;
            this.textBoxName.Enabled = false;
            this.comboBoxCompany.Enabled = false;
            this.buttonDelete.Enabled = true;
            this.buttonSave.Enabled = false;
            this.buttonEdit.Enabled = true;
        }
        private void LoadUserById(string id)
        {
            this.user = UserBusiness.GetById(id);
            this.textBoxName.Text = user.name;
            this.textBoxSurname.Text = user.surname;
            this.textBoxEmail.Text = user.email;
            this.radioButtonAdmin.Checked = user.user_type.Equals("admin");
            this.radioButtonUser.Checked = user.user_type.Equals("user");
        }
        private void SetPasswordTextBox()
        {
            textBoxPassword.PasswordChar = '*';
            textBoxPassword.MaxLength = 8;
        }
        private void textBoxSearchUser_TextChanged(object sender, EventArgs e)
        {
            if (this.usersTable == null) return;
            this.usersTable.DefaultView.RowFilter = $"Name LIKE '%{textBoxSearchUser.Text}%' OR Surname LIKE '%{textBoxSearchUser.Text}%' OR Email LIKE '%{textBoxSearchUser.Text}%' OR USER_TYPE LIKE '%{textBoxSearchUser.Text}%'";
        }
        private void buttonNew_Click(object sender, EventArgs e)
        {
            this.ClearFormUser();
            this.UnlockFormUserNew();
            this.New();
        }
        private void New()
        {
            this.isEditing = false;
            this.labelError.Visible = false;
            this.user = null;
        }
        private void buttonSave_Click(object sender, EventArgs e)
        {
            if (!ValidateFormUser()) return;
            this.SaveUser();
            this.BlockFormUser();
            this.LoadUsers();
        }
        private void buttonDelete_Click(object sender, EventArgs e)
        {
            this.DeleteUser();
         
        }
        private void SaveUser()
        {
            if (this.user == null) this.user = new UserEntity();
            this.user.name = textBoxName.Text;
            this.user.surname = textBoxSurname.Text;
            this.user.email = textBoxEmail.Text;
            if (comboBoxCompany.SelectedValue == null) return;
            this.user.company = CompanyBusiness.GetById(comboBoxCompany.SelectedValue.ToString());
            this.user.password = (this.isEditing && !textBoxPassword.Text.Equals("")) ? textBoxPassword.Text : null;
            this.user.user_type = (radioButtonUser.Checked) ? "user" : "admin";
            Helpers.Alert("Usuario guardado exitosamente", FormAlert.enmType.success, true);
            UserBusiness.Save(this.user);
        }
        private void DeleteUser()
        {
            int selectedRowCount = dataGridViewUsers.Rows.GetRowCount(DataGridViewElementStates.Selected);
            if (selectedRowCount != 1) return;
            int confirmar = Convert.ToInt32(MessageBox.Show("¿Seguro que desea eliminar el usuario? Si el usuario envió alguna notificación el nombre de este será eliminado de dicha notificación", "CONFIRMAR", MessageBoxButtons.YesNo));

            if (confirmar == 6)
            {
                string id = dataGridViewUsers.SelectedRows[0].Cells[0].Value.ToString();
                UserBusiness.Delete(id);
                Helpers.Alert("Usuario eliminado exitosamente", FormAlert.enmType.success, true);
                this.BlockFormUser();
                this.LoadUsers();
                this.ClearFormUser();
            }
        }
        private void ClearFormUser()
        {
            this.textBoxName.Text = "";
            this.textBoxSurname.Text = "";
            this.textBoxEmail.Text = "";
            this.textBoxPassword.Text = "";
            this.radioButtonAdmin.Checked = false;
            this.radioButtonUser.Checked = false;
            this.textBoxName.Text = "";
        }
        private void LoadComboCompanies()
        {
            this.comboBoxCompany.DataSource = CompanyBusiness.GetAll();
            this.comboBoxCompany.DisplayMember = "name";
            this.comboBoxCompany.ValueMember = "id";
        }
        private void BlockFormUser()
        {
            this.textBoxName.Enabled = false;
            this.textBoxSurname.Enabled = false;
            this.textBoxEmail.Enabled = false;
            this.textBoxPassword.Enabled = false;
            this.radioButtonAdmin.Enabled = false;
            this.radioButtonUser.Enabled = false;
            this.textBoxName.Enabled = false;
            this.comboBoxCompany.Enabled = false;
            this.buttonNew.Enabled = true;
            this.buttonEdit.Enabled = false;
            this.buttonSave.Enabled = false;
            this.buttonDelete.Enabled = false;
        }
        private void UnlockFormUserNew()
        {
            this.textBoxName.Enabled = true;
            this.textBoxSurname.Enabled = true;
            this.textBoxEmail.Enabled = true;
            this.textBoxPassword.Enabled = true;
            this.radioButtonAdmin.Enabled = true;
            this.radioButtonUser.Enabled = true;
            this.textBoxName.Enabled = true;
            this.comboBoxCompany.Enabled = true;
            this.buttonNew.Enabled = true;
            this.buttonSave.Enabled = true;
            this.buttonEdit.Enabled = false;
            this.buttonDelete.Enabled = false;
        }
        private void UnlockFormUserEdit()
        {
            this.textBoxName.Enabled = true;
            this.textBoxSurname.Enabled = true;
            this.textBoxEmail.Enabled = true;
            this.textBoxPassword.Enabled = true;
            this.radioButtonAdmin.Enabled = true;
            this.radioButtonUser.Enabled = true;
            this.textBoxName.Enabled = true;
            this.comboBoxCompany.Enabled = true;
            this.buttonNew.Enabled = true;
            this.buttonSave.Enabled = true;
            this.buttonEdit.Enabled = false;
            this.buttonDelete.Enabled = true;
        }
        private bool ValidateFormUser()
        {
            string msg = null;

            if (!radioButtonAdmin.Checked && !radioButtonUser.Checked) msg = "El tipo de usuario es obligatorio";
            if (textBoxPassword.Text.Equals("") && !this.isEditing) msg = "la contraseña es obligatoria";
            if (textBoxEmail.Text.Equals("")) msg = "El correo es obligatorio";
            if (textBoxSurname.Text.Equals("")) msg = "El apellido es obligatorio";
            if (textBoxName.Text.Equals("")) msg = "El nombre es obligatorio";
            if (msg != null)
            {
                this.labelError.Visible = true;
                this.labelError.Text = msg;
                return false;
            }
            return true;
        }
        private void buttonEdit_Click(object sender, EventArgs e)
        {
            this.UnlockFormUserEdit();
            this.Edit();
        }
        private void Edit()
        {
            this.isEditing = true;
            this.labelError.Visible = false;

        }


        private void textBoxPassword_TextChanged(object sender, EventArgs e)
        {
            this.isEditing = true;
        }
    }
}
