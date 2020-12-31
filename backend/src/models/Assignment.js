const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Assignment",
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
			user: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "User",
					key: "id",
				},
			},
			role: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "Role",
					key: "id",
				},
			},
		},
		{
			sequelize,
			tableName: "Assignment",
			schema: "dbo",
			timestamps: true,
			indexes: [
				{
					name: "PK__Assignme__3213E83F0C69E4F8",
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
