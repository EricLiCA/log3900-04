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
    /// Interaction logic for Chat.xaml
    /// </summary>
    public partial class Chat : Page
    {
        private ObservableCollection<ChatMessage> Messages;

        public Chat()
        {
            InitializeComponent();
            Messages = new ObservableCollection<ChatMessage>();
            Messages.Add(new ChatMessage() {
                Sender = "Jean",
                Timestamp = new DateTime(2018, 9, 22, 14, 30, 45),
                Message = "Bienvenue dans le canal!"
            });
            Messages.Add(new ChatMessage() {
                Sender = "Luc",
                Timestamp = new DateTime(2018, 9, 22, 14, 30, 58),
                Message = "Merci Beaucoup! J'ai hâte de travailler avec vous dans le cadre de ce projet!"
            });

            ChatWindow.ItemsSource = Messages;
        }
    }
}
