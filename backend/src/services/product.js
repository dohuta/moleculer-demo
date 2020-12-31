"use strict";

const { MoleculerError } = require("moleculer").Errors;

const db = require("../handlers/database-handler");
const authHandler = require("../handlers/auth-handler");

/**
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

module.exports = {
	name: "product",
	version: process.env.SERVICE_PRODUCT_VERSION,
	metadata: {
		scalable: true,
		priority: 5,
	},
	actions: {
		products: {
			rest: {
				method: "GET",
				path: "/products",
			},
			params: {
				id: { type: "string", min: 9, max: 255, optional: true },
				name_contains: {
					type: "string",
					min: 6,
					max: 255,
					optional: true,
				},
			},
			async handler({ action, params, meta, ...ctx }) {
				const result = db.models.Product.findAll({
					include: {
						model: db.models.Product_Media,
						include: {
							model: db.models.Media,
						},
					},
				});
				console.log(
					"🚀 ~ file: product.js ~ line 43 ~ handler ~ result",
					result
				);

				return result;
			},
		},
	},
	hooks: {
		before: {},
		error: {
			"*": function (ctx, err) {
				// Log error
				this.logger.error(
					`Error occurred when '${ctx.action.name}' action was called`,
					err
				);

				// Throw further the error
				throw new MoleculerError(
					err.message,
					err.code || 500,
					err.type,
					err.data
				);
			},
		},
	},
	methods: {
		isAuthenticated: authHandler.isAuthenticated,
		isValid2performAction: authHandler.isValid2performAction,
	},
};
