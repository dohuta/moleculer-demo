"use strict";

const { MoleculerError } = require("moleculer").Errors;
const { Op } = require("sequelize");

const db = require("../handlers/database-handler");
const authHandler = require("../handlers/auth-handler");

const { AUTH_ERRORS, INPUT_ERRORS } = require("../common/constants");

/**
 * @typedef {import('moleculer').Context} Context Moleculer's Context
 */

module.exports = {
	name: "user",
	version: process.env.SERVICE_USER_VERSION,
	metadata: {
		scalable: true,
		priority: 5,
	},
	actions: {
		signin: {
			rest: {
				method: "POST",
				path: "/signin",
			},
			params: {
				username: { type: "string", min: 9, max: 255 },
				password: { type: "string", min: 6, max: 255 },
			},
			async handler({ action, params, meta, ...ctx }) {
				const { username, password } = params;

				let user = await db.models.User.scope("withPassword").findAll({
					where: {
						phone: username,
					},
					include: {
						model: db.models.Assignment,
						include: {
							model: db.models.Role,
							attributes: ["name"],
							include: {
								model: db.models.Permission,
								attributes: ["name"],
							},
						},
					},
				});

				if (user && user.length === 1) {
					user = user[0];
				} else {
					this.logger.info(`user.signin :: User not found`);
					throw new MoleculerError(
						AUTH_ERRORS.USER_NOT_FOUND,
						AUTH_ERRORS.code,
						"USER_NOT_FOUND"
					);
				}

				const valid = authHandler.verifyPassword(
					password,
					user.password
				);

				if (!valid) {
					this.logger.info(`user.signin :: Invalid password`);
					throw new MoleculerError(
						AUTH_ERRORS.INVALID_USER_NAME_PASSWORD,
						AUTH_ERRORS.code,
						"INVALID_USER_NAME_PASSWORD"
					);
				}

				const refinedUser = this.refinedUserObject(user.get());
				const token = await authHandler.generateToken(refinedUser);

				return token;
			},
		},
		signout: {
			rest: {
				method: "POST",
				path: "/signout",
			},
			params: {
				all: { type: "boolean" },
			},
			async handler({ action, params, meta, ...ctx }) {
				const { all } = params;

				if (all) {
					authHandler.deleteAllAuthInfoByUserID(meta.user.id);
				} else {
					authHandler.deleteAuthInfoByUserID(meta.user.id);
				}

				return true;
			},
		},
		signup: {
			rest: {
				method: "POST",
				path: "/signup",
			},
			params: {
				username: { type: "string", min: 9, max: 255 },
				password: { type: "string", min: 6, max: 255 },
			},
			async handler({ action, params, meta, ...ctx }) {
				const { username, password } = params;

				let user = await db.models.User.findAll({
					where: {
						phone: username,
					},
				});

				if (user && user.length === 1) {
					this.logger.info(`user.signout :: User existed`);
					throw new MoleculerError(
						AUTH_ERRORS.USER_EXISTED,
						AUTH_ERRORS.code,
						"USER_EXISTED"
					);
				} else {
					const created = await User.create({
						phone: username,
						password: authHandler.hashPassword(password),
					});

					const token = authHandler.generateToken(created);

					return token;
				}
			},
		},
		getProfile: {
			rest: {
				method: "GET",
				path: "/getProfile",
			},
			async handler({ action, params, meta, ...ctx }) {
				const { user } = meta;

				const results = await db.models.User.findAll({
					where: {
						id: user.id,
					},
				});

				if (results && results.length === 1) {
					return results[0];
				} else {
					this.logger.info(`user.getProfile :: User not found`);
					throw new MoleculerError(
						AUTH_ERRORS.USER_NOT_FOUND,
						AUTH_ERRORS.code,
						"USER_NOT_FOUND"
					);
				}
			},
		},
		updateProfile: {
			rest: {
				method: "PUT",
				path: "/updateProfile",
			},
			params: {
				phone: {
					type: "string",
					min: 9,
					max: 20,
					nullable: true,
					optional: true,
				},
				full_name: {
					type: "string",
					min: 9,
					max: 255,
					nullable: true,
					optional: true,
				},
				old_password: {
					type: "string",
					min: 9,
					max: 255,
					optional: true,
				},
				new_password: {
					type: "string",
					min: 9,
					max: 255,
					optional: true,
				},
				re_new_password: {
					type: "string",
					min: 9,
					max: 255,
					optional: true,
				},
			},
			async handler({ action, params, meta, ...ctx }) {
				const { user } = meta;

				const {
					phone,
					full_name,
					old_password,
					new_password,
					re_new_password,
				} = params;

				const _user = await db.models.User.findByPk(user.id);

				if (!user || user.deleted) {
					throw new MoleculerError(
						AUTH_ERRORS.ACCESS_DENIED,
						AUTH_ERRORS.code,
						AUTH_ERRORS.ACCESS_DENIED
					);
				}

				if (phone) _user.phone = phone;
				if (full_name) _user.full_name = full_name;

				if (new_password) {
					const isValid = authHandler.verifyPassword(
						old_password,
						_user.password
					);

					if (!isValid)
						throw new MoleculerError(
							INPUT_ERRORS.BAD_INPUT + ". Wrong password",
							INPUT_ERRORS.code,
							"BAD_INPUT"
						);

					if (new_password !== re_new_password) {
						throw new MoleculerError(
							INPUT_ERRORS.BAD_INPUT +
								". New password and Reconfirm password are not match",
							INPUT_ERRORS.code,
							"BAD_INPUT"
						);
					}

					const hashedPassword = authHandler.hashPassword(
						re_new_password
					);

					_user.password = hashedPassword;
				}

				await _user.save();

				return true;
			},
		},
	},
	hooks: {
		before: {
			signout: "isAuthenticated",
			getProfile: [
				function isAuthenticated(ctx) {
					return this.isAuthenticated(ctx);
				},
				function isValid2performAction(ctx) {
					return this.isValid2performAction(ctx, undefined, [
						"READ:OWN_PROFILE",
						"READ:OWN_ORDERS",
					]);
				},
			],
		},
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
		refinedUserObject(user) {
			const refined = { ...user };

			delete refined.password;
			delete refined.createdAt;
			delete refined.updatedAt;
			delete refined.Assignments;

			const allRoles = user.Assignments.map((x) => x.Role.name);
			const allPermission = user.Assignments.reduce((pre, curr) => {
				const permissions = curr.Role.Permissions.map((x) => x.name);
				pre = [...pre, ...permissions];
				return pre;
			}, []);

			refined["allRoles"] = allRoles;
			refined["allPermissions"] = allPermission;

			return refined;
		},
	},
};
