const CacheBase = require("./cache");

class CartCache {
	constructor() {
		this.cache = new CacheBase(process.env.CART_CACHE_INDEX);
	}

	getCart(userId) {
		return this.cache.get(userId);
	}

	async setCart(userId, cartData) {
		const cart = await this.cache.get(userId);
		if (cart && cart instanceof Array && cart.length) {
			newCart = [...cart, cartData];
			this.cache.set(userId, newCart);
		} else {
			this.cache.set(userId, cartData);
		}
		return true;
	}

	async delCart(userId) {
		return await this.cache.del(userId);
	}
}

module.exports = new CartCache();
