local BM = Balatromon

BM.evolution_rules = BM.evolution_rules or {}

BM.evolution_rules.curimon = {
    gurimon = {note = 'Standard route'}
}
BM.evolution_rules.gurimon = {
    gammamon = {note = 'Standard route'}
}
BM.evolution_rules.gammamon = {
    gulusgammamon = {bad_path = true, note = 'Care Crisis route'},
    betelgammamon = {note = 'Standard route'},
    kausgammamon = {note = 'Standard route'},
    wezengammamon = {note = 'Standard route'}
}
BM.evolution_rules.gulusgammamon = {
    regulusmon = {note = 'Standard route'}
}
BM.evolution_rules.betelgammamon = {
    canoweissmon = {note = 'Standard route'}
}
BM.evolution_rules.kausgammamon = {
    wingdramon = {note = 'Standard route'}
}
BM.evolution_rules.wezengammamon = {
    triceramon = {note = 'Standard route'},
    lamortmon = {note = 'Standard route'}
}
BM.evolution_rules.canoweissmon = {
    siriusmon = {note = 'Standard route'}
}
BM.evolution_rules.regulusmon = {
    arcturusmon = {note = 'Standard route'}
}
BM.evolution_rules.siriusmon = {
    proximamon = {device = 'golden_digivice', note = 'Beyond route'}
}
BM.evolution_rules.arcturusmon = {
    proximamon = {device = 'golden_digivice', note = 'Beyond route'}
}


BM.evolution_rules.pyonmon = {
    bosamon = {note = 'Standard route'}
}

BM.evolution_rules.bosamon = {
    angoramon = {note = 'Standard route'}
}

BM.evolution_rules.angoramon = {
    symbareangoramon = {note = 'Standard route'}
}

BM.evolution_rules.symbareangoramon = {
    lamortmon = {note = 'Standard route'}
}

BM.evolution_rules.lamortmon = {
    diarbbitmon = {note = 'Standard route'},
    megagargomon = {note = 'Alternate Standard route'}
}

BM.evolution_rules.puyomon = {
    puyoyomon = {note = 'Standard route'}
}

BM.evolution_rules.puyoyomon = {
    jellymon_hidden = {note = 'Hidden form'},
    jellymon_unfurl = {note = 'Unfurled form'},
    salamon = {note = 'Standard route'}
}

BM.evolution_rules.jellymon_hidden = {
    teslajellymon = {note = 'Standard route'},
    jellymon_unfurl = {note = 'Unfurled form'}
}

BM.evolution_rules.jellymon_unfurl = {
    teslajellymon = {note = 'Standard route'},
    jellymon_hidden = {note = 'Hidden form'}
}

BM.evolution_rules.teslajellymon = {
    thetismon = {note = 'Standard route'}
}

BM.evolution_rules.thetismon = {
    amphimon = {note = 'Standard route'}
}
