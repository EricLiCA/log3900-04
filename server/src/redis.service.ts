import * as redis from 'redis';
import { RedisConfig } from './configs/databases';

export class RedisService {

    public static getInstance(): redis.RedisClient {
        if (RedisService.client === undefined) {
            this.client = redis.createClient(
                Number(RedisConfig.PORT), RedisConfig.HOST,
            );
        }
        return this.client;
    }

    private static client: redis.RedisClient;
}
