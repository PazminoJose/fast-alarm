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
        DataTable usersTable = new DataTable();
        UserEntity user = null;
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
            this.buttonNew.ForeColor = ThemeColor.text;
            this.buttonSave.ForeColor = ThemeColor.text;
            this.buttonDelete.ForeColor = ThemeColor.text;
            this.labelError.ForeColor = ThemeColor.error;
            this.radioButtonAdmin.ForeColor = ThemeColor.text;
            this.radioButtonUser.ForeColor = ThemeColor.text;

        }
        private void LoadUsers()
        {
            dataGridViewUsers.ReadOnly = true;
            dataGridViewUsers.AllowUserToAddRows = false;
            usersTable = ToDataTable(UserBusiness.GetAll()); 
            dataGridViewUsers.DataSource = usersTable;
          
        }
        private DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name.ToUpper());
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        private void dataGridViewUsers_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1) return;
            var id = dataGridViewUsers.Rows[e.RowIndex].Cells["Id"].Value.ToString();
            this.LoadUserById(id);
            this.UnlockFormUser();
        }

        private void LoadUserById(string id)
        {
            this.user = UserBusiness.GetById(id);
            this.textBoxName.Text = user.name;
            this.textBoxSurname.Text = user.surname;
            this.textBoxEmail.Text = user.email;
            this.textBoxPassword.Text = user.password.Substring(0,8);
            this.radioButtonAdmin.Checked = user.user_type.Equals("admin") ;
            this.radioButtonUser.Checked = user.user_type.Equals("user");
        }
        private void SetPasswordTextBox()
        {
            textBoxPassword.PasswordChar = '*';
            textBoxPassword.MaxLength = 8;
        }

        private void textBoxSearchUser_TextChanged(object sender, EventArgs e)
        {
            this.usersTable.DefaultView.RowFilter = $"Name LIKE '%{textBoxSearchUser.Text}%' OR Surname LIKE '%{textBoxSearchUser.Text}%'";
        }

        private void buttonNew_Click(object sender, EventArgs e)
        {
            this.ClearFormUser();
            this.UnlockFormUser();
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
            this.BlockFormUser();
            this.LoadUsers();
            this.ClearFormUser();
        }

        private void SaveUser()
        {
            if (this.user == null) this.user = new UserEntity();
            this.user.name = textBoxName.Text;
            this.user.surname = textBoxSurname.Text;
            this.user.email = textBoxEmail.Text;
            this.user.company = CompanyBusiness.GetById(comboBoxCompany.SelectedValue.ToString());
            this.user.password = textBoxPassword.Text;
            this.user.user_type = (radioButtonUser.Checked) ? "user":"admin";
         
            UserBusiness.Save(this.user);
        }
        private void DeleteUser()
        {
            int selectedRowCount = dataGridViewUsers.Rows.GetRowCount(DataGridViewElementStates.Selected);
            if (selectedRowCount != 1) return;
            int confirmar = Convert.ToInt32(MessageBox.Show("¿Seguro que desea eliminar el usuario?", "CONFIRMAR", MessageBoxButtons.YesNo));

            if (confirmar == 6)
            {
                string id = dataGridViewUsers.SelectedRows[0].Cells[0].Value.ToString();
                UserBusiness.Delete(id);
                this.LoadUsers();
                MessageBox.Show("Usuario eliminado correctamente");
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
            this.buttonSave.Enabled = false;
            this.buttonDelete.Enabled = false;
        }
        private void UnlockFormUser()
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
            this.buttonDelete.Enabled = true;
        }
        private bool ValidateFormUser()
        {
            string msg = null;    
         
            if (!radioButtonAdmin.Checked && !radioButtonUser.Checked) msg = "El tipo de usuario es obligatorio";
            if (textBoxPassword.Text.Equals("")) msg = "la contraseña es obligatoria";
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

 
    }
}
