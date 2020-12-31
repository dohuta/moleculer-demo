const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
	process.env.DB_MAIN_NAME,
	process.env.DB_MAIN_USERNAME,
	process.env.DB_MAIN_PWD,
	{
		dialect: "mssql",
		dialectOptions: {
			options: {
				encrypt: true,
				loginTimeout: 30,
				validateBulkLoadParameters: true,
			},
		},
		pool: {
			max: 5,
			min: 0,
			acquire: 30000,
			idle: 10000,
		},
	}
);

const models = require("../models/init-models")(sequelize);

class Database {
	constructor() {
		this.adapter = new Sequelize(
			process.env.DB_MAIN_NAME,
			process.env.DB_MAIN_USERNAME,
			process.env.DB_MAIN_PWD,
			{
				dialect: "mssql",
			}
		);
		this.models = models;
	}
}

module.exports = new Database();
