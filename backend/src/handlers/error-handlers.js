const { MoleculerError } = require("moleculer").Errors;

const { AUTH_ERRORS } = require("../common/constants");

class AuthError extends MoleculerError {
	constructor(code, msg = null, data = null) {
		super(msg || AUTH_ERRORS[code], AUTH_ERRORS.code, "AUTH_ERRORS", data);
	}
}

module.exports = AuthError;
