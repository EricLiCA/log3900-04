import { Client, ClientConfig } from 'pg';
import { PostgresConfig } from './configs/databases';

const clientConfig: ClientConfig = {
    user: PostgresConfig.USER,
    database: PostgresConfig.DATABASE,
    password: PostgresConfig.PASSWORD,
    port: Number(PostgresConfig.PORT),
    host: PostgresConfig.HOST,
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
