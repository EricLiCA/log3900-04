import { SocketServer } from '../socket-server';
import { Connection } from './connection';

export class ChatRoom {

    private _id: string;
    private _participants: Set<Connection>;

    constructor(_id: string) {
        this._participants = new Set<Connection>();
        this._id = _id;
    }

    public get id(): string {
        return this._id;
    }

    public get participants(): Set<Connection> {
        return this._participants;
    }

    public add(connection: Connection): void {
        this._participants.add(connection);
        connection.socket.join(this.id);

        connection.socket.to(this.id).emit('message', `${connection.user.name} has joined the chat room`);
        connection.socket.emit('message', 'You have joined the Chat Room!');

        connection.socket.on('chat', (...args: any[]) => {
            console.log('chat', connection.user.name, args[0]);
            SocketServer.instance.to(this.id).emit('chat', connection.user.name, args[0]);
        });
        connection.socket.on('disconnect', () => {
            if (this.participants.has(connection)) {
                this.participants.delete(connection);
            }

            SocketServer.instance.to(this.id).emit('message', `${connection.user.name} has left the chat room`);
        });
    }
}
