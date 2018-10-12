using MaterialDesignThemes.Wpf;
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
        private ObservableCollection<ChatRoom> NotSubscribedChatRooms { get; set; }
        private ObservableCollection<ChatRoom> SubscribedChatRooms { get; set; }
        
        public MessagingWindow()
        {
            InitializeComponent();
            this.NotSubscribedChatRooms = new ObservableCollection<ChatRoom>();
            this.SubscribedChatRooms = new ObservableCollection<ChatRoom>();
            Listfirst.ItemsSource = this.SubscribedChatRooms;
            Listsecond.ItemsSource = this.NotSubscribedChatRooms;
            this.NotSubscribedChatRooms.Add(new ChatRoom("Fun Times"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Happy Meal"));
            this.NotSubscribedChatRooms.Add(new ChatRoom("Feelin' Good"));
        }

        private void Listfirst_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ChatDock.Content = new Chat();
            Console.WriteLine(this.SubscribedChatRooms[Listfirst.SelectedIndex].Name);
        }
        

        internal void Initialize(Badged countingBadge)
        {
            if (countingBadge.Badge == null || Equals(countingBadge.Badge, ""))
                countingBadge.Badge = 1;
            else
                countingBadge.Badge = int.Parse(countingBadge.Badge.ToString()) + 1;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            string toJoin = ((Button)sender).Tag.ToString();

            ChatRoom room = this.NotSubscribedChatRooms.First<ChatRoom>(ChatRoom => ChatRoom.Name == toJoin);
            this.NotSubscribedChatRooms.Remove(room);
            this.SubscribedChatRooms.Add(room);
        }
    }
}
