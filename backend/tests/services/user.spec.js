"use strict";

const { ServiceBroker } = require("moleculer");
const { MoleculerError } = require("moleculer").Errors;
const UserService = require("../../src/services/user");

const testCases = require("../testCases/user.service");

describe("Unit Test 'user' service", () => {
	let broker = new ServiceBroker({ logger: false });
	broker.createService(UserService);

	beforeAll(() => broker.start());
	afterAll(() => broker.stop());

	testCases["v1.user.signin"].forEach((c) => {
		it(c.description, async () => {
			const { input, expect: expectation } = c;

			if (expectation == true) {
				const res = await broker.call("v1.user.signin", input);

				expect(res).not.toBeNull();
				expect(res.length).toBeGreaterThan(1);
			} else {
				const [code, message] = expectation.split("::");
				const error = new MoleculerError(message, code);
				try {
					await broker.call("v1.user.signin", input);
				} catch (err) {
					expect(err).toBeInstanceOf(MoleculerError);
					expect(`${err.code}::${err.type}`).toBe(expectation);
				}
			}
		});
	});
});
