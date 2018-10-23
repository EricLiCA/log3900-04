import { expect } from 'chai';
import * as io from 'socket.io-client';

import { socketServer, TEST_HOST, TEST_PORT } from '../mocks/socket-server.mock';
import { ChatLobbyService } from './lobby.service';

describe('ChatLobbyService', () => {
    let socket: SocketIOClient.Socket;
    let lobbyService: ChatLobbyService;

    before((done) => {
        lobbyService = new ChatLobbyService(socketServer);
        lobbyService.listenForLobbyRequests();
        socket = io.connect(`${TEST_HOST}:${TEST_PORT}`);
        socket.on('connect', () => {
            done();
        });
    });

    it('should have no users at the start', () => {
        expect(lobbyService.getUsers().size).to.equal(0);
    });

    it('should listen to join chat requests', (done) => {
        setTimeout(() => {
            expect(lobbyService.getUsers().size).to.be.greaterThan(0);
            done();
        }, 10);
        socket.emit('join chat', 'testUser');
    });
});
