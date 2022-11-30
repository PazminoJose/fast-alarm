using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Media;
using DesktopClient.Utils;
using LiveCharts;
using LiveCharts.Defaults;
using LiveCharts.Wpf;
using CefSharp.WinForms;
using CefSharp;
using Business;

namespace DesktopClient.Forms
{
    public partial class FormDashboard : Form
    {
        const string CANTONES = "cantones";
        const string PROVINCIAS = "provincias";
        private  ChromiumWebBrowser browser;
        public FormDashboard()
        {
            InitializeComponent();
            InitTheme();
            initBrowser();
            loadChartCantones();
            loadChartProvincias();
        }

        private void InitTheme()
        {
            this.label1.ForeColor = ThemeColor.text;
            this.label2.ForeColor = ThemeColor.text;
            this.label3.ForeColor = ThemeColor.text;
            this.BackColor = ThemeColor.background;
      

        }
        private void loadChartCantones()
        {
            var report = ReportBusiness.GetReport().report;
            SeriesCollection series = new SeriesCollection();
            Func<ChartPoint, string> labelPoint = chartPoint =>
               string.Format("{0} ({1:P})", chartPoint.Y, chartPoint.Participation);
            
            foreach (var canton in report[CANTONES].Keys)
            {
                cartesianChart1.Series.Add(new LineSeries
                {
                    Values = new ChartValues<double> { 2022, 2023, 2024, 2025, 2026 },
                    StrokeThickness = 4,
                    StrokeDashArray = new System.Windows.Media.DoubleCollection(50),
                    Stroke = new SolidColorBrush(System.Windows.Media.Color.FromRgb(107, 185, 79)),
                    LineSmoothness = 0,
                    PointGeometry = null
                });
                chartCantones.Series.Add(canton);
                chartCantones.Series[canton].Points.AddXY(canton, report[CANTONES][canton]);
                series.Add(new PieSeries
                {

                    Title = canton,
                    Values = new ChartValues<double> { report[CANTONES][canton] },
                    PushOut = 15,
                    DataLabels = true,
                    LabelPoint = labelPoint
                });
            }
            pieChartCantones.Series = series;
          
        }
        private void loadChartProvincias()
        {
            
            var report = ReportBusiness.GetReport().report;
            SeriesCollection series = new SeriesCollection();
            Func<ChartPoint, string> labelPoint = chartPoint =>
               string.Format("{0} ({1:P})", chartPoint.Y, chartPoint.Participation);
            foreach (var provincia in report[PROVINCIAS].Keys)
            {
                chartProvincias.Series.Add(provincia);
                chartProvincias.Series[provincia].Points.AddXY(provincia, report[PROVINCIAS][provincia]);

                series.Add(new PieSeries
                {
                    Title = provincia,
                    Values = new ChartValues<double> { report[PROVINCIAS][provincia] },
                    PushOut = 15,
                    DataLabels = true,
                    LabelPoint = labelPoint
                });
            }
            pieChartProvincias.Series = series;
        }
        public void initBrowser()
        {
            chromiumWebBrowser1.LoadUrl("http://137.184.195.186:3000");
            
        }

        //public void form()
        //{
        //    var r = new Random();
        //    cartesianChart1.Series.Add(new HeatSeries
        //    {

        //        Values = new ChartValues<HeatPoint>
        //        {


        //    //X means sales man
        //    //Y is the day
        //    //"Jeremy Swanson"
        //            new HeatPoint(0, 0, r.Next(0, 10)),
        //            new HeatPoint(0, 1, r.Next(0, 10)),
        //            new HeatPoint(0, 2, r.Next(0, 10)),
        //            new HeatPoint(0, 3, r.Next(0, 10)),
        //            new HeatPoint(0, 4, r.Next(0, 10)),
        //            new HeatPoint(0, 5, r.Next(0, 10)),
        //            new HeatPoint(0, 6, r.Next(0, 10)),
        //            //"Lorena Hoffman"
        //            new HeatPoint(1, 0, r.Next(0, 10)),
        //            new HeatPoint(1, 1, r.Next(0, 10)),
        //            new HeatPoint(1, 2, r.Next(0, 10)),
        //            new HeatPoint(1, 3, r.Next(0, 10)),
        //            new HeatPoint(1, 4, r.Next(0, 10)),
        //            new HeatPoint(1, 5, r.Next(0, 10)),
        //            new HeatPoint(1, 6, r.Next(0, 10)),
        //            //"Robyn Williamson"
        //            new HeatPoint(2, 0, r.Next(0, 10)),
        //            new HeatPoint(2, 1, r.Next(0, 10)),
        //            new HeatPoint(2, 2, r.Next(0, 10)),
        //            new HeatPoint(2, 3, r.Next(0, 10)),
        //            new HeatPoint(2, 4, r.Next(0, 10)),
        //            new HeatPoint(2, 5, r.Next(0, 10)),
        //            new HeatPoint(2, 6, r.Next(0, 10)),
        //            //"Carole Haynes"
        //            new HeatPoint(3, 0, r.Next(0, 10)),
        //            new HeatPoint(3, 1, r.Next(0, 10)),
        //            new HeatPoint(3, 2, r.Next(0, 10)),
        //            new HeatPoint(3, 3, r.Next(0, 10)),
        //            new HeatPoint(3, 4, r.Next(0, 10)),
        //            new HeatPoint(3, 5, r.Next(0, 10)),
        //            new HeatPoint(3, 6, r.Next(0, 10)),
        //            //"Essie Nelson"
        //            new HeatPoint(4, 0, r.Next(0, 10)),
        //            new HeatPoint(4, 1, r.Next(0, 10)),
        //            new HeatPoint(4, 2, r.Next(0, 10)),
        //            new HeatPoint(4, 3, r.Next(0, 10)),
        //            new HeatPoint(4, 4, r.Next(0, 10)),
        //            new HeatPoint(4, 5, r.Next(0, 10)),
        //            new HeatPoint(4, 6, r.Next(0, 10))
        //        },
        //        DataLabels = true,

        //        //The GradientStopCollection is optional
        //        //If you do not set this property, LiveCharts will set a gradient
        //        GradientStopCollection = new GradientStopCollection
        //        {
        //            new GradientStop(System.Windows.Media.Color.FromRgb(0, 0, 0), 0),
        //            new GradientStop(System.Windows.Media.Color.FromRgb(0, 255, 0), .25),
        //            new GradientStop(System.Windows.Media.Color.FromRgb(0, 0, 255), .5),
        //            new GradientStop(System.Windows.Media.Color.FromRgb(255, 0, 0), .75),
        //            new GradientStop(System.Windows.Media.Color.FromRgb(255, 255, 255), 1)
        //        }

        //    });
        //    cartesianChart1.AxisX.Add(new Axis
        //    {
        //        LabelsRotation = -15,
        //        Labels = new[]
        //        {
        //            "Jeremy Swanson",
        //            "Lorena Hoffman",
        //            "Robyn Williamson",
        //            "Carole Haynes",
        //            "Essie Nelson"
        //        },
        //        Separator = new Separator { Step = 1 }
        //    });

        //    cartesianChart1.AxisY.Add(new Axis
        //    {
        //        Labels = new[]
        //        {
        //            "Monday",
        //            "Tuesday",
        //            "Wednesday",
        //            "Thursday",
        //            "Friday",
        //            "Saturday",
        //            "Sunday"
        //        }
        //    });
        //}


    }
}