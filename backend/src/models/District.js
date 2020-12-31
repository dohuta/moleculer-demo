const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"District",
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
			city_dist: {
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
			tableName: "District",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__District__3213E83F403A637C",
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
