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
