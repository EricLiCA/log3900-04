using PolyPaint.Modeles;
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
            RoomsList.ItemsSource = this.ChatRooms;
            Listsecond.ItemsSource = this.ChatRooms;
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
            this.ChatRooms.Add(new ChatRoom("Fun Times"));
            this.ChatRooms.Add(new ChatRoom("Happy Meal"));
        }
    }
}
