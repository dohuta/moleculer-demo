module.exports = {
	"POST signin": `${process.env.SERVICE_USER_VERSION}.user.signin`,
	"POST signout": `${process.env.SERVICE_USER_VERSION}.user.signout`,
	"POST signup": `${process.env.SERVICE_USER_VERSION}.user.signup`,
	"GET me": `${process.env.SERVICE_USER_VERSION}.user.getProfile`,
	"PUT me": `${process.env.SERVICE_USER_VERSION}.user.updateProfile`,
};
