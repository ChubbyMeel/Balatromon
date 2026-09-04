local BM = Balatromon

BM.artist_badges = BM.artist_badges or {
    normal = {},
    x = {}
}

BM.ARTIST_BADGE_COLOUR = HEX('6F66D9')

function BM.add_artist_badge(digimon, artist, form)
    local slug = BM.slug(digimon)

    if slug:sub(-2) == '_x' then
        slug = slug:sub(1, -3)
        form = 'x'
    end

    form = form or 'normal'

    if form == 'both' then
        BM.artist_badges.normal[slug] = artist
        BM.artist_badges.x[slug] = artist
    elseif form == 'x' then
        BM.artist_badges.x[slug] = artist
    else
        BM.artist_badges.normal[slug] = artist
    end

    local center =
        SMODS.Centers
        and SMODS.Centers[BM.center_key(slug)]

    if not center or center._bm_artist_badge then
        return
    end

    local old_set_badges = center.set_badges

    center.set_badges = function(self, card, badges)
        if old_set_badges then
            old_set_badges(self, card, badges)
        end

        local is_x =
            BM.has_x_antibody
            and BM.has_x_antibody(card)

        local artist_name

        if is_x then
            artist_name = BM.artist_badges.x[slug]
        else
            artist_name = BM.artist_badges.normal[slug]
        end

        if artist_name then
            badges[#badges + 1] = create_badge(
                artist_name,
                BM.ARTIST_BADGE_COLOUR,
                G.C.WHITE,
                1
            )
        end
    end

    center._bm_artist_badge = true
end

BM.add_artist_badge('Agumon X', 'Art by StarRush')
BM.add_artist_badge('Gabumon X', 'Art by StarRush')
BM.add_artist_badge('AoiBotamamon', 'DigiFake')
BM.add_artist_badge('Wanyamon', 'Art by ChubbyMeel')
BM.add_artist_badge('Bearmon', 'Art by ChubbyMeel')
BM.add_artist_badge('Grizzlymon', 'Art by ChubbyMeel')
BM.add_artist_badge('GreatGrizzlymon', 'Art by ChubbyMeel')
BM.add_artist_badge('Callismon', 'Art by ChubbyMeel')
BM.add_artist_badge('Elecmon', 'Art by ChubbyMeel')
BM.add_artist_badge('BanchoLeomon', 'Art by ChubbyMeel')
BM.add_artist_badge('Tokomon X', 'Art by ChubbyMeel')
BM.add_artist_badge('Phoenixmon X', 'Art by ChubbyMeel')
BM.add_artist_badge('Monzaemon X', 'Art by ChubbyMeel')
BM.add_artist_badge('GrapLeomon', 'Art by ChubbyMeel')
BM.add_artist_badge('SaberLeomon', 'Art by ChubbyMeel')
BM.add_artist_badge('Magnamon', 'Art by ChubbyMeel')
BM.add_artist_badge('Omegamon', 'Art by ChubbyMeel')
BM.add_artist_badge('Raidramon', 'Art by ChubbyMeel')
BM.add_artist_badge('Veedramon', 'Art by ChubbyMeel')
BM.add_artist_badge('AeroVeedramon', 'Art by ChubbyMeel')
BM.add_artist_badge('UltraForceVeedramon', 'Art by ChubbyMeel')
BM.add_artist_badge('Imperialdramon Paladin Mode', 'Art by ChubbyMeel')


