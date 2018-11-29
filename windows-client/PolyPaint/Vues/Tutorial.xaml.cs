using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;

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
                                    @"../../Resources/15imageGallery.png",
                                    @"../../Resources/16_pictureDetail.png"};

        private String[] DESCRIPTIONS = { "1)   This is how you connect to the app",
                                          "2)   Once connected, you can disconnect (1), manage account (2) and change account picture (3).",
                                          "3)   Here you can navigate between tabs. Gallery (1) redirects to gallery, \n" +
                                                "Users (2) redirects to users, Chat (3) redirects to chat and Search (4) is used to search. \n" +
                                                "You can also filter the search.",
                                          "4)   Click here to add an image",
                                          "5)   To create an image, simply enter a name, an optional password, \n" +
                                                " and determine if the image is public or private",
                                          "6)   The top left part of the edition screen is used for file management",
                                          "7)   The top middle part of the edition sceen is used to copy and paste",
                                          "8)   Finally, the part on the left of the menu is used for drawing utilities (shapes, colors, etc)",
                                          "9)   The color menu allows many different color presets",
                                          "10)  The other tab allows the user to personalise the colors",
                                          "11)  The chat tab in the main menu allows the user to communicate with other users",
                                          "12)  The friends tab allows the user to see his friends (1) aswell as connected users (2)",
                                          "13)  Still in the friends tab, on the far right, you can add friends",
                                          "14)  Here is an example of the modal used when add friend is clicked",
                                          "15)  Finally, here is an example of the image gallery. Your images (1) are diplayed on top. \n" +
                                                "Public images (2) are on the bottom \n" +
                                                "As you can see, images can be public (3) or private (4). \n " +
                                                "Simply click on the image to enter image detail.",
                                          "16)  Here you can see picture details. You can edit, manage info, change privacy and like the image. \n" +
                                                "The comment section is below the image."};
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
                textBlock.Padding = new Thickness(5, 5, 5, 5);
                textBlock.FontFamily = new FontFamily("Century Gothic");
                textBlock.FontSize = 20;
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
