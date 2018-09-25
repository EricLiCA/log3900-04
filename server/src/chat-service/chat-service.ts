import { SocketServer } from "../socket-server";
// import { AuthenticationService } from "../user-service/authentication-service";
// import { ChatRoom } from "./chat-room";
// import { Connection } from "./connection";

export class ChatService {
    private static chatService: ChatService;
    private usernames: Map<string, string>;
    private connectedUsers: Set<string>;

    /* Keep it simple (not this release)
    private rooms: Map<string, ChatRoom>;
    */

    private constructor() {
        // this.rooms = new Map();
        // Reserve key usernames
        this.usernames = new Map();
        this.connectedUsers = new Set();
        this.connectedUsers.add("You");
        this.connectedUsers.add("you");
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
        SocketServer.instance.on("connection", (socket: SocketIO.Socket) => {
            /* scope creep
            const connection = new Connection(socket);
            */
            /* Not for this release: scope creep (Keep it simple; KISS principle)
            socket.on("login", (...args: any[]) => this.login(connection, args));
            */
            /* No rooms for this release neither, just main room required (Keep it simple)
            socket.on("joinRoom", (...args: any[]) => this.joinRoom(connection, args));
            */
            console.log(`New socket connection from ${socket.id}`);
            socket.on("setUsername", (username: string) => {
                console.log(`${socket.id} wants to set username as ${username}`);
                if (this.connectedUsers.has(username)) {
                    socket.emit("setUsernameStatus", "Username already taken!");
                } else {
                    this.connectedUsers.add(username);
                    this.usernames.set(socket.id, username);
                }
            });

            socket.on("disconnect", () => {
                console.log(`${socket.id} has disconnected`);
                if (this.usernames.has(socket.id)) {
                    // Username is now unused
                    this.connectedUsers.delete(this.usernames.get(socket.id));
                }
            });

            socket.on("message", (message: string) => {
                console.log(`Received: ${message}`);
                socket.emit("message", "You", message);
                if (this.usernames.has(socket.id)) {
                    socket.broadcast.emit("message", this.usernames.get(socket.id), message);
                }
            });
        });

    }

    /* scope creep
    private login(connection: Connection, args: any[]): void {
        if (args.length < 2) {
            connection.socket.emit("error", "Your request must contain the email and the password");
            return;
        }

        AuthenticationService.instance.validateCredentials(args[0], args[1]).then((valid) => {
            if (!valid) {
                connection.socket.emit("err", "User or Password is not valid");
                return;
            }

            connection.connect(args[0]);
            connection.socket.emit("logged-in", AuthenticationService.instance.generateJsonwebtoken(args[0]));
        }, (rejectReason) => {
            throw new Error(rejectReason);
        }).catch((error: Error) => {
            connection.socket.emit("err", error.message);
        });
    }

    private joinRoom(connection: Connection, args: any[]): void {
        if (args.length === 0) {
            connection.socket.emit("error", "Your request must contain at least two parameters to connect to a room");
            return;
        }

        let room = this.rooms.get(args[0]);
        if (!room) {
            room = new ChatRoom(args[0]);
            this.rooms.set(args[0], room);
        }

        connection.socket.removeAllListeners("joinRoom");
        room.add(connection);
    }*/
}
