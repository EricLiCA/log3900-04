using PolyPaint.Modeles;
using PolyPaint.Services;
using PolyPaint.VueModeles;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Chat.xaml
    /// </summary>
    public partial class Chat : Page
    {
        private Regex regex = new Regex("^ {0,}$");

        public string ThreadName { get; }

        public Chat(ChatViewModel viewModel)
        {
            DataContext = viewModel;
            InitializeComponent();
        }

        private void TextInput_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Enter && !e.IsRepeat)
            {
                ((ChatViewModel)DataContext).SendMessage.Execute(MessageToSend.Text);
                MessageToSend.Text = "";
            }
        }

        private void SendButton_Click(object sender, RoutedEventArgs e)
        {
            ((ChatViewModel)DataContext).SendMessage.Execute(MessageToSend.Text);
            MessageToSend.Text = "";
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            ((ChatViewModel)DataContext).AddPerson.Execute(((Button)sender).Tag);
        }
    }
}
