export class AuthenticationService {

    private static _instance: AuthenticationService;

    constructor() {
    }

    public static get instance(): AuthenticationService {
        if (!this._instance) {
            this._instance = new AuthenticationService();
        }

        return AuthenticationService._instance;
    }
}