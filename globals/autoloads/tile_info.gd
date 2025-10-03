extends Node

static var INFO = {
    "road":
    {
        "path": "res://tiles/Road/road1.gltf",
        "icon": "res://tiles/Road/road1.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true,
    },
    "road_split":
    {
        "path": "res://tiles/Road/road2.gltf",
        "icon": "res://tiles/Road/road2.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true
    },
    "road_end":
    {
        "path": "res://tiles/Road/road_end.gltf",
        "icon": "res://tiles/Road/roadend.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true
    },
    "road_corner":
    {
        "path": "res://tiles/Road/road_corner.gltf",
        "icon": "res://tiles/Road/OTA_ground textures.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true
    },
    "asphalt":
    {
        "path": "res://tiles/Road/asphalt.gltf",
        "icon": "res://tiles/Road/asphalt.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true
    },
    "sand":
    {
        "path": "res://tiles/Ground/sand.gltf",
        "icon": "res://tiles/Ground/sandground.jpg",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true
    },
    "apps":
    {
        "path": "res://tiles/apps/apps.gltf",
        "icon": "res://tiles/apps/apps.png",
        "default_height": 0,
        "size": Vector3i(1, 2, 1),
        "walkable": false
    },
    "apps_small":
    {
        "path": "res://tiles/apps/apps_small.gltf",
        "icon": "res://tiles/apps/apps_small.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": false

    },
    "refinery":
        ## TODO: Is centered but origin should be at 0,0
    {
        "path": "res://tiles/Factory/Refinery.gltf",
        "icon": "res://tiles/Factory/refinery_icon.png",
        "default_height": 0,
        "size": Vector3i(2, 1, 3),
        "walkable": false

    },
    "parkinglot":
    {
        "path": "res://tiles/apps/parkinglot.gltf",
        "icon": "res://tiles/Factory/refinery_icon.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 2),
        "walkable": true

    },
    "spawn_enemy_1x1":
    {
        "path": "res://tiles/special/spawns/enemy_1x1.tscn",
        "icon": "res://tiles/special/spawns/enemy_1x1.png",
        "default_height": 0,
        "size": Vector3i(1, 1, 1),
        "walkable": true,
    },
    "spawn_allied_3x2":
    {
        "path": "res://tiles/special/spawns/allied_3x2.tscn",
        "icon": "res://tiles/special/spawns/allied_3x2.png",
        "default_height": 0,
        "size": Vector3i(3, 1, 2),
        "walkable": true,
    }
}

static var EDITOR_ONLY = ["spawn_enemy_1x1", "spawn_allied_3x2"]

static var FOLDERS = {
    "Ground": ["road", "sand", "road_split", "road_end", "road_corner", "asphalt"],
    "Buildings": ["apps", "apps_small", "refinery", "parkinglot"],
    "Special": ["spawn_enemy_1x1", "spawn_allied_3x2"]
}


func get_instance(tile_name: String) -> Node3D:
    return load(TileInfo.INFO[tile_name]["path"]).instantiate()
