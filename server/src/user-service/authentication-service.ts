import { compare, genSalt, hash } from "bcrypt-nodejs";
import { JsonWebTokenError, NotBeforeError, sign, TokenExpiredError, verify } from "jsonwebtoken";
import { Utils } from "../utils/Utils";

export const secretLength = 32;

export class AuthenticationService {

    private static _instance: AuthenticationService;
    private secret: string;

    private constructor() {
        this.secret = Utils.generateRandomSecret(secretLength);
    }

    public static get instance(): AuthenticationService {
        if (!this._instance) {
            this._instance = new AuthenticationService();
        }

        return AuthenticationService._instance;
    }

    public hashPassword(password: string): Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            genSalt(10, (error: Error, salt: string) => {
                if (error) {
                    reject(error);
                    return;
                }

                hash(password, salt, null, (err: Error, hashedPassword: string) => {
                    if (err) {
                        reject(err);
                        return;
                    }

                    resolve(hashedPassword);
                });
            });
        });
    }

    public validateCredentials(email: string, password: string): Promise<boolean> {
        /* MUST FETCH FROM THE DATABASE */
        const hashedPassword = "$2a$10$Pveiz7gSBa0HrTdkRRWcw.AuLy7985VIF2Lgmo1TjFes7lZt2TT1W";

        return new Promise<boolean> ((resolve, reject) => {
            compare(password, hashedPassword, (error: Error, result: boolean) => {
                if (error) {
                    reject(error);
                    return;
                }

                resolve(result);
            });
        });
    }

    public generateJsonwebtoken(email: string): Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            sign( { email }, this.secret, { expiresIn: "6h" }, (error: Error, encoded: string) => {
                if (error) {
                    reject(error.message);
                    return;
                }

                resolve(encoded);
            });
        });
    }

    public validateJsonwebtoken(token: string): Promise<string> {
        return new Promise<string> ((resolve, reject) => {
            verify(token, this.secret,
                (error: JsonWebTokenError | NotBeforeError | TokenExpiredError, decoded: {email: string}) => {
                if (error) {
                    reject(error.message);
                    return;
                }

                resolve(decoded.email);
            });
        });
    }
}
