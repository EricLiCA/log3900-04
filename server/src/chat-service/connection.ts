import { User } from "../user-service/user";

export class Connection {
    private _user: User;

    constructor(private _socket: SocketIO.Socket) {
        this._user = new User(false);
    }

    public get user(): User {
        return this._user;
    }

    public get socket(): SocketIO.Socket {
        return this._socket;
    }

    public connect(email: string) {
        this._user.connect(email);
    }
}
