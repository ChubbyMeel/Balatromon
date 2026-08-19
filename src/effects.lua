local BM = Balatromon
BM.effect_handlers = BM.effect_handlers or {}
local H = BM.effect_handlers

local function simple_mult(n) return function(card, context) if context.joker_main then return {mult=n} end end end
local function simple_chips(n) return function(card, context) if context.joker_main then return {chips=n} end end end
local function hand_mult(hand,n) return function(card,context) if context.joker_main and BM.contains_hand(context,hand) then return {mult=n} end end end
local function hand_chips(hand,n) return function(card,context) if context.joker_main and BM.contains_hand(context,hand) then return {chips=n} end end end
local function eor_dollars(n) return function(card,context) if context.end_of_round and context.main_eval then return {dollars=n} end end end
local function single_to(enh)
    return function(card,context)
        if context.before and context.main_eval and #context.full_hand == 1 and not context.blueprint then
            BM.set_enhancement(context.full_hand[1], enh)
            return {message='Changed!'}
        end
    end
end
local function boss_negative_tarot(key,count)
    return function(card,context)
        if context.end_of_round and context.main_eval and BM.is_boss() and not context.blueprint then
            local made=0
            for _=1,count do if BM.add_consumable('Tarot',key,'e_negative') then made=made+1 end end
            if made>0 then return {message='Created!'} end
        end
    end
end

H.botamon = simple_mult(2)
H.koromon = simple_mult(4)
H.agumon = simple_mult(6)
H.greymon = function(card,context)
    local e=card.ability.extra
    BM.ensure_target(card,'target_rank',BM.RANKS,'greymon_rank')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'greymon_rank'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank),G.C.ATTENTION) end
    if context.joker_main and BM.contains_rank(context.scoring_hand,e.target_rank) then return {xmult=2} end
end
H.metalgreymon = function(card,context) if context.joker_main then return {xmult=3} end end
H.skullgreymon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    if context.remove_playing_cards and not context.blueprint then
        local n=#(context.removed or {}); if n>0 then e.xmult=e.xmult+0.25*n; return {message='XMult Up!'} end
    end
    if context.joker_main then return {xmult=e.xmult} end
end
H.tyrannomon = function(card,context)
    local e=card.ability.extra
    BM.ensure_target(card,'target_suit',BM.SUITS,'tyrannomon_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_suit',BM.SUITS,'tyrannomon_suit'); return BM.target_change_return(card,'Target: '..tostring(e.target_suit),(G.C.SUITS and G.C.SUITS[e.target_suit]) or G.C.FILTER) end
    if context.joker_main and BM.contains_suit(context.scoring_hand,e.target_suit) then return {xmult=2} end
end
H.numemon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 2
    if context.discard and not context.blueprint then e.xmult=math.max(0,e.xmult-0.01); return {message='XMult Down'} end
    if context.joker_main then return {xmult=e.xmult} end
end
H.garbagemon = function(card,context)
    local e=card.ability.extra; e.round_xmult=e.round_xmult or 1
    BM.ensure_target(card,'target_rank',BM.RANKS,'garbage_rank')
    if context.end_of_round and context.main_eval and not context.blueprint then e.round_xmult=1; BM.reroll_target(card,'target_rank',BM.RANKS,'garbage_rank'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank),G.C.ATTENTION) end
    if context.discard and BM.get_rank(context.other_card)==e.target_rank and not context.blueprint then e.round_xmult=e.round_xmult+0.75; return {message='XMult Up!'} end
    if context.joker_main then return {xmult=e.round_xmult} end
