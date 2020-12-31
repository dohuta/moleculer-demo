const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Order",
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
			user_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "User",
					key: "id",
				},
			},
			status: {
				type: DataTypes.STRING(20),
				allowNull: false,
			},
			paid: {
				type: DataTypes.BOOLEAN,
				allowNull: true,
				defaultValue: false,
			},
		},
		{
			sequelize,
			tableName: "Order",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Order__3213E83FCC279A90",
					unique: true,
					fields: [{ name: "id" }],
				},
			],
			defaultScope: {
				attributes: { exclude: ["_version"] },
			},
		}
	);
};
