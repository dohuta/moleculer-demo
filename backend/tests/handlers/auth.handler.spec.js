const authHandler = require("../../src/handlers/auth-handler");

const testCases = require("../testCases/auth.handler");

describe("Unit Test 'Authentication' handler", () => {
	testCases.hashPassword.forEach((c) => {
		it(c.description, async () => {
			const { input, expect: expectation } = c;

			if (expectation == true) {
				const res = await authHandler.hashPassword(input.password);

				expect(res).not.toBeNull();
				expect(res.length).toBeGreaterThan(1);
			} else {
				try {
					const res = await authHandler.hashPassword(input.password);
				} catch (err) {
					expect(err).toBeInstanceOf(Error);
				}
			}
		});
	});

	testCases.verifyPassword.forEach((c) => {
		it(c.description, async () => {
			const { input, expect: expectation } = c;

			if (expectation == true) {
				const res = await authHandler.verifyPassword(
					input.password,
					input.hashedPassword
				);

				expect(res).toBe(true);
			} else {
				try {
					const res = await authHandler.verifyPassword(
						input.password,
						input.hashedPassword
					);
					expect(res).toBeNull(false);
				} catch (err) {
					expect(err).toBeInstanceOf(Error);
				}
			}
		});
	});
});
