const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Ward",
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
				type: DataTypes.STRING(64),
				allowNull: true,
			},
			district_ward: {
				type: DataTypes.INTEGER,
				allowNull: true,
				references: {
					model: "District",
					key: "id",
				},
			},
		},
		{
			sequelize,
			tableName: "Ward",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Ward__3213E83F80570219",
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
