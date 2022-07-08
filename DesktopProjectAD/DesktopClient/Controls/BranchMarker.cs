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
    internal class BranchMarker : GMarkerGoogle
    {
        public int id { get; set; }
        public BranchMarker(int id, PointLatLng point , GMarkerGoogleType type) : base(point,type)
        {
            this.id = id;
        }
    }
}
