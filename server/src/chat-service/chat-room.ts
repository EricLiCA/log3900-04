import { Connection } from "./connection";
import { SocketServer } from "../socket-server";

export class ChatRoom {
    
    private _participants: Connection[];

    constructor(private _id: string) {
        this._participants = [];
    }

    public get id(): string {
        return this._id;
    };

    public get participants(): Connection[] {
        return this._participants;
    };

    public add(connection: Connection): void {
        this._participants.push(connection);
        connection.socket.join(this.id);

        connection.socket.to(this.id).emit('message', `${connection.user.name} has joined the chat room`)
        connection.socket.emit('message', 'You have joined the Chat Room!');

        connection.socket.on('chat', (...args: any[]) => {connection.socket.to(this.id).emit('chat', connection.user.name, args[0]);
        console.log('chat', connection.user.name, args[0]);});
        connection.socket.on('disconnect', () => {
            delete this.participants.splice(this.participants.indexOf(connection), 1)[0];
            SocketServer.instance.to(this.id).emit('message', `${connection.user.name} has left the chat room`);
        });
    }
}