import { expect } from "chai";
import { Connection } from "./connection";
import { mock } from 'sinon';

describe("Connection", () => {

    let connection = new Connection(undefined);
        
    it("should be instantiated as an anonymous user", () => {
        expect(connection.socket).to.be.undefined;
        expect(connection.user.email).to.be.undefined;
    });

    describe("connect()", () => {
        
        it("should call the method with the same name from User", () => {
            let connectMock = mock(connection.user);
            connectMock.expects('connect').calledOnceWith('email@email.com');

            connection.connect('email@email.com');
            
            connectMock.verify();
            connectMock.restore();
        });
    });
});
