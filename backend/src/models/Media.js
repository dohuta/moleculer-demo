const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Media",
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
				type: DataTypes.STRING(511),
				allowNull: true,
			},
			uri: {
				type: DataTypes.STRING,
				allowNull: true,
			},
			ext: {
				type: DataTypes.STRING(4),
				allowNull: true,
			},
			mime: {
				type: DataTypes.STRING(63),
				allowNull: true,
			},
			size: {
				type: DataTypes.INTEGER,
				allowNull: true,
			},
			hash: {
				type: DataTypes.STRING,
				allowNull: true,
			},
			sha256: {
				type: DataTypes.STRING,
				allowNull: true,
			},
		},
		{
			sequelize,
			tableName: "Media",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			indexes: [
				{
					name: "PK__Media__3213E83FF315FAF7",
					unique: true,
					fields: [{ name: "id" }],
				},
			],
			defaultScope: {
				attributes: { exclude: ["_version", "hash", "sha256"] },
			},
		}
	);
};
