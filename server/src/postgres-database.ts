import { Client, ClientConfig } from "pg";
import { Postgres } from "./configs/databases";

const clientConfig: ClientConfig = {
    user: Postgres.USER,
    database: Postgres.DATABASE,
    password: Postgres.PASSWORD,
    port: Number(Postgres.PORT),
    host: Postgres.HOST,
    keepAlive: true,
    ssl: false,
};

export class PostgresDatabase {

    public static getInstance(): Promise<Client> {

        return new Promise<Client>((resolve, reject) => {
            if (PostgresDatabase.database === undefined) {
                PostgresDatabase.database = new Client(clientConfig);
                PostgresDatabase.database.connect((err: Error) => {
                    if (err) {
                        reject(err.message);
                        PostgresDatabase.database = undefined;
                    }
                    resolve(PostgresDatabase.database);
                });
            } else {
                resolve(PostgresDatabase.database);
            }

        });
    }

    private static database: Client;

}
