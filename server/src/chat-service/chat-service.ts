import { SocketServer } from '../socket-server';
import { ChatRoom } from './chat-room';

export class ChatService {
    private static chatService: ChatService;
    private io: SocketIO.Server;

    private rooms: Map<String, ChatRoom>

    private constructor() {
        this.io = SocketServer.getInstance();
        this.rooms = new Map();
    }

    public static getInstance(): ChatService {
        if (this.chatService === undefined) {
            this.chatService = new ChatService();
        }
        return this.chatService;
    }

    public startChatService(): void {
        this.listenForConnections();
    }

    private listenForConnections(): void {
        this.io.on('connection', (socket: SocketIO.Socket) => {
            socket.on('joinRoom', args => this.joinRoom(socket, args));
            console.log(`New socket connection from ${socket.handshake.address}`);
        });
        
    }

    private joinRoom(socket: SocketIO.Socket, args: any[]): void {
        if (args.length === 0) {
            socket.emit('error', 'Your request must contain at least two parameters to connect to a room');
            return;
        }

        let room = this.rooms.get(args[0]);
        if (!room) {
            room = new ChatRoom(args[0]);
            this.rooms.set(args[0], room);
        }
        
        socket.removeAllListeners('joinRoom');
        room.add(socket);
    }
}
