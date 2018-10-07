import * as redis from 'redis';

export class RedisService {

    public static getInstance(): redis.RedisClient {
        if (RedisService.client === undefined) {
            this.client = redis.createClient();
        }
        return this.client;
    }

    private static client: redis.RedisClient;
}
