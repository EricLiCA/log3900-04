import { expect } from "chai";
import { User } from "./user";
import { spy } from 'sinon';

describe("User", () => {

    let randomStub = spy( Math, 'random');
    
    beforeEach(() => {
        randomStub.resetHistory();
    });

    after(() => {
        randomStub.restore();
    })

    describe("if the user is authenticated", () => {
        
        it("should not instantiate if email is not specified", () => {
            expect( () => {
                new User(true);
            }).to.throw( Error );
        });
        
        it("should instantiate correctly", () => {
            
            let user = new User(true, 'email@email.com');
            expect(user.email).to.equal('email@email.com');
            // expect(user.id)   /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
            // expect(user.name) /* WILL BE CHECKED ONCE DATABASE FETCHING IS IMPLEMENTED */
        });
    });
    
    describe("if the user is not authenticated", () => {

        it("should instantiate correctly", () => {
            let user = new User(false);
            let randomNumber = randomStub.firstCall.returnValue;
            expect(user.name).to.equal(`Anonymous #${Math.ceil(randomNumber * 10000)}`);
        });
    });
});
