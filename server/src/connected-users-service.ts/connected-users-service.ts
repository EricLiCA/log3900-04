import { Socket } from 'socket.io';
import { User } from './user';

export class ConnectedUsersService {

    private static get instance(): ConnectedUsersService {
        if (this.connectedUsersService === undefined) {
            this.connectedUsersService = new ConnectedUsersService();
        }
        return this.connectedUsersService;
    }

    public static get connectedUsers(): User[] {
        return ConnectedUsersService.instance.users;
    }

    public static connect(user: User): void {
        ConnectedUsersService.instance.users.push(user);
    }

    public static getBySocket(id: string): User {
        return ConnectedUsersService.instance.users[ConnectedUsersService.findIndexBySocket(id)];
    }

    public static getByName(name: string): User {
        return ConnectedUsersService.instance.users[ConnectedUsersService.findIndexByName(name)];
    }

    public static isConnectedByName(name: string): boolean {
        return ConnectedUsersService.findIndexByName(name) !== -1;
    }

    public static disconnect(socket: Socket): void {
        ConnectedUsersService.connectedUsers.splice(this.findIndexBySocket(socket.id), 1);
    }

    public static getAll(): User[] {
        return ConnectedUsersService.instance.users;
    }

    private static connectedUsersService: ConnectedUsersService;

    private static findIndexByName(name: string): number {
        return ConnectedUsersService.instance.users.findIndex((user) => user.name === name);
    }

    private static findIndexBySocket(id: string): number {
        return ConnectedUsersService.instance.users.findIndex((user) => user.socket.id === id);
    }

    private users: User[];

    constructor() {
        this.users = [];
    }

}
