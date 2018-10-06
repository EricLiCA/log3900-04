import { Application } from './app';
import { SERVER_PORT } from './configs/http';
import { SocketServer } from './socket-server';

import * as http from 'http';
import { post } from 'superagent';
import { ChatService } from './chat-service/chat-service';
import { PostgresDatabase } from './postgres-database';

const application: Application = Application.bootstrap();

// Port configuration
const appPort = normalizePort(process.env.PORT || SERVER_PORT);
application.app.set('port', appPort);

// Create the HTTP server
const server = http.createServer(application.app);

// Send deployment status update to team Slack channel
startServices().then((map: Map<string, boolean>) => {
    let statusUpdate = `Server deployment was completed at ${new Date().toLocaleString('en-US')}`;

    map.forEach((value: boolean, key: string) => {
        statusUpdate += `\n${key} : ${value ? 'ok' : 'error'}`;
    });

    if (process.env.PROD) {
        post('https://hooks.slack.com/services/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')
        .send({text: statusUpdate})
        .end();
    }
});

/**
 * Normalize the port number from string to number
 *
 * @param val Port value
 * @returns Normalized port value or false if invalid
 */
function normalizePort(val: number | string): number | string | boolean {
    const port: number = (typeof val === 'string') ? parseInt(val, 10) : val;
    if (isNaN(port)) {
        return val;
    } else if (port >= 0) {
        return port;
    } else {
        return false;
    }
}

/**
 * Starts all the services
 *
 * @returns A map with all the service and their startup success value
 */
async function startServices(): Promise<Map<string, boolean>> {

    const results = new Map<string, boolean>();

    await PostgresDatabase.getInstance().then((onfullfiled) => {
        results.set('PostgreSQL', true);
    }, (onRejected) => {
        results.set('PostgreSQL', false);
    });

    SocketServer.setServer(server);
    ChatService.instance.startChatService();
    results.set('SocketServer', true);

    server.listen(appPort);
    server.on('error', onError);
    server.on('listening', onListening);
    results.set('Application', true);

    return results;
}

/**
 * Server detected an error
 *
 * @param error Error message caught by the server
 */
function onError(error: NodeJS.ErrnoException): void {
    if (error.syscall !== 'listen') { throw error; }
    const bind = (typeof appPort === 'string') ? 'Pipe ' + appPort : 'Port ' + appPort;
    switch (error.code) {
        case 'EACCES':
            console.error(`${bind} requires elevated privileges`);
            process.exit(1);
            break;
        case 'EADDRINUSE':
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
    const bind = (typeof addr === 'string') ? `pipe ${addr}` : `port ${addr.port}`;
    console.log(`Listening on ${bind}`);
}
