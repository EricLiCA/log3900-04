import { Application } from './app';
import { SERVER_PORT, SLACK_API } from './configs/http';
import { SocketServer } from './socket-server';

import * as http from 'http';
import * as _ from 'lodash';
import { post } from 'superagent';
import { PostgresDatabase } from './postgres-database';
import { RedisService } from './redis.service';

import { ChatLobbyService } from './chat-service/lobby.service';

const application: Application = Application.bootstrap();

// Port configuration
const appPort = normalizePort(process.env.PORT || SERVER_PORT);
application.app.set('port', appPort);

// Create the HTTP server
const server = http.createServer(application.app);

// Create the chat application
let chatLobbyService: ChatLobbyService;

// Send deployment status update to team Slack channel
startServices().then((map: Map<string, boolean>) => {
    let statusUpdate = `Server deployment was completed at ${new Date().toLocaleString('en-US')}`;

    map.forEach((value: boolean, key: string) => {
        statusUpdate += `\n${key} : ${value ? 'ok' : 'error'}`;
    });

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: statusUpdate })
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
    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Starting Deployment Services' })
            .end();
    }

    const results = new Map<string, boolean>();

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Connecting to PostgreSQL' })
            .end();
    }

    await PostgresDatabase.getInstance().then((onfullfiled) => {
        results.set('PostgreSQL', true);
        if (process.env.PROD) {
            post(SLACK_API)
                .send({ text: 'Connected to PostgreSQL' })
                .end();
        }
    }, (onRejected) => {
        results.set('PostgreSQL', false);
        if (process.env.PROD) {
            post(SLACK_API)
                .send({ text: 'Error connecting to PostgreSQL' })
                .end();
        }
    });

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Starting Socket Server' })
            .end();
    }
    SocketServer.setServer(server);
    chatLobbyService = new ChatLobbyService(SocketServer.socketServerInstance);
    chatLobbyService.listenForLobbyRequests();
    results.set('SocketServer', true);
    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Socket Server started' })
            .end();
    }

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Starting server application' })
            .end();
    }
    server.listen(appPort);
    server.on('error', onError);
    server.on('listening', onListening);
    results.set('Application', true);
    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Application started' })
            .end();
    }

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Connecting to Redis' })
            .end();
    }
    // Clear Redis
    const redisClient = RedisService.getInstance();
    redisClient.on('error', (err) => {
        results.set('Redis', false);
        console.log('Redis connection could not be established');
        if (process.env.PROD) {
            post(SLACK_API)
                .send({ text: 'Could not connect to Redis\n' + err })
                .end();
        }
    });
    redisClient.on('connect', (err) => {
        results.set('Redis', true);
        console.log('Redis successfully connected');
        if (process.env.PROD) {
            post(SLACK_API)
                .send({ text: 'Redis connected' })
                .end();
        }
    });
    redisClient.flushall();

    if (process.env.PROD) {
        post(SLACK_API)
            .send({ text: 'Querying for Sessions' })
            .end();
    }
    const db = await PostgresDatabase.getInstance();
    await db.query('SELECT * FROM Sessions').then((queryResult) => {
        if (queryResult.rowCount > 0) {
            const tokens = _.flatMap(queryResult.rows, (session): string[] => {
                return [session.userid, session.token];
            });
            redisClient.hmset('authTokens', tokens);
        }
    })
        .catch((err) => {
            console.log(err);
            if (process.env.PROD) {
                post(SLACK_API)
                    .send({ text: 'Error querying sessions' })
                    .end();
            }
        });

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
