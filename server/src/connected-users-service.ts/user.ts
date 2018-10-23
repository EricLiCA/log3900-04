import { Socket } from 'socket.io';

export class User {
    public anonymous: boolean;
    public socket: Socket;
    public name: string;

    constructor(anonymous: boolean, socket: Socket, name: string) {
        this.anonymous = anonymous;
        this.socket = socket;
        this.name = name;
    }
}
