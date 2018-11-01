import { Component , OnInit } from '@angular/core';
import { ImageService } from '../services/gallery.service';

@Component({
  selector: 'gallery-component',
  templateUrl: './gallery.component.html',
  styleUrls: ['./gallery.component.scss']
})
export class GalleryComponent {

  private images: String[];
  private date: Date = new Date();

  constructor(
    private imageService: ImageService
  ) { }

  /** GET images from the server */
  ngOnInit()  {
    this.imageService.getImages().then(result => {
      this.images = result.map(elem => {
        return elem.fullImageUrl;
      });
    });
  }
}
