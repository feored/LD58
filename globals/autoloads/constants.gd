extends Node

const ARENA_SIZE_X = 30
const ARENA_SIZE_Y = 30

enum EnemyType { Knight, KnightCaptain, Mage }

const BASE_SPELL_DAMAGE = 60

const ENEMY_SPAWN_CHANCES = [
	{EnemyType.Knight: 100, EnemyType.KnightCaptain: 0, EnemyType.Mage: 15},
	{EnemyType.Knight: 85, EnemyType.KnightCaptain: 0, EnemyType.Mage: 15},
	{EnemyType.Knight: 85, EnemyType.KnightCaptain: 0, EnemyType.Mage: 15},
	{EnemyType.Knight: 85, EnemyType.KnightCaptain: 5, EnemyType.Mage: 10},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 5, EnemyType.Mage: 15}
]
