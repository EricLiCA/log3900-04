import * as http from 'http';
import * as io from 'socket.io';
import { ChatService } from './chat-service/chat-service';
import { ConnectedUsersService } from './connected-users-service.ts/connected-users-service';
import { User } from './connected-users-service.ts/user';
import { CollaborativeService } from './collaborative-edition/collaborative-service';

export class SocketServer {
    private static socketServer: SocketIO.Server;
    private static httpServer: http.Server;

    public static setServer(server: http.Server): void {
        this.httpServer = server;
        SocketServer.socketServer = io.listen(SocketServer.httpServer);
        SocketServer.listenForConnections();
    }

    public static get socketServerInstance(): SocketIO.Server {
        return SocketServer.socketServer;
    }

    private static listenForConnections(): void {
        SocketServer.socketServer.on('connection', (socket: SocketIO.Socket) => {
            console.log(`New socket connection with id ${socket.id}`);
            socket.on('setUsername', (username: string) => {
                console.log(`${socket.id} wants to set username as ${username}`);
                if (ConnectedUsersService.isConnectedByName(username)) {
                    socket.emit('setUsernameStatus', 'Username already taken!');
                    socket.disconnect();
                } else {
                    socket.emit('setUsernameStatus', 'OK');
                    let user = new User(true, socket, username);
                    ConnectedUsersService.connect(user);
                    ChatService.instance.newConnection(user);
                    CollaborativeService.instance.newConnection(user);

                    socket.on('disconnect', () => {
                        CollaborativeService.instance.closeConnection(user);
                        ChatService.instance.closeConnection(user);
                        ConnectedUsersService.disconnect(socket);
                    });
                }
            });

            socket.on('disconnect', () => {
                console.log(`${socket.id} has disconnected`);
            });
        });
    }

}
