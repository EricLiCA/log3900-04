import { expect } from "chai";
import { Utils } from "./Utils";

describe ("Utils", () => {

    /*
     * Because source-map-support uses Math.random() and source-map-support
     * is used by sinon, Math.random() can't be stubed to test the secret
     * generation.
     */

    describe('generateRandomSecret()', () => {
        it ('should generate a word the right length', () => {
            expect(Utils.generateRandomSecret(0).length).to.equal(0);
            expect(Utils.generateRandomSecret(1).length).to.equal(1);
            expect(Utils.generateRandomSecret(10).length).to.equal(10);
        });

        it ('should generate ASCII characters between 0 and z', () => {
            const tries = 10000;
            const word = Utils.generateRandomSecret(tries);
            for (let i = 0; i < tries; i++) {
                expect(word.charCodeAt(i)).to.be.lessThan(123);
                expect(word.charCodeAt(i)).to.not.be.lessThan(48);
            }
        });

    });
});