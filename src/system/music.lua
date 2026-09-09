local function in_run()
    return
        G
        and G.STAGE == G.STAGES.RUN
end

local function booster_open()
    return
        G.booster_pack
        and not G.booster_pack.REMOVED
end

local function shop_open()
    return
        G.shop
        and not G.shop.REMOVED
        and not booster_open()
end

local function boss_active()
    return
        G.GAME
        and G.GAME.blind
        and G.GAME.blind.boss
        and not shop_open()
        and not booster_open()
end

SMODS.Sound {
    key = 'music_braveheart_regular',
    path = 'BraveHeart2.ogg',

    pitch = 1,
    volume = 1,

    select_music_track = function(self)
        if in_run()
        and not shop_open()
        and not boss_active() then
            return 100
        end
    end
}

SMODS.Sound {
    key = 'music_braveheart_shop',
    path = 'BraveHeart1.ogg',

    pitch = 1,
    volume = 1,

    select_music_track = function(self)
        if in_run()
        and shop_open() then
            return 200
        end
    end
}

SMODS.Sound {
    key = 'music_braveheart_boss',
    path = 'BraveHeart.ogg',

    pitch = 1,
    volume = 1,

    select_music_track = function(self)
        if in_run()
        and boss_active() then
            return 300
        end
    end
}