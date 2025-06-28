export function toBase64(str) {
    return btoa(unescape(encodeURIComponent(str)));
}
