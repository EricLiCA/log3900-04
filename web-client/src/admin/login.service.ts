import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Credentials } from "./credentials";
import { User } from "src/users/User";

@Injectable()
export class AuthenticationService {
    private _loggedIn = false;

    constructor(
        private http: HttpClient,
        ) { }

    public get loggedIn(): boolean {
        return this._loggedIn;
    }

    public open() {
        
    }

    public authenticate(Username: String, Password: String): Promise<Credentials> {
        //Verify authentication
        const body = {username: Username, password: Password};
        const apiUrl = 'http://localhost:3000/v2/sessions';
        return this.http.post(apiUrl, body).toPromise().then((data: Credentials) => {
            if(data.id) {
                this._loggedIn = true;
                return data;
            }
            else {
                return null;
            }
          });
    }
}