﻿using QLDKINTERNET.Public;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLDKINTERNET.GUI
{
    public class KieuCaiDatGui:KieuCaiDatPublic
    {
        int _index;

        public int Index
        {
            get { return _index; }
            set { _index = value; }
        }
        public KieuCaiDatGui()
            : base()
        {

        }

    }
}
