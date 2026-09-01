local BM = Balatromon

BM.royal_knights = {
    gallantmon = true,
    omegamon = true,
    magnamon = true,
    ultraforceveedramon = true,
    imperialdramon_paladin_mode = true
}

BM.ROYAL_KNIGHT_BADGE_COLOUR =
    HEX('D9B84A')


function BM.add_royal_knight_badge(
    slug,
    badges
)
    slug = BM.slug(slug)

    if not BM.royal_knights[slug] then
        return
    end

    badges[#badges + 1] =
        create_badge(
            'Royal Knight',
            BM.ROYAL_KNIGHT_BADGE_COLOUR,
            G.C.WHITE,
            1
        )
end


function BM.is_royal_knight(card)
    local slug =
        BM.get_card_slug
        and BM.get_card_slug(card)

    return slug
        and BM.royal_knights[slug]
        == true
end