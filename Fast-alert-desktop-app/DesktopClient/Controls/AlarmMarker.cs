using DesktopClient.Controls;
using GMap.NET;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient
{
    internal class AlarmMarker : GMarkerGoogle
    {
        public AlarmButton btn { get; set; }
        public AlarmMarker(AlarmButton btn, PointLatLng point , GMarkerGoogleType type) : base(point,type)
        {
            this.btn = btn;
            this.ToolTipMode = MarkerTooltipMode.Always;
            this.ToolTipText = (this.btn!=null) ? this.btn.address : "";
        }
    }
}
