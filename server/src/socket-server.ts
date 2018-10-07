import * as http from 'http';
import * as io from 'socket.io';

export class SocketServer {

    public static setServer(server: http.Server): void {
        this.httpServer = server;
    }

    public static get instance(): SocketIO.Server {
        if (this.httpServer === undefined) {
            console.error('No http server provided!');
            return undefined;
        }
        if (this.socketServerInstance === undefined) {
            this.socketServerInstance = io.listen(this.httpServer);
        }
        return this.socketServerInstance;
    }
    private static socketServerInstance: SocketIO.Server;
    private static httpServer: http.Server;
}
