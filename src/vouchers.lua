local BM = Balatromon

SMODS.Voucher {
    key = 'classic_goggles',

    atlas = 'Voucher',
    pos = {x = 0, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Classic Goggles',
        text = {
            '{C:attention}Digi Items{} appear',
            '{C:attention}2X{} more frequently',
            'in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_digi_item_shop_mult = 2

        G.GAME.digiitem_rate = 2
    end,
}


SMODS.Voucher {
    key = 'digidestined',

    atlas = 'Voucher',
    pos = {x = 1, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    requires = {
        'v_DigiMeel_classic_goggles'
    },

    loc_txt = {
        name = 'Digidestined',
        text = {
            '{C:attention}Digi Items{} appear',
            '{C:attention}4X{} more frequently',
            'in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_digi_item_shop_mult = 4

        G.GAME.digiitem_rate = 4
    end,
}



SMODS.Voucher {
    key = 'digivice_abundance',

    atlas = 'Voucher',
    pos = {x = 2, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    loc_txt = {
        name = 'Digivice Abundance',
        text = {
            '{C:attention}Rookie{} and {C:attention}Champion{}',
            'Digimon appear more',
            'frequently in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_digivice_abundance = true
    end,
}



SMODS.Voucher {
    key = 'mega_digivolution',

    atlas = 'Voucher',
    pos = {x = 3, y = 0},

    cost = 10,

    discovered = false,
    unlocked = true,

    requires = {
        'v_DigiMeel_digivice_abundance'
    },

    loc_txt = {
        name = 'Mega Digivolution',
        text = {
            '{C:attention}Ultimate{} Digimon',
            'can now appear',
            'in the shop'
        }
    },

    redeem = function(self, card)
        G.GAME.balatromon_mega_digivolution = true
    end,
}