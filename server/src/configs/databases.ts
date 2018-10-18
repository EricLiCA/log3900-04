export namespace PostgresConfig {
    export const HOST = process.env.PROD ? process.env.PG_HOST : 'localhost';
    export const PORT = process.env.PROD ? process.env.PG_PORT : '5432';
    export const USER = process.env.PROD ? process.env.PG_USER : '';
    export const PASSWORD = process.env.PROD ? process.env.PG_PASSWORD : '';
    export const DATABASE = process.env.PROD ? process.env.PG_DB : 'postgres';
}

export namespace RedisConfig {
    export const HOST = process.env.REDIS_HOST;
    export const PORT = process.env.REDIS_PORT;
}
