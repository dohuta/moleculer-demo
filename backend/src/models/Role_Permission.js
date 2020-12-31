const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Role_Permission",
		{
			role_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				primaryKey: true,
				references: {
					model: "Role",
					key: "id",
				},
			},
			permission_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				primaryKey: true,
				references: {
					model: "Permission",
					key: "id",
				},
			},
		},
		{
			sequelize,
			tableName: "Role_Permission",
			schema: "dbo",
			timestamps: false,
			indexes: [
				{
					name: "PK__Role_Per__C85A546378C8E847",
					unique: true,
					fields: [{ name: "role_id" }, { name: "permission_id" }],
				},
			],
		}
	);
};
