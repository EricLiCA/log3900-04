using PolyPaint.DataAccessObject;
using System;
using System.Collections.Generic;
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
    /// Interaction logic for Gallery.xaml
    /// </summary>
    public partial class Gallery : Page
    {
        private List<Image> images;
        private ImageDao imageDao;

        public Gallery()
        {
            InitializeComponent();
            this.imageDao = new ImageDao();
            this.user.Text = "abcd";
        }

        public void Visualize()
        {

        }

        public void ChangeImageProtectionLevel(string protectionLevel)
        {

        }

        public void CommentImage()
        {

        }

        public void LikeImage()
        {

        }

        public void init()
        {
            this.Dispatcher.Invoke(() =>
            {
                this.imageDao.GetAll(user);
            });
        }
    }
}
