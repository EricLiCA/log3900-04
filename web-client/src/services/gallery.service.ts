import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Image } from '../gallery/Image';

@Injectable({ providedIn: 'root' })
export class ImageService {

  private apiUrl = 'http://localhost:3000/v2/images';

  constructor(
    private http: HttpClient,
    ) { }

  /** GET heroes from the server */
  getImages (): Promise<String[]> {
    return this.http.get(this.apiUrl).toPromise().then((data: Array<Image>) => {
      const imageUrls = data.map((singleFullImage) => {
        return singleFullImage.fullImageUrl;
      })
      return imageUrls;
    });
  }
}