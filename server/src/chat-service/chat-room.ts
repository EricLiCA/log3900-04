import { Connection } from "./connection";

export class ChatRoom {
    
    private _participants: Connection[];

    constructor(private _id: String) {
        this._participants = [];
    }

    public get id(): String {
        return this._id;
    };

    public get participants(): Connection[] {
        return this._participants;
    };

    public add(socket: SocketIO.Socket): void {
        this._participants.forEach((participant: Connection) => {
            participant.socket.emit('message', `${socket.handshake.address} has joined the chat room`);
        });

        this._participants.push(new Connection(socket));
        socket.emit('message', 'You have joined the Chat Room!');

        socket.on('chat', (args: any[]) => this.onChat(socket, String(args[0])));
        socket.on('disconnect', () => this.onDisconnect(socket));
    }

    private onChat(socket: SocketIO.Socket, message: String) {
        this._participants.forEach((participant: Connection) => {
            if (participant.socket !== socket) {
                participant.socket.emit('chat', message);
            }
        });
    }

    private onDisconnect(socket: SocketIO.Socket) {
        delete this.participants.splice(this.participants.findIndex(participant => participant.socket === socket), 1)[0];
        
        this.participants.forEach((participant: Connection) => {
            participant.socket.emit('message', `${socket.handshake.address} has left the chat room`)
        });
    }
}