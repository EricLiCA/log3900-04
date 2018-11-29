import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Image } from '../gallery/Image';

@Injectable({ providedIn: 'root' })
export class ImageService {

  private apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/images';

  constructor(
    private http: HttpClient,
    ) { }

  /** GET heroes from the server */
  getImages (): Promise<Image[]> {
    return this.http.get(this.apiUrl).toPromise().then((data: Array<Image>) => {
      const imageUrls = data.map((singleFullImage) => {
        return singleFullImage;
      })
      return imageUrls;
    });
  }
}