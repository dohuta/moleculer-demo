const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"User",
		{
			_version: {
				type: DataTypes.INTEGER,
				allowNull: true,
				defaultValue: 1,
			},
			id: {
				autoIncrement: true,
				type: DataTypes.INTEGER,
				allowNull: false,
				primaryKey: true,
			},
			phone: {
				type: DataTypes.STRING(20),
				allowNull: false,
				unique: "UQ__User__B43B145F64594E65",
			},
			password: {
				type: DataTypes.STRING(255),
				allowNull: true,
			},
			full_name: {
				type: DataTypes.STRING(255),
				allowNull: true,
			},
		},
		{
			sequelize,
			tableName: "User",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__User__3213E83FDB27676D",
					unique: true,
					fields: [{ name: "id" }],
				},
				{
					name: "UQ__User__B43B145F64594E65",
					unique: true,
					fields: [{ name: "phone" }],
				},
			],
			defaultScope: {
				attributes: { exclude: ["_version", "password"] },
			},
			scopes: {
				withPassword: {
					attributes: { include: ["password"] },
				},
			},
		}
	);
};
