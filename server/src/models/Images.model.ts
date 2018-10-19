import { PostgresDatabase } from '../postgres-database';

export class ImagesModel {
    public static async getAll(): Promise<ImagesModel[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query('SELECT * FROM images');
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new ImagesModel(
                    row.Id,
                    row.OwnerId,
                    row.Title,
                    row.ProtectionLevel,
                    row.Password,
                    row.ThumbnailUrl,
                    row.FullImageUrl,
                );
            }));
        } else {
            return Promise.resolve([]);
        }
    }

    public static async getByOwnerId(ownerId: string): Promise<ImagesModel[]> {
        const db = await PostgresDatabase.getInstance();
        const queryResponse = await db.query(
            'SELECT * FROM images WHERE "OwnerId" = $1',
            [ownerId],
        );
        if (queryResponse.rowCount > 0) {
            return Promise.resolve(queryResponse.rows.map((row) => {
                return new ImagesModel(
                    row.Id,
                    row.OwnerId,
                    row.Title,
                    row.ProtectionLevel,
                    row.Password,
                    row.ThumbnailUrl,
                    row.FullImageUrl,
                );
            }));
        } else {
            return Promise.resolve([]);
        }
    }

    public static async create(
        ownerId: string,
        title: string,
        protectionLevel: string,
        password: string,
        thumbnailUrl: string,
        fullImageUrl: string,
    ): Promise<ImagesModel> {
        let values = [
            ['OwnerId', ownerId],
            ['Title', title],
            ['ProtectionLevel', protectionLevel],
            ['Password', password],
            ['ThumbnailUrl', thumbnailUrl],
            ['FullImageUrl', fullImageUrl],
        ];
        values = values.filter((value) => value[1] !== undefined);
        if (values.length === 0) {
            return Promise.resolve(undefined);
        } else {
            // Build the INSERT query
            let queryText = 'INSERT INTO Images(';
            let interpolation: string = '';
            values.forEach((value, i) => {
                queryText += `"${value[0]}"`;
                interpolation += `$${i + 1}`;
                if (i !== values.length - 1) {
                    queryText += ',';
                    interpolation += ',';
                }
            });
            queryText += `) VALUES(${interpolation}) RETURNING *;`;

            const preparedQuery = {
                text: queryText,
                values: values.map((value) => value[1]),
            };

            // Query the database
            try {
                const db = await PostgresDatabase.getInstance();
                const queryResponse = await db.query(preparedQuery);
                if (queryResponse.rowCount > 0) {
                    const result = queryResponse.rows[0];
                    return Promise.resolve(new ImagesModel(
                        result.Id,
                        result.OwnerId,
                        result.Title,
                        result.ProtectionLevel,
                        result.Password,
                        result.ThumbnailUrl,
                        result.FullImageUrl,
                    ));
                } else {
                    return Promise.resolve(undefined);
                }
            } catch (err) {
                console.log(err);
                return Promise.resolve(undefined);
            }
        }
    }

    public static async update(
        id: string,
        ownerId: string,
        title: string,
        protectionLevel: string,
        password: string,
        thumbnailUrl: string,
        fullImageUrl: string,
    ): Promise<ImagesModel> {
        let values = [
            ['OwnerId', ownerId],
            ['Title', title],
            ['ProtectionLevel', protectionLevel],
            ['Password', password],
            ['ThumbnailUrl', thumbnailUrl],
            ['FullImageUrl', fullImageUrl],
        ];
        values = values.filter((value) => value[1] !== undefined);
        if (values.length === 0) {
            return Promise.resolve(undefined);
        } else {
            // Build the INSERT query
            let queryText = 'UPDATE images SET ';
            values.forEach((value, i) => {
                queryText += `"${value[0]}" = $${i + 1}`;
                if (i !== values.length - 1) {
                    queryText += ',';
                }
            });
            queryText += ` WHERE "Id" = $${values.length + 1} RETURNING *;`;

            const preparedQuery = {
                text: queryText,
                values: values.map((value) => value[1]).concat([id]),
            };

            // Query the database
            try {
                const db = await PostgresDatabase.getInstance();
                const queryResponse = await db.query(preparedQuery);
                if (queryResponse.rowCount > 0) {
                    const result = queryResponse.rows[0];
                    return Promise.resolve(new ImagesModel(
                        result.Id,
                        result.OwnerId,
                        result.Title,
                        result.ProtectionLevel,
                        result.Password,
                        result.ThumbnailUrl,
                        result.FullImageUrl,
                    ));
                } else {
                    return Promise.resolve(undefined);
                }
            } catch (err) {
                console.log(err);
                return Promise.resolve(undefined);
            }
        }
    }

    public static async delete(id: string): Promise<ImagesModel> {
        const db = await PostgresDatabase.getInstance();
        const response = await db.query(
            'DELETE FROM images WHERE "Id" = $1 RETURNING *;',
            [id],
        );
        if (response.rowCount > 0) {
            const result = response.rows[0];
            return Promise.resolve(new ImagesModel(
                result.Id,
                result.OwnerId,
                result.Title,
                result.ProtectionLevel,
                result.Password,
                result.ThumbnailUrl,
                result.FullImageUrl,
            ));
        } else {
            return Promise.resolve(undefined);
        }
    }

    public constructor(
        public id: string,
        public ownerId: string,
        public title: string,
        public protectionLevel: string,
        public password: string,
        public thumbnailUrl: string,
        public fullImageUrl: string,
    ) { }
}
