export class ChatRoom {
    
    private _participants: SocketIO.Socket[];

    constructor(private _id: String) {
        this._participants = [];
    }

    public get id(): String {
        return this._id;
    };

    public get participants(): SocketIO.Socket[] {
        return this._participants;
    };

    public add(socket: SocketIO.Socket): void {
        this._participants.forEach((participant: SocketIO.Socket) => {
            participant.emit('message', `${socket.handshake.address} has joined the chat room`);
        });

        this._participants.push(socket);
        socket.emit('message', 'You have joined the Chat Room!');

        socket.on('chat', (args: any[]) => this.onChat(socket, String(args[0])));
        socket.on('disconnect', () => this.onDisconnect(socket));
    }

    private onChat(socket: SocketIO.Socket, message: String) {
        this._participants.forEach((participant: SocketIO.Socket) => {
            if (participant !== socket) {
                participant.emit('chat', message);
            }
        });
    }

    private onDisconnect(socket: SocketIO.Socket) {
        delete this.participants.splice(this.participants.indexOf(socket), 1)[0];
        
        this.participants.forEach((participant: SocketIO.Socket) => {
            participant.emit('message', `${socket.handshake.address} has left the chat room`)
        });
    }
}