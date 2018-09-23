import { compare, hash, genSalt } from 'bcrypt-nodejs';
import { sign, verify, JsonWebTokenError, NotBeforeError, TokenExpiredError } from 'jsonwebtoken';

export class AuthenticationService {

    private static _instance: AuthenticationService;
    private secret: string;

    constructor() {
        this.secret = this.generateRandomSecret(32);
    }

    public static get instance(): AuthenticationService {
        if (!this._instance) {
            this._instance = new AuthenticationService();
        }

        return AuthenticationService._instance;
    }

    private generateRandomSecret(length: number): string {
        let secret = '';
        for (let i = 0; i < length; i++) {
            secret += String.fromCharCode(48 + Math.floor(Math.random() * 77));
        }
        return secret;
    }

    public hashPassword(password: string) : Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            genSalt(10, (error: Error, salt: string) => {
                if (error) {
                    reject(error);
                    return;
                }

                hash(password, salt, null, (err: Error, hash: string) => {
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
        const hash = /* MUST FETCH FROM THE DATABASE */ '$2a$10$Pveiz7gSBa0HrTdkRRWcw.AuLy7985VIF2Lgmo1TjFes7lZt2TT1W';
        
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

    public generateJsonwebtoken(email: string): string {
        return sign( { email }, this.secret, { expiresIn: '6h' } );
    }

    public validateJsonwebtoken(token: string) : Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            verify(token, this.secret, (error: JsonWebTokenError | NotBeforeError | TokenExpiredError, decoded: object | string) => {
                if (error) {
                    reject(error);
                    return;
                }

                resolve(decoded['user']);
            });
        });
    }
}