import { Component , OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ImageService } from '../services/gallery.service'

@Component({
  selector: 'gallery-component',
  templateUrl: './gallery.component.html',
  styleUrls: ['./gallery.component.scss']
})
export class GalleryComponent {

  private images: String[];

  constructor(
    private http: HttpClient,
    private imageService: ImageService
  ) { }

  /** GET images from the server */
  ngOnInit()  {
    this.imageService.getImages().then(result => {
      this.images = result;
    });
  }
}
