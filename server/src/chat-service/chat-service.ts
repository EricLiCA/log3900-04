import { SocketServer } from "../socket-server";

export class ChatService {

    public static getInstance(): ChatService {
        if (this.chatService === undefined) {
            this.chatService = new ChatService();
        }
        return this.chatService;
    }
    private static chatService: ChatService;
    private io: SocketIO.Server;

    private constructor() {
        this.io = SocketServer.getInstance();
    }

    public startChatService(): void {
        this.listenForConnections();
    }

    private listenForConnections(): void {
        this.io.on("connection", (socket: SocketIO.Socket) => {
            socket.emit("chat", "You are now connected to the chat service!");
        });
    }
}