end
H.wargreymon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1; e.seen=e.seen or {}
    BM.ensure_target(card,'target_rank',BM.RANKS,'wargrey_rank'); BM.ensure_target(card,'target_suit',BM.SUITS,'wargrey_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then e.seen={}; BM.reroll_target(card,'target_rank',BM.RANKS,'wargrey_rank'); BM.reroll_target(card,'target_suit',BM.SUITS,'wargrey_suit'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank)..' of '..tostring(e.target_suit),G.C.ATTENTION) end
    if context.individual and context.cardarea==G.play and BM.get_rank(context.other_card)==e.target_rank and context.other_card:is_suit(e.target_suit) and not context.blueprint then
        local id=tostring(context.other_card.playing_card or context.other_card.sort_id); if not e.seen[id] then e.seen[id]=true; e.xmult=e.xmult+0.5; return {message='XMult Up!'} end
    end
    if context.joker_main then return {xmult=e.xmult} end
end
H.machinedramon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    BM.ensure_target(card,'target_rank',BM.RANKS,'machine_rank'); BM.ensure_target(card,'target_suit',BM.SUITS,'machine_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'machine_rank'); BM.reroll_target(card,'target_suit',BM.SUITS,'machine_suit'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank)..' of '..tostring(e.target_suit),G.C.ATTENTION) end
    if context.end_of_round and context.individual and context.cardarea==G.hand and BM.get_rank(context.other_card)==e.target_rank and context.other_card:is_suit(e.target_suit) and not context.blueprint then e.xmult=e.xmult+0.5; return {message='XMult Up!'} end
    if context.joker_main then return {xmult=e.xmult} end
end
H.blackwargreymon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    if context.remove_playing_cards and not context.blueprint then local n=#(context.removed or {}); if n>0 then e.xmult=e.xmult+0.5*n; return {message='XMult Up!'} end end
    if context.joker_main then return {xmult=e.xmult} end
end
H.jyarimon = hand_mult('Pair',8)
H.gigimon = hand_mult('Two Pair',9)
H.guilmon = hand_mult('Flush',10)
H.growlmon = hand_mult('Four of a Kind',17)
H.monochromon = function(card,context)
    if context.joker_main then
        local c,r=BM.highest_card(context.scoring_hand,false)
        if c then if not context.blueprint then BM.set_enhancement(c,'m_gold') end; return {mult=r} end
    end
end
H.wargrowlmon = function(card,context)
    local e=card.ability.extra; e.mult=e.mult or 0; BM.ensure_target(card,'target_hand',BM.HANDS,'wargrowl_hand')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_hand',BM.HANDS,'wargrowl_hand'); return BM.target_change_return(card,'Target: '..tostring(e.target_hand),G.C.ATTENTION) end
    if context.before and context.main_eval and context.scoring_name==e.target_hand and not context.blueprint then e.mult=e.mult+10; return {message='+10 Mult'} end
    if context.joker_main and e.mult~=0 then return {mult=e.mult} end
end
H.megadramon = function(card,context)
    if context.before and context.main_eval and not context.blueprint then
        local c,r=BM.highest_card(context.full_hand,true); if not c then return end
        BM.set_enhancement(c,'m_steel')
        for _,h in ipairs(G.hand.cards or {}) do if BM.get_rank(h)==r then BM.set_enhancement(h,'m_steel') end end
        return {message='Steel!'}
    end
end
H.gigadramon = function(card,context) if context.joker_main then local _,r=BM.lowest_card(G.hand.cards); if r and r<math.huge then return {mult=r*2} end end end
H.mammothmon = function(card,context) if context.joker_main and BM.all_four_suits(context.scoring_hand) then return {dollars=20,chips=50,xmult=2} end end
H.triceramon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_hand',BM.HANDS,'tricera_hand')
    if context.joker_main and context.scoring_name==e.target_hand then return {xmult=4} end
    if context.after and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_hand',BM.HANDS,'tricera_hand'); return BM.target_change_return(card,'Target: '..tostring(e.target_hand),G.C.ATTENTION) end
end
H.gallantmon = function(card,context)
    local e=card.ability.extra; e.previous_form_value=e.previous_form_value or 3
    if context.joker_main then return {xmult=e.previous_form_value/3} end
end
H.cotsucomon = function(card,context) BM.apply_blind_reduction(card,context,0.02,false) end
H.kakkinmon = function(card,context) BM.apply_blind_reduction(card,context,0.03,false) end
H.ludomon = function(card,context) BM.apply_blind_reduction(card,context,0.05,false) end
H.tialudomon = function(card,context) BM.apply_blind_reduction(card,context,0.10,true) end
H.raijiludomon = function(card,context) BM.apply_blind_reduction(card,context,0.25,true) end
H.knightmon = function(card,context)
    local e=card.ability.extra; e.mult=e.mult or 0
    if context.after and context.main_eval and not context.blueprint and not SMODS.last_hand_oneshot then e.mult=e.mult+6; return {message='+6 Mult'} end
    if context.joker_main and e.mult~=0 then return {mult=e.mult} end
end
H.bryweludramon = function(card,context) if context.setting_blind and context.main_eval and BM.is_boss() and G.GAME.blind.disable and not context.blueprint then G.GAME.blind:disable(); return {message='Boss Disabled!'} end end
H.punimon = simple_chips(20)
H.tsunomon = function(card,context)
    local e=card.ability.extra; e.discards=e.discards or 0
    if context.setting_blind and context.main_eval and not context.blueprint then e.discards=0 end
    if context.pre_discard and context.main_eval and not context.blueprint then e.discards=e.discards+1 end
    if context.joker_main then return {chips=90-5*e.discards} end
end
H.gabumon = function(card,context)
    local e=card.ability.extra; e.chips=e.chips or 0
    if context.before and context.main_eval and not context.blueprint then
        local numbered=false; local good=false
        for _,c in ipairs(context.scoring_hand or {}) do if BM.is_face(c) and numbered then good=true break elseif not BM.is_face(c) then numbered=true end end
        if good then e.chips=e.chips+8; return {message='+8 Chips'} end
    end
    if context.joker_main and e.chips~=0 then return {chips=e.chips} end
end
H.garurumon = function(card,context)
    local e=card.ability.extra; e.chips=e.chips or 0
    if context.before and context.main_eval and not context.blueprint then for _,c in ipairs(context.scoring_hand or {}) do if BM.is_face(c) then e.chips=e.chips+10; return {message='+10 Chips'} end end end
    if context.joker_main and e.chips~=0 then return {chips=e.chips} end
end
H.leomon = function(card,context)
    local e=card.ability.extra; e.chips=e.chips or 0; BM.ensure_target(card,'target_hand',BM.HANDS,'leomon_hand')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_hand',BM.HANDS,'leomon_hand'); return BM.target_change_return(card,'Target: '..tostring(e.target_hand),G.C.ATTENTION) end
    if context.before and context.main_eval and context.scoring_name==e.target_hand and not context.blueprint then e.chips=e.chips+15; return {message='+15 Chips'} end
    if context.joker_main and e.chips~=0 then return {chips=e.chips} end
end
H.madleomon = function(card,context) if context.joker_main then return {chips=1000-100*(G.hand and G.hand.config.card_limit or 0)} end end
H.weregarurumon = function(card,context)
    local e=card.ability.extra; e.chips=e.chips or 0; BM.ensure_target(card,'target_rank',BM.RANKS,'weregaruru_rank')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'weregaruru_rank'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank),G.C.ATTENTION) end
    if context.discard and BM.get_rank(context.other_card)==e.target_rank and not context.blueprint then e.chips=e.chips+20; return {message='+20 Chips'} end
    if context.joker_main and e.chips~=0 then return {chips=e.chips} end
