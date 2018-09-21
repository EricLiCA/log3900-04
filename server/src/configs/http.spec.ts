import { expect } from "chai";
import { SERVER_PORT } from "./http";

describe("Http", () => {
    describe("SERVER_PORT", () => {
        it("should be 3000", () => {
            expect(SERVER_PORT).to.equal("3000");
        });
    });
});
