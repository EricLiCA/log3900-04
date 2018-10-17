import { SocketServer } from '../socket-server';

export class ChatService {
    private static chatService: ChatService;
    private usernames: Map<string, string>;
    private connectedUsers: Set<string>;
    private rooms: Map<string, Set<string>>;

    private constructor() {
        // Reserve key usernames
        this.usernames = new Map<string, string>();
        this.connectedUsers = new Set<string>();
        this.rooms = new Map<string, Set<string>>();
        this.connectedUsers.add('You');
        this.connectedUsers.add('you');
    }

    public static get instance(): ChatService {
        if (this.chatService === undefined) {
            this.chatService = new ChatService();
        }
        return this.chatService;
    }

    public startChatService(): void {
        this.listenForConnections();
    }

    public getRooms(): Map<string, Set<string>> {
        return this.rooms;
    }

    private listenForConnections(): void {
        SocketServer.instance.on('connection', (socket: SocketIO.Socket) => {
            console.log(`New socket connection with id ${socket.id}`);
            socket.on('setUsername', (username: string) => {
                console.log(`${socket.id} wants to set username as ${username}`);
                if (this.connectedUsers.has(username)) {
                    socket.emit('setUsernameStatus', 'Username already taken!');
                    socket.disconnect();
                } else {
                    socket.emit('setUsernameStatus', 'OK');
                    this.connectedUsers.add(username);
                    this.usernames.set(socket.id, username);
                }
            });

            socket.on('disconnect', () => {
                console.log(`${socket.id} has disconnected`);
                if (this.usernames.has(socket.id)) {
                    for (let room in socket.rooms) {
                        console.log(`${socket.id} has left the room ${room}`);
                        socket.leave(room);
                        socket.broadcast.to(room).emit('chatInfo', room, `${this.usernames.get(socket.id)} has left the room`);
                    }
                    this.connectedUsers.delete(this.usernames.get(socket.id));
                }
            });

            socket.on('joinRoom', (room: string) => {
                if (!this.rooms.has(room)) {
                    this.rooms.set(room, new Set<string>());
                }
                this.rooms.get(room).add(socket.id);
                socket.join(room);
                SocketServer.instance.emit('joinRoomInfo', room, this.usernames.get(socket.id));
                console.log(`${socket.id} has joined the room ${room}`);
            });

            socket.on('leaveRoom', (room: string) => {
                if (!this.rooms.has(room)) {
                    return;
                }
                let users = this.rooms.get(room);
                users.delete(socket.id);
                if (users.size == 0) {
                    this.rooms.delete(room);
                }
                socket.leave(room);
                socket.broadcast.to(room).emit('leaveRoomInfo', room, this.usernames.get(socket.id));
                console.log(`${socket.id} has left the room ${room}`);
            });

            socket.on('message', (room: string, message: string) => {
                console.log(`Received: ${message}`);
                socket.emit('message', room, 'You', message);
                if (this.usernames.has(socket.id)) {
                    socket.broadcast.to(room).emit('message', room, this.usernames.get(socket.id), message);
                } else {
                    socket.emit('setUsernameStatus', 'No username set!');
                }
            });
        });
    }
}
