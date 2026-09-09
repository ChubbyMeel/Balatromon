local BM = Balatromon

local function install_digivolution_tooltips()
    if not (G and G.localization and G.localization.descriptions) then return end

    G.localization.descriptions.Other = G.localization.descriptions.Other or {}

    SMODS.process_loc_text(
        G.localization.descriptions.Other,
        'balatromon_digivice_requirement',
        {
            name = 'Digivolution Requirement',
            text = {
                '{C:attention}Casual:{} Minimum {C:green}3 Bond{}',
                '{C:attention}Standard:{} {C:green}Full Bond{}',
            }
        }
    )

    SMODS.process_loc_text(
        G.localization.descriptions.Other,
        'balatromon_ready_to_digivolve',
        {
            name = 'Ready to Digivolve!',
            text = {
                '{C:attention}Double Click{} to activate',
            }
        }
    )
end

function BM.add_digivice_requirement_tooltip(info_queue)
    if not info_queue then return end

    info_queue[#info_queue + 1] = {
        set = 'Other',
        key = 'balatromon_digivice_requirement'
    }
end

function BM.add_ready_digivolution_tooltip(info_queue, card)
    if not info_queue or not card or card.facing == 'back' then return end

    if BM.can_manual_digivolve
    and BM.can_manual_digivolve(card) then
        info_queue[#info_queue + 1] = {
            set = 'Other',
            key = 'balatromon_ready_to_digivolve'
        }
    end
end

local old_process_loc_text = SMODS.current_mod.process_loc_text

SMODS.current_mod.process_loc_text = function(self)
    if old_process_loc_text then
        old_process_loc_text(self)
    end

    install_digivolution_tooltips()
end

install_digivolution_tooltips()

for _, center in pairs(SMODS.Centers or {}) do
    if center
    and center.balatromon
    and not center._bm_ready_digivolution_tooltip_wrapped then
        local old_loc_vars = center.loc_vars

        center.loc_vars = function(self, info_queue, card)
            local result

            if old_loc_vars then
                result = old_loc_vars(self, info_queue, card)
            end

            BM.add_ready_digivolution_tooltip(info_queue, card)

            return result or {vars = {}}
        end

        center._bm_ready_digivolution_tooltip_wrapped = true
    end
end
