const jwt = require("jsonwebtoken");
const CacheBase = require("./cache");

class AuthCache {
	constructor() {
		this.cache = new CacheBase(process.env.AUTH_CACHE_INDEX);
	}

	/**
	 * Load payload from cache by token
	 * @param {String} token
	 */
	getToken(token) {
		return this.cache.get(token);
	}

	/**
	 * Save token as key and payload as value to cache
	 * @param {String} token
	 * @param {*} payload additional data
	 */
	async setToken(token, payload) {
		// NOTE: the line below doesnt set lifetime for token (each key-value pair in one hashset) so I replace with the second one, we will save an object of only ip
		await this.cache.setX(
			token,
			payload,
			process.env.JWT_EXPIRATION || "7d"
		);
		return true;
	}

	/**
	 * Remove one token from cache
	 * @param {String} token
	 */
	async deleteToken(token) {
		await this.cache.del(token);
		return true;
	}

	/**
	 * Delete all tokens from cache
	 * @param {String} userId
	 * @param {jwt} jwt
	 */
	async deleteAllTokensByUserId(userId, jwt) {
		const tokens = await this.cache.getKeys();
		tokens.forEach((token) => {
			const payload = jwt.decode(token);
			if (payload.user.id === userId) {
				this.cache.del(token);
			}
		});
		return true;
	}
}

module.exports = new AuthCache();
