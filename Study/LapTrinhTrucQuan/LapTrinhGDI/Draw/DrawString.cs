﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Draw
{
    public partial class DrawString : Form
    {
        public DrawString()
        {
            InitializeComponent();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            Graphics g = this.CreateGraphics();
            string testString = "Test String";
            Font verdana14 = new Font("Verdana", 14);
            SizeF sz = g.MeasureString(testString, verdana14);
            string stringDetails = "Height: " + sz.Height.ToString()
                                    + ", Width: " + sz.Width.ToString();
            MessageBox.Show("String details: " + stringDetails);
            g.DrawString(testString, verdana14, Brushes.Green, new PointF(50, 50));
            g.DrawRectangle(new Pen(Color.Blue, 3), 50, 50, sz.Width, sz.Height);
            g.Dispose();
        }
    }
}
