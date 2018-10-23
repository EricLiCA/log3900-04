import { SocketServer } from '../socket-server';
import { User } from '../connected-users-service.ts/user';
import { ConnectedUsersService } from '../connected-users-service.ts/connected-users-service';

export class ChatService {
    private static chatService: ChatService;
    private rooms: Map<string, Set<string>>;

    private constructor() {
        // Reserve key usernames
        this.rooms = new Map<string, Set<string>>();
    }

    public static get instance(): ChatService {
        if (ChatService.chatService === undefined) {
            ChatService.chatService = new ChatService();
        }
        return this.chatService;
    }

    public getRooms(): Map<string, Set<string>> {
        return this.rooms;
    }

    public newConnection(user: User): void {

        user.socket.on('joinRoom', (room: string) => {
            this.addToRoom(room, user);
        });

        user.socket.on('leaveRoom', (room: string) => {
            this.removeFromRoom(room, user);
            this.checkIfEmpty(room);
        });

        user.socket.on('addToRoom', (room: string, username: string) => {
            if (!ConnectedUsersService.isConnectedByName(username)) return;
            this.addToRoom(room, ConnectedUsersService.getByName(username));
        });

        user.socket.on('message', (room: string, message: string) => {
            console.log(`Received from ${user.socket.id} to ${room}: ${message}`);
            user.socket.emit('message', room, 'You', message);
            user.socket.broadcast.to(room).emit('message', room, user.name, message);
        });
    }

    public addToRoom(room: string, user: User) {
        if (!this.rooms.has(room)) {
            this.rooms.set(room, new Set<string>());
        }

        this.rooms.get(room).add(user.socket.id);
        user.socket.join(room);
        SocketServer.socketServerInstance.emit('joinRoomInfo', room, user.name);
        console.log(`${user.socket.id} has joined the room ${room}`);
    }

    public removeFromRoom(room: string, user: User) {
        if (!this.rooms.has(room)) return;

        this.rooms.get(room).delete(user.socket.id);
        user.socket.leave(room);
        SocketServer.socketServerInstance.emit('leaveRoomInfo', room, user.name);
        console.log(`${user.socket.id} has left the room ${room}`);
    }

    public checkIfEmpty(room: string) {
        if (!this.rooms.has(room)) return;

        if (this.rooms.get(room).size === 0)
            this.rooms.delete(room);
    }

    public closeConnection(user: User) {
        let roomsUserWasIn: string[] = [];

        this.rooms.forEach((users: Set<string>, room: string) => {
            if (users.has(user.socket.id)) {
                this.removeFromRoom(room, user);
            }
        });

        roomsUserWasIn.forEach(room => {
            this.checkIfEmpty(room);
        });
    }
}