end
H.loaderleomon = function(card,context)
    local e=card.ability.extra; e.chips=e.chips or 0; BM.ensure_target(card,'target_hand',BM.HANDS,'loader_hand')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_hand',BM.HANDS,'loader_hand'); return BM.target_change_return(card,'Target: '..tostring(e.target_hand),G.C.ATTENTION) end
    if context.pre_discard and context.main_eval and not context.blueprint then local h=BM.get_poker_hand_name(G.hand.highlighted); if h==e.target_hand then e.chips=e.chips+50; return {message='+50 Chips'} end end
    if context.joker_main and e.chips~=0 then return {chips=e.chips} end
end
H.metalgarurumon = function(card,context)
    local e=card.ability.extra; e.xchips=e.xchips or 1; e.seen=e.seen or {}; BM.ensure_target(card,'target_rank',BM.RANKS,'metalgaruru_rank'); BM.ensure_target(card,'target_suit',BM.SUITS,'metalgaruru_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then e.seen={}; BM.reroll_target(card,'target_rank',BM.RANKS,'metalgaruru_rank'); BM.reroll_target(card,'target_suit',BM.SUITS,'metalgaruru_suit'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank)..' of '..tostring(e.target_suit),G.C.ATTENTION) end
    if context.individual and context.cardarea==G.play and BM.get_rank(context.other_card)==e.target_rank and context.other_card:is_suit(e.target_suit) and not context.blueprint then local id=tostring(context.other_card.playing_card or context.other_card.sort_id); if not e.seen[id] then e.seen[id]=true; e.xchips=e.xchips+0.25; return {message='XChips Up!'} end end
    if context.joker_main then return {xchips=e.xchips} end
end
H.heavyleomon = function(card,context)
    local e=card.ability.extra; e.xchips=e.xchips or 1
    if context.poker_hand_changed and context.new_level and context.old_level and context.new_level>context.old_level and not context.blueprint then
        if context.scoring_name==BM.find_least_played_hand() then e.xchips=e.xchips+0.25; return {message='XChips Up!'} end
    end
    if context.joker_main then return {xchips=e.xchips} end
end
H.monzaemon = function(card,context) if context.setting_blind and context.main_eval and not context.blueprint and BM.add_consumable('Tarot') then return {message='Tarot!'} end end
H.warumonzaemon = function(card,context) if context.end_of_round and context.main_eval and not context.blueprint then local n=BM.add_food(2); if n>0 then return {message='Food!'} end end end
H.polarbearmon = function(card,context)
    if context.modify_shop_card and context.card and not context.card.ability.balatromon_polar_discount then
        local center=context.card.config and context.card.config.center
        local is_planet=center and center.set=='Planet'
        local is_celestial=center and center.set=='Booster' and (center.kind=='Celestial' or tostring(center.key):find('celestial'))
        if is_planet or is_celestial then context.card.ability.balatromon_polar_discount=true; context.card.ability.extra_value=(context.card.ability.extra_value or 0)-2; context.card:set_cost() end
    end
end
H.pichimon = hand_chips('Pair',50)
H.bukamon = hand_chips('Three of a Kind',100)
H.gomamon = hand_chips('Flush',80)
H.crabmon = hand_chips('Straight',160)
H.ikkakumon = function(card,context) if context.joker_main then local n=0; for _,c in ipairs(context.full_hand or {}) do if BM.is_unenhanced(c) then n=n+1 end end; if n>0 then return {chips=5*n} end end end
H.shellmon = function(card,context) if context.setting_blind and context.main_eval and not context.blueprint then BM.add_playing_card{area=G.deck, enhancement='m_stone'}; return {message='Stone Card!'} end end
H.seadramon = function(card,context) if context.individual and context.cardarea==G.play and BM.is_face(context.other_card) then return {chips=30} end end
H.zudomon = function(card,context)
    local e=card.ability.extra
    if context.setting_blind and context.main_eval and not context.blueprint then e.boss_active=BM.is_boss(); if e.boss_active then return {dollars=8,message='Boss Bonus!'} end end
    if context.joker_main and e.boss_active then return {chips=100} end
end
H.marinebullmon = function(card,context) if context.joker_main then local n=BM.count_deck_enhancement('m_stone'); if n>0 then return {chips=25*n} end end end
H.megaseadramon = function(card,context) if context.individual and context.cardarea==G.play and BM.is_face(context.other_card) and not context.blueprint then context.other_card.ability.perma_bonus=(context.other_card.ability.perma_bonus or 0)+30; return {chips=30,message='+30 Permanent Chips'} end end
H.vikemon = simple_chips(1000)
H.hydramon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_stone') then return {mult=20} end end
H.metalseadramon = function(card,context) if context.individual and context.cardarea==G.play and not context.blueprint then context.other_card.ability.perma_bonus=(context.other_card.ability.perma_bonus or 0)+50; return {chips=50,message='+50 Permanent Chips'} end end
H.poyomon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_lucky') then return {mult=2} end end
H.tokomon = boss_negative_tarot('c_magician',1)
H.patamon = single_to('m_lucky')
H.angemon = function(card,context)
    if context.before and context.main_eval and not context.blueprint then
        if #context.full_hand==1 then BM.set_enhancement(context.full_hand[1],'m_lucky') end
        for _,c in ipairs(context.full_hand or {}) do if BM.get_rank(c)==7 then BM.set_enhancement(c,'m_lucky') end end
        return {message='Lucky!'}
    end
end
H.pegasusmon = function(card,context) if context.mod_probability then return {numerator=context.numerator} end end
H.magnaangemon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    if context.pseudorandom_result and context.result and context.trigger_obj and SMODS.is_playing_card(context.trigger_obj) and BM.has_enhancement(context.trigger_obj,'m_lucky') and not context.blueprint then e.xmult=e.xmult+0.3; return {message='XMult Up!'} end
    if context.joker_main then return {xmult=e.xmult} end
end
H.seraphimon = function(card,context)
    local e=card.ability.extra
    if context.before and context.main_eval and not context.blueprint then e.lucky_money_hit=false end
    if context.pseudorandom_result and context.result and context.trigger_obj and SMODS.is_playing_card(context.trigger_obj) and BM.has_enhancement(context.trigger_obj,'m_lucky') then
        local id=string.lower(tostring(context.identifier or '')); if id:find('money') or id:find('dollar') then e.lucky_money_hit=true end
    end
    if context.joker_main and e.lucky_money_hit then return {xmult=2} end
end
H.yukimibotamon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_glass') then return {chips=30} end end
H.nyaromon = boss_negative_tarot('c_justice',2)
H.salamon = single_to('m_glass')
H.gatomon = function(card,context)
    if context.before and context.main_eval and not context.blueprint then
        local single=#context.full_hand==1
        if single then BM.set_enhancement(context.full_hand[1],'m_glass') end
        for _,c in ipairs(context.full_hand or {}) do if BM.is_face(c) and not (single and c==context.full_hand[1]) then BM.set_enhancement(c,'m_lucky') end end
        return {message='Changed!'}
    end
end
H.nefertimon = function(card,context) if context.mod_probability then return {numerator=-(context.numerator/2)} end end
H.angewomon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    if context.remove_playing_cards and not context.blueprint then local n=0; for _,c in ipairs(context.removed or {}) do if BM.has_enhancement(c,'m_glass') then n=n+1 end end; if n>0 then e.xmult=e.xmult+0.69*n; return {message='XMult Up!'} end end
    if context.joker_main then return {xmult=e.xmult} end
end
H.magnadramon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_glass') and SMODS.pseudorandom_probability(card,'magnadramon',1,2) then return {xmult=3} end end
H.pagumon = boss_negative_tarot('c_chariot',2)
H.deminon = function() end
H.damidevimon = function() end
H.demidevimon = single_to('m_steel')
H.devimon = function(card,context)
    if (context.hand_drawn or context.first_hand_drawn) and context.main_eval and not context.blueprint then
        local changed=false; for _,c in ipairs(G.hand.cards or {}) do local r=BM.get_rank(c); if r==14 or r==2 then changed=BM.set_enhancement(c,'m_steel') or changed end end
        if changed then return {message='Steel!'} end
    end
end
H.ladydevimon = function(card,context) if context.discard and BM.has_enhancement(context.other_card,'m_steel') then return {dollars=2} end end
H.myotismon = function(card,context) if context.joker_main then local n=BM.count_deck_enhancement('m_steel'); if n>0 then return {xmult=1+0.25*n} end end end
H.malomyotismon = function(card,context) if context.individual and context.cardarea==G.hand and BM.get_rank(context.other_card)==13 then return {xmult=1.5} end end
H.piedmon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1
    if context.remove_playing_cards and not context.blueprint then local n=0; for _,c in ipairs(context.removed or {}) do if BM.is_face(c) then n=n+1 end end; if n>0 then e.xmult=e.xmult+n; return {message='XMult Up!'} end end
    if context.joker_main then return {xmult=e.xmult} end
end
H.sakumon = single_to('m_gold')
H.sakuttomon = boss_negative_tarot('c_devil',1)
H.zubamon = function(card,context) if context.before and context.main_eval and not context.blueprint then local ch=false; for _,c in ipairs(context.full_hand or {}) do if BM.is_face(c) then ch=BM.set_enhancement(c,'m_gold') or ch end end; if ch then return {message='Gold!'} end end end
H.zubaeagermon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_gold') then return {dollars=4} end end
H.duramon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_gold') then return {dollars=6} end end
H.durandamon = function(card,context) if context.individual and context.cardarea==G.play and BM.has_enhancement(context.other_card,'m_gold') then return {dollars=6,xmult=1.5} end end
H.kimeramon = function(card,context)
    if context.before and context.main_eval and not context.blueprint and (G.GAME.current_round.hands_played or 0)==0 and #context.full_hand==1 then
        SMODS.copy_card(context.full_hand[1],{area=G.hand}); return {message='Copied!'}
    end
end
H.apocalymon = function(card,context)
    if context.before and context.main_eval and not context.blueprint and (G.GAME.current_round.hands_played or 0)==0 and #context.scoring_hand==5 then
        SMODS.destroy_cards(context.scoring_hand); return {dollars=20,message='Destroyed!'}
    end
end
H.chibomon = function(card,context) if context.repetition and context.cardarea==G.play and context.scoring_hand and context.other_card==context.scoring_hand[#context.scoring_hand] then return {repetitions=1} end end
H.demiveemon = function(card,context) if context.repetition and context.cardarea==G.play and context.scoring_hand and context.other_card==context.scoring_hand[1] then return {repetitions=1} end end
H.veemon = function(card,context) if context.repetition and context.cardarea==G.play and context.scoring_hand and context.other_card==context.scoring_hand[1] then return {repetitions=2} end end
H.exveemon = function(card,context) if context.repetition and context.cardarea==G.play and BM.is_face(context.other_card) then return {repetitions=1} end end
H.flamedramon = function(card,context) if context.after and context.main_eval and not context.blueprint and SMODS.pseudorandom_probability(card,'flamedramon',1,5) then SMODS.upgrade_poker_hands{hands=context.scoring_name,level_up=1,from=card}; return {message='Hand Upgraded!'} end end
H.paildramon = function(card,context) if context.repetition and context.cardarea==G.play and (G.GAME.current_round.hands_left or 0)==0 then return {repetitions=2} end end
H.wingdramon = function(card,context)
    local e=card.ability.extra
    if context.setting_blind and context.main_eval and not context.blueprint then e.used_discard_upgrade=false end
    if context.pre_discard and context.main_eval and not e.used_discard_upgrade and not context.blueprint then local h=BM.get_poker_hand_name(G.hand.highlighted); if h then e.used_discard_upgrade=true; SMODS.upgrade_poker_hands{hands=h,level_up=1,from=card}; return {message='Hand Upgraded!'} end end
end
H.imperialdramon_dragon_mode = function(card,context) if context.repetition and context.cardarea==G.hand then return {repetitions=1} end end
H.imperialdramon_fighter_mode = function(card,context) if context.repetition and context.cardarea==G.play then return {repetitions=2} end end
H.gekkomon = function(card,context)
    local i=BM.joker_index(card); local other=i and G.jokers.cards[i+1]
    if other and other~=card then return SMODS.blueprint_effect(card,other,context) end
end
H.troopmon = function(card,context) local other=G.jokers and G.jokers.cards[1]; if other and other~=card then return SMODS.blueprint_effect(card,other,context) end end
H.digitamamon = function(card,context)
    if context.retrigger_joker_check and G.jokers and context.other_card==G.jokers.cards[#G.jokers.cards] and context.other_card~=card and not context.retrigger_joker then return {repetitions=2} end
end
H.espimon = function(card,context)
    local e=card.ability.extra; e.sell_rounds=e.sell_rounds or 0
    if context.end_of_round and context.main_eval and not context.blueprint then e.sell_rounds=e.sell_rounds+1; if e.sell_rounds==2 then return {message='Ready to Sell!'} end end
    if context.selling_self and e.sell_rounds>=2 then local t=BM.random_other_joker(card,'espimon_copy'); if t then BM.copy_joker(t,true) end end
end
H.hoverespimon = function(card,context)
    local e=card.ability.extra; e.sell_rounds=e.sell_rounds or 0
    if context.end_of_round and context.main_eval and not context.blueprint then e.sell_rounds=e.sell_rounds+1; if e.sell_rounds==3 then return {message='Ready to Sell!'} end end
    if context.selling_self and e.sell_rounds>=3 then local t=G.jokers and G.jokers.cards[1]; if t and t~=card then BM.copy_joker(t,false) end end
end
H.relemon = eor_dollars(4)
H.viximon = eor_dollars(5)
H.renamon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_rank',BM.RANKS,'renamon_rank')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'renamon_rank'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank),G.C.ATTENTION) end
    if context.discard and BM.get_rank(context.other_card)==e.target_rank then return {dollars=5} end
end
H.kyubimon = function(card,context)
    local e=card.ability.extra; e.payout=e.payout or 10
    if context.blind_defeated and BM.is_boss() and not context.blueprint then e.payout=e.payout+2; return {message='Payout Up!'} end
    if context.end_of_round and context.main_eval then return {dollars=e.payout} end
end
H.taomon = function(card,context) if context.joker_main then return {xmult=math.max(1,math.floor((G.GAME.dollars or 0)/10))} end end
H.sakuyamon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_rank',BM.RANKS,'sakuyamon_rank')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'sakuyamon_rank'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank),G.C.ATTENTION) end
    if context.discard and BM.get_rank(context.other_card)==e.target_rank then return {dollars=5} end
    if context.joker_main then return {xmult=math.max(1,math.floor((G.GAME.dollars or 0)/10))} end
end
H.zerimon = function(card,context) if context.individual and context.cardarea==G.hand and BM.is_face(context.other_card) and SMODS.pseudorandom_probability(card,'zerimon',1,2) then return {dollars=1} end end
H.gummymon = function(card,context) if context.end_of_round and context.main_eval and not context.blueprint then BM.add_sell_value_to_all(1); return {message='+$1 Sell Value'} end end
H.terriermon = function(card,context)
    local r=context.other_card and BM.get_rank(context.other_card)
    if context.individual and context.cardarea==G.play and (r==8 or r==10 or r==11) and SMODS.pseudorandom_probability(card,'terriermon',1,4) and not context.blueprint then if BM.add_consumable('Tarot') then return {message='Tarot!'} end end
end
H.gargomon = function(card,context) local r=context.other_card and BM.get_rank(context.other_card); if context.individual and context.cardarea==G.play and (BM.is_face(context.other_card) or r==14 or r==2) then return {mult=5} end end
H.guardromon = function(card,context)
    if context.first_hand_drawn and context.main_eval and not context.blueprint then local seal=SMODS.poll_seal{key='guardromon_seal',guaranteed=true}; BM.add_playing_card{area=G.hand,seal=seal}; return {message='Card Added!'} end
end
H.machmon = function() end -- SMODS.shortcut is patched below while Machmon is owned.
H.rapidmon = function(card,context)
    local e=card.ability.extra
    if context.setting_blind and context.main_eval and not context.blueprint then e.used_first_discard=false end
    if context.discard and not e.used_first_discard and context.full_hand and #context.full_hand==1 and not context.blueprint then e.used_first_discard=true; return {remove=true,dollars=3} end
end
H.andromon = function() end -- Card:is_suit is patched below while Andromon is owned.
H.tankdramon = function(card,context)
    if context.end_of_round and context.main_eval and not context.blueprint then
        local money=0; local purple=0
        for _,c in ipairs(G.hand.cards or {}) do if c.seal=='Gold' then money=money+3 elseif c.seal=='Purple' then purple=purple+1 end end
        for _=1,purple do BM.add_consumable('Tarot') end
        if money>0 or purple>0 then return {dollars=money,message='Seals Activated!'} end
    end
end
H.megagargomon = function(card,context)
    if context.ending_shop and context.main_eval and not context.blueprint and G.consumeables and #G.consumeables.cards>0 and BM.has_room(G.consumeables) then
        local t=BM.random_element(G.consumeables.cards,'megagargomon_copy'); local c=SMODS.copy_card(t,{area=G.consumeables}); if c then c:set_edition('e_negative',true) end; return {message='Copied!'}
    end
end
H.hiandromon = function(card,context)
    local e=card.ability.extra; e.xmult=e.xmult or 1; e.suit_count=e.suit_count or 0; BM.ensure_target(card,'target_suit',BM.SUITS,'hiandro_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then e.suit_count=0; BM.reroll_target(card,'target_suit',BM.SUITS,'hiandro_suit'); return BM.target_change_return(card,'Target: '..tostring(e.target_suit),(G.C.SUITS and G.C.SUITS[e.target_suit]) or G.C.FILTER) end
    if context.discard and context.other_card:is_suit(e.target_suit) and not context.blueprint then e.suit_count=e.suit_count+1; if e.suit_count>=7 then local n=math.floor(e.suit_count/7); e.suit_count=e.suit_count%7; e.xmult=e.xmult+n; return {message='XMult Up!'} end end
    if context.joker_main then return {xmult=e.xmult} end
end
H.pururumon = function() end
H.poromon = function() end
H.hawkmon = function(card,context)
    if context.pre_discard and context.main_eval and BM.get_poker_hand_name(G.hand.highlighted)=='Flush' and not context.blueprint then card.ability.extra.hawk_hand_size=(card.ability.extra.hawk_hand_size or 0)+1; G.hand:change_size(1); return {message='+1 Hand Size'} end
end
H.biyomon = function(card,context)
    if context.pre_discard and context.main_eval and BM.get_poker_hand_name(G.hand.highlighted)=='Four of a Kind' and not context.blueprint then ease_hands_played(2); return {message='+2 Hands'} end
end
H.birdramon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_suit',BM.SUITS,'birdramon_suit')
    if context.individual and context.cardarea==G.play and context.other_card:is_suit(e.target_suit) then return {mult=4} end
    if context.after and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_suit',BM.SUITS,'birdramon_suit'); return BM.target_change_return(card,'Target: '..tostring(e.target_suit),(G.C.SUITS and G.C.SUITS[e.target_suit]) or G.C.FILTER) end
end
H.aquilamon = function() end
H.halsemon = function() end
H.garudamon = function(card,context)
    local e=card.ability.extra; e.mode=e.mode or 1
    local c=context.other_card
    if context.individual and context.cardarea==G.play then
        if e.mode==1 and c:is_suit('Hearts') and SMODS.pseudorandom_probability(card,'garudamon_bloodstone',1,2) then return {xmult=1.5}
        elseif e.mode==2 and c:is_suit('Spades') then return {chips=50}
        elseif e.mode==3 and c:is_suit('Clubs') then return {mult=7}
        elseif e.mode==4 and c:is_suit('Diamonds') then return {dollars=1} end
    end
    if context.after and context.main_eval and not context.blueprint then e.mode=e.mode%4+1; card:juice_up(0.8,0.5); return {message='Changed: '..({'Bloodstone','Arrowhead','Onyx Agate','Rough Gem'})[e.mode], colour=G.C.ATTENTION} end
end
H.parrotmon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_suit',BM.SUITS,'parrot_suit')
    if context.individual and context.cardarea==G.play and context.other_card:is_suit(e.target_suit) then return {xmult=1.5} end
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_suit',BM.SUITS,'parrot_suit'); return BM.target_change_return(card,'Target: '..tostring(e.target_suit),(G.C.SUITS and G.C.SUITS[e.target_suit]) or G.C.FILTER) end
end
H.hippogryphonmon = function(card,context)
    local e=card.ability.extra; BM.ensure_target(card,'target_rank',BM.RANKS,'hippo_rank'); BM.ensure_target(card,'target_suit',BM.SUITS,'hippo_suit')
    if context.end_of_round and context.main_eval and not context.blueprint then BM.reroll_target(card,'target_rank',BM.RANKS,'hippo_rank'); BM.reroll_target(card,'target_suit',BM.SUITS,'hippo_suit'); return BM.target_change_return(card,'Target: '..BM.rank_name(e.target_rank)..' of '..tostring(e.target_suit),G.C.ATTENTION) end
    if context.individual and context.cardarea==G.play and BM.get_rank(context.other_card)==e.target_rank and context.other_card:is_suit(e.target_suit) then return {xmult=2} end
end
H.phoenixmon = function(card,context)
    if context.selling_card and context.card and context.card.config and context.card.config.center and context.card.config.center.set=='Joker' then BM.last_sold_joker_key=context.card.config.center.key end
    if context.blind_defeated and BM.is_boss() and BM.last_sold_joker_key and not context.blueprint and BM.has_room(G.jokers) then local c=SMODS.add_card{set='Joker',area=G.jokers,key=BM.last_sold_joker_key,no_edition=true}; if c then c:set_edition('e_negative',true) end; return {message='Returned!'} end
end
H.valkyrimon = function(card,context) local r=context.other_card and BM.get_rank(context.other_card); if context.individual and context.cardarea==G.play and (r==13 or r==12) then return {xmult=2} end end
H.akatorimon = function(card,context)
    if context.end_of_round and context.main_eval and not context.blueprint then local pool={}; for _,c in ipairs(G.jokers.cards or {}) do if c~=card and BM.is_digimon(c) then pool[#pool+1]=c end end; for i=1,math.min(3,#pool) do local pick=BM.random_element(pool,'akatorimon'..i); BM.feed(pick,1); for j=#pool,1,-1 do if pool[j]==pick then table.remove(pool,j) break end end end; return {message='Fed!'} end
end
H.kokatorimon = function(card,context) if context.end_of_round and context.main_eval and not context.blueprint then local i=BM.joker_index(card); local t=i and G.jokers.cards[i-1]; if t and BM.is_digimon(t) then BM.feed(t,1); return {message='Fed!'} end end end
H.pinamon = function(card,context) if context.selling_self and not context.blueprint then BM.add_food(1) end end

-- Rule-altering effects that cannot be expressed as a normal calculate return.
if not BM._shortcut_patched then
    BM._shortcut_patched=true
    local old_shortcut=SMODS.shortcut
    SMODS.shortcut=function(...)
        if SMODS.find_card(BM.center_key('machmon'),true)[1] then return true end
        return old_shortcut(...)
    end
end

if not BM._is_suit_patched and Card and Card.is_suit then
    BM._is_suit_patched=true
    local old_is_suit=Card.is_suit
    Card.is_suit=function(self,suit,bypass_debuff,flush_calc)
        if SMODS.find_card(BM.center_key('andromon'),true)[1] then
            if suit=='Hearts' and old_is_suit(self,'Diamonds',bypass_debuff,flush_calc) then return true end
            if suit=='Diamonds' and old_is_suit(self,'Hearts',bypass_debuff,flush_calc) then return true end
            if suit=='Spades' and old_is_suit(self,'Clubs',bypass_debuff,flush_calc) then return true end
            if suit=='Clubs' and old_is_suit(self,'Spades',bypass_debuff,flush_calc) then return true end
        end
        return old_is_suit(self,suit,bypass_debuff,flush_calc)
    end
end

function BM.run_effect(slug,card,context)
    local fn=H[slug]
    if fn then return fn(card,context) end
end
