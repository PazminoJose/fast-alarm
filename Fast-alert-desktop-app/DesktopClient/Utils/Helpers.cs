using DesktopClient.Forms;
using GMap.NET;
using GMap.NET.MapProviders;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DesktopClient.Utils
{
    public static class Helpers
    {
        public static DataTable ToDataTable<T>(List<T> items)
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
                    values[i] = (Props[i].GetValue(item, null)==null)?"N/A" : Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }

        public static void Alert(string msg, FormAlert.enmType type, bool isTimeNotification)
        {
            FormAlert fm = new FormAlert(msg, type, isTimeNotification);
            fm.ShowAlert();
        }
        public static Placemark GetPlacemarkByPointLatLng(PointLatLng point)
        {
            List<Placemark> placemarks = null;
            var statusCode = GMapProviders.GoogleMap.GetPlacemarks(point, out placemarks);
            if (statusCode != GeoCoderStatusCode.OK && placemarks == null) return new Placemark();
            return placemarks.First();
        }
    }
}
