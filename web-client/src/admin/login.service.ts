import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Credentials } from "./credentials";
import { User } from "src/users/User";

@Injectable()
export class AuthenticationService {
    private _loggedIn = false;
    public admin = false;
    public image = false;
    public permission = false;
    public management = false;
    public user: Credentials;
    private password: String;
    private userName: String;

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
        this.userName = Username;
        var body = {username: Username, password: Password};
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/sessions';
        return this.http.post(apiUrl, body).toPromise().then((data: Credentials) => {
            if(data.id) {
                this._loggedIn = true;
                this.user = data;
                if(data.userLevel === "admin"){
                    this.admin = true;
                }
                else if(data.userLevel === "image"){
                    this.image = true;
                }
                else if(data.userLevel === "permissions") {
                    this.permission = true;
                }
                else if (data.userLevel === "management") {
                    this.management = true;
                }
                this.user.userName = this.userName;
                return data;
            }
            else {
                return null;
            }
          });
    }

    public changeUsername(newUsername: String, Password: String): boolean {
        const body = {username: newUsername, token: this.user.token};
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users/' + this.user.id;
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
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users/' + this.user.id;
        if(Password === this.password){
            this.http.put(apiUrl, body).toPromise().then(result => {
                return true;
            });
        }
        else {
            return false;
        }
    }

    public createUser(name: String, pass: String): void {
        const body = {username: name, password: pass};
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users';
        this.http.post(apiUrl, body).toPromise();
    }

    public deleteUser(userToDelete: String): void {
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users/' + userToDelete;
        this.http.delete(apiUrl).toPromise();
    }

    public changeUserPermissions(user: User): void {
        console.log(user);
        const apiUrl = 'http://ec2-34-200-247-233.compute-1.amazonaws.com/v2/users/' + user.id;
        this.http.put(apiUrl, user).toPromise();
    }
}