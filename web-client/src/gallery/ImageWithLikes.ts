import {Image as img} from './Image';

export class ImageWithLikes extends img {
    id: String;
    ownerId: String;
    title: String;
    protectionLevel: String;
    password: String;
    thumbnailUrl: String;
    fullImageUrl: String;
    imageLikes: Number;
    authorName: String;
    date: Date;

    constructor(image: img, likes: number) {
        super()
        this.id = image.id;
        this.ownerId = image.ownerId;
        this.title = image.title;
        this.protectionLevel = image.protectionLevel;
        this.password = image.password;
        this.thumbnailUrl = image.thumbnailUrl;
        this.fullImageUrl = image.fullImageUrl;
        this.imageLikes = likes;
        this.date = image.date;
        this.authorName = image.authorName;
    }
  }