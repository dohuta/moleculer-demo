"use strict";

const ApiGateway = require("moleculer-web");
const helmet = require("helmet");

const authHandler = require("../handlers/auth-handler");
const USER_ALIASES = require("../aliases/USER");

/**
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 * @typedef {import('http').IncomingMessage} IncomingRequest Incoming HTTP Request
 * @typedef {import('http').ServerResponse} ServerResponse HTTP Server Response
 */

module.exports = {
	name: "api",
	mixins: [ApiGateway],
	settings: {
		// Exposed port
		port: process.env.PORT || 3000,
		// Exposed IP
		ip: "0.0.0.0",
		use: [],
		routes: [
			{
				path: "/api",
				whitelist: ["**"],
				use: [helmet()],
				mergeParams: true,
				authentication: true,
				authorization: true,
				autoAliases: false,
				aliases: {
					health: "$node.health",
					...USER_ALIASES,
				},
				onBeforeCall(ctx, route, req, res) {
					// Set request headers to context meta
					ctx.meta.userAgent = req.headers["user-agent"];
				},
				// onAfterCall(ctx, route, req, res, data) {
				// 	// Async function which return with Promise
				// 	// return doSomething(ctx, res, data);
				// 	return;
				// },
				bodyParsers: {
					json: {
						strict: false,
						limit: "1MB",
					},
					urlencoded: {
						extended: true,
						limit: "1MB",
					},
				},
				mappingPolicy: "all", // Available values: "all", "restrict"
				logging: true,
			},
		],
		log4XXResponses: "info",
		logRequestParams: "info",
		logResponseData: "info",
		assets: {
			folder: "../public",
			options: {},
		},
	},
	methods: {
		/**
		 * Authenticate the user from request
		 *
		 * @param {Context} ctx
		 * @param {Object} route
		 * @param {IncomingMessage} req
		 * @param {ServerResponse} res
		 * @returns
		 */
		authenticate(ctx, route, req, res) {
			try {
				const user = authHandler.validateRequest(
					req,
					null,
					req.$action.auth == "required"
				);

				// Attach user object to context
				ctx.meta["user"] = user;

				return Promise.resolve(ctx);
			} catch (error) {
				this.logger.error(`AUTH :: ${JSON.stringify(error)}`);
				Promise.reject(
					new ApiGateway.Errors.UnAuthorizedError(
						ApiGateway.Errors.ERR_INVALID_TOKEN
					)
				);
			}
		},
		/**
		 * Authorize the user from request
		 *
		 * @param {Context} ctx
		 * @param {Object} route
		 * @param {IncomingMessage} req
		 * @param {ServerResponse} res
		 * @returns
		 */
		authorize(ctx, route, req, res) {
			try {
				const user = authHandler.validateRequest(
					req,
					null,
					req.$action.auth == "required"
				);

				// Attach user object to context
				ctx.meta["user"] = user;

				return Promise.resolve(ctx);
			} catch (error) {
				this.logger.error(`AUTH :: ${JSON.stringify(error)}`);
				Promise.reject(
					new ApiGateway.Errors.UnAuthorizedError(
						ApiGateway.Errors.ERR_INVALID_TOKEN
					)
				);
			}
		},
	},
};
