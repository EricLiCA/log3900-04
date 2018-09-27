import { expect } from "chai";
import { ChatRoom } from "./chat-room";

describe("ChatRoom", () => {
    const chatRoom: ChatRoom = new ChatRoom("roomId");

    it("should be correctly instantiated", () => {
        expect(chatRoom.id).to.equal("roomId");
        expect(chatRoom.participants).to.not.equal(undefined);
        expect(chatRoom.participants.size).to.equal(0);
    });

});
