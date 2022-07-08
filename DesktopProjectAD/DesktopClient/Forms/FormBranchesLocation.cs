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
using DesktopClient.Classes;

namespace DesktopClient.Forms
{
    public partial class FormBranchesLocation : Form
    {
        GMapOverlay markers = null;
        public FormBranchesLocation()
        {
            InitializeComponent();
            LoadMap();
            GenerateBranchButtons();
        }
        private void LoadMap()
        {
            gMapControl.MapProvider = GMapProviders.GoogleMap;
            gMapControl.DragButton = MouseButtons.Left;
            gMapControl.ShowCenter = false;
            double latitude = -0.1074016582484328;
            double longitude = -78.47017988776682;
            gMapControl.Position = new PointLatLng(latitude, longitude);
            gMapControl.MaxZoom = 18;
            gMapControl.MinZoom = 7;
            gMapControl.Zoom = 7;



            PointLatLng point = new PointLatLng(latitude, longitude);

            GMapMarker marker = new BranchMarker(1, point, GMarkerGoogleType.green_dot);
            marker.ToolTipText = "Sucursal 1";
            marker.ToolTipMode = MarkerTooltipMode.Always;
            double lat = marker.Position.Lat;
            double lng = marker.Position.Lng;
            // 1. Create overlay
            markers = new GMapOverlay("markers");
            // Add all availabe markers to that overlay
            markers.Markers.Add(marker);
            // 3. Cover map with overlay
            gMapControl.Overlays.Add(markers);

        }

        private void gMapControl_OnMapZoomChanged()
        {
            Console.WriteLine(gMapControl.Zoom);
            Console.Read();
        }
        private void GenerateBranchButtons()
        {
            int posX, posY;
            int width, height;
            width = (panelButtons.Width / 2);
            height = (panelButtons.Height / 6);
            posX = 0;
            posY = 0;

            for (int i = 1; i <= 5; i++)
            {

                BranchButton btn = new BranchButton(1);
                btn.ForeColor = Color.White;

                // Set button color
                btn.BackColor = Color.FromArgb(50, 205, 50);
                // Set btton size
                btn.Size = new Size(width, height);
                // Set button text
                btn.Text = "Sucursal " + i.ToString();
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
            int index = 0;
            foreach (var marker in markers.Markers.Select((value, i) => (value, i)))
            {
                if (((BranchMarker)marker.value).id == ((BranchButton)sender).id) index = marker.i;
            }

            BranchMarker bm = (BranchMarker)markers.Markers[index];
            if (bm.id == 1)
            {
                gMapControl.Zoom = 13;
                gMapControl.Position = new PointLatLng(bm.Position.Lat, bm.Position.Lng);
            }
        }
        private void gMapControl_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            PointLatLng point = item.Position;
            int name = ((BranchMarker)item).id;
            Console.WriteLine("");

        }
    }
}
