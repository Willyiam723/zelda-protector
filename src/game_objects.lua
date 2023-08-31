--[[
    GD50
    Zelda Protector

    Author: Will Dong
    willyiam723@gmail.com
]]

GAME_OBJECT_DEFS = {
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        clickable = true,
        defaultState = 'full',
        states = {
            ['full'] = {
                frame = 5
            }
        }
    },
    ['flower'] = {
        type = 'tiles',
        texture = 'tiles',
        frame = 41,
        width = 16,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'solid',
        isShiny = true,
        states = {
            ['solid'] = {
                frame = 41
            }
        }
    },
    ['hammer-icon'] = {
        type = 'hammer-icon',
        texture = 'hammer-icon',
        frame = 1,
        width = 10,
        height = 10,
        solid = false,
        clickable = true,
        defaultState = 'unclicked',
        states = {
            ['unclicked'] = {
                frame = 1
            },
            ['clicked'] = {
                frame = 1
            }
        }
    },
    ['crossbow-icon'] = {
        type = 'crossbow-icon',
        texture = 'crossbow-icon',
        frame = 1,
        width = 10,
        height = 10,
        solid = false,
        clickable = true,
        defaultState = 'unclicked',
        states = {
            ['unclicked'] = {
                frame = 1
            },
            ['clicked'] = {
                frame = 1
            }
        }
    },
    ['rockets-icon'] = {
        type = 'rockets-icon',
        texture = 'rockets-icon',
        frame = 1,
        width = 10,
        height = 10,
        solid = false,
        clickable = true,
        defaultState = 'unclicked',
        states = {
            ['unclicked'] = {
                frame = 1
            },
            ['clicked'] = {
                frame = 1
            }
        }
    },
    ['arrow-left'] = {
        type = 'arrows-horizontal',
        texture = 'arrows-horizontal',
        frame = 4,
        width = 16,
        height = 5,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 4
            }
        }
    },
    ['arrow-right'] = {
        type = 'arrows-horizontal',
        texture = 'arrows-horizontal',
        frame = 5,
        width = 16,
        height = 5,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 5
            }
        }
    },
    ['arrow-up'] = {
        type = 'arrows-vertical',
        texture = 'arrows-vertical',
        frame = 2,
        width = 5,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 2
            }
        }
    },
    ['arrow-down'] = {
        type = 'arrows-vertical',
        texture = 'arrows-vertical',
        frame = 1,
        width = 5,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 1
            }
        }
    },
    ['bullet-left'] = {
        type = 'bullets-horizontal',
        texture = 'bullets-horizontal',
        frame = 3,
        width = 16,
        height = 8,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 3
            }
        }
    },
    ['bullet-right'] = {
        type = 'bullets-horizontal',
        texture = 'bullets-horizontal',
        frame = 4,
        width = 16,
        height = 8,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 4
            }
        }
    },
    ['bullet-up'] = {
        type = 'bullets-vertical',
        texture = 'bullets-vertical',
        frame = 2,
        width = 8,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 2
            }
        }
    },
    ['bullet-down'] = {
        type = 'bullets-vertical',
        texture = 'bullets-vertical',
        frame = 1,
        width = 8,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'fire',
        states = {
            ['fire'] = {
                frame = 1
            }
        }
    },
    ['coin'] = {
        type = 'coin',
        texture = 'coin',
        frame = 3,
        width = 16,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'solid',
        states = {
            ['solid'] = {
                frame = 3
            }
        }
    },
    ['sign'] = {
        type = 'sign',
        texture = 'sign',
        frame = 29,
        width = 16,
        height = 16,
        solid = true,
        clickable = false,
        defaultState = 'solid',
        states = {
            ['solid'] = {
                frame = 29
            }
        }
    }
}