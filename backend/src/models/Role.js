const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Role",
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
			name: {
				type: DataTypes.STRING(20),
				allowNull: false,
				unique: "UQ__Role__72E12F1BECD20C7A",
			},
		},
		{
			sequelize,
			tableName: "Role",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Role__3213E83FC9E4E71E",
					unique: true,
					fields: [{ name: "id" }],
				},
				{
					name: "UQ__Role__72E12F1BECD20C7A",
					unique: true,
					fields: [{ name: "name" }],
				},
			],
			defaultScope: {
				attributes: { exclude: ["_version"] },
			},
		}
	);
};
