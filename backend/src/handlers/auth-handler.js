const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const { MoleculerError } = require("moleculer").Errors;

const { AUTH_ERRORS } = require("../common/constants");

const authCache = require("../utils/auth-cache");
const db = require("./database-handler");

class Authentication {
	constructor() {
		this.jwtOptions = {
			expiresIn: process.env.JWT_EXPIRATION,
		};
	}

	/**
	 * Return hashed string of password with salt:12
	 * @param {string} password
	 */
	hashPassword(password) {
		return bcrypt.hashSync(password, 12);
	}

	/**
	 * Verify password
	 * @param {string} password
	 * @param {string} hashedPassword
	 */
	verifyPassword(password, hashedPassword) {
		return bcrypt.compareSync(password, hashedPassword);
	}

	/**
	 * Delete one token
	 * @param {string} userId
	 */
	async deleteAuthInfoByUserID(userId) {
		return authCache.deleteToken(userId, jwt);
	}

	/**
	 * Delete many tokens by userId
	 * @param {string} userId
	 */
	async deleteAllAuthInfoByUserID(userId) {
		return authCache.deleteAllTokensByUserId(userId, jwt);
	}

	/**
	 * Generate token by user ID
	 * @param {*} user
	 */
	async generateToken(user) {
		let refinedUser = user;

		// get plain object instead of entity
		if (refinedUser instanceof db.models.User) {
			refinedUser = user.get();
		}

		// NOTE: options (object) is used for test or other reasons
		// synchronous call since no callback supplied
		const token = jwt.sign(user, process.env.JWT_SECRET, this.jwtOptions);

		// save token to redis cache
		await authCache.setToken(token, user);

		return token;
	}

	/**
	 * Extract authorization information from request/token
	 * @param {*} req Request
	 * @param {string | null | undefined} token
	 * @param {boolean} required default is false
	 */
	validateRequest(req, token = null, required = false) {
		const auth =
			token ||
			req.headers["Authorization"] ||
			req.headers["authorization"];

		if (auth && auth.startsWith("Bearer")) {
			const token = auth.slice(7);

			let decrypted;
			try {
				decrypted = jwt.verify(
					token,
					process.env.JWT_SECRET,
					this.jwtOptions
				);
			} catch (error) {
				console.error(
					`AUTH :: Error on decrypting token :: ${JSON.stringify(
						error
					)}`
				);
				throw MoleculerError(
					AUTH_ERRORS.INVALID_TOKEN,
					AUTH_ERRORS.code
				);
			}

			if (decrypted && Object.keys(decrypted).length) {
				return decrypted;
			} else {
				console.error(`AUTH :: Error on decrypted token :: empty data`);
				throw MoleculerError(
					AUTH_ERRORS.INVALID_TOKEN,
					AUTH_ERRORS.code
				);
			}
		} else if (required) {
			// No token. Throw an error or do nothing if anonymous access is allowed.
			// throw new E.UnAuthorizedError(E.ERR_NO_TOKEN);
			console.error(`AUTH :: Error on decrypted token :: empty data`);
			throw MoleculerError(AUTH_ERRORS.INVALID_TOKEN, AUTH_ERRORS.code);
		} else {
			// Do nothing
			return null;
		}
	}

	isAuthenticated(context) {
		if (!context || !context.meta.user) {
			this.logger.info(
				`User.hook.getOwnUser :: Access denied due to not authenticated`
			);
			throw new MoleculerError(
				AUTH_ERRORS.ACCESS_DENIED,
				AUTH_ERRORS.code
			);
		}
	}

	isValid2performAction(
		context,
		requiredRoles = undefined,
		requiredPermissions = undefined
	) {
		if (
			!context ||
			(requiredPermissions &&
				!requiredPermissions.length &&
				requiredPermissions &&
				!requiredPermissions.length)
		)
			throw new MoleculerError(
				AUTH_ERRORS.ACCESS_DENIED,
				AUTH_ERRORS.code
			);

		const { user } = context.meta;

		if (!user)
			throw new MoleculerError(
				AUTH_ERRORS.ACCESS_DENIED,
				AUTH_ERRORS.code
			);
		if (requiredRoles && requiredRoles.length) {
			const inte = intersection(user.allRoles, requiredRoles);
			if (inte.length === requiredRoles.length) return true;
		}
		if (requiredPermissions && requiredPermissions.length) {
			const inte = intersection(user.allPermissions, requiredPermissions);
			if (inte.length === requiredPermissions.length) return true;
		}

		throw new MoleculerError(AUTH_ERRORS.ACCESS_DENIED, AUTH_ERRORS.code);
	}
}

function intersection(left, right) {
	const result = [];
	right.forEach((ele) => {
		if (left.includes(ele)) result.push(ele);
	});
	return result;
}

module.exports = new Authentication();
