import { expect } from 'chai';
// import * as io from 'socket.io-client';

import { server } from '../mocks/socket-server.mock';
import { ChatService } from './chat-service';

describe('ChatService', () => {
    // let socket: SocketIOClient.Socket;

    before(() => {
        server;
    });

    describe('getInstance()', () => {
        it('should return a singleton', () => {
            expect(ChatService.instance)
                .to.equal(ChatService.instance);
        });
    });

    describe('chat scenario', () => {
        it('should connect users', () => {
            // The usernames should be unique

            // Anonymous users are allowed

        });

        it('should let users create a room that does not already exist', () => {
            // the creation should be unique: you can join that room however

            // client will be notified of existing room
        });

        it('should automatically add the user who created the room to it', () => {

        });

        it('should not let users create a room that already exists', () => {

        });

        it('should let another user join an already created room', () => {

        });

        it('should let users send messages to each other in a chat room', () => {

        });

        it('should let users invite another user to a room', () => {

        });

        it('should let a user invite multiple users to a room on creation', () => {

        });

        it('should let users know who is currently online', () => {

        });

        it('should let users quit a chat room', () => {

        });

        it('should let users join the chat room after', () => {

        });

        it('should tell other clients the moment a client disconnects', () => {

        });
    });

});
