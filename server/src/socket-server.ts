import * as io from 'socket.io';
import * as http from 'http';

export class SocketServer {
    private static socketServerInstance: SocketIO.Server;
    private static httpServer: http.Server;

    public static setServer(server: http.Server): void {
        this.httpServer = server;
    }

    public static getInstance(): SocketIO.Server {
        if (this.httpServer === undefined) {
            console.error('No http server provided!');
            return undefined;
        }
        if (this.socketServerInstance === undefined) {
            this.socketServerInstance = io.listen(this.httpServer);
        }
        return this.socketServerInstance;
    }
}
