import { SocketServer } from '../socket-server';

export class ChatService {
    private static chatService: ChatService;
    private usernames: Map<string, string>;
    private connectedUsers: Set<string>;

    private constructor() {
        // Reserve key usernames
        this.usernames = new Map();
        this.connectedUsers = new Set();
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
                    // Username is now unused
                    this.connectedUsers.delete(this.usernames.get(socket.id));
                }
            });

            socket.on('message', (message: string) => {
                console.log(`Received: ${message}`);
                socket.emit('message', 'You', message);
                if (this.usernames.has(socket.id)) {
                    socket.broadcast.emit('message', this.usernames.get(socket.id), message);
                } else {
                    socket.emit('setUsernameStatus', 'No username set!');
                }
            });
        });
    }
}
