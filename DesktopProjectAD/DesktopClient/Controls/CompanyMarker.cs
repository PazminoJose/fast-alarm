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
    internal class CompanyMarker : GMarkerGoogle
    {
        public CompanyButton btn { get; set; }
        public CompanyMarker(CompanyButton btn, PointLatLng point , GMarkerGoogleType type) : base(point,type)
        {
            this.btn = btn;
            this.ToolTipMode = MarkerTooltipMode.Always;
            this.ToolTipText = (this.btn!=null) ? this.btn.company.name : "";
            
        }
    }
}
