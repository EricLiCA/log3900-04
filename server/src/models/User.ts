import { PostgresDatabase } from '../postgres-database';

export class User {
    public static async getAll(): Promise<User[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM Users');
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

    public static async get(id: string): Promise<User> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM Users WHERE "Id" = $1', [id]);
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new User(
                row.Id,
                row.Username,
                row.Password,
                row.UserLevel,
                row.ProfileImage,
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async create(username: string, password: string): Promise<User> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'INSERT INTO Users("Username", "Password") VALUES($1, $2) RETURNING *',
            [username, password],
        );
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new User(
                row.Id,
                row.Username,
                row.Password,
                row.UserLevel,
                row.ProfileImage,
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public static async delete(id: string): Promise<User> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'DELETE FROM Users WHERE "Id" = $1 RETURNING *',
            [id],
        );
        if (queryResponse.rowCount > 0) {
            const row = queryResponse.rows[0];
            return Promise.resolve(new User(
                row.Id,
                row.Username,
                row.Password,
                row.UserLevel,
                row.ProfileImage,
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public Id: string;
    public Username: string;
    public Password: string;
    public UserLevel: string;
    public ProfileImage: string;

    public constructor(id: string, username: string, password: string, userLevel: string, profileImage: string) {
        this.Id = id;
        this.Username = username;
        this.Password = password;
        this.UserLevel = userLevel;
        this.ProfileImage = profileImage;
    }
}
