using MaterialDesignThemes.Wpf;
using PolyPaint.VueModeles;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for MessagingWindow.xaml
    /// </summary>
    public partial class MessagingWindow : Page
    {
        private Regex regex = new Regex("^ {0,}$");

        public MessagingWindow(MessagingViewModel viewModel)
        {
            DataContext = viewModel;
            InitializeComponent();
        }

        private void SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ((MessagingViewModel)this.DataContext).OpenChat(Listfirst.SelectedIndex);
        }

        private void Filter_TextChanged(object sender, TextChangedEventArgs e)
        {
            ((MessagingViewModel)this.DataContext).FilterChanged(((TextBox)sender).Text);
        }

        private void NewRoom_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            if (regex.IsMatch(newRoomName.Text)) return;

            ((MessagingViewModel)this.DataContext).NewRoom.Execute(newRoomName.Text);
            DialogHost.CloseDialogCommand.Execute(sender, (IInputElement)sender);
            newRoomName.Text = "";
        }
    }
}
