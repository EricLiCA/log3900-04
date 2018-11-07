import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Credentials } from "./credentials";
import { User } from "src/users/User";

@Injectable()
export class AuthenticationService {
    private _loggedIn = false;
    private user: Credentials;
    private password: String;

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
        this.password = Password;
        const body = {username: Username, password: Password};
        const apiUrl = 'http://localhost:3000/v2/sessions';
        return this.http.post(apiUrl, body).toPromise().then((data: Credentials) => {
            if(data.id) {
                this._loggedIn = true;
                this.user = data;
                return data;
            }
            else {
                return null;
            }
          });
    }

    public changeUsername(newUsername: String, Password: String): boolean {
        const body = {username: newUsername, token: this.user.token};
        const apiUrl = 'http://localhost:3000/v2/users/' + this.user.id;
        if(Password === this.password){
            this.http.put(apiUrl, body).toPromise().then(result => {
                return true;
            });
        }
        else {
            return false;
        }
    }

    public changPassword(Password: String, newPassword: String): boolean {
        const body = {password: newPassword, token: this.user.token};
        const apiUrl = 'http://localhost:3000/v2/users/' + this.user.id;
        if(Password === this.password){
            this.http.put(apiUrl, body).toPromise().then(result => {
                return true;
            });
        }
        else {
            return false;
        }
    }
}