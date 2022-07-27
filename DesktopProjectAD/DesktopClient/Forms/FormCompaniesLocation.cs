using System;
using System.Collections.Generic;
using System.ComponentModel;
using GMap.NET;
using GMap.NET.MapProviders;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DesktopClient.Controls;
using Business;
using Entities;
using DesktopClient.Classess;
using SocketIOClient;
using DesktopClient.Utils;

namespace DesktopClient.Forms
{
    public partial class FormCompaniesLocation : Form
    {
        GMapOverlay markers = null;
        CompanyEntity company = null;
        int totalMarkers = 0;
        bool isCompanyFormActive = false;

        public FormCompaniesLocation()
        {
            InitializeComponent();
            LoadMap();
            LoadMarkers();
            LoadCompanyButtons();
            BlockFormCompany();
            this.buttonDisableAlarm.Visible = false;
            Task task = this.GetNotificationAsync();
        }
        // Map methods
        private void LoadMap()
        {
            GMapProviders.GoogleMap.ApiKey = Properties.Settings.Default.API_KEY_GMAP;
            gMapControl.MapProvider = GMapProviders.GoogleMap;
            gMapControl.DragButton = MouseButtons.Left;
            gMapControl.ShowCenter = false;
        }
        private void gMapControl_OnMapClick(PointLatLng pointClick, MouseEventArgs e)
        {
            if (!isCompanyFormActive) return;
            AddMarkerOnMap(pointClick);
            SetAdressByPointLatLng(pointClick);

        }
        private void LoadMarkers()
        {
            gMapControl.Overlays.Clear();
            List<CompanyEntity> companies = CompanyBusiness.GetAll();
            // Set total markers
            totalMarkers = companies.Count();
            // 1. Create overlay
            markers = new GMapOverlay("markers");
            foreach (var company in companies)
            {
                CompanyButton btn = new CompanyButton(company);
                PointLatLng point = new PointLatLng(company.latitude, company.longitude);
                GMarkerGoogleType type = (company.state.Equals("normal")) ? GMarkerGoogleType.green_dot : GMarkerGoogleType.red_dot;
                GMapMarker marker = new CompanyMarker(btn, point, type);
                // Add all markers to the overlay
                markers.Markers.Add(marker);
            }
            // 3. Cover map with overlay
            gMapControl.Overlays.Add(markers);

            double latitude = Constants.INITIAL_LATITUDE;
            double longitude = Constants.INITIAL_LONGITUDE;
            gMapControl.Position = new PointLatLng(latitude, longitude);
            gMapControl.MaxZoom = Constants.MAX_ZOOM;
            gMapControl.MinZoom = Constants.MIN_ZOOM;
            gMapControl.Zoom = 7;
        }
        private void gMapControl_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            CompanyMarker marker = (CompanyMarker)item;
            LoadCompany(marker.btn);

        }
        private void AddMarkerOnMap(PointLatLng point)
        {
            // Removing old marker 
            if (markers.Markers.Count() > totalMarkers) markers.Markers.RemoveAt(markers.Markers.Count() - 1);
            // Clear Markers in the map overlay
            gMapControl.Overlays.Clear();
            // Add new marker
            GMapMarker marker = new CompanyMarker(null, point, GMarkerGoogleType.blue_dot);
            markers.Markers.Add(marker);
            gMapControl.Overlays.Add(markers);


        }

