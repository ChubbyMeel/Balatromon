local BM = Balatromon

BM.attributes = BM.attributes or {}
BM.ATTRIBUTE_BADGE_COLOUR = BM.ATTRIBUTE_BADGE_COLOUR or HEX('4F78A8')
BM.ATTRIBUTE_BADGE_TEXT_COLOUR = BM.ATTRIBUTE_BADGE_TEXT_COLOUR or G.C.WHITE

local function normalize_attribute(attribute)
    if attribute == nil then
        return nil
    end

    attribute = tostring(attribute)

    if attribute == '' then
        return nil
    end

    return attribute
end

local function attribute_key(attribute)
    attribute = normalize_attribute(attribute)

    if not attribute then
        return nil
    end

    if BM.slug then
        return BM.slug(attribute)
    end

    return string.lower(attribute)
        :gsub('[^%w]+', '_')
        :gsub('^_+', '')
        :gsub('_+$', '')
end

function BM.register_attribute(attribute, args)
    attribute = normalize_attribute(attribute)

    if not attribute then
        return nil
    end

    args = args or {}

    local key = attribute_key(attribute)

    BM.attributes[key] = {
        key = key,
        name = attribute,
        badge_label = args.badge_label or args.label or attribute,
        badge_colour = args.badge_colour or args.colour or BM.ATTRIBUTE_BADGE_COLOUR,
        text_colour = args.text_colour or BM.ATTRIBUTE_BADGE_TEXT_COLOUR,
        badge_scale = args.badge_scale or 1
    }

    return BM.attributes[key]
end

function BM.get_attribute(source)
    if not source then
        return nil
    end

    local direct =
        normalize_attribute(source.balatromon_attribute)
        or normalize_attribute(source.attribute)

    if direct then
        return direct
    end

    local ability_attribute =
        source.ability
        and normalize_attribute(source.ability.balatromon_attribute)

    if ability_attribute then
        return ability_attribute
    end

    local center =
        source.config
        and source.config.center

    if center and center ~= source then
        return BM.get_attribute(center)
    end

    return nil
end

function BM.get_attribute_definition(attribute)
    attribute = normalize_attribute(attribute)

    if not attribute then
        return nil
    end

    local registered =
        BM.attributes[attribute_key(attribute)]

    if registered then
        return registered
    end

    return {
        key = attribute_key(attribute),
        name = attribute,
        badge_label = attribute,
        badge_colour = BM.ATTRIBUTE_BADGE_COLOUR,
        text_colour = BM.ATTRIBUTE_BADGE_TEXT_COLOUR,
        badge_scale = 1
    }
end

function BM.add_attribute_badge(card, badges, center)
    if not badges then
        return
    end

    local attribute =
        BM.get_attribute(card)
        or BM.get_attribute(center)

    if not attribute then
        return
    end

    local def =
        BM.get_attribute_definition(attribute)

    badges[#badges + 1] = create_badge(
        def.badge_label,
        def.badge_colour,
        def.text_colour,
        def.badge_scale
    )
end

function BM.attach_attribute_badge(center)
    if not center
    or center._bm_attribute_badge then
        return center
    end

    local old_set_badges = center.set_badges

    center.set_badges = function(self, card, badges)
        if old_set_badges then
            old_set_badges(self, card, badges)
        end

        BM.add_attribute_badge(
            card,
            badges,
            self
        )
    end

    center._bm_attribute_badge = true

    return center
end

function BM.set_attribute(target, attribute)
    if not target then
        return nil
    end

    attribute = normalize_attribute(attribute)

    if target.config and target.config.center then
        target.ability = target.ability or {}
        target.ability.balatromon_attribute = attribute
        BM.attach_attribute_badge(target.config.center)
    else
        target.balatromon_attribute = attribute
        BM.attach_attribute_badge(target)
    end

    return attribute
end

function BM.clear_attribute(target)
    return BM.set_attribute(target, nil)
end

function BM.has_attribute(source, attribute)
    local current = BM.get_attribute(source)
    local wanted = normalize_attribute(attribute)

    if not current or not wanted then
        return false
    end

    return attribute_key(current) == attribute_key(wanted)
end

function BM.install_attribute_badges()
    local seen = {}

    local function install_from(pool)
        for _, center in pairs(pool or {}) do
            if type(center) == 'table'
            and not seen[center] then
                seen[center] = true
                BM.attach_attribute_badge(center)
            end
        end
    end

    install_from(SMODS.Centers)
    install_from(G and G.P_CENTERS)
end
