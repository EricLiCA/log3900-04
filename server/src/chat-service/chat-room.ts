export class ChatRoom {
    
    constructor(private _id: String) {
    }

    public get id(): String {
        return this._id;
    };
}