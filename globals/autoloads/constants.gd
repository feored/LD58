extends Node

const ARENA_SIZE_X = 29
const ARENA_SIZE_Y = 29

enum EnemyType { Knight, KnightCaptain, Mage }

const BASE_SPELL_DAMAGE = 60

const ENEMY_SPAWN_CHANCES = [
	{EnemyType.Knight: 100, EnemyType.KnightCaptain: 0, EnemyType.Mage: 0},
	{EnemyType.Knight: 80, EnemyType.KnightCaptain: 0, EnemyType.Mage: 20},
	{EnemyType.Knight: 70, EnemyType.KnightCaptain: 10, EnemyType.Mage: 20},
	{EnemyType.Knight: 50, EnemyType.KnightCaptain: 20, EnemyType.Mage: 30},
	{EnemyType.Knight: 30, EnemyType.KnightCaptain: 30, EnemyType.Mage: 40}
]
