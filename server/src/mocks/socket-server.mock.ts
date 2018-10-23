import * as express from 'express';
import * as http from 'http';

import { AddressInfo } from 'net';
import { SocketServer } from '../socket-server';

export const TEST_HOST = 'http://localhost';
export let TEST_PORT: number;

const app = express();
export const server = http.createServer(app);
server.listen(0, () => {
    const address = server.address() as AddressInfo;
    TEST_PORT = address.port;
    console.log('Testing on port ' + TEST_PORT);
});
SocketServer.setServer(server);
export const socketServer = SocketServer.socketServerInstance;
