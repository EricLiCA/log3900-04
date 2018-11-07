import { Component , OnInit } from '@angular/core';
import { ImageService } from '../services/gallery.service';
import { Image } from './Image';

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
  ) { }

  /** GET images from the server */
  ngOnInit()  {
    this.imageService.getImages().then(result => {
      result.forEach((image: Image) => {
        if(image.protectionLevel === "public") {
          this.imageData.push(image);
        }
      });
    });
  }
}
