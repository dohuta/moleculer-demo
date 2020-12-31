const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Address",
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
			address_line_1: {
				type: DataTypes.STRING(511),
				allowNull: true,
			},
			address_line_2: {
				type: DataTypes.STRING(511),
				allowNull: true,
			},
			ward_add: {
				type: DataTypes.INTEGER,
				allowNull: true,
				references: {
					model: "Ward",
					key: "id",
				},
			},
			district_add: {
				type: DataTypes.INTEGER,
				allowNull: true,
				references: {
					model: "District",
					key: "id",
				},
			},
			city_add: {
				type: DataTypes.INTEGER,
				allowNull: true,
				references: {
					model: "City",
					key: "id",
				},
			},
		},
		{
			sequelize,
			tableName: "Address",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Address__3213E83FF4A09732",
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
