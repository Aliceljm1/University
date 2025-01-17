﻿using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FontAndColorDialogs
{
    class Program
    {
        static void Main(string[] args)
        {
            FontAndColorDialogs a = new FontAndColorDialogs();
            Application.Run(a);
        }
    }
    class FontAndColorDialogs : Form
    {
        public FontAndColorDialogs()
        {
            Text = "Font and Color Dialogs";
            ResizeRedraw = true;
            Menu = new MainMenu();
            Menu.MenuItems.Add("&Format");
            Menu.MenuItems[0].MenuItems.Add("&Font...",
            new EventHandler(MenuFontOnClick));
            Menu.MenuItems[0].MenuItems.Add("&Background Color...",
            new EventHandler(MenuColorOnClick));
        }
        void MenuFontOnClick(object obj, EventArgs ea)
        {
            FontDialog fontdlg = new FontDialog();
            fontdlg.Font = Font;
            fontdlg.Color = ForeColor;
            fontdlg.ShowColor = true;
            if (fontdlg.ShowDialog() == DialogResult.OK)
            {
                Font = fontdlg.Font;
                ForeColor = fontdlg.Color;
                Invalidate();
            }
        }
        void MenuColorOnClick(object obj, EventArgs ea)
        {
            ColorDialog clrdlg = new ColorDialog();
            clrdlg.Color = BackColor;
            if (clrdlg.ShowDialog() == DialogResult.OK)
                BackColor = clrdlg.Color;
        }
        protected override void OnPaint(PaintEventArgs pea)
        {
            Graphics grfx = pea.Graphics;
            StringFormat strfmt = new StringFormat();
            strfmt.Alignment = strfmt.LineAlignment =
            StringAlignment.Center;
            grfx.DrawString("Hello common dialog boxes!", Font,
            new SolidBrush(ForeColor),
            this.ClientRectangle, strfmt);
        }
    }
}
