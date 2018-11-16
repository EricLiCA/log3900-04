import { User } from "./user";
import { Socket } from "socket.io";

export class ConnectedUsersService {
    
    private static connectedUsersService: ConnectedUsersService;

    private users: User[];

    constructor() {
        this.users = [];
    }

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

    private static findIndexByName(name: string): number {
        return ConnectedUsersService.instance.users.findIndex(user => user.name === name);
    }

    private static findIndexBySocket(id: string): number {
        return ConnectedUsersService.instance.users.findIndex(user => user.socket.id === id);
    }

    public static getBySocket(id: string): User {
        const index = ConnectedUsersService.findIndexBySocket(id);
        return index >= 0 ? ConnectedUsersService.instance.users[index] : undefined;
    }

    public static getByName(name: string): User {
        const index = ConnectedUsersService.findIndexByName(name);
        return index >= 0 ? ConnectedUsersService.instance.users[index] : undefined;
    }

    public static isConnectedByName(name: string): boolean {
        return ConnectedUsersService.findIndexByName(name) !== -1;
    }

    public static disconnect(socket: Socket): void {
        const index = ConnectedUsersService.findIndexBySocket(socket.id);
        if (index >= 0)
            ConnectedUsersService.connectedUsers.splice(index, 1);
    }

    public static getAll(): User[] {
        return ConnectedUsersService.instance.users;
    }

    public static deleteUser(name: string): void {
        let toDelete = ConnectedUsersService.getByName(name);
        toDelete.socket.disconnect();
        ConnectedUsersService.disconnect(toDelete.socket);
    }


}