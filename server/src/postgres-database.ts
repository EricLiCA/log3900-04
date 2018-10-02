import { Client, ClientConfig } from "pg";
import { POSTGRES_ENDPOINT, POSTGRES_PORT, POSTGRES_PASSWORD, POSTGRES_DATABASE, POSTGRES_USER } from "./configs/http";

const clientConfig: ClientConfig = {
    user: POSTGRES_USER,
    database: POSTGRES_DATABASE,
    password: POSTGRES_PASSWORD,
    port: POSTGRES_PORT,
    host: POSTGRES_ENDPOINT,
    keepAlive: true,
    ssl: false
}

export class PostgresDatabase {

    private static database: Client;

    public static getInstance(): Promise<Client> {

        return new Promise<Client>((resolve, reject) => {
            if ( PostgresDatabase.database === undefined ) {
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
    
}
