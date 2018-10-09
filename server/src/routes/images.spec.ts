const IMAGES_URL: String = "http://localhost:3000/images/";
const TEST: string = "TEST"

describe("ImagesRoute", () => {
    const chai = require('chai');
    const chaiHttp = require('chai-http');
    chai.use(chaiHttp);

    it("should add a new image", (done: MochaDone) => {
        const newImage = {
            ownerId: TEST,
            title: TEST,
            protectionLevel: TEST,
            password: TEST,
            thumbnailUrl: TEST,
            fullImageUrl: TEST,
        }
        // tslint:disable-next-line:no-any
        chai.request(IMAGES_URL).post().send({ newImage }).end((err: boolean, res: any) => {
            const result: string = JSON.parse(res.text);
            chai.expect(result).to.equal();
        });
        // tslint:disable-next-line:no-magic-numbers
    }).timeout(15000);
});
