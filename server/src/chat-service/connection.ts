import { User } from "../user-service/user";

export class Connection {
    private _user: User;
    private _socket: SocketIO.Socket;

    constructor(socket: SocketIO.Socket) {
        this._user = new User(false);
        this._socket = socket;
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
