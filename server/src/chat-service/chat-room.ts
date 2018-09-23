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

    public add(socket: SocketIO.Socket): void {
        let connection = new Connection(socket);
        this._participants.push(connection);
        socket.join(this.id);

        socket.to(this.id).emit('message', `${connection.user.name} has joined the chat room`)
        socket.emit('message', 'You have joined the Chat Room!');

        socket.on('chat', (args: any[]) => socket.to(this.id).emit('chat', args[0]));
        socket.on('disconnect', () => this.onDisconnect(socket));
    }

    private onDisconnect(socket: SocketIO.Socket) {
        delete this.participants.splice(this.participants.findIndex(participant => participant.socket === socket), 1)[0];
        SocketServer.instance.to(this.id).emit('message', `${socket.handshake.address} has left the chat room`)
    }
}