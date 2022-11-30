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
        AlarmEntity alarm = null;
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
            this.label6.ForeColor = ThemeColor.text;
            this.label7.ForeColor = ThemeColor.text;
            groupBox1.ForeColor = ThemeColor.text;
            groupBox2.ForeColor = ThemeColor.text;
            this.dataGridViewNotifications.BackgroundColor = ThemeColor.background;
            this.dataGridViewNotifications.DefaultCellStyle.ForeColor = ThemeColor.black;
        }

        private void LoadNotification()
        {
            List<AlarmEntity> notifications = AlarmBusiness.GetAll();
            if(notifications!=null) this.notifications = Helpers.ToDataTable(notifications);
            this.dataGridViewNotifications.DataSource = this.notifications;
        }

        private void dateTimePickerFilter_ValueChanged(object sender, EventArgs e)
        {
            if (this.notifications == null) return;
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
            this.alarm = AlarmBusiness.GetById(id);
            this.textBoxMessage.Text = this.alarm.message;
            this.textBoxDate.Text = this.alarm.date.ToString();
            this.textBoxUser.Text = this.alarm.user.ToString(); ;
            this.textBoxState.Text = this.alarm.state;
            this.textBoxAddress.Text = Helpers.GetPlacemarkByPointLatLng(new GMap.NET.PointLatLng(this.alarm.latitude,this.alarm.longitude)).Address;
        }

    }
}
