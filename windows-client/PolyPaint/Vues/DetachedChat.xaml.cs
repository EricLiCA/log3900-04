using PolyPaint.Services;
using PolyPaint.Utilitaires;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for DetachedChat.xaml
    /// </summary>
    public partial class DetachedChat : Window
    {
        public DetachedChat()
        {
            this.DataContext = this;
            InitializeComponent();

            Closing += new CancelEventHandler(((MainWindow)Application.Current.MainWindow).showAttachedChat);
        }

        public MessagingWindowOutside MessagingOutside {
            get => MessagingViewManager.instance.DetachedMessagingView;
        }

    }
}
