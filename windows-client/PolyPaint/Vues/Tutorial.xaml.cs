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
using System.Windows.Threading;

namespace PolyPaint.Vues
{
    /// <summary>
    /// Interaction logic for Tutorial.xaml
    /// </summary>
    public partial class Tutorial : Page
    {
        private String[] IMAGES = { @"../../Resources/1_Connect.png",
                                    @"../../Resources/2_account.png",
                                    @"../../Resources/3_mainFunctionalities.png",
                                    @"../../Resources/4_addImage.png",
                                    @"../../Resources/5_imageCreation.png",
                                    @"../../Resources/6_file management.png",
                                    @"../../Resources/7_copyPaste.png",
                                    @"../../Resources/8_drawingUtilities.png",
                                    @"../../Resources/9_color1.png",
                                    @"../../Resources/10_color2.png",
                                    @"../../Resources/11_chat.png",
                                    @"../../Resources/12_friendPage.png",
                                    @"../../Resources/13_friendRequest.png",
                                    @"../../Resources/14_friendRequestModal.png",
                                    @"../../Resources/15imageGallery.png"};

        private String[] DESCRIPTIONS = { "This is how you connect to the app",
                                          "Enter your credentials here and click connect, or hit create account to create one",
                                          "Here you can navigate between tabs. 1 is the gallery, 2 is for users, 3 is for chat. 4 is used to search. You can also filter the search.",
                                          "Click here to add an image",
                                          "To create an image, simply enter a name, an optional password, and determine if the image is public or private",
                                          "The top left part of the edition screen is used for file management",
                                          "The top middle part of the edition sceen is used to copy and paste",
                                          "Finally, the part on the left of the menu is used for drawing utilities (shapes, colors, etc)",
                                          "The color menu allows many different color presets",
                                          "The other tab allows the user to personalise the colors",
                                          "The chat tab in the main menu allows the user to communicate with other users",
                                          "The friends tab allows the user to see his friends (1) aswell as connected users (2)",
                                          "Still in the friends tab, on the far right, you can add friends",
                                          "Here is an example of the modal used when add friend is clicked",
                                          "Finally, here is an example of the image gallery. As you can see, images can be public or private. Simply click on the image to start editing!"};
        private static double IMAGE_WIDTH = 512;  

        private List<Image> _images = new List<Image>();

        public Tutorial()
        {
            InitializeComponent();
            addImages();

        }

        // add images to the stage 
        private void addImages()
        {
            for (int i = 0; i < IMAGES.Length; i++)
            {

                TextBlock textBlock = new TextBlock();
                textBlock.Text = DESCRIPTIONS[i];
                textBlock.TextAlignment = TextAlignment.Center;

                LayoutRoot.Children.Add(textBlock);

                string url = IMAGES[i];

                Image image = new Image();
                BitmapImage src = new BitmapImage();
                src.BeginInit();
                src.UriSource = new Uri(url, UriKind.Relative);
                src.CacheOption = BitmapCacheOption.OnLoad;
                src.EndInit();
                image.Source = src;
                image.Width = IMAGE_WIDTH;

                LayoutRoot.Children.Add(image);
                
            }
        }
    }
}
