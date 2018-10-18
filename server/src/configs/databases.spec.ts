import { expect } from 'chai';
import { PostgresConfig } from './databases';

describe('Postgres config', () => {
    describe('HOST', () => {
        it('should not be empty', () => {
            console.log(PostgresConfig.DATABASE);
            console.log(PostgresConfig.HOST);
            console.log(PostgresConfig.PORT);
            console.log(PostgresConfig.USER);
            expect(PostgresConfig.HOST).to.not.be.undefined;
            expect(PostgresConfig.HOST).to.not.be.empty;
        });

        it('should be a valid host (url, localhost, or IP address)', () => {
            // tslint:disable-next-line
            const urlRegex = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/gm;
            expect(urlRegex.test(PostgresConfig.HOST) || PostgresConfig.HOST === 'localhost').to.be.true;
        });
    });

    describe('PORT', () => {
        it('should not be empty', () => {
            expect(PostgresConfig.PORT).to.not.be.undefined;
            expect(PostgresConfig.PORT).to.not.be.empty;
        });

        it('should be a number', () => {
            expect(isNaN(Number(PostgresConfig.PORT))).to.be.false;
        });

        it('should be between 1024 and 65535', () => {
            expect(Number(PostgresConfig.PORT)).to.be.greaterThan(1023);
            expect(Number(PostgresConfig.PORT)).to.be.lessThan(65536);
        });
    });

    describe('USER', () => {
        it('should not be empty', () => {
            expect(PostgresConfig.USER).to.not.be.undefined;
            if (process.env.PROD) {
                expect(PostgresConfig.USER).to.not.be.empty;
            }
        });
    });

    describe('PASSWORD', () => {
        it('should not be empty', () => {
            expect(PostgresConfig.PASSWORD).to.not.be.undefined;
            if (process.env.PROD) {
                expect(PostgresConfig.PASSWORD).to.not.be.empty;
            }
        });
    });

    describe('DATABASE', () => {
        it('should not be empty', () => {
            expect(PostgresConfig.DATABASE).to.not.be.undefined;
            expect(PostgresConfig.DATABASE).to.not.be.empty;
        });
    });
});
