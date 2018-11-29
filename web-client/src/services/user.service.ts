import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { User } from '../users/User';
import { Image } from 'src/gallery/Image';
import { Likes } from './Likes';
import { ImageWithLikes } from 'src/gallery/ImageWithLikes';

@Injectable({ providedIn: 'root' })
export class UserService {         

    constructor(
        private http: HttpClient,
        ) { }

    getUsers (): Promise<User[]> {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users';  
        return this.http.get(apiUrl).toPromise().then((data: Array<User>) => {
            const users = data;
            return users;
        });
    }
    
    getUserById (id: String): Promise<User> {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users/' + id;
        return this.http.get(apiUrl).toPromise().then((data: User) => {
            return data;
        })
    }
 
    getUserImages(id: String): Promise<Image[]> {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/imagesByOwnerId/' + id;  
        return this.http.get(apiUrl).toPromise().then((data: Array<Image>) => {
            return data;
        });
    }

    deleteUserImage(id: String): void {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/images/' + id;
        this.http.delete(apiUrl).toPromise().then(result => {
            console.log(result);
        })
    }

    getUserImagesLikes(images: Image[]): Promise<ImageWithLikes[]> {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/imageLikes/';
        let imageIds: string[] = [];
        let imagesWithLikes: ImageWithLikes[] = [];
        images.forEach(image => {
            imageIds.push(image.id.toString());
            imagesWithLikes.push(new ImageWithLikes(image, 0));
        });
        return this.http.get(apiUrl).toPromise().then((likes: Likes[])=> {
            imagesWithLikes.forEach(image => {
                likes.forEach(like => {
                    if(image.id === like.ImageId){
                        image.imageLikes = image.imageLikes.valueOf() + 1;
                    }
                });
            });
            return imagesWithLikes;
        });
    }

}