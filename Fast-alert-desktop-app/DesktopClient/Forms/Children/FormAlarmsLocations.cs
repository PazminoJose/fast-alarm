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
    public partial class FormAlarmsLocations : Form
    {
        GMapOverlay markers = null;
        AlarmEntity marker = null;
        int totalMarkers = 0;
        bool isCompanyFormActive = false;
        public FormAlarmsLocations()
        {
            InitializeComponent();
            LoadMap();
            LoadMarkers();
            LoadCompanyButtons();
            SetReadOnlyAlarmInfo();
            this.buttonDisableAlarm.Enabled = false;
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
        //private void gMapControl_OnMapClick(PointLatLng pointClick, MouseEventArgs e)
        //{
        //    if (!isCompanyFormActive) return;
        //    AddMarkerOnMap(pointClick);
        //    textBoxAdress.Text = GetAdressByPointLatLng(pointClick);

        //}
        private void LoadMarkers()
        {
            gMapControl.Overlays.Clear();
            List<AlarmEntity> alarms = AlarmBusiness.GetAllActive();
            if (alarms == null) return;
            // Set total markers
            totalMarkers = alarms.Count();
            // Create overlay
            markers = new GMapOverlay("markers");
            markers.Markers.Add(CreateMarker(Session.GetCurrentUpc()));
            foreach (var alarm in alarms)
            {
                GMapMarker marker = CreateMarker(alarm);
                // Add all markers to the overlay
                markers.Markers.Add(marker);
            }
            // Cover map with overlay
            gMapControl.Overlays.Add(markers);

            double latitude = Constants.INITIAL_LATITUDE;
            double longitude = Constants.INITIAL_LONGITUDE;
            gMapControl.Position = new PointLatLng(latitude, longitude);
            gMapControl.MaxZoom = Constants.MAX_ZOOM;
            gMapControl.MinZoom = Constants.MIN_ZOOM;
            gMapControl.Zoom = Constants.MIN_ZOOM;
        }
        private GMapMarker CreateMarker(Object marker)
        {
            if (marker is AlarmEntity)
            {
                string address = Helpers.GetPlacemarkByPointLatLng(new PointLatLng(((AlarmEntity)marker).latitude, ((AlarmEntity)marker).longitude)).Address;
                AlarmButton btn = new AlarmButton((AlarmEntity)marker, address);
                PointLatLng point = new PointLatLng(((AlarmEntity)marker).latitude, ((AlarmEntity)marker).longitude);
                GMarkerGoogleType type = GMarkerGoogleType.red_dot;
                GMapMarker newMarker = new AlarmMarker(btn, point, type);
                return newMarker;
            }
            else
            {
                string address = Helpers.GetPlacemarkByPointLatLng(new PointLatLng(((UPCEntity)marker).latitude, ((UPCEntity)marker).longitude)).Address;
                PointLatLng point = new PointLatLng(((UPCEntity)marker).latitude, ((UPCEntity)marker).longitude);
                GMarkerGoogleType type = GMarkerGoogleType.green_dot;
                GMapMarker newMarker = new GMarkerGoogle(point, type);
                newMarker.ToolTipText = address;
                return newMarker;
            }
           
        }
        private void gMapControl_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            if (item is AlarmMarker)
            {
                OnClickAlarmMarker(item);
            }
            else
            {
                OnClickUpcMarker();
            }
        }
        private void AddMarkerOnMap(PointLatLng point)
        {
            // Removing old marker 
            if (markers == null) return;
            if (markers.Markers.Count() > totalMarkers) markers.Markers.RemoveAt(markers.Markers.Count() - 1);
            // Clear Markers in the map overlay
            gMapControl.Overlays.Clear();
            // Add new marker
            GMapMarker marker = new AlarmMarker(null, point, GMarkerGoogleType.blue_dot);
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
            AlarmButton btn = null;
            if (markers == null) return;
            foreach (var marker in markers.Markers)
            {
                if (!(marker is AlarmMarker)) continue;
                btn = ((AlarmMarker)marker).btn;
                if (btn == null) return;
                // Set btton size
                btn.Size = new Size(width, height);
                // Set button text
                btn.Click += OnClickAlarmButton;
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
        private void OnClickUpcMarker()
        {
            this.buttonDisableAlarm.Enabled = false;
            double latitude = Session.GetCurrentUpc().latitude;
            double longitude = Session.GetCurrentUpc().longitude;
            ZoomInMap(new PointLatLng(latitude, longitude));
            ClearAlarmInfo();
        }
        private void OnClickAlarmMarker(GMapMarker item)
        {
            AlarmMarker marker = (AlarmMarker)item;
            PointLatLng start = new PointLatLng(Session.GetCurrentUpc().latitude, Session.GetCurrentUpc().longitude);
            PointLatLng end = marker.Position;
            AddRoutesBetweenTwoPlacesToOverlay(start, end);
            LoadAlert(marker.btn);

        }
        private void OnClickAlarmButton(object sender, EventArgs e)
        {
        
            AlarmButton btn = (AlarmButton)sender;
            PointLatLng start = new PointLatLng(Session.GetCurrentUpc().latitude, Session.GetCurrentUpc().longitude);
            PointLatLng end = new PointLatLng(btn.alarm.latitude, btn.alarm.longitude);
            AddRoutesBetweenTwoPlacesToOverlay(start, end);
            LoadAlert(btn);
            this.buttonDisableAlarm.Enabled = true;

        }
        private void LoadAlert(AlarmButton btn)
        {
            if (btn == null) return;
            SetNotificationInfo(btn.alarm);
            marker = btn.alarm;
            ZoomInMap(new PointLatLng(btn.alarm.latitude, btn.alarm.longitude));
        }

        private void AddRoutesBetweenTwoPlacesToOverlay(PointLatLng start, PointLatLng end)
        {
            MapRoute route = GoogleMapProvider.Instance.GetRoute(start, end,false, false, 13);
            GMapRoute gmapRoute = new GMapRoute(route.Points, "route");
            GMapOverlay routesOverlay = new GMapOverlay("routes");
            routesOverlay.Routes.Add(gmapRoute);
            if (gMapControl.Overlays.Count >= 2) gMapControl.Overlays.RemoveAt(1);
            gMapControl.Overlays.Add(routesOverlay);

        }
        private void ZoomInMap(PointLatLng point)
        {
            gMapControl.Zoom = Constants.MAX_ZOOM;
            gMapControl.Position = point;
        }
        // Form Methods
        private void SetNotificationInfo(AlarmEntity alarm)
        {
            if (alarm.user == null) return;
            textBoxName.Text = String.Format("{0} {1}", alarm.user.name, alarm.user.surname);
            textBoxPhone.Text = alarm.user.phone;
            textBoxIdCard.Text = alarm.user.idCard;
            textBoxAdress.Text = Helpers.GetPlacemarkByPointLatLng(new PointLatLng(alarm.latitude, alarm.longitude)).Address;
        }
        private void SetReadOnlyAlarmInfo()
        {
            textBoxName.ReadOnly = true;
            textBoxPhone.ReadOnly = true;
            textBoxAdress.ReadOnly = true;
            textBoxIdCard.ReadOnly = true;
        }
        private void ClearAlarmInfo()
        {
            textBoxName.Text = "";
            textBoxPhone.Text = "";
            textBoxAdress.Text = "";
            textBoxIdCard.Text = "";
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
    
        private void buttonDelete_Click(object sender, EventArgs e)
        {
            this.LoadMarkers();
            this.LoadCompanyButtons();
        }
     
        // Notification
        public async Task GetNotificationAsync()
        {

            var client = new SocketIO(Properties.Settings.Default.URL_API);

            client.On("alert", (response) =>
            {
                string msg = response.GetValue<string>();
                string AlarmId = response.GetValue<string>(1);
                if (!this.IsDisposed)
                {
                    this.Invoke(new Action(() =>
                    {
                        this.LoadMarkers();
                        this.LoadCompanyButtons();
                        this.ZoomOnAlarm(AlarmId);
                        AlarmEntity alarm = AlarmBusiness.GetById(AlarmId);
                        AddRoutesBetweenTwoPlacesToOverlay(Session.GetCurrentUpc().getPosition(), new PointLatLng(alarm.latitude, alarm.latitude));
                    }));
                }

            });

            await client.ConnectAsync();

        }
        private void ZoomOnAlarm(string id)
        {
            foreach (var marker in this.markers.Markers)
            {
                if (!(marker is AlarmMarker)) continue;
                if (((AlarmMarker)marker).btn.alarm.id.Equals(id))
                {
                    ZoomInMap(marker.Position);
                    AddRoutesBetweenTwoPlacesToOverlay(Session.GetCurrentUpc().getPosition(), marker.Position);
                }

            }
        }

        private void DisableAlarm()
        {
            if (this.marker == null) return;
            this.marker.state = "defused";
            AlarmBusiness.Save(this.marker);
            this.LoadMarkers();
            this.LoadCompanyButtons();
            this.buttonDisableAlarm.Enabled = false;
        }
        private void buttonDisableAlarm_Click(object sender, EventArgs e)
        {

            this.DisableAlarm();
        }

        private void buttonUPC_Click(object sender, EventArgs e)
        {
            OnClickUpcMarker();
            ClearAlarmInfo();
        }
    }

}
