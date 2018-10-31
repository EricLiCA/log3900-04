import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { User } from '../users/User';

@Injectable({ providedIn: 'root' })
export class UserService {

    private apiUrl = 'http://localhost:3000/v2/users';            

    constructor(
        private http: HttpClient,
        ) { }

  /** GET heroes from the server */
  getUsers (): Promise<User[]> {
    return this.http.get(this.apiUrl).toPromise().then((data: Array<User>) => {
      const users = data;
      return users;
    });
  }
}