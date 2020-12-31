var DataTypes = require("sequelize").DataTypes;
var _Address = require("./Address");
var _Assignment = require("./Assignment");
var _City = require("./City");
var _District = require("./District");
var _Media = require("./Media");
var _Order = require("./Order");
var _Orderline = require("./Orderline");
var _Permission = require("./Permission");
var _Product = require("./Product");
var _Product_Media = require("./Product_Media");
var _Product_Variant = require("./Product_Variant");
var _Role = require("./Role");
var _Role_Permission = require("./Role_Permission");
var _User = require("./User");
var _Ward = require("./Ward");

function initModels(sequelize) {
	var Address = _Address(sequelize, DataTypes);
	var Assignment = _Assignment(sequelize, DataTypes);
	var City = _City(sequelize, DataTypes);
	var District = _District(sequelize, DataTypes);
	var Media = _Media(sequelize, DataTypes);
	var Order = _Order(sequelize, DataTypes);
	var Orderline = _Orderline(sequelize, DataTypes);
	var Permission = _Permission(sequelize, DataTypes);
	var Product = _Product(sequelize, DataTypes);
	var Product_Media = _Product_Media(sequelize, DataTypes);
	var Product_Variant = _Product_Variant(sequelize, DataTypes);
	var Role = _Role(sequelize, DataTypes);
	var Role_Permission = _Role_Permission(sequelize, DataTypes);
	var User = _User(sequelize, DataTypes);
	var Ward = _Ward(sequelize, DataTypes);

	Product.belongsToMany(Media, {
		through: Product_Media,
		foreignKey: "product_id",
		otherKey: "media_id",
	});
	Media.belongsToMany(Product, {
		through: Product_Media,
		foreignKey: "media_id",
		otherKey: "product_id",
	});
	Role.belongsToMany(Permission, {
		through: Role_Permission,
		foreignKey: "role_id",
		otherKey: "permission_id",
	});
	Permission.belongsToMany(Role, {
		through: Role_Permission,
		foreignKey: "permission_id",
		otherKey: "role_id",
	});
	Address.belongsTo(District, { foreignKey: "district_add" });
	District.hasMany(Address, { foreignKey: "district_add" });
	Address.belongsTo(User, { foreignKey: "user_id" });
	User.hasMany(Address, { foreignKey: "user_id" });
	Address.belongsTo(Ward, { foreignKey: "ward_add" });
	Ward.hasMany(Address, { foreignKey: "ward_add" });
	Address.belongsTo(City, { foreignKey: "city_add" });
	City.hasMany(Address, { foreignKey: "city_add" });
	Assignment.belongsTo(Role, { foreignKey: "role" });
	Role.hasMany(Assignment, { foreignKey: "role" });
	Assignment.belongsTo(User, { foreignKey: "user" });
	User.hasMany(Assignment, { foreignKey: "user" });
	District.belongsTo(City, { foreignKey: "city_dist" });
	City.hasMany(District, { foreignKey: "city_dist" });
	Order.belongsTo(User, { foreignKey: "user_id" });
	User.hasMany(Order, { foreignKey: "user_id" });
	Orderline.belongsTo(Order, { foreignKey: "order_id" });
	Order.hasMany(Orderline, { foreignKey: "order_id" });
	Orderline.belongsTo(Product_Variant, { foreignKey: "product_variant_id" });
	Product_Variant.hasMany(Orderline, { foreignKey: "product_variant_id" });
	Product_Media.belongsTo(Media, { foreignKey: "media_id" });
	Media.hasMany(Product_Media, { foreignKey: "media_id" });
	Product_Media.belongsTo(Product, { foreignKey: "product_id" });
	Product.hasMany(Product_Media, { foreignKey: "product_id" });
	Product_Variant.belongsTo(Product, { foreignKey: "product_id" });
	Product.hasMany(Product_Variant, { foreignKey: "product_id" });
	Role_Permission.belongsTo(Permission, { foreignKey: "permission_id" });
	Permission.hasMany(Role_Permission, { foreignKey: "permission_id" });
	Role_Permission.belongsTo(Role, { foreignKey: "role_id" });
	Role.hasMany(Role_Permission, { foreignKey: "role_id" });
	Ward.belongsTo(District, { foreignKey: "district_ward" });
	District.hasMany(Ward, { foreignKey: "district_ward" });

	return {
		Address,
		Assignment,
		City,
		District,
		Media,
		Order,
		Orderline,
		Permission,
		Product,
		Product_Media,
		Product_Variant,
		Role,
		Role_Permission,
		User,
		Ward,
	};
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
