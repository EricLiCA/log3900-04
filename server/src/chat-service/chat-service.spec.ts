import { expect } from 'chai';
import * as io from 'socket.io-client';

import { ChatService } from './chat-service';
import { TEST_HOST, TEST_PORT, server } from '../mocks/socket-server.mock';

describe('ChatService', () => {
    let socket: SocketIOClient.Socket;

    before(() => {
        server.listen(TEST_PORT, () => {
            console.log(`Testing on port ${TEST_PORT}`);
        });
    });

    beforeEach((done) => {
        socket = io.connect(`${TEST_HOST}:${TEST_PORT}`);
        socket.on('connect', () => {
            done();
        });
    });

    after(() => {
        server.close();
    });
    
    afterEach(() => {
        if (socket.connected) {
            socket.disconnect();
        }
    });

    describe('getInstance()', () => {
        it('should return a singleton', () => {
            expect(ChatService.getInstance())
                .to.equal(ChatService.getInstance());
        });
    });

});
