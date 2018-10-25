export class ChatLobbyService {
    private io: SocketIO.Server;
    private channels: Map<string, Set<string>>;
    private users: Map<string, string>;

    public constructor(socketServer: SocketIO.Server) {
        this.io = socketServer;
        this.channels = new Map<string, Set<string>>();
        this.users = new Map<string, string>();
    }

    public getUsers() {
        return this.users;
    }

    public getChannels() {
        return this.channels;
    }

    public listenForLobbyRequests(): void {
        this.listenForConnections();
        this.listenForGetChannels();
    }

    private listenForConnections(): void {
        this.io.on('connection', (socket) => {
            socket.on('join chat', (username: string) => {
                // allows multiple sockets to join under same username (user on multiple devices)
                this.users.set(socket.id, username);
                socket.join(`user:${username}`); // create private chat channel for each username
            });

            socket.on('disconnect', () => {
                this.users.delete(socket.id);
                // Notify all other clients
                socket.broadcast.emit('sent all channels', this.channels);
            });
        });
    }

    private listenForGetChannels(): void {
        this.io.on('connection', (socket) => {
            socket.on('get channels', () => {
                socket.emit('sent all channels', this.channels.keys);
            });
        });
    }
}
