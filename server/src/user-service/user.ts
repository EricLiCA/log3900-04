export class User {

    private _id: number;
    private _name: string;
    private _email: string;

    public get id(): number {
        return this._id;
    }

    public get name(): string {
        return this._name;
    }

    public get email(): string {
        return this._email;
    }

    constructor(authenticated: boolean, email?: string) {
        if (authenticated) {
            if (!email) {
                throw new Error('Missing email adress for an authenticated account');
            }

            this._id = /* FETCH FROM DATABASE */ Math.ceil(Math.random() * 10000);
            this._email = email;
            this._name = /* FETCH FROM DATABASE */ email;

        } else {
            this._name = `Anonymous #${Math.ceil(Math.random() * 10000)}`;
        }
    }

    public connect(email: string): void {
        if (!email) {
            throw new Error('Missing email adress for an authenticated account');
        }

        this._id = /* FETCH FROM DATABASE */ Math.ceil(Math.random() * 10000);
        this._email = email;
        this._name = /* FETCH FROM DATABASE */ email;
    }
}
