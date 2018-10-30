export namespace PostgresConfig {
    export const HOST = process.env.PG_HOST;
    export const PORT = process.env.PG_PORT;
    export const USER = process.env.PG_USER;
    export const PASSWORD = process.env.PG_PASSWORD;
    export const DATABASE = process.env.PG_DB;
}

export namespace RedisConfig {
    export const HOST = process.env.REDIS_HOST;
    export const PORT = process.env.REDIS_PORT;
}

export namespace S3Config {
    export const ACCESS_KEY = process.env.S3_ACCESS_KEY;
    export const SECRET_KEY = process.env.S3_SECRET_KEY;
}
