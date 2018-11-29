import { Component , OnInit } from '@angular/core';
import { ImageService } from '../services/gallery.service';
import { Image } from './Image';
import { AuthenticationService } from 'src/admin/login.service';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { ImagePreviewComponent } from './image-preview/image-preview.component';
import { LikesAndCommentsService } from '../services/likes-and-comments.service';

@Component({
  selector: 'gallery-component',
  templateUrl: './gallery.component.html',
  styleUrls: ['./gallery.component.scss']
})
export class GalleryComponent {

  private date: Date = new Date();
  private imageData: Image[] = [];

  constructor(
    private imageService: ImageService,
    private loginService: AuthenticationService,
    private dialog: MatDialog,
    private likesAndCommentsService: LikesAndCommentsService
  ) { }

  /** GET images from the server */
  ngOnInit()  {
    this.imageService.getImages().then(result => {
      result.forEach((image: Image) => {
        if(image.protectionLevel === "public" || image.protectionLevel === "protected") {
          this.imageData.push(image);
        }
      });
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
