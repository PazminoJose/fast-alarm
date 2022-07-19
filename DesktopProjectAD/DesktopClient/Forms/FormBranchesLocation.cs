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

namespace DesktopClient.Forms
{
    public partial class FormBranchesLocation : Form
    {
        GMapOverlay markers = null;
        CompanyEntity company = null;
        int totalMarkers = 0;
        bool isCompanyFormActive = false;
        public FormBranchesLocation()
        {
            InitializeComponent();
            LoadMap();
            LoadMarkers();
            AddCompanyButtonsToPanel();
            BlockFormCompany();

        }
        private void LoadMap()
        {
            GMapProviders.GoogleMap.ApiKey = Properties.Settings.Default.API_KEY_GMAP;
            gMapControl.MapProvider = GMapProviders.GoogleMap;
            gMapControl.DragButton = MouseButtons.Left;
            gMapControl.ShowCenter = false;
            double latitude = -1.3460634739251633;
            double longitude = -78.56483353462201;
            gMapControl.Position = new PointLatLng(latitude, longitude);
            gMapControl.MaxZoom = 18;
            gMapControl.MinZoom = 7;
            gMapControl.Zoom = 7;

        }
        private void AddCompanyButtonsToPanel()
        {
            int posX, posY;
            int width, height;
            width = (int)(panelButtons.Width / 1.3);
            height = (panelButtons.Height / 6);
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

                GMapMarker marker = new CompanyMarker(btn, point, GMarkerGoogleType.green_dot);
                // Add all markers to the overlay
                markers.Markers.Add(marker);
            }
            // 3. Cover map with overlay
            gMapControl.Overlays.Add(markers);
        }
        private void ClickBranchButton(object sender, EventArgs e)
        {
            CompanyButton btn = (CompanyButton)sender;
            ClickButtonMarkerAction(btn);

        }
        private void ClickButtonMarkerAction(CompanyButton btn)
        {
            if (btn == null) return;
            LoadFormCompany(btn.company);
            UnlockFormCompanyOnCompanySelected();
            company = btn.company;
            gMapControl.Zoom = 13;
            gMapControl.Position = new PointLatLng(btn.company.latitude, btn.company.longitude);
        }

        private void gMapControl_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            CompanyMarker marker = (CompanyMarker)item;
            ClickButtonMarkerAction(marker.btn);

        }
        private void SetAdressByPointLatLng(PointLatLng point)
        {
            List<Placemark> placemarks = null;
            var statusCode = GMapProviders.GoogleMap.GetPlacemarks(point, out placemarks);
            if (statusCode != GeoCoderStatusCode.OK && placemarks == null) return;
            textBoxAdress.Text = placemarks.First().Address;
        }

        private void gMapControl_OnMapClick(PointLatLng pointClick, MouseEventArgs e)
        {
            if (!isCompanyFormActive) return;
            AddMarkerOnMap(pointClick);
            SetAdressByPointLatLng(pointClick);

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
        private void LoadFormCompany(CompanyEntity company)
        {
            textBoxName.Text = company.name;
            textBoxContact.Text = company.contact;
            textBoxAdress.Text = company.address;
        }
        private void CleanFormCompany()
        {
            textBoxName.Text = "";
            textBoxContact.Text = "";
            textBoxAdress.Text = "";
        }
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
            CleanFormCompany();
        }

        private void buttonEdit_Click(object sender, EventArgs e)
        {
            UnlockFormCompanyEdit();
            EditCompany();
        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            SaveCompany();
            BlockFormCompany();
        }
        private void EditCompany()
        {
            this.company.name = textBoxName.Text;
            this.company.contact = textBoxContact.Text;
            this.company.address = textBoxAdress.Text;
            if (markers.Markers.Count() > totalMarkers)
            {
                PointLatLng point = markers.Markers.Last().Position;
                this.company.latitude = point.Lat;
                this.company.longitude = point.Lng;

            }
            CompanyBusiness.Save(company);



        }
        private void SaveCompany()
        {
            string name = textBoxName.Text;
            string contact = textBoxContact.Text;
            string adress = textBoxAdress.Text;
            CompanyMarker marker = (CompanyMarker)markers.Markers.Last();
            this.company = new CompanyEntity(Session.actualUser.Company, null, name, adress, contact, marker.Position.Lat, marker.Position.Lng);
            CompanyBusiness.Save(company);

        }
        private void buttonDelete_Click(object sender, EventArgs e)
        {
           if( MessageBox.Show("¿Esta seguro que desea eliminar la sucursal?", "Confirmar", MessageBoxButtons.OKCancel).Equals(DialogResult.OK))
            {
                CompanyBusiness.Delete(this.company.id);    
            }
            
        }
    }

}
