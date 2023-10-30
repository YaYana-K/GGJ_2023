extends Node

class_name Skins

enum Type{
	HORCE,
	COW,
	RACCOON,
	BEAVER,
	HAMSTER,
	CAT,
	RABBIT,
	DEER,
	LION,
	HUMANS
}
enum SkinType{
	DEFAULT,
	SCOUT,
	CROCODILE,
	WAITER,
	SPEARMEN,
	MAGICIAN,
	PIRATE,
	SHERIFF,
	FARMER
}

const skins = {
	Type.HORCE: {
		SkinType.DEFAULT: Rect2(0, 0, 187, 182),
		SkinType.SCOUT: Rect2(0, 1, 187, 182),
		SkinType.CROCODILE: Rect2(0, 2, 187, 182),
		SkinType.WAITER: Rect2(0, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(0, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(0, 5, 187, 182),
		SkinType.PIRATE: Rect2(0, 6, 187, 182),
		SkinType.SHERIFF: Rect2(0, 7, 187, 182),
		SkinType.FARMER: Rect2(0, 8, 187, 182),
	},
	Type.COW:{
		SkinType.DEFAULT: Rect2(1, 0, 187, 182),
		SkinType.SCOUT: Rect2(1, 1, 187, 182),
		SkinType.CROCODILE: Rect2(1, 2, 187, 182),
		SkinType.WAITER: Rect2(1, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(1, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(1, 5, 187, 182),
		SkinType.PIRATE: Rect2(1, 6, 187, 182),
		SkinType.SHERIFF: Rect2(1, 7, 187, 182),
		SkinType.FARMER: Rect2(1, 8, 187, 182),
	},
	Type.RACCOON: {
		SkinType.DEFAULT: Rect2(2, 0, 187, 182),
		SkinType.SCOUT: Rect2(2, 1, 187, 182),
		SkinType.CROCODILE: Rect2(2, 2, 187, 182),
		SkinType.WAITER: Rect2(2, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(2, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(2, 5, 187, 182),
		SkinType.PIRATE: Rect2(2, 6, 187, 182),
		SkinType.SHERIFF: Rect2(2, 7, 187, 182),
		SkinType.FARMER: Rect2(2, 8, 187, 182),
	},
	Type.BEAVER:{
		SkinType.DEFAULT: Rect2(3, 0, 187, 182),
		SkinType.SCOUT: Rect2(3, 1, 187, 182),
		SkinType.CROCODILE: Rect2(3, 2, 187, 182),
		SkinType.WAITER: Rect2(3, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(3, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(3, 5, 187, 182),
		SkinType.PIRATE: Rect2(3, 6, 187, 182),
		SkinType.SHERIFF: Rect2(3, 7, 187, 182),
		SkinType.FARMER: Rect2(3, 8, 187, 182),
	},
	Type.HAMSTER:{
		SkinType.DEFAULT: Rect2(4, 0, 187, 182),
		SkinType.SCOUT: Rect2(4, 1, 187, 182),
		SkinType.CROCODILE: Rect2(4, 2, 187, 182),
		SkinType.WAITER: Rect2(4, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(4, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(4, 5, 187, 182),
		SkinType.PIRATE: Rect2(4, 6, 187, 182),
		SkinType.SHERIFF: Rect2(4, 7, 187, 182),
		SkinType.FARMER: Rect2(4, 8, 187, 182),
	},
	Type.CAT:{
		SkinType.DEFAULT: Rect2(5, 0, 187, 182),
		SkinType.SCOUT: Rect2(5, 1, 187, 182),
		SkinType.CROCODILE: Rect2(5, 2, 187, 182),
		SkinType.WAITER: Rect2(5, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(5, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(5, 5, 187, 182),
		SkinType.PIRATE: Rect2(5, 6, 187, 182),
		SkinType.SHERIFF: Rect2(5, 7, 187, 182),
		SkinType.FARMER: Rect2(5, 8, 187, 182),
	},
	Type.RABBIT:{
		SkinType.DEFAULT: Rect2(6, 0, 187, 182),
		SkinType.SCOUT: Rect2(6, 1, 187, 182),
		SkinType.CROCODILE: Rect2(6, 2, 187, 182),
		SkinType.WAITER: Rect2(6, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(6, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(6, 5, 187, 182),
		SkinType.PIRATE: Rect2(6, 6, 187, 182),
		SkinType.SHERIFF: Rect2(6, 7, 187, 182),
		SkinType.FARMER: Rect2(6, 8, 187, 182),
	},
	Type.DEER:{
		SkinType.DEFAULT: Rect2(7, 0, 187, 182),
		SkinType.SCOUT: Rect2(7, 1, 187, 182),
		SkinType.CROCODILE: Rect2(7, 2, 187, 182),
		SkinType.WAITER: Rect2(7, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(7, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(7, 5, 187, 182),
		SkinType.PIRATE: Rect2(7, 6, 187, 182),
		SkinType.SHERIFF: Rect2(7, 7, 187, 182),
		SkinType.FARMER: Rect2(7, 8, 187, 182),
	},
	Type.LION:{
		SkinType.DEFAULT: Rect2(8, 0, 187, 182),
		SkinType.SCOUT: Rect2(8, 1, 187, 182),
		SkinType.CROCODILE: Rect2(8, 2, 187, 182),
		SkinType.WAITER: Rect2(8, 3, 187, 182),
		SkinType.SPEARMEN: Rect2(8, 4, 187, 182),
		SkinType.MAGICIAN: Rect2(8, 5, 187, 182),
		SkinType.PIRATE: Rect2(8, 6, 187, 182),
		SkinType.SHERIFF: Rect2(8, 7, 187, 182),
		SkinType.FARMER: Rect2(8, 8, 187, 182),
	}
}

static func get_player_skin(type: Type, skin: SkinType):
	return skins[type][skin]
