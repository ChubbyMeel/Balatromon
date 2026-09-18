local BM = Balatromon

function BM.install_digivolution_localization()
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

function BM.add_ready_digivolution_tooltip(info_queue, card)
    if card.facing == 'back' then return end

    if BM.can_manual_digivolve(card) then
        info_queue[#info_queue + 1] = {
            set = 'Other',
            key = 'balatromon_ready_to_digivolve'
        }
    end
end

BM.install_digivolution_localization()

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
