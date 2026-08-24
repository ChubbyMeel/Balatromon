local BM = Balatromon

local FAMINED_KEY = BM.PREFIX .. '_famined'
local FASTING_KEY = BM.PREFIX .. '_fasting'

BM.FASTING_STICKER_RATE = 0.1

SMODS.Sticker {
    key = 'famined',

    atlas = 'Seal',
    pos = {x = 4, y = 0},

    loc_txt = {
        name = 'Famined',
        label = 'Famined',
        text = {
            'This Digimon gets',
            '{C:red}hungry{} every',
            '{C:attention}1{} round instead of 2'
        }
    },

    badge_colour = HEX('E87932'),

    sets = {
        Joker = true
    },

    default_compat = true,

    rate = 0,

    should_apply = function(self, card, center, area, bypass_roll)
        if not center
        or center.balatromon ~= true then
            return false
        end

        if card
        and card.ability
        and card.ability[FASTING_KEY] then
            return false
        end

        return SMODS.Sticker.should_apply(
            self,
            card,
            center,
            area,
            bypass_roll
        )
    end
}

SMODS.Sticker {
    key = 'fasting',

    atlas = 'Seal',
    pos = {x = 5, y = 0},

    loc_txt = {
        name = 'Fasting',
        label = 'Fasting',
        text = {
            'This Digimon gets',
            '{C:red}hungry{} every',
            '{C:attention}4{} rounds instead of 2'
        }
    },

    badge_colour = HEX('7FCB35'),

    sets = {
        Joker = true
    },

    default_compat = true,

    needs_enable_flag = false,

    rate = BM.FASTING_STICKER_RATE,

    should_apply = function(self, card, center, area, bypass_roll)
        if not center
        or center.balatromon ~= true then
            return false
        end

        if card
        and card.ability
        and (
            card.ability[FAMINED_KEY]
            or card.ability.perishable
        ) then
            return false
        end

        return SMODS.Sticker.should_apply(
            self,
            card,
            center,
            area,
            bypass_roll
        )
    end
}

if not BM._famined_perishable_patch then
    BM._famined_perishable_patch = true

    local old_set_perishable = Card.set_perishable

    Card.set_perishable = function(self, value)
        if value
        and BM.is_digimon(self) then
            self.ability.perishable = nil
            self.ability.perish_tally = nil

            if not self.ability[FASTING_KEY] then
                self:add_sticker(
                    FAMINED_KEY,
                    true
                )
            end

            return
        end

        return old_set_perishable(
            self,
            value
        )
    end
end