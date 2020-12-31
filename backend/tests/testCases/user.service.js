module.exports = {
	"v1.user.signin": [
		{
			description: "should return token",
			input: { username: "0901111111", password: "P@ssw0rd" },
			expect: true,
		},
		{
			description: "should throw validation error",
			input: { password: "P@ssw0rd" },
			expect: "422::VALIDATION_ERROR",
		},
		{
			description: "should throw validation error",
			input: { username: "0901111111" },
			expect: "422::VALIDATION_ERROR",
		},
		{
			description: "should throw validation error",
			input: {},
			expect: "422::VALIDATION_ERROR",
		},
		{
			description: "should throw auth error",
			input: { username: "0901111112", password: "P@ssw0rd" },
			expect: "403::USER_NOT_FOUND",
		},
		{
			description: "should throw auth error",
			input: { username: "0901111111", password: "P@ssw1rd" },
			expect: "403::INVALID_USER_NAME_PASSWORD",
		},
	],
};
