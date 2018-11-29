import * as express from 'express';
import * as http from 'http';

import { SocketServer } from '../socket-server';

export const TEST_HOST = 'http://localhost';
export let TEST_PORT: number = 3002;

const app = express();
export const server = http.createServer(app);
SocketServer.setServer(server);
export const socketServer = SocketServer.socketServerInstance;
