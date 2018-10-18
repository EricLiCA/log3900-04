import { PostgresDatabase } from '../postgres-database';
import { User } from './User';

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

    public userId: string;
    public friends: User[];

    public constructor(id: string, friends: User[]) {
        this.userId = id;
        this.friends = friends;
    }
}
