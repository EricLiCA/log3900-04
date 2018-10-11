using PolyPaint.Modeles;
using PolyPaint.Services;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MessagingWindow.xaml
    /// </summary>
    public partial class MessagingWindow : Page
    {
        private ObservableCollection<ChatRoom> ChatRooms;

        public MessagingWindow()
        {
            InitializeComponent();
            this.ChatRooms = new ObservableCollection<ChatRoom>();
            Listsecond.ItemsSource = this.ChatRooms;
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
        }

        private void Listsecond_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ServerService.instance.server == null)
            {
                ChatDock.Content = "Not Connected to Database";
                return;
            }
            ChatDock.Content = new Chat();
            Console.WriteLine(this.ChatRooms[Listsecond.SelectedIndex].Name);
        }
    }
}
