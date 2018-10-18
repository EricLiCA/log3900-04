export namespace PostgresConfig {
    export const HOST = process.env.PG_HOST === undefined ? 'localhost' : process.env.PG_HOST;
    export const PORT = process.env.PG_PORT === undefined ? '5432' : process.env.PG_PORT;
    export const USER = process.env.PG_USER === undefined ? 'postgres' : process.env.PG_PASSWORD;
    export const PASSWORD = process.env.PG_PASSWORD === undefined ? '' : process.env.PG_PASSWORD;
    export const DATABASE = process.env.PG_DB === undefined ? '' : process.env.PG_DB;
}

export namespace RedisConfig {
    export const HOST = process.env.REDIS_HOST;
    export const PORT = process.env.REDIS_PORT;
}
