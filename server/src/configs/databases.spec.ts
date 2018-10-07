import { expect } from 'chai';
import { Postgres } from './databases';

describe('Postgres config', () => {
    describe('HOST', () => {
        it('should not be empty', () => {
            expect(Postgres.HOST).to.not.be.undefined;
            expect(Postgres.HOST).to.not.be.empty;
        });

        it('should be a valid host (url, localhost, or IP address)', () => {
            // tslint:disable-next-line
            const urlRegex = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/gm;
            expect(urlRegex.test(Postgres.HOST) || Postgres.HOST === 'localhost').to.be.true;
        });
    });

    describe('PORT', () => {
        it('should not be empty', () => {
            expect(Postgres.PORT).to.not.be.undefined;
            expect(Postgres.PORT).to.not.be.empty;
        });

        it('should be a number', () => {
            expect(isNaN(Number(Postgres.PORT))).to.be.false;
        });

        it('should be between 1024 and 65535', () => {
            expect(Number(Postgres.PORT)).to.be.greaterThan(1023);
            expect(Number(Postgres.PORT)).to.be.lessThan(65536);
        });
    });

    describe('USER', () => {
        it('should not be empty', () => {
            expect(Postgres.USER).to.not.be.undefined;
            expect(Postgres.USER).to.not.be.empty;
        });
    });

    describe('PASSWORD', () => {
        it('should not be empty', () => {
            expect(Postgres.PASSWORD).to.not.be.undefined;
            expect(Postgres.PASSWORD).to.not.be.empty;
        });
    });

    describe('DATABASE', () => {
        it('should not be empty', () => {
            expect(Postgres.DATABASE).to.not.be.undefined;
            expect(Postgres.DATABASE).to.not.be.empty;
        });
    });
});
