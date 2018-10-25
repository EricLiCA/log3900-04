import { Injectable } from "@angular/core";

@Injectable()
export class AuthenticationService {
    private _loggedIn = false;

    public get loggedIn(): boolean {
        return this._loggedIn;
    }

    public authenticate(username: string, password: string): Promise<boolean> | boolean {
        //Verify authentication
        this._loggedIn = true;
        return this._loggedIn;
    }
}