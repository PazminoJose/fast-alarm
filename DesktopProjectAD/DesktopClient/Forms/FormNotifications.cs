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
using Business;
using Entities;

namespace DesktopClient.Forms
{
    public partial class FormNotifications : Form
    {
        DataTable notifications = null;
        NotificationEntity notification = null;
        public FormNotifications()
        {
            InitializeComponent();
            this.InitTheme();
            this.LoadNotification();
        }
        private void InitTheme()
        {
            this.BackColor = ThemeColor.background;
            this.label1.ForeColor = ThemeColor.text;
            this.label2.ForeColor = ThemeColor.text;
            this.label3.ForeColor = ThemeColor.text;
            this.label4.ForeColor = ThemeColor.text;
            this.label5.ForeColor = ThemeColor.text;
            this.label6.ForeColor = ThemeColor.text;
            groupBox1.ForeColor = ThemeColor.text;
            groupBox2.ForeColor = ThemeColor.text;
            this.dataGridViewNotifications.BackgroundColor = ThemeColor.background;
            this.dataGridViewNotifications.DefaultCellStyle.ForeColor = ThemeColor.black;
        }

        private void LoadNotification()
        {
            this.notifications = Helpers.ToDataTable(NotificationBusiness.GetAll());
            this.dataGridViewNotifications.DataSource = this.notifications;
        }

        private void dateTimePickerFilter_ValueChanged(object sender, EventArgs e)
        {
      
            notifications.DefaultView.RowFilter = String.Format("Date LIKE '%{0}/{1}/{2}%' ", ((DateTimePicker)sender).Value.Day, ((DateTimePicker)sender).Value.Month, ((DateTimePicker)sender).Value.Year);

        }

        private void dataGridViewNotifications_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == -1) return;
            var id = dataGridViewNotifications.Rows[e.RowIndex].Cells["Id"].Value.ToString();
            this.LoadNotificationById(id);
     
        }

        private void LoadNotificationById(string id)
        {
            this.notification = NotificationBusiness.GetById(id);
            this.textBoxMessage.Text = this.notification.message;
            this.textBoxDate.Text = this.notification.date.ToString();
            this.textBoxUser.Text = this.notification.user.ToString(); ;
            this.textBoxCompany.Text = this.notification.user.company.ToString();
            this.textBoxUserType.Text = this.notification.user.user_type;
        }

    }
}
