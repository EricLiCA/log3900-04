import { PostgresDatabase } from '../postgres-database';
import { RedisService } from '../redis.service';

export class SessionsModel {
    /*public static async create(username: string, password: string): Promise<SessionsModel> {

        const db = await PostgresDatabase.getInstance();
        db.query('SELECT * FROM Users WHERE "Username" = $1', [req.body.username]).then((query) => {
            if (query.rowCount > 0) {
                const result = query.rows[0];
                if (req.body.password === result.Password) {
                    const redisClient = RedisService.getInstance();
                    redisClient.hget('authTokens', result.Id, (redisErr, cachedToken) => {
                        if (cachedToken !== null) {
                            res.send({
                                id: result.Id,
                                token: cachedToken,
                                userLevel: result.UserLevel,
                                profileImage: result.ProfileImage,
                            });
                        } else {
                            db.query(
                                `INSERT INTO Sessions("userid")
                                VALUES($1)
                                ON CONFLICT ("userid")
                                DO UPDATE SET "userid" = excluded.userid
                                RETURNING *`,
                                [result.Id],
                            )
                                .then((queryResponse) => {
                                    if (queryResponse.rowCount > 0) {
                                        const sessionResult = queryResponse.rows[0];
                                        redisClient.hset('authTokens', sessionResult.userid, sessionResult.token);
                                        res.send({
                                            id: sessionResult.userid,
                                            token: sessionResult.token,
                                        });
                                    }
                                })
                                .catch((err) => {
                                    res.sendStatus(400);
                                });
                        }
                    });
                } else {
                    res.sendStatus(403);
                }
            } else {
                res.sendStatus(404);
            }
        })
            .catch((err) => {
                res.sendStatus(400); // Bad request
            });
    }*/

    public constructor(
        public userId: string,
        public token: string,
    ) { }
}
