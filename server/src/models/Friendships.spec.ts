import { Friendships, FriendshipStatus } from './Friendships';
import { User } from './User';

import { expect } from 'chai';

let user1: User;
let user2: User;

const username1 = 'friendships_testuser1';
const username2 = 'friendships_testuser2';
const password = 'test';

describe('Friendships', () => {
    before(async () => {
        user1 = await User.create(username1, password);
        user2 = await User.create(username2, password);
    });

    it('should create a friend request', async () => {
        const response = await Friendships.create(user1.Id, user2.Id);
        expect(response).to.equal(FriendshipStatus.REQUESTED);
    });

    it('should return the pending friend request', async () => {
        const response = await Friendships.getPending(user2.Id);
        expect(response[0].Id).to.equal(user1.Id);
    });

    it('should accept a friend request', async () => {
        const response = await Friendships.create(user2.Id, user1.Id);
        expect(response).to.equal(FriendshipStatus.ACCEPTED);
    });

    it('should get all the friends of a user', (done) => {
        Friendships.get(user1.Id).then((result) => {
            expect(result.userId).to.equal(user1.Id);
            expect(result.friends).length.to.be.greaterThan(0);
            done();
        });
    });

    it('should delete the friendship', async () => {
        const response = await Friendships.delete(user1.Id, user2.Id);
        expect(response).to.equal(FriendshipStatus.DELETED);
    });

    it('should refuse a friend request', async () => {
        const response = await Friendships.create(user1.Id, user2.Id);
        expect(response).to.equal(FriendshipStatus.REQUESTED);
        const response2 = await Friendships.delete(user2.Id, user1.Id);
        expect(response2).to.equal(FriendshipStatus.REFUSED);
    });

    after(async () => {
        await User.delete(user1.Id);
        await User.delete(user2.Id);
    });
});
