﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Fill
{
    public partial class FillPolygon : Form
    {
        public FillPolygon()
        {
            InitializeComponent();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            SolidBrush redBrush = new SolidBrush(Color.Red);
            Point pt1 = new Point(50, 50);
            Point pt2 = new Point(60, 80);
            Point pt3 = new Point(90, 50);
            Point pt4 = new Point(250, 50);
            Point pt5 = new Point(300, 100);
            Point pt6 = new Point(350, 200);
            Point[] ptsArray = { pt1, pt2, pt3, pt4, pt5, pt6 };
            g.FillPolygon(redBrush, ptsArray);
        }
    }
}
