using PolyPaint.VueModeles;
using PolyPaint.Vues;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace PolyPaint.Services
{
    class MessagingViewManager
    {
        private static MessagingViewManager _instance;
        public static MessagingViewManager instance
        {
            get
            {
                if (MessagingViewManager._instance == null)
                {
                    MessagingViewManager._instance = new MessagingViewManager();
                }
                return MessagingViewManager._instance;
            }
        }

        public Page LargeMessagingView { get; set; }

        public MessagingViewManager()
        {
            MessagingViewModel viewModel = new MessagingViewModel();
            this.LargeMessagingView = new MessagingWindow(viewModel);
        }
    }
}
