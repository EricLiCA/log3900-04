import { expect } from "chai";
import { mock } from "sinon";
import { Connection } from "./connection";

describe("Connection", () => {

    const connection = new Connection(undefined);

    it("should be instantiated as an anonymous user", () => {
        expect(connection.socket).to.equal(undefined);
        expect(connection.user.email).to.equal(undefined);
    });

    describe("connect()", () => {

        it("should call the method with the same name from User", () => {
            const connectMock = mock(connection.user);
            connectMock.expects("connect").calledOnceWith("email@email.com");

            connection.connect("email@email.com");

            connectMock.verify();
            connectMock.restore();
        });
    });
});
