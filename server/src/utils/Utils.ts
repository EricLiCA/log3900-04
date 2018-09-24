export namespace Utils {
    
    export function generateRandomSecret(length: number): string {
        let secret = '';
        for (let i = 0; i < length; i++) {
            secret += String.fromCharCode(48 + Math.floor(Math.random() * 75));
        }
        return secret;
    }
}