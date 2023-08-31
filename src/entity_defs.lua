--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

ENTITY_DEFS = {
    ['protector-hammer'] = {
        walkSpeed = PROTECTOR_WALK_SPEED,
        price = PROTECTOR_HAMMER_PRICE,
        attack = PROTECTOR_HAMMER_ATTACK,
        animations = {
            ['hammer-idle-left'] = {
                frames = {7},
                texture = 'hammer'
            },
            ['hammer-idle-right'] = {
                frames = {13},
                texture = 'hammer'
            },
            ['hammer-idle-down'] = {
                frames = {1},
                texture = 'hammer'
            },
            ['hammer-idle-up'] = {
                frames = {19},
                texture = 'hammer'
            },
            ['hammer-left'] = {
                frames = {7, 8, 9, 10, 11, 12},
                interval = 0.08,
                looping = false,
                texture = 'hammer'
            },
            ['hammer-right'] = {
                frames = {13, 14, 15, 16, 17, 18},
                interval = 0.08,
                looping = false,
                texture = 'hammer'
            },
            ['hammer-down'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.08,
                looping = false,
                texture = 'hammer'
            },
            ['hammer-up'] = {
                frames = {19, 20, 21, 22, 23, 24},
                interval = 0.08,
                looping = false,
                texture = 'hammer'
            }
        }
    },
    ['protector-crossbow'] = {
        walkSpeed = PROTECTOR_WALK_SPEED,
        price = PROTECTOR_CROSSBOW_PRICE,
        attack = PROTECTOR_CROSSBOW_ATTACK,
        animations = {
            ['crossbow-idle-left'] = {
                frames = {7},
                texture = 'crossbow'
            },
            ['crossbow-idle-right'] = {
                frames = {13},
                texture = 'crossbow'
            },
            ['crossbow-idle-down'] = {
                frames = {1},
                texture = 'crossbow'
            },
            ['crossbow-idle-up'] = {
                frames = {19},
                texture = 'crossbow'
            },
            ['crossbow-left'] = {
                frames = {7, 8, 9, 10, 11, 12},
                interval = 0.08,
                looping = false,
                texture = 'crossbow'
            },
            ['crossbow-right'] = {
                frames = {13, 14, 15, 16, 17, 18},
                interval = 0.08,
                looping = false,
                texture = 'crossbow'
            },
            ['crossbow-down'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.08,
                looping = false,
                texture = 'crossbow'
            },
            ['crossbow-up'] = {
                frames = {19, 20, 21, 22, 23, 24},
                interval = 0.08,
                looping = false,
                texture = 'crossbow'
            }
        }
    },
    ['protector-rockets'] = {
        walkSpeed = PROTECTOR_WALK_SPEED,
        price = PROTECTOR_ROCKETS_PRICE,
        attack = PROTECTOR_ROCKETS_ATTACK,
        animations = {
            ['rockets-idle-left'] = {
                frames = {7},
                texture = 'rockets'
            },
            ['rockets-idle-right'] = {
                frames = {13},
                texture = 'rockets'
            },
            ['rockets-idle-down'] = {
                frames = {1},
                texture = 'rockets'
            },
            ['rockets-idle-up'] = {
                frames = {19},
                texture = 'rockets'
            },
            ['rockets-left'] = {
                frames = {7, 8, 9, 10, 11, 12},
                interval = 0.15,
                looping = false,
                texture = 'rockets'
            },
            ['rockets-right'] = {
                frames = {13, 14, 15, 16, 17, 18},
                interval = 0.15,
                looping = false,
                texture = 'rockets'
            },
            ['rockets-down'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.15,
                looping = false,
                texture = 'rockets'
            },
            ['rockets-up'] = {
                frames = {19, 20, 21, 22, 23, 24},
                interval = 0.15,
                looping = false,
                texture = 'rockets'
            }
        }
    },
    ['bull'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {22, 23, 24, 23},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {34, 35, 36, 35},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {10, 11, 12, 11},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {46, 47, 48, 47},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {23},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {35},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {11},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {47},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_ONE_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_ONE
    },
    ['pig'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {19, 20, 21, 20},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {31, 32, 33, 32},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {7, 8, 9, 8},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {43, 44, 45, 44},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {20},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {32},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {8},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {44},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_ONE_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_ONE
    },
    ['bat'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {13, 14, 15, 14},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {25, 26, 27, 26},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 2},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {37, 38, 39, 38},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {14},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {26},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {2},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {38},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_TWO_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_TWO
    },
    ['frog'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {16, 17, 18, 17},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {28, 29, 30, 29},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {4, 5, 6, 5},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {40, 41, 42, 41},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {17},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {29},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {41},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_TWO_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_TWO
    },
    ['devil'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {61, 62, 63, 62},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {73, 74, 75, 74},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {49, 50, 51, 50},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {85, 86, 87, 86},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {62},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {74},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {50},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {86},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_THREE_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_THREE
    },
    ['skeleton'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {52, 53, 54, 53},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {88, 89, 90, 89},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {65},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {77},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {53},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {89},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_THREE_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_THREE
    },
    ['ghost'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {67, 68, 69, 68},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {79, 80, 81, 80},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {55, 56, 57, 56},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {91, 92, 93, 92},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {68},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {80},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {56},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {92},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_FOUR_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_FOUR
    },
    ['demon'] = {
        texture = 'monsters',
        animations = {
            ['walk-left'] = {
                frames = {70, 71, 72, 71},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-right'] = {
                frames = {82, 83, 84, 83},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-down'] = {
                frames = {58, 59, 60, 59},
                interval = 0.2,
                texture = 'monsters'
            },
            ['walk-up'] = {
                frames = {94, 95, 96, 95},
                interval = 0.2,
                texture = 'monsters'
            },
            ['idle-left'] = {
                frames = {71},
                texture = 'monsters'
            },
            ['idle-right'] = {
                frames = {83},
                texture = 'monsters'
            },
            ['idle-down'] = {
                frames = {59},
                texture = 'monsters'
            },
            ['idle-up'] = {
                frames = {95},
                texture = 'monsters'
            }
        },
        reward = REWARD_LEVEL_FOUR_ENEMY,
        walkSpeed = ENEMY_WALK_SPEED_LEVEL_FOUR
    },
    ['zelda'] = {
        texture = 'zelda',
        animations = {
            ['5-health'] = {
                frames = {2},
                texture = 'zelda-stand'
            },
            ['4-health'] = {
                frames = {3},
                texture = 'zelda-stand'
            },
            ['3-health'] = {
                frames = {26},
                texture = 'zelda-stand'
            },
            ['2-health'] = {
                frames = {49},
                texture = 'zelda-fall'
            },
            ['1-health'] = {
                frames = {48},
                texture = 'zelda-fall'
            },
            ['dead'] = {
                frames = {1},
                texture = 'zelda-stand'
            }
        }
    },
    ['flower'] = {
        texture = 'tiles',
        animations = {
            ['idle-left'] = {
                frames = {41},
                texture = 'tiles'
            },
            ['idle-right'] = {
                frames = {41},
                texture = 'tiles'
            },
            ['idle-down'] = {
                frames = {41},
                texture = 'tiles'
            },
            ['idle-up'] = {
                frames = {41},
                texture = 'tiles'
            }
        },
        reward = REWARD_LEVEL_FOUR_ENEMY,
        walkSpeed = 0
    }
}