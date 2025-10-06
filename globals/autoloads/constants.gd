extends Node

const ARENA_SIZE_X = 29
const ARENA_SIZE_Y = 29

enum EnemyType { Knight, KnightCaptain, Mage }

const BASE_SPELL_DAMAGE = 60

const ENEMY_SPAWN_CHANCES = [
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15}
]
