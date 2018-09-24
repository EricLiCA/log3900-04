import { Application } from "./app";
import { SERVER_PORT } from "./configs/http";
import { SocketServer } from "./socket-server";

import * as http from 'http';
import { ChatService } from './chat-service/chat-service';

const application: Application = Application.bootstrap();

// Port configuration
const appPort = normalizePort(process.env.PORT || SERVER_PORT);
application.app.set("port", appPort);

// Create the HTTP server
const server = http.createServer(application.app);

/**
 *  Listen to inbound connections on configured port
 */
server.listen(appPort);
server.on("error", onError);
server.on("listening", onListening);

SocketServer.setServer(server);
ChatService.instance.startChatService();

/**
 * Normalize the port number from string to number
 *
 * @param val Port value
 * @returns Normalized port value or false if invalid
 */
function normalizePort(val: number | string): number | string | boolean {
    const port: number = (typeof val === "string") ? parseInt(val, 10) : val;
    if (isNaN(port)) {
        return val;
    } else if (port >= 0) {
        return port;
    } else {
        return false;
    }
}

/**
 * Server detected an error
 *
 * @param error Error message caught by the server
 */
function onError(error: NodeJS.ErrnoException): void {
    if (error.syscall !== "listen") { throw error; }
    const bind = (typeof appPort === "string") ? "Pipe " + appPort : "Port " + appPort;
    switch (error.code) {
        case "EACCES":
            console.error(`${bind} requires elevated privileges`);
            process.exit(1);
            break;
        case "EADDRINUSE":
            console.error(`${bind} is already in use`);
            process.exit(1);
            break;
        default:
            throw error;
    }
}

/**
 * Logs to STDOUT that the server is listening
 */
function onListening(): void {
    const addr = server.address();
    const bind = (typeof addr === "string") ? `pipe ${addr}` : `port ${addr.port}`;
    console.log(`Listening on ${bind}`);
}