        // Actions
        private void LoadCompanyButtons()
        {
          
            panelButtons.Controls.Clear();
            int posX, posY;
            int width, height;
            width = (int)(188 / 1.3);
            height = (575 / 6);
            posX = 0;
            posY = 0;
            CompanyButton btn = null;
            foreach (var marker in markers.Markers)
            {

                btn = ((CompanyMarker)marker).btn;
                // Set btton size
                btn.Size = new Size(width, height);
                // Set button text
                btn.Click += ClickBranchButton;
                // Add button to panel
                panelButtons.Controls.Add(btn);
                // Set button position
                btn.Location = new Point(posX, posY);

                if (panelButtons.Controls.Count > 0)
                {
                    posX += width;
                }
                if (panelButtons.Controls.Count % 2 == 0)
                {
                    posX = 0;
                    posY += height;
                }
            }
        }
        private void ClickBranchButton(object sender, EventArgs e)
        {
        
            CompanyButton btn = (CompanyButton)sender;
            LoadCompany(btn);

        }
        private void LoadCompany(CompanyButton btn)
        {
            if (btn == null) return;
            SetFormData(btn.company);
            UnlockFormCompanyOnCompanySelected();
            company = btn.company;
            if (!company.state.Equals("normal")) this.buttonDisableAlarm.Visible = true;
            gMapControl.Zoom = Constants.MAP_ZOOM;
            gMapControl.Position = new PointLatLng(btn.company.latitude, btn.company.longitude);
        }
        private void SetAdressByPointLatLng(PointLatLng point)
        {
            List<Placemark> placemarks = null;
            var statusCode = GMapProviders.GoogleMap.GetPlacemarks(point, out placemarks);
            if (statusCode != GeoCoderStatusCode.OK && placemarks == null) return;
            textBoxAdress.Text = placemarks.First().Address;
        }
 
        // Form Methods
        private void SetFormData(CompanyEntity company)
        {
            textBoxName.Text = company.name;
            textBoxContact.Text = company.contact;
            textBoxAdress.Text = company.address;
        }
        private void BlockFormCompany()
        {
            textBoxName.Enabled = false;
            textBoxContact.Enabled = false;
            textBoxAdress.Enabled = false;
            buttonSearch.Enabled = false;
            buttonNew.Enabled = true;
            buttonEdit.Enabled = false;
            buttonSave.Enabled = false;
            buttonDelete.Enabled = false;
            isCompanyFormActive = false;

        }
        private void UnlockFormCompanyEdit()
        {
            textBoxName.Enabled = true;
            textBoxContact.Enabled = true;
            textBoxAdress.Enabled = true;
            buttonSearch.Enabled = true;
            buttonNew.Enabled = true;
            buttonEdit.Enabled = false;
            buttonSave.Enabled = true;
            buttonDelete.Enabled = true;
            isCompanyFormActive = true;
        }
        private void UnlockFormCompanyOnCompanySelected()
        {
            textBoxName.Enabled = false;
            textBoxContact.Enabled = false;
            textBoxAdress.Enabled = false;
            buttonSearch.Enabled = false;
            buttonNew.Enabled = true;
            buttonEdit.Enabled = true;
            buttonSave.Enabled = false;
            buttonDelete.Enabled = true;
            isCompanyFormActive = false;
        }
        private void UnlockFormCompanyNew()
        {
            textBoxName.Enabled = true;
            textBoxContact.Enabled = true;
            textBoxAdress.Enabled = true;
            buttonSearch.Enabled = true;
            buttonNew.Enabled = true;
            buttonEdit.Enabled = false;
            buttonSave.Enabled = true;
            buttonDelete.Enabled = false;
            isCompanyFormActive = true;
        }
        private void ClearFormCompany()
        {
            textBoxName.Text = "";
            textBoxContact.Text = "";
            textBoxAdress.Text = "";
            this.labelError.Visible = false;
        }

