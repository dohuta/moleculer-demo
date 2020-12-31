const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Product_Media",
		{
			product_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				primaryKey: true,
				references: {
					model: "Product",
					key: "id",
				},
			},
			media_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				primaryKey: true,
				references: {
					model: "Media",
					key: "id",
				},
			},
		},
		{
			sequelize,
			tableName: "Product_Media",
			schema: "dbo",
			timestamps: false,
			indexes: [
				{
					name: "PK__Product___1A08F9FA5AFAE0E0",
					unique: true,
					fields: [{ name: "product_id" }, { name: "media_id" }],
				},
			],
		}
	);
};
