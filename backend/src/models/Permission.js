const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Permission",
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
				unique: "UQ__Permissi__72E12F1B9E9A08B9",
			},
		},
		{
			sequelize,
			tableName: "Permission",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Permissi__3213E83F30DDAF65",
					unique: true,
					fields: [{ name: "id" }],
				},
				{
					name: "UQ__Permissi__72E12F1B9E9A08B9",
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