        // Buttons
        private void buttonSearch_Click(object sender, EventArgs e)
        {
            string search = textBoxAdress.Text;
            GeoCoderStatusCode status = gMapControl.SetPositionByKeywords(search);
            if (status == GeoCoderStatusCode.OK)
            {
                gMapControl.Zoom = 17;

                List<PointLatLng> points = null;
                var statusCode = GMapProviders.GoogleMap.GetPoints(search, out points);
                AddMarkerOnMap(points.First());
            }
        }
        private void buttonNew_Click(object sender, EventArgs e)
        {
            UnlockFormCompanyNew();
            ClearFormCompany();
            this.company = null;
        }
        private void buttonEdit_Click(object sender, EventArgs e)
        {
            UnlockFormCompanyEdit();
            EditCompany();
        }
        private void buttonSave_Click(object sender, EventArgs e)
        {
            if (!Validate()) return;
            SaveCompany();
            LoadMarkers();
            LoadCompanyButtons();
            UnlockFormCompanyOnCompanySelected();
        }
        private void buttonDelete_Click(object sender, EventArgs e)
        {
            this.DeleteCompany();
            this.LoadMarkers();
            this.LoadCompanyButtons();
        }
        private void DeleteCompany()
        {
            if (MessageBox.Show("¿Esta seguro que desea eliminar la sucursal? Si existen usuarios asignados a esta sucursal tendrá que reasignarlos manualmente después", "Confirmar", MessageBoxButtons.OKCancel).Equals(DialogResult.OK))
            {
                CompanyBusiness.Delete(this.company.id);
            }
        }
        private void EditCompany()
        {
            this.company.name = textBoxName.Text;
            this.company.contact = textBoxContact.Text;
            this.company.address = textBoxAdress.Text;
            if (markers.Markers.Count() > totalMarkers)
            {
                PointLatLng point = markers.Markers.Last().Position;
                this.company.latitude = (float)point.Lat;
                this.company.longitude = (float)point.Lng;

            }
            CompanyBusiness.Save(company);



        }
        private void SaveCompany()
        {
            if (this.company == null) this.company = new CompanyEntity();
            this.company.name = textBoxName.Text;
            this.company.contact = textBoxContact.Text;
            this.company.address = textBoxAdress.Text;
            CompanyMarker marker = (CompanyMarker)markers.Markers.Last();
            if( markers.Markers.Count() > totalMarkers)
            {
                this.company.latitude = (float)marker.Position.Lat;
                this.company.longitude = (float)marker.Position.Lng;
            }
            this.company.state = "normal";
            this.company.headOffice = (this.company.id == Session.actualUser.company.id) ? null : Session.actualUser.company;
            CompanyBusiness.Save(company);
            if (this.company.id == null) Helpers.Alert("Compania guardada exitosamente", FormAlert.enmType.success, true);
            else Helpers.Alert("Compania editada exitosamente", FormAlert.enmType.success, true);
        }
        private bool Validate()
        {
            string msg = "";
            if (textBoxAdress.Text.Equals("")) msg = "La dirección es obligatoria";
            if (textBoxContact.Text.Equals("")) msg = "El contacto es obligatorio";
            if (textBoxName.Text.Equals("")) msg = "El nombre es obligatorio";
            if (!msg.Equals(""))
            {
                this.labelError.Visible = true;
                this.labelError.Text = msg;
                return false;
            }
            return true;

        }
        // Notification
        public  async Task GetNotificationAsync()
        {
     
            var client = new SocketIO(Properties.Settings.Default.URL_API);

            client.On("alert", (response) =>
            {
                string msg = response.GetValue<string>();
                string idCompnay = response.GetValue<string>(1);
                if (!this.IsDisposed) { 
                this.Invoke(new Action(() => {
                    this.LoadMarkers();
                    this.LoadCompanyButtons();
                    this.ZoomInMapCompany(idCompnay);
                }));
            }

            });

            await client.ConnectAsync();

        }
        private void ZoomInMapCompany(string id)
        {
            foreach (var marker in this.markers.Markers)
            {
                if (((CompanyMarker)marker).btn.company.id.Equals(id))
                {
                    gMapControl.Position = marker.Position;
                    gMapControl.Zoom = Constants.MAP_ZOOM;
                }

            }
        }

        private void DisableAlarm()
        {
            if (this.company == null) return;
            this.company.state = "normal";
            CompanyBusiness.Save(this.company);
            this.LoadMarkers();
            this.LoadCompanyButtons();
            this.buttonDisableAlarm.Visible = false;
        }
        private void buttonDisableAlarm_Click(object sender, EventArgs e)
        {

            this.DisableAlarm();
        }

    
    }

}
