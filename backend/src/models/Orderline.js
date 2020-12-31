const Sequelize = require("sequelize");
module.exports = function (sequelize, DataTypes) {
	return sequelize.define(
		"Orderline",
		{
			_version: {
				type: DataTypes.INTEGER,
				allowNull: true,
				defaultValue: 1,
			},
			order_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "Order",
					key: "id",
				},
			},
			product_variant_id: {
				type: DataTypes.INTEGER,
				allowNull: false,
				references: {
					model: "Product_Variant",
					key: "id",
				},
			},
			quantity: {
				type: DataTypes.INTEGER,
				allowNull: true,
				defaultValue: 1,
			},
		},
		{
			sequelize,
			tableName: "Orderline",
			schema: "dbo",
			timestamps: true,
			paranoid: true,
			defaultScope: {
				attributes: { exclude: ["_version"] },
			},
		}
	);
};
