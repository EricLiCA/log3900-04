import { PostgresDatabase } from '../postgres-database';
import { User } from './User';

export enum FriendshipStatus {
    REQUESTED = 'requested',
    ACCEPTED = 'accepted',
    REFUSED = 'refused',
    DELETED = 'deleted',
    ERROR = 'error',
}

export class Friendships {
    public static async get(id: string): Promise<Friendships> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'SELECT * FROM users WHERE "Id" IN (select "FriendId" from friendships where "UserId" = $1)',
            [id],
        );
        if (queryResponse.rowCount > 0) {
            const friendships = new Friendships(id, queryResponse.rows.map((row) => {
                return new User(
                    row.Id,
                    row.Username,
                    row.Password,
                    row.UserLevel,
                    row.ProfileImage,
                );
            }));
            return Promise.resolve(friendships);
        } else {
            return Promise.resolve(new Friendships(id, []));
        }
    }

    public static async getPending(id: string): Promise<User[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            `SELECT *
            FROM users
            WHERE "Id" IN (select "RequesterId" from pending_friend_requests where "ReceiverId" = $1)
            `,
            [id],
        );
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new User(
                    row.Id,
                    row.Username,
                    row.Password,
                    row.UserLevel,
                    row.ProfileImage,
                );
            }));
        } else {
            return Promise.resolve([]);
        }
    }

    public static async create(id: string, friendId: string): Promise<FriendshipStatus> {
        const db = await PostgresDatabase.getInstance();
        try {
            const alreadyAsked = await db.query(
                `SELECT *
                FROM pending_friend_requests
                WHERE "RequesterId" = $1 AND "ReceiverId" = $2;
                `,
                [id, friendId],
            );
            if (alreadyAsked.rowCount > 0)
                return Promise.resolve(FriendshipStatus.REQUESTED);

            const pendingRequest = await db.query(
                `SELECT *
                FROM pending_friend_requests
                WHERE "RequesterId" = $2 AND "ReceiverId" = $1;
                `,
                [id, friendId],
            );
            if (pendingRequest.rowCount > 0) { // friend already requested to be friends with user
                // delete the pending friend request
                const deletePendingFriendRequest = await db.query(
                    `DELETE FROM pending_friend_requests
                    WHERE "RequesterId" = $2 AND "ReceiverId" = $1
                    RETURNING *;
                    `,
                    [id, friendId],
                );
                if (deletePendingFriendRequest.rowCount === 0) {
                    return Promise.resolve(FriendshipStatus.ERROR);
                }
                // add the friend
                const createFriendshipResponse = await db.query(
                    `INSERT INTO friendships ("UserId", "FriendId")
                    VALUES ($1, $2), ($2, $1) RETURNING *;
                    `,
                    [id, friendId],
                );
                if (createFriendshipResponse.rowCount === 0) {
                    return Promise.resolve(FriendshipStatus.ERROR);
                } else {
                    return Promise.resolve(FriendshipStatus.ACCEPTED);
                }
            } else { // friend not already requested to be friends with user
                const createFriendRequest = await db.query(
                    `INSERT INTO pending_friend_requests ("RequesterId", "ReceiverId")
                    VALUES ($1, $2)
                    RETURNING *;
                    `,
                    [id, friendId],
                );
                if (createFriendRequest.rowCount > 0) {
                    return Promise.resolve(FriendshipStatus.REQUESTED);
                } else {
                    return Promise.resolve(FriendshipStatus.ERROR);
                }
            }
        } catch {
            return Promise.resolve(FriendshipStatus.ERROR);
        }
    }

    public static async delete(id: string, friendId: string): Promise<FriendshipStatus> {
        const db = await PostgresDatabase.getInstance();
        try {
            const pendingRequest = await db.query(
                `SELECT *
                FROM pending_friend_requests
                WHERE "RequesterId" = $2 AND "ReceiverId" = $1;
                `,
                [id, friendId],
            );
            if (pendingRequest.rowCount > 0) { // friend request is pending
                // delete the pending friend request
                const deletePendingFriendRequest = await db.query(
                    `DELETE FROM pending_friend_requests
                    WHERE "RequesterId" = $2 AND "ReceiverId" = $1
                    RETURNING *;
                    `,
                    [id, friendId],
                );
                if (deletePendingFriendRequest.rowCount === 0) {
                    return Promise.resolve(FriendshipStatus.ERROR);
                } else {
                    return Promise.resolve(FriendshipStatus.REFUSED);
                }
            } else { // no pending friend request
                const friendshipDeletion = await db.query(
                    `DELETE FROM friendships
                    WHERE ("UserId", "FriendId") IN (($1, $2), ($2, $1))
                    RETURNING *;
                    `,
                    [id, friendId],
                );
                if (friendshipDeletion.rowCount > 0) {
                    return Promise.resolve(FriendshipStatus.DELETED);
                } else {
                    return Promise.resolve(FriendshipStatus.ERROR);
                }
            }
        } catch (err) {
            return Promise.resolve(FriendshipStatus.ERROR);
        }
    }

    public userId: string;
    public friends: User[];

    public constructor(id: string, friends: User[]) {
        this.userId = id;
        this.friends = friends;
    }
}
