local BM = Balatromon

do
    local slug = 'botamon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Botamon', text={
            '{C:mult}+2{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Koromon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Botamon', stage=stage, evolves_to='Koromon', effect='+2 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'koromon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Koromon', text={
            '{C:mult}+4{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Agumon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Koromon', stage=stage, evolves_to='Agumon', effect='+4 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'agumon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Agumon', text={
            '{C:mult}+6{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Greymon, Tyrannomon, Numemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Agumon', stage=stage, evolves_to='Greymon, Tyrannomon, Numemon', effect='+6 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'greymon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Greymon', text={
            '{X:mult,C:white}X2{} Mult if played hand contains {C:attention}#4#{}',
            '{C:inactive}(rank changes at end of round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGreymon, SkullGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'greymon_rank') or e.target_rank or 14
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank)}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Greymon', stage=stage, evolves_to='MetalGreymon, SkullGreymon', effect='X2 Mult if played hand contains [Rank] (rank changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'metalgreymon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MetalGreymon', text={
            '{X:mult,C:white}X3{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WarGreymon, Machinedramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MetalGreymon', stage=stage, evolves_to='WarGreymon, Machinedramon', effect='X3 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'skullgreymon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='SkullGreymon', text={
            'Gain {X:mult,C:white}X0.25{} Mult every time a card is destroyed',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'BlackWarGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='SkullGreymon', stage=stage, evolves_to='BlackWarGreymon', effect='Gain X0.25 Mult every time a card is destroyed'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'tyrannomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Tyrannomon', text={
            '{X:mult,C:white}X2{} Mult if played hand contains {V:1}#4#{}',
            '{C:inactive}(suit changes at end of round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGreymon, SkullGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'tyrannomon_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_suit, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Tyrannomon', stage=stage, evolves_to='MetalGreymon, SkullGreymon', effect='X2 Mult if played hand contains [Suit] (suit changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'numemon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Numemon', text={
            '{X:mult,C:white}X2{} Mult',
            '{C:inactive}(-X0.01 Mult for every discarded card){}',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Garbagemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 2}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Numemon', stage=stage, evolves_to='Garbagemon', effect='X2 Mult (-X0.01 Mult for every discarded card)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'garbagemon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Garbagemon', text={
            'Gain {X:mult,C:white}X0.75{} Mult for every {C:attention}#4#{} Discarded. Reset',
            'at the end of the round',
            '{C:inactive}(rank changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'garbage_rank') or e.target_rank or 14
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),e.round_xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Garbagemon', stage=stage, evolves_to='-', effect='Gain X0.75 Mult for every [Rank] Discarded. Reset at the end of the round (rank changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'wargreymon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='WarGreymon', text={
            'Gain {X:mult,C:white}X0.5{} Mult for every {C:attention}#4#{} of {V:1}#5#{} Played',
            '{C:inactive}(Upgrade limited once per card including',
            'retrigger){} {C:inactive}(card changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=0},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'wargrey_rank') or e.target_rank or 14
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'wargrey_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),target_suit,e.xmult or 1, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='WarGreymon', stage=stage, evolves_to='-', effect='Gain X0.5 Mult for every [Rank] of [Suit] Played (Upgrade limited once per card including retrigger) (card changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'machinedramon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Machinedramon', text={
            'Gain {X:mult,C:white}X0.5{} Mult for every {C:attention}#4#{} of {V:1}#5#{} Held in',
            'hand at the end of the round',
            '{C:inactive}(card changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'machine_rank') or e.target_rank or 14
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'machine_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),target_suit,e.xmult or 1, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Machinedramon', stage=stage, evolves_to='-', effect='Gain X0.5 Mult for every [Rank] of [Suit] Held in hand at the end of the round (card changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'blackwargreymon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='BlackWarGreymon', text={
            'Gain {X:mult,C:white}X0.5{} Mult every time a card is destroyed',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='BlackWarGreymon', stage=stage, evolves_to='-', effect='Gain X0.5 Mult every time a card is destroyed'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'jyarimon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Jyarimon', text={
            '{C:mult}+8{} Mult if played hand contains a Pair',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gigimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Jyarimon', stage=stage, evolves_to='Gigimon', effect='+8 Mult if played hand contains a Pair'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gigimon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gigimon', text={
            '{C:mult}+9{} Mult if played hand contains Two Pair',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Guilmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gigimon', stage=stage, evolves_to='Guilmon', effect='+9 Mult if played hand contains Two Pair'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'guilmon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Guilmon', text={
            '{C:mult}+10{} Mult if played hand contains a Flush',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Growlmon, Numemon, Monochromon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Guilmon', stage=stage, evolves_to='Growlmon, Numemon, Monochromon', effect='+10 Mult if played hand contains a Flush'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'growlmon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Growlmon', text={
            '{C:mult}+17{} Mult if played hand contains Four of a',
            'Kind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WarGrowlmon, Megadramon, Gigadramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Growlmon', stage=stage, evolves_to='WarGrowlmon, Megadramon, Gigadramon', effect='+17 Mult if played hand contains Four of a Kind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'monochromon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Monochromon', text={
            'Add to Mult the highest valued card in played',
            'hand and make it gold',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Mammothmon, Triceramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Monochromon', stage=stage, evolves_to='Mammothmon, Triceramon', effect='Add to Mult the highest valued card in played hand and make it gold'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'wargrowlmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='WarGrowlmon', text={
            'Gain {C:mult}+10{} Mult every time {C:attention}#4#{} is played',
            '{C:inactive}(poker hand changes at end of round){}',
            '{C:inactive}(Currently {C:mult}+#5#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gallantmon, BlackWarGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_target(card,'target_hand',BM.HANDS,'wargrowl_hand') or e.target_hand or 'High Card'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_hand,e.mult or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='WarGrowlmon', stage=stage, evolves_to='Gallantmon, BlackWarGreymon', effect='Gain +10 Mult every time [poker hand] is played (poker hand changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'megadramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Megadramon', text={
            'Make the non-enhanced highest value card and',
            'all of its rank held in hand into steel cards',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Machinedramon, BlackWarGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Megadramon', stage=stage, evolves_to='Machinedramon, BlackWarGreymon', effect='Make the non-enhanced highest value card and all of its rank held in hand into steel cards'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gigadramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gigadramon', text={
            'Add to Mult double the lowest valued card held',
            'in hand',
            '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=1},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Machinedramon, BlackWarGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = 0; if G.hand and G.hand.cards then local _,r=BM.lowest_card(G.hand.cards); if r and r<math.huge then current=r*2 end end
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gigadramon', stage=stage, evolves_to='Machinedramon, BlackWarGreymon', effect='Add to Mult double the lowest valued card held in hand'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'mammothmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Mammothmon', text={
            'If the played hand contains scoring Diamond,',
            'Club, Heart, and Spade, gain {C:money}$20{}, {C:chips}+50{} Chips',
            'and {X:mult,C:white}X2{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Vikemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Mammothmon', stage=stage, evolves_to='Vikemon', effect='If the played hand contains scoring Diamond, Club, Heart, and Spade, gain $20, +50 Chips and X2 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'triceramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Triceramon', text={
            '{X:mult,C:white}X4{} Mult if played hand contains {C:attention}#4#{}',
            '{C:inactive}(poker hand changes every hand){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WarGreymon, BlackWarGreymon, HeavyLeomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_target(card,'target_hand',BM.HANDS,'tricera_hand') or e.target_hand or 'High Card'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_hand}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Triceramon', stage=stage, evolves_to='WarGreymon, BlackWarGreymon, HeavyLeomon', effect='X4 Mult if played hand contains [poker hand] (poker hand changes every hand)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gallantmon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gallantmon', text={
            'Gives {X:mult,C:white}X#4#{} Mult',
            "{C:inactive}(1/3 of its previous form\'s stored value)",
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local previous=e.previous_form_value
            if previous == nil then previous = 3 end
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,previous/3}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gallantmon', stage=stage, evolves_to='-', effect='X[1/3 of the previous values of this card when it was unevolved] Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'cotsucomon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Cotsucomon', text={
            'Reduce score requirement to beat small and big',
            'blind by 2%',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Kakkinmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Cotsucomon', stage=stage, evolves_to='Kakkinmon', effect='Reduce score requirement to beat small and big blind by 2%'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'kakkinmon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Kakkinmon', text={
            'Reduce score requirement to beat small and big',
            'blind by 3%',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Ludomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Kakkinmon', stage=stage, evolves_to='Ludomon', effect='Reduce score requirement to beat small and big blind by 3%'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'ludomon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Ludomon', text={
            'Reduce score requirement to beat small and big',
            'blind by 5%',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'TiaLudomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Ludomon', stage=stage, evolves_to='TiaLudomon', effect='Reduce score requirement to beat small and big blind by 5%'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'tialudomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='TiaLudomon', text={
            'Reduce score requirement to beat any blind by',
            '10%',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'RaijiLudomon, Knightmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='TiaLudomon', stage=stage, evolves_to='RaijiLudomon, Knightmon', effect='Reduce score requirement to beat any blind by 10%'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'raijiludomon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='RaijiLudomon', text={
            'Reduce score requirement to beat any blind by',
            '25%',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'BryweLudramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='RaijiLudomon', stage=stage, evolves_to='BryweLudramon', effect='Reduce score requirement to beat any blind by 25%'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'knightmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Knightmon', text={
            'Gain {C:mult}+6{} Mult for every hand played that does',
            'not win',
            '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gallantmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.mult or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Knightmon', stage=stage, evolves_to='Gallantmon', effect='Gain +6 Mult for every hand played that does not win'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'bryweludramon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='BryweLudramon', text={
            'Disable boss blind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=2},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='BryweLudramon', stage=stage, evolves_to='-', effect='Disable boss blind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'punimon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Punimon', text={
            '{C:chips}+20{} Chips',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Tsunomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Punimon', stage=stage, evolves_to='Tsunomon', effect='+20 Chips'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'tsunomon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Tsunomon', text={
            '{C:chips}+90{} Chips',
            '{C:inactive}(-5 Chips per discard used){}',
            '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gabumon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = 90 - 5 * (e.discards or 0)
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Tsunomon', stage=stage, evolves_to='Gabumon', effect='+90 Chips (-5 Chips per discard used)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gabumon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gabumon', text={
            'Gain {C:chips}+8{} Chips if hand played contains a',
            'scoring face card after a scoring numbered',
            'card',
            '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Garurumon, Numemon, Leomon, MadLeomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.chips or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gabumon', stage=stage, evolves_to='Garurumon, Numemon, Leomon, MadLeomon', effect='Gain +8 Chips if hand played contains a scoring face card after a scoring numbered card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'garurumon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Garurumon', text={
            'Gain {C:chips}+10{} Chips if played hand contains a',
            'scoring face card',
            '{C:inactive}(carried over Chips from Gabumon){}',
            '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'WereGarurumon, Mammothmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.chips or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Garurumon', stage=stage, evolves_to='WereGarurumon, Mammothmon', effect='Gain +10 Chips if played hand contains a scoring face card (carried over Chips from Gabumon)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'leomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Leomon', text={
            'Gain {C:chips}+15{} Chips if played hand contains {C:attention}#4#{}',
            '{C:inactive}(carried over Chips from Gabumon){} {C:inactive}(poker hand',
            'changes at end of round){}',
            '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'LoaderLeomon, Knightmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_target(card,'target_hand',BM.HANDS,'leomon_hand') or e.target_hand or 'High Card'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_hand,e.chips or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Leomon', stage=stage, evolves_to='LoaderLeomon, Knightmon', effect='Gain +15 Chips if played hand contains [poker hand] (carried over Chips from Gabumon) (poker hand changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'madleomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MadLeomon', text={
            '{C:chips}+1000{} Chips',
            '{C:inactive}(-100 Chips for each card of hand size){}',
            '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'LoaderLeomon, Knightmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = 1000 - 100 * (G.hand and G.hand.config and G.hand.config.card_limit or 0)
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MadLeomon', stage=stage, evolves_to='LoaderLeomon, Knightmon', effect='+1000 Chips (-100 Chips for each card of hand size)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'weregarurumon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='WereGarurumon', text={
            'Gain {C:chips}+20{} Chips if {C:attention}#4#{} is discarded.',
            '{C:inactive}(can upgrade once per discard){} {C:inactive}(rank changes',
            'every round){}',
            '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalGarurumon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'weregaruru_rank') or e.target_rank or 14
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),e.chips or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='WereGarurumon', stage=stage, evolves_to='MetalGarurumon', effect='Gain +20 Chips if [Rank] is discarded. (can upgrade once per discard) (rank changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'loaderleomon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='LoaderLeomon', text={
            'Gain {C:chips}+50{} Chips if {C:attention}#4#{} is discarded.',
            '{C:inactive}(poker hand changes at end of round){}',
            '{C:inactive}(Currently {C:chips}+#5#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HeavyLeomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_hand=card and BM.ensure_target(card,'target_hand',BM.HANDS,'loader_hand') or e.target_hand or 'High Card'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_hand,e.chips or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='LoaderLeomon', stage=stage, evolves_to='HeavyLeomon', effect='Gain +50 Chips if [poker hand] is discarded. (poker hand changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'metalgarurumon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MetalGarurumon', text={
            'Gain {X:chips,C:white}X0.25{} Chips for every {C:attention}#4#{} of {V:1}#5#{} Played',
            '{C:inactive}(Upgrade limited once per card including',
            'retrigger){} {C:inactive}(card changes at end of round){}',
            '{C:inactive}(Currently {X:chips,C:white}X#6#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'metalgaruru_rank') or e.target_rank or 14
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'metalgaruru_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),target_suit,e.xchips or 1, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MetalGarurumon', stage=stage, evolves_to='-', effect='Gain X0.25 Chips for every [Rank] of [Suit] Played (Upgrade limited once per card including retrigger) (card changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'heavyleomon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='HeavyLeomon', text={
            'Gain {X:chips,C:white}X0.25{} Chips every time the least played',
            'poker hand is upgraded',
            '{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=3},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xchips or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='HeavyLeomon', stage=stage, evolves_to='-', effect='Gain X0.25 Chips every time the least played poker hand is upgraded'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'monzaemon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Monzaemon', text={
            'Create a tarot card when blind is selected',
            '{C:inactive}(must have room){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return true
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Monzaemon', stage=stage, evolves_to='-', effect='Create a tarot card when blind is selected (must have room)'}
    local weight = 10
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
        key = BM.center_key(slug),
        weight = weight,
        stage = stage}
end

do
    local slug = 'warumonzaemon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='WaruMonzaemon', text={
            'Create 2 Food items at the end of a round',
            '{C:inactive}(must have room){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return true
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='WaruMonzaemon', stage=stage, evolves_to='-', effect='Create 2 Food items at the end of a round (must have room)'}
    local weight = 4
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
        key = BM.center_key(slug),
        weight = weight,
        stage = stage}
end

do
    local slug = 'polarbearmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='PolarBearmon', text={
            'All planet cards and celestial booster packs',
            'cost {C:money}$2{} less',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return true
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='PolarBearmon', stage=stage, evolves_to='-', effect='All planet cards and celestial booster packs cost $2 less'}
    local weight = 4
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
        key = BM.center_key(slug),
        weight = weight,
        stage = stage}
end

do
    local slug = 'pichimon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Pichimon', text={
            '{C:chips}+50{} Chips if played hand contains a Pair',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Bukamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Pichimon', stage=stage, evolves_to='Bukamon', effect='+50 Chips if played hand contains a Pair'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'bukamon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Bukamon', text={
            '{C:chips}+100{} Chips if played hand contains Three of a',
            'Kind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gomamon, Crabmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Bukamon', stage=stage, evolves_to='Gomamon, Crabmon', effect='+100 Chips if played hand contains Three of a Kind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gomamon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gomamon', text={
            '{C:chips}+80{} Chips if played hand contains a Flush',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Ikkakumon, Shellmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gomamon', stage=stage, evolves_to='Ikkakumon, Shellmon', effect='+80 Chips if played hand contains a Flush'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'crabmon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Crabmon', text={
            '{C:chips}+160{} Chips if played hand contains a Straight',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Seadramon, Shellmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Crabmon', stage=stage, evolves_to='Seadramon, Shellmon', effect='+160 Chips if played hand contains a Straight'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'ikkakumon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Ikkakumon', text={
            'Gives {C:chips}+5{} Chips for every unenhanced cards',
            'played this hand',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Zudomon, Mammothmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Ikkakumon', stage=stage, evolves_to='Zudomon, Mammothmon', effect='Gives +5 Chips for every unenhanced cards played this hand'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'shellmon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Shellmon', text={
            'Add a stone card when blind is selected',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MarineBullmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Shellmon', stage=stage, evolves_to='MarineBullmon', effect='Add a stone card when blind is selected'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'seadramon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Seadramon', text={
            'Every face card gives {C:chips}+30{} Chips',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=4},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MegaSeadramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Seadramon', stage=stage, evolves_to='MegaSeadramon', effect='Every face card gives +30 Chips'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'zudomon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Zudomon', text={
            'Gives {C:chips}+100{} Chips and {C:money}$8{} when boss blind effect',
            'is activated',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Vikemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Zudomon', stage=stage, evolves_to='Vikemon', effect='Gives +100 Chips and $8 when boss blind effect is activated'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'marinebullmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MarineBullmon', text={
            'Gives {C:chips}+25{} Chips for each Stone Card in your',
            'full deck',
            '{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Hydramon, Vikemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = 25 * BM.count_deck_enhancement('m_stone')
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MarineBullmon', stage=stage, evolves_to='Hydramon, Vikemon', effect='Gives +25 Chips for each Stone Card in your full deck'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'megaseadramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MegaSeadramon', text={
            'Face card played gets {C:chips}+30{} Chips permanently',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MetalSeadramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MegaSeadramon', stage=stage, evolves_to='MetalSeadramon', effect='Face card played gets +30 Chips permanently'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'vikemon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Vikemon', text={
            '{C:chips}+1000{} Chips, -3 hand size',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Vikemon', stage=stage, evolves_to='-', effect='+1000 Chips, -3 hand size'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'hydramon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Hydramon', text={
            'Each played stone card gives {C:mult}+20{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Hydramon', stage=stage, evolves_to='-', effect='Each played stone card gives +20 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'metalseadramon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MetalSeadramon', text={
            'Cards played gain {C:chips}+50{} Chips permanently',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MetalSeadramon', stage=stage, evolves_to='-', effect='Cards played gain +50 Chips permanently'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'poyomon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Poyomon', text={
            'Each played lucky card gives {C:mult}+2{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Tokomon, Pagumon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Poyomon', stage=stage, evolves_to='Tokomon, Pagumon', effect='Each played lucky card gives +2 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'tokomon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Tokomon', text={
            'Create a negative magician at the end of a',
            'boss blind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Patamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Tokomon', stage=stage, evolves_to='Patamon', effect='Create a negative magician at the end of a boss blind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'patamon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Patamon', text={
            'If the first played card is a single card,',
            'turn it into a lucky card',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Angemon, Pegasusmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Patamon', stage=stage, evolves_to='Angemon, Pegasusmon', effect='If the first played card is a single card, turn it into a lucky card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'angemon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Angemon', text={
            'All played cards with rank 7 turn to lucky',
            'cards. Also applies Patamon’s effect',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=5},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MagnaAngemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Angemon', stage=stage, evolves_to='MagnaAngemon', effect='All played cards with rank 7 turn to lucky cards. Also applies Patamon’s effect'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'pegasusmon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Pegasusmon', text={
            'Double any probability',
            '{C:inactive}(eg, {C:green}1 in 3{} to 2 in 3){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MagnaAngemon, HippoGryphonmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Pegasusmon', stage=stage, evolves_to='MagnaAngemon, HippoGryphonmon', effect='Double any probability (eg, 1 in 3 to 2 in 3)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'magnaangemon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MagnaAngemon', text={
            'Gain {X:mult,C:white}X0.3{} Mult every time a Lucky Card',
            'triggers',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Seraphimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MagnaAngemon', stage=stage, evolves_to='Seraphimon', effect='Gain X0.3 Mult every time a Lucky Card triggers'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'seraphimon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Seraphimon', text={
            'Lucky cards can give {X:mult,C:white}X2{} Mult on money hit',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Seraphimon', stage=stage, evolves_to='-', effect='Lucky cards can give X2 Mult on money hit'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'yukimibotamon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='YukimiBotamon', text={
            'Each played glass card gives {C:chips}+30{} Chips',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Nyaromon, Pagumon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='YukimiBotamon', stage=stage, evolves_to='Nyaromon, Pagumon', effect='Each played glass card gives +30 Chips'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'nyaromon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Nyaromon', text={
            'Create 2 negative justice at the end of a boss',
            'blind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Salamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Nyaromon', stage=stage, evolves_to='Salamon', effect='Create 2 negative justice at the end of a boss blind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'salamon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Salamon', text={
            'If the first played card is a single card,',
            'turn it into a glass card',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gatomon, Nefertimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Salamon', stage=stage, evolves_to='Gatomon, Nefertimon', effect='If the first played card is a single card, turn it into a glass card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gatomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gatomon', text={
            'All played face cards turn to lucky cards,',
            'Also applies Salamon’s effect',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Angewomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gatomon', stage=stage, evolves_to='Angewomon', effect='All played face cards turn to lucky cards, Also applies Salamon’s effect'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'nefertimon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Nefertimon', text={
            'Reduce any probability by half',
            '{C:inactive}(eg, {C:green}1 in 3{} to 0.5 in 3){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Angewomon, HippoGryphonmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Nefertimon', stage=stage, evolves_to='Angewomon, HippoGryphonmon', effect='Reduce any probability by half (eg, 1 in 3 to 0.5 in 3)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'angewomon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Angewomon', text={
            'Gain {X:mult,C:white}X0.69{} Mult every time a glass card breaks',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=6},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Magnadramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Angewomon', stage=stage, evolves_to='Magnadramon', effect='Gain X0.69 Mult every time a glass card breaks'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'magnadramon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name='Magnadramon',
            text={
                'Glass cards have a {C:green}#4# in #5#{} chance to',
                '{X:mult,C:white}X3{} Mult additionally',
                BM.care_status_text(stage),
                '{C:red}Care Mistakes{} #3#/3',
            }
        },

        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker',
        pos = {x=9,y=6},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local numerator, denominator =
                SMODS.get_probability_vars(
                    card,
                    1,
                    2,
                    'magnadramon'
                )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    numerator,
                    denominator
                }
            }
        end,

        in_pool = function(self,args)
            return stage=='Fresh'
                or stage=='In-Training'
                or stage=='Rookie'
                or stage=='Champion'
                or stage=='Rare'
        end,

        add_to_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_add(card,slug)
            end
        end,

        remove_from_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_remove(card,slug)
            end
        end,

        can_sell = function(self,card,context)
            return BM.can_sell(card,slug)
        end,

        calculate = function(self,card,context)
            BM.care_tick(card,context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(slug,card,context)
        end,
    }

    BM.joker_defs[slug] = {
        name='Magnadramon',
        stage=stage,
        evolves_to='-',
        effect='Glass cards have a 1 in 2 chance to X3 Mult additionally'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
            key=BM.center_key(slug),
            weight=weight,
            stage=stage
        }
    end
end

do
    local slug = 'pagumon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Pagumon', text={
            'Create 2 negative chariot at the end of a boss',
            'blind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'DemiDevimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Pagumon', stage=stage, evolves_to='DemiDevimon', effect='Create 2 negative chariot at the end of a boss blind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'demidevimon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='DemiDevimon', text={
            'If the first played card is a single card,',
            'turn it into a steel card',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Devimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='DemiDevimon', stage=stage, evolves_to='Devimon', effect='If the first played card is a single card, turn it into a steel card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'devimon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Devimon', text={
            'Ace and 2 held in hand turn into steel cards',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Myotismon, LadyDevimon, Kimeramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Devimon', stage=stage, evolves_to='Myotismon, LadyDevimon, Kimeramon', effect='Ace and 2 held in hand turn into steel cards'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'ladydevimon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='LadyDevimon', text={
            'Steel cards give {C:money}$2{} when discarded',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MaloMyotismon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='LadyDevimon', stage=stage, evolves_to='MaloMyotismon', effect='Steel cards give $2 when discarded'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'myotismon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Myotismon', text={
            'Each Steel card in deck gives {X:mult,C:white}X0.25{} Mult',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MaloMyotismon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = 1 + 0.25 * BM.count_deck_enhancement('m_steel')
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Myotismon', stage=stage, evolves_to='MaloMyotismon', effect='Each Steel card in deck gives X0.25 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'malomyotismon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MaloMyotismon', text={
            'Each King held in hand gives {X:mult,C:white}X1.5{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MaloMyotismon', stage=stage, evolves_to='-', effect='Each King held in hand gives X1.5 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'piedmon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Piedmon', text={
            'Gain {X:mult,C:white}X1{} Mult for every face card destroyed',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.xmult or 1}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Piedmon', stage=stage, evolves_to='-', effect='Gain X1 Mult for every face card destroyed'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'sakumon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Sakumon', text={
            'If the first played card is a single card,',
            'turn it into a gold card',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Sakuttomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Sakumon', stage=stage, evolves_to='Sakuttomon', effect='If the first played card is a single card, turn it into a gold card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'sakuttomon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Sakuttomon', text={
            'Create a negative devil at the end of a boss',
            'blind',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Zubamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Sakuttomon', stage=stage, evolves_to='Zubamon', effect='Create a negative devil at the end of a boss blind'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'zubamon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Zubamon', text={
            'All played face cards turn to gold card',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=7},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'ZubaEagermon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Zubamon', stage=stage, evolves_to='ZubaEagermon', effect='All played face cards turn to gold card'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'zubaeagermon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='ZubaEagermon', text={
            'Each played gold card gives {C:money}$4{}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Duramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='ZubaEagermon', stage=stage, evolves_to='Duramon', effect='Each played gold card gives $4'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'duramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Duramon', text={
            'Each played gold card gives {C:money}$6{}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Durandamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Duramon', stage=stage, evolves_to='Durandamon', effect='Each played gold card gives $6'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'durandamon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Durandamon', text={
            'Each played gold card gives {C:money}$6{} and {X:mult,C:white}X1.5{} Mult',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Durandamon', stage=stage, evolves_to='-', effect='Each played gold card gives $6 and X1.5 Mult'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'kimeramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Kimeramon', text={
            'If first hand of round has only 1 card, add a',
            'permanent copy to deck and draw it to hand',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Apocalymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Kimeramon', stage=stage, evolves_to='Apocalymon', effect='If first hand of round has only 1 card, add a permanent copy to deck and draw it to hand'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'apocalymon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Apocalymon', text={
            'If first hand of round has 5 scoring cards,',
            'destroy all of it and gain {C:money}$20{}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Apocalymon', stage=stage, evolves_to='-', effect='If first hand of round has 5 scoring cards, destroy all of it and gain $20'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'chibomon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Chibomon', text={
            'Retrigger last played card used in scoring',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'DemiVeemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Chibomon', stage=stage, evolves_to='DemiVeemon', effect='Retrigger last played card used in scoring'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'demiveemon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='DemiVeemon', text={
            'Retrigger first played card used in scoring',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Veemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='DemiVeemon', stage=stage, evolves_to='Veemon', effect='Retrigger first played card used in scoring'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'veemon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Veemon', text={
            'Retrigger first played card used in scoring 2',
            'additional times',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'ExVeemon, Flamedramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Veemon', stage=stage, evolves_to='ExVeemon, Flamedramon', effect='Retrigger first played card used in scoring 2 additional times'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'exveemon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='ExVeemon', text={
            'Retrigger all played face cards',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=8},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Paildramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='ExVeemon', stage=stage, evolves_to='Paildramon', effect='Retrigger all played face cards'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'flamedramon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name='Flamedramon',
            text={
                '{C:green}#4# in #5#{} chance to upgrade played poker hand after it is scored',
                BM.care_status_text(stage),
                '{C:red}Care Mistakes{} #3#/3',
            }
        },

        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker',
        pos = {x=9,y=8},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Wingdramon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local numerator, denominator =
                SMODS.get_probability_vars(
                    card,
                    1,
                    5,
                    'flamedramon'
                )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    numerator,
                    denominator
                }
            }
        end,

        in_pool = function(self,args)
            return stage=='Fresh'
                or stage=='In-Training'
                or stage=='Rookie'
                or stage=='Champion'
                or stage=='Rare'
        end,

        add_to_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_add(card,slug)
            end
        end,

        remove_from_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_remove(card,slug)
            end
        end,

        can_sell = function(self,card,context)
            return BM.can_sell(card,slug)
        end,

        calculate = function(self,card,context)
            BM.care_tick(card,context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(slug,card,context)
        end,
    }

    BM.joker_defs[slug] = {
        name='Flamedramon',
        stage=stage,
        evolves_to='Wingdramon',
        effect='1 in 5 chance to upgrade played poker hand'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
            key=BM.center_key(slug),
            weight=weight,
            stage=stage
        }
    end
end

do
    local slug = 'paildramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Paildramon', text={
            'Retrigger all played cards in final hand of',
            'the round 2 additional times',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Fighter Mode, Imperialdramon Dragon Mode',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Paildramon', stage=stage, evolves_to='Imperialdramon Fighter Mode, Imperialdramon Dragon Mode', effect='Retrigger all played cards in final hand of the round 2 additional times'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'wingdramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Wingdramon', text={
            'Upgrade the level of the first discarded poker',
            'hand each round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Gallantmon, BlackWarGreymon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Wingdramon', stage=stage, evolves_to='Gallantmon, BlackWarGreymon', effect='Upgrade the level of the first discarded poker hand each round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'imperialdramon_dragon_mode'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Imperialdramon Dragon Mode', text={
            'Retrigger all cards held in hand abilities',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Fighter Mode',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Imperialdramon Dragon Mode', stage=stage, evolves_to='Imperialdramon Fighter Mode', effect='Retrigger all cards held in hand abilities'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'imperialdramon_fighter_mode'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Imperialdramon Fighter Mode', text={
            'Retrigger all played cards 2 additional times',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Imperialdramon Dragon Mode',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Imperialdramon Fighter Mode', stage=stage, evolves_to='Imperialdramon Dragon Mode', effect='Retrigger all played cards 2 additional times'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'gekkomon'
    local stage = 'Rare'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gekkomon', text={
            'Copies the Digimon Joker\'s effect to the right',
            'of this Joker',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gekkomon', stage=stage, evolves_to='-', effect='Copies the Digimon Joker\'s effect to the right of this Joker'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'troopmon'
    local stage = 'Rare'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Troopmon', text={
            'Copies the leftmost Digimon Joker\'s effect',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Troopmon', stage=stage, evolves_to='-', effect='Copies the leftmost Digimon Joker\'s effect'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'digitamamon'
    local stage = 'Rare'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Digitamamon', text={
            'Retrigger the rightmost Joker\'s effect 2',
            'additional times. Perpetually rental.',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Digitamamon', stage=stage, evolves_to='-', effect='Retrigger the rightmost Joker\'s effect 2 additional times. Perpetually rental.'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'espimon'
    local stage = 'Rare'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Espimon', text={
            'After {C:attention}2{} rounds, sell this card to',
            'Duplicate a random Joker',
            '{C:inactive}(Removes Negative from copy){}',
            '{C:inactive}(Currently {C:attention}#4#{C:inactive}/2 rounds){}',
            '{C:inactive}(Evolve using D-Ark){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HoverEspimon',
        loc_vars = function(self,info_queue,card)
            local e = card and card.ability and card.ability.extra or extra
            local rounds = math.min(e.sell_rounds or 0, 2)

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    rounds
                }
            }
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Espimon', stage=stage, evolves_to='HoverEspimon', effect='After 2 rounds, sell this card to Duplicate a random Joker (Removes Negative from copy)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'hoverespimon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='HoverEspimon', text={
            'After {C:attention}3{} rounds, sell this card to',
            'Duplicate the leftmost Joker',
            '{C:inactive}(Currently {C:attention}#4#{C:inactive}/3 rounds){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e = card and card.ability and card.ability.extra or extra
            local rounds = math.min(e.sell_rounds or 0, 3)

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    rounds
                }
            }
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='HoverEspimon', stage=stage, evolves_to='-', effect='After 3 rounds, sell this card to Duplicate the leftmost Joker'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'relemon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Relemon', text={
            'Earn {C:money}$4{} at end of round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=9},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Viximon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Relemon', stage=stage, evolves_to='Viximon', effect='Earn $4 at end of round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'viximon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Viximon', text={
            'Earn {C:money}$5{} at end of round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Renamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Viximon', stage=stage, evolves_to='Renamon', effect='Earn $5 at end of round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'renamon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Renamon', text={
            'Earn {C:money}$5{} for each discarded {C:attention}#4#{}',
            '{C:inactive}(rank changes at end of round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Kyubimon, ZubaEagermon, Gatomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'renamon_rank') or e.target_rank or 14
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank)}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Renamon', stage=stage, evolves_to='Kyubimon, ZubaEagermon, Gatomon', effect='Earn $5 for each discarded [rank] {C:inactive}(rank changes at end of round){}'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'kyubimon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Kyubimon', text={
            'Earn {C:money}$10{} at end of round. Payout increases by',
            '{C:money}$2{} when Boss Blind is defeated',
            '{C:inactive}(Currently {C:money}$#4#{C:inactive} payout){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Taomon, LadyDevimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,e.payout or 10}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Kyubimon', stage=stage, evolves_to='Taomon, LadyDevimon', effect='Earn $10 at end of round. Payout increases by $2 when Boss Blind is defeated'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'taomon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Taomon', text={
            '{X:mult,C:white}X1{} Mult for every {C:money}$10{} owned',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Sakuyamon, Piedmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local current = math.max(1,math.floor((G.GAME and G.GAME.dollars or 0)/10))
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Taomon', stage=stage, evolves_to='Sakuyamon, Piedmon', effect='X1 Mult for every $10 owned'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'sakuyamon'
    local stage = 'Mega'

    local extra = {
        hunger = 1,
        bond = 0,
        care_mistakes = 0,
        care_rounds = 0
    }

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name = 'Sakuyamon',
            text = {
                '{X:mult,C:white}X1{} Mult for every {C:money}$10{} owned',
                'Also has the {C:attention}Renamon{} effect',
                '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult){}',
                BM.care_status_text(stage),
                '{C:red}Care Mistakes{} #3#/3',
            }
        },

        config = {
            extra = extra
        },

        rarity = BM.stage_rarity(stage),
        cost = 5,

        atlas = 'Joker',
        pos = {x = 4, y = 10},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = '-',

        loc_vars = function(self, info_queue, card)
            local e =
                card
                and card.ability
                and card.ability.extra
                or extra

            local target_rank =
                card
                and BM.ensure_target(
                    card,
                    'target_rank',
                    BM.RANKS,
                    'sakuyamon_rank'
                )
                or e.target_rank
                or 14

            local current_xmult =
                math.max(
                    1,
                    math.floor(
                        (G.GAME and G.GAME.dollars or 0) / 10
                    )
                )


            info_queue[#info_queue + 1] = {
                set = 'Other',
                key = 'DigiMeel_sakuyamon_renamon_effect',
                vars = {
                    BM.rank_name(target_rank)
                }
            }

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    current_xmult
                }
            }
        end,

        in_pool = function(self, args)
            return stage == 'Fresh'
                or stage == 'In-Training'
                or stage == 'Rookie'
                or stage == 'Champion'
                or stage == 'Rare'
        end,

        add_to_deck = function(self, card, from_debuff)
            if not from_debuff then
                BM.on_add(card, slug)
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if not from_debuff then
                BM.on_remove(card, slug)
            end
        end,

        can_sell = function(self, card, context)
            return BM.can_sell(card, slug)
        end,

        calculate = function(self, card, context)
            BM.care_tick(card, context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(
                slug,
                card,
                context
            )
        end,
    }

    BM.joker_defs[slug] = {
        name = 'Sakuyamon',
        stage = stage,
        evolves_to = '-',
        effect = 'X1 Mult for every $10 owned, apply Renamon effect'
    }

    local weight =
        BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys + 1] = {
            key = BM.center_key(slug),
            weight = weight,
            stage = stage
        }
    end
end

do
    local slug = 'zerimon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name='Zerimon',
            text={
                'Each face card held in hand has a {C:green}#4# in #5#{}',
                'chance to give {C:money}$1{}',
                BM.care_status_text(stage),
                '{C:red}Care Mistakes{} #3#/3',
            }
        },

        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker',
        pos = {x=5,y=10},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Gummymon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local numerator, denominator =
                SMODS.get_probability_vars(
                    card,
                    1,
                    2,
                    'zerimon'
                )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    numerator,
                    denominator
                }
            }
        end,

        in_pool = function(self,args)
            return stage=='Fresh'
                or stage=='In-Training'
                or stage=='Rookie'
                or stage=='Champion'
                or stage=='Rare'
        end,

        add_to_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_add(card,slug)
            end
        end,

        remove_from_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_remove(card,slug)
            end
        end,

        can_sell = function(self,card,context)
            return BM.can_sell(card,slug)
        end,

        calculate = function(self,card,context)
            BM.care_tick(card,context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(slug,card,context)
        end,
    }

    BM.joker_defs[slug] = {
        name='Zerimon',
        stage=stage,
        evolves_to='Gummymon',
        effect='Each face card held in hand has a 1 in 2 chance to give $1'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
            key=BM.center_key(slug),
            weight=weight,
            stage=stage
        }
    end
end

do
    local slug = 'gummymon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gummymon', text={
            'Add {C:money}$1{} of sell value to every Joker and',
            'Consumable card at end of round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Terriermon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gummymon', stage=stage, evolves_to='Terriermon', effect='Add $1 of sell value to every Joker and Consumable card at end of round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'terriermon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}

    SMODS.Joker {
        key = slug,

        loc_txt = {
            name='Terriermon',
            text={
                '{C:green}#4# in #5#{} chance for each played 8, 10, and Jacks',
                'to create a Tarot card when scored',
                BM.care_status_text(stage),
                '{C:red}Care Mistakes{} #3#/3',
            }
        },

        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker',
        pos = {x=7,y=10},

        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        balatromon = true,
        balatromon_stage = stage,
        balatromon_evolves_to = 'Gargomon, Guardromon, Machmon',

        loc_vars = function(self, info_queue, card)
            local e = card and card.ability and card.ability.extra or extra

            local numerator, denominator =
                SMODS.get_probability_vars(
                    card,
                    1,
                    4,
                    'terriermon'
                )

            return {
                vars = {
                    e.hunger or 1,
                    e.bond or 0,
                    e.care_mistakes or 0,
                    numerator,
                    denominator
                }
            }
        end,

        in_pool = function(self,args)
            return stage=='Fresh'
                or stage=='In-Training'
                or stage=='Rookie'
                or stage=='Champion'
                or stage=='Rare'
        end,

        add_to_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_add(card,slug)
            end
        end,

        remove_from_deck = function(self,card,from_debuff)
            if not from_debuff then
                BM.on_remove(card,slug)
            end
        end,

        can_sell = function(self,card,context)
            return BM.can_sell(card,slug)
        end,

        calculate = function(self,card,context)
            BM.care_tick(card,context)

            if card.ability.extra.permanently_disabled then
                return
            end

            return BM.run_effect(slug,card,context)
        end,
    }

    BM.joker_defs[slug] = {
        name='Terriermon',
        stage=stage,
        evolves_to='Gargomon, Guardromon, Machmon',
        effect='1 in 4 chance for each played 8, 10, and Jacks to create a Tarot card when scored'
    }

    local weight = BM.stage_shop_weight(stage)

    if weight > 0 then
        BM.shop_joker_keys[#BM.shop_joker_keys+1] = {
            key=BM.center_key(slug),
            weight=weight,
            stage=stage
        }
    end
end

do
    local slug = 'gargomon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Gargomon', text={
            'Played face cards, Ace cards and 2\'s give {C:mult}+5{}',
            'Mult when scored',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Rapidmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Gargomon', stage=stage, evolves_to='Rapidmon', effect='Played face cards, Ace cards and 2\'s give +5 Mult when scored'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'guardromon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Guardromon', text={
            'When round begins, add a random playing card',
            'with a random seal to your hand',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=10},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Andromon, Tankdramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Guardromon', stage=stage, evolves_to='Andromon, Tankdramon', effect='When round begins, add a random playing card with a random seal to your hand'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'machmon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Machmon', text={
            'Allows Straights to be made with gaps of 1',
            'rank',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'LoaderLeomon, Tankdramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Machmon', stage=stage, evolves_to='LoaderLeomon, Tankdramon', effect='Allows Straights to be made with gaps of 1 rank'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'rapidmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Rapidmon', text={
            'If first discard of round has only 1 card,',
            'destroy it and earn {C:money}$3{}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'MegaGargomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Rapidmon', stage=stage, evolves_to='MegaGargomon', effect='If first discard of round has only 1 card, destroy it and earn $3'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'andromon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Andromon', text={
            'Hearts and Diamonds count as the same suit,',
            'Spades and Clubs count as the same suit',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HiAndromon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Andromon', stage=stage, evolves_to='HiAndromon', effect='Hearts and Diamonds count as the same suit, Spades and Clubs count as the same suit'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'tankdramon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Tankdramon', text={
            'Activate any purple seal and gold seal held in',
            'hand at the end of a round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Machinedramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Tankdramon', stage=stage, evolves_to='Machinedramon', effect='Activate any purple seal and gold seal held in hand at the end of a round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'megagargomon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='MegaGargomon', text={
            'Creates a Negative copy of 1 random consumable',
            'card in your possession at the end of the shop',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='MegaGargomon', stage=stage, evolves_to='-', effect='Creates a Negative copy of 1 random consumable card in your possession at the end of the shop'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'hiandromon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='HiAndromon', text={
            'This Joker gains {X:mult,C:white}X1{} Mult every 7 {V:1}#4#{} cards',
            'discarded',
            '{C:inactive}(suit changes at end of round){}',
            '{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'hiandro_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_suit,e.xmult or 1, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='HiAndromon', stage=stage, evolves_to='-', effect='This Joker gains X1 Mult every 7 [suit] cards discarded'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'pururumon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Pururumon', text={
            '+1 hands each round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Poromon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Pururumon', stage=stage, evolves_to='Poromon', effect='+1 hands each round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'poromon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Poromon', text={
            '+1 discard selection limit',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Hawkmon, Biyomon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Poromon', stage=stage, evolves_to='Hawkmon, Biyomon', effect='+1 discard selection limit'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'hawkmon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Hawkmon', text={
            'Gain an extra handsize for every flush',
            'discarded',
            '{C:inactive}(Poromon’s effect is also applied){}',
            '{C:inactive}(Reset every round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Aquilamon, Halsemon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Hawkmon', stage=stage, evolves_to='Aquilamon, Halsemon', effect='Gain an extra handsize for every flush discarded (Poromon’s effect is also applied)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'biyomon'
    local stage = 'Rookie'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Biyomon', text={
            'Gain 2 extra hands when four of a kind is',
            'discarded',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=11},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Birdramon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Biyomon', stage=stage, evolves_to='Birdramon', effect='Gain 2 extra hands when four of a kind is discarded'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'birdramon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Birdramon', text={
            'Played card with {V:1}#4#{} give {C:mult}+4{} Mult when scored',
            '{C:inactive}(suit changes every hand played){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Garudamon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'birdramon_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_suit, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Birdramon', stage=stage, evolves_to='Garudamon', effect='Played card with [suit] give +4 Mult when scored (suit changes every hand played)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'aquilamon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Aquilamon', text={
            '+2 handsize, -1 hand every round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=1,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Parrotmon, HippoGryphonmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Aquilamon', stage=stage, evolves_to='Parrotmon, HippoGryphonmon', effect='+2 handsize, -1 hand every round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'halsemon'
    local stage = 'Champion'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Halsemon', text={
            '+3 discards each round, -1 hand size',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=2,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'HippoGryphonmon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Halsemon', stage=stage, evolves_to='HippoGryphonmon', effect='+3 discards each round, -1 hand size'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'garudamon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Garudamon', text={
            'Cycle between the effects of {C:attention}Bloodstone{},',
            '{C:attention}Arrowhead{}, {C:attention}Onyx Agate{} and',
            '{C:attention}Rough Gem{} every hand played',
            '{C:inactive}(Now {C:attention}#4#{C:inactive}){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=3,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Phoenixmon, Valkyrimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local mode_names = {'Bloodstone', 'Arrowhead', 'Onyx Agate', 'Rough Gem'}
            local current_mode = mode_names[e.mode or 1] or 'Bloodstone'

            local referenced_jokers = {
                'j_bloodstone',
                'j_arrowhead',
                'j_onyx_agate',
                'j_rough_gem',
            }
            for _, center_key in ipairs(referenced_jokers) do
                if G.P_CENTERS[center_key] then
                    info_queue[#info_queue + 1] = G.P_CENTERS[center_key]
                end
            end

            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,current_mode}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Garudamon', stage=stage, evolves_to='Phoenixmon, Valkyrimon', effect='Cycle between the effects of Bloodstone, Arrowhead, Onyx Agate and Rough Gem every hand played'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'parrotmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Parrotmon', text={
            'Each played card with {V:1}#4#{} gives {X:mult,C:white}X1.5{} Mult when',
            'scored',
            '{C:inactive}(suit changes at end of round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=4,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Phoenixmon, Valkyrimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'parrot_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,target_suit, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Parrotmon', stage=stage, evolves_to='Phoenixmon, Valkyrimon', effect='Each played card with [suit] gives X1.5 Mult when scored (suit changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'hippogryphonmon'
    local stage = 'Ultimate'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='HippoGryphonmon', text={
            'Each played {C:attention}#4#{} of {V:1}#5#{} gives {X:mult,C:white}X2{} Mult when',
            'scored',
            '{C:inactive}(Card changes at end of round){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=5,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Phoenixmon, Valkyrimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            local target_rank=card and BM.ensure_target(card,'target_rank',BM.RANKS,'hippo_rank') or e.target_rank or 14
            local target_suit=card and BM.ensure_target(card,'target_suit',BM.SUITS,'hippo_suit') or e.target_suit or 'Hearts'
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0,BM.rank_name(target_rank),target_suit, colours={(G.C.SUITS and G.C.SUITS[target_suit]) or G.C.FILTER}}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='HippoGryphonmon', stage=stage, evolves_to='Phoenixmon, Valkyrimon', effect='Each played [rank] of [suit] gives X2 Mult when scored (Card changes at end of round)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'phoenixmon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Phoenixmon', text={
            'Create a negative copy of a last sold Joker',
            'when boss blind is defeated',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=6,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Phoenixmon', stage=stage, evolves_to='-', effect='Create a negative copy of a last sold Joker when boss blind is defeated'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'valkyrimon'
    local stage = 'Mega'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Valkyrimon', text={
            'Played Kings and Queens each give {X:mult,C:white}X2{} Mult when',
            'scored',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=7,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Valkyrimon', stage=stage, evolves_to='-', effect='Played Kings and Queens each give X2 Mult when scored'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'akatorimon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Akatorimon', text={
            'Feed 3 random Digimon Jokers every round',
            '{C:inactive}(excluding Akatorimon){}',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=8,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Akatorimon', stage=stage, evolves_to='-', effect='Feed 3 random Digimon Jokers every round (excluding Akatorimon)'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'kokatorimon'
    local stage = 'In-Training'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Kokatorimon', text={
            'Feed the Digimon Joker to its left every round',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=9,y=12},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = '-',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Kokatorimon', stage=stage, evolves_to='-', effect='Feed the Digimon Joker to its left every round'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end

do
    local slug = 'pinamon'
    local stage = 'Fresh'
    local extra = {hunger=1, bond=0, care_mistakes=0, care_rounds=0}
    SMODS.Joker {
        key = slug,
        loc_txt = {name='Pinamon', text={
            'Sell this Joker to create a Food',
            BM.care_status_text(stage),
            '{C:red}Care Mistakes{} #3#/3',
        }},
        config = {extra=extra},
        rarity = BM.stage_rarity(stage),
        cost = 5,
        atlas = 'Joker', pos = {x=0,y=13},
        blueprint_compat = true, eternal_compat = true, perishable_compat = true,
        balatromon = true,
        balatromon_stage = stage, balatromon_evolves_to = 'Akatorimon, Kokatorimon',
        loc_vars = function(self,info_queue,card)
            local e=card and card.ability and card.ability.extra or extra
            return {vars={e.hunger or 1,e.bond or 0,e.care_mistakes or 0}}
        end,
        in_pool = function(self,args)
            return stage=='Fresh' or stage=='In-Training' or stage=='Rookie' or stage=='Champion' or stage=='Rare'
        end,
        add_to_deck = function(self,card,from_debuff) if not from_debuff then BM.on_add(card,slug) end end,
        remove_from_deck = function(self,card,from_debuff) if not from_debuff then BM.on_remove(card,slug) end end,
        can_sell = function(self,card,context) return BM.can_sell(card,slug) end,
        calculate = function(self,card,context)
            BM.care_tick(card,context)
            if card.ability.extra.permanently_disabled then return end
            return BM.run_effect(slug,card,context)
        end,
    }
    BM.joker_defs[slug] = {name='Pinamon', stage=stage, evolves_to='Akatorimon, Kokatorimon', effect='Sell this Joker to create a Food'}
    local weight=BM.stage_shop_weight(stage)
    if weight>0 then BM.shop_joker_keys[#BM.shop_joker_keys+1]={key=BM.center_key(slug),weight=weight,stage=stage} end
end
