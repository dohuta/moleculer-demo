const Redis = require("ioredis");
const ms = require("ms");
const util = require("util");

class CacheBase {
	constructor(databaseName) {
		const db = new Redis(process.env.DB_REDIS_ENDPOINT, {
			db: databaseName,
			showFriendlyErrorStack: true,
		});

		this.cache = db;
	}

	/**
	 * Get value by key
	 * @param {String} key
	 */
	async get(key) {
		const rawData = await this.cache.get(key);
		return JSON.parse(rawData);
	}

	/**
	 * Get many value by prefix key
	 * @param {String | undefined | null} prefix (empty if get all)
	 */
	async getMany(prefix = undefined) {
		const rawData = await this.cache.keys(`${prefix ? prefix : ""}*`);
		const data = rawData.map(async (key) => {
			const temp = {};
			const value = await this.cache.get(key);
			temp[key] = JSON.parse(value);
			return temp;
		});
		return data;
	}

	/**
	 * Get many keys by prefix
	 * @param {String | undefined | null} prefix (empty if get all)
	 */
	async getKeys(prefix = undefined) {
		return await this.cache.keys(`${prefix ? prefix : ""}*`);
	}

	/**
	 * Set value by key
	 * @param {String} key
	 * @param {*} value
	 */
	async set(key, value) {
		return await this.cache.set(key, JSON.stringify(value));
	}

	/**
	 * Set value by key with expiration
	 * @param {String} key
	 * @param {*} value
	 * @param {String} expiresIn ex: 3s, 1d, 12m...
	 */
	async setX(key, value, expiresIn) {
		return await this.cache.set(
			key,
			JSON.stringify(value),
			"EX",
			ms(expiresIn) / 1000 // convert to second
		);
	}

	/**
	 * Delete record by key
	 * @param {String} key
	 */
	async del(key) {
		return await this.cache.del(key);
	}

	/**
	 * Delete many records by array of keys
	 * @param {String} keys
	 */
	async delMany(keys) {
		return await this.cache.del(keys);
	}

	/**
	 * Flush all
	 */
	async flush() {
		return await this.cache.flushdb();
	}
}

module.exports = CacheBase;
