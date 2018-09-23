export class ChatRoom {
    
    private participants: SocketIO.Socket[];

    constructor(private _id: String) {
        this.participants = [];
    }

    public get id(): String {
        return this._id;
    };

    public add(socket: SocketIO.Socket): void {
        this.participants.forEach((participant: SocketIO.Socket) => {
            participant.emit('message', `${socket.handshake.address} has joined the chat room`);
        });

        this.participants.push(socket);
        socket.emit('message', 'You have joined the Chat Room!');

        socket.on('chat', (args: any[]) => this.onChat(socket, String(args[0])));
        socket.on('disconnect', () => this.onDisconnect(socket));
    }

    private onChat(socket: SocketIO.Socket, message: String) {
        this.participants.forEach((participant: SocketIO.Socket) => {
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