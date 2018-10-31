import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { User } from '../users/User';
import { Image } from 'src/gallery/Image';

@Injectable({ providedIn: 'root' })
export class UserService {         

    constructor(
        private http: HttpClient,
        ) { }

    getUsers (): Promise<User[]> {
        const apiUrl = 'http://localhost:3000/v2/users';  
        return this.http.get(apiUrl).toPromise().then((data: Array<User>) => {
            const users = data;
            return users;
        });
    }
    
    getUserImages(id: Number): Promise<String[]> {
        const apiUrl = 'http://localhost:3000/v2/imagesByOwnerId/' + id;  
        return this.http.get(apiUrl).toPromise().then((data: Array<Image>) => {
            const images = data.map((singleFullImage) => {
                return singleFullImage.fullImageUrl;
            });
            return images;
        });
    }
}