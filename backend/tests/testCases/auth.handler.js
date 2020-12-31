module.exports = {
	hashPassword: [
		{
			expect: true,
			description: "returns hashed password",
			input: { password: "P@ssw0rd" },
		},
		{ expect: false, description: "throws error", input: { password: "" } },
		{ expect: false, description: "throws error", input: {} },
	],
	verifyPassword: [
		{
			expect: true,
			description: "password is verified",
			input: {
				password: "P@ssw0rd",
				hashedPassword:
					"$2y$12$L4uQGPD9RR4WlrCupg29qOy1lREMNCUS7cr4tG10Y0uZHUbNM/97a",
			},
		},
		{
			expect: false,
			description: "throws error",
			input: {
				password: "",
				hashedPassword:
					"$2y$12$L4uQGPD9RR4WlrCupg29qOy1lREMNCUS7cr4tG10Y0uZHUbNM/97a",
			},
		},
		{
			expect: false,
			description: "throws error",
			input: {
				hashedPassword:
					"$2y$12$L4uQGPD9RR4WlrCupg29qOy1lREMNCUS7cr4tG10Y0uZHUbNM/97a",
			},
		},
		{
			expect: false,
			description: "throws error",
			input: {
				password: "P@ssw0rd",
				hashedPassword: "",
			},
		},
		{
			expect: false,
			description: "throws error",
			input: {
				password: "P@ssw0rd",
			},
		},
	],
};
