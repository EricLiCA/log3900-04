import { compare, hash, genSalt } from 'bcrypt-nodejs';
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

    public hashPassword(password: string) : Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            genSalt(10, (error: Error, salt: string) => {
                if (error) {
                    reject(error);
                    return;
                }

                hash(password, salt, (err: Error, hash: string) => {
                    if (err) {
                        reject(err);
                        return;
                    }

                    resolve(hash);
                });
            });
        });
    }

    public validateCredentials(email: string, password: string) : Promise<boolean> {
        const hash = /* MUST FETCH FROM THE DATABASE */ "";
        
        return new Promise<boolean> ((resolve, reject) => {
            compare(password, hash, (error: Error, result: boolean) => {
                if (error) {
                    reject(error);
                    return;
                }

                resolve(result);
            });
        });
    }
}