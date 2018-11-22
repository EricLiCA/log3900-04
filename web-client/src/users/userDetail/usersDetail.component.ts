import { Component } from '@angular/core';
import { UserService } from '../../services/user.service';
import { ActivatedRoute } from '@angular/router';
import { Image } from 'src/gallery/Image';
import { User } from '../User';
import { AuthenticationService } from 'src/admin/login.service';
import { ImageWithLikes } from 'src/gallery/ImageWithLikes';
import { MatDialog } from '@angular/material';
import { LikesAndCommentsService } from '../../services/likes-and-comments.service';
import { ImagePreviewComponent } from '../../gallery/image-preview/image-preview.component';

@Component({
  selector: 'usersDetail-component',
  templateUrl: './usersDetail.component.html',
  styleUrls: ['./usersDetail.component.scss']
})

export class UsersDetailComponent {
  
  private date: Date = new Date();
  private userImages: Image[] = [];
  private userImagesWithLikes: ImageWithLikes[] = [];
  private currentUser: User;
  private admin = this.loginService.admin;
  private imagePermissions = this.loginService.image;

  constructor(
    private route: ActivatedRoute,
    private userService: UserService,
    private loginService: AuthenticationService,
    private dialog: MatDialog,
    private likesAndCommentsService: LikesAndCommentsService
  ) { }

  /** GET images from the server */
  ngOnInit() {
    const id = this.route.snapshot.paramMap.get('id');
    this.userService.getUserById(id).then((user: User) => {
      this.currentUser = user;
    });
    this.initImages(id);
  }

  initImages(id: string): void {
    
    this.userService.getUserImages(id).then((images: Image[]) => {
        images.forEach(image => {
          if(image.protectionLevel === "public" || image.protectionLevel === "protected"){
            this.userImages.push(image);
          }
          if(this.loginService.user && image.ownerId === this.loginService.user.id && image.protectionLevel === "private" || this.admin || this.imagePermissions) {
            this.userImages.push(image);
          }
        });
    }).then(result => {
      this.userService.getUserImagesLikes(this.userImages).then(images => {
        this.userImagesWithLikes = images;
      });
    })
  }

  removeImage(clickedImage: ImageWithLikes): void {
    this.userImagesWithLikes = this.userImagesWithLikes.map(image => {
      if (image !== clickedImage) {
        return image;
      }
      else {
        this.userService.deleteUserImage(clickedImage.id);
      }
    });
  }

  openDialog(image: Image): void {
    this.likesAndCommentsService.imageId = image.id;
    this.likesAndCommentsService.previewImage();
    this.dialog.open(ImagePreviewComponent , {
      data: image,
      width: "75%",
      height: "75%"
    });
  }

}
