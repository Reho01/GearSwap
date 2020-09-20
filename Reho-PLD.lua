-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Toggle Treasure Hunter Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--Windower Bindings Here.

	windower.send_command('wait 7;input /lockstyleset 60')

pName = player.name

-- Saying hello
windower.add_to_chat(8,'----- Welcome back to your PLD v1.19 Gearswap, '..pName..' -----')

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Sentinel = buffactive.sentinel or false
    state.Buff.Cover = buffactive.cover or false
    state.Buff.Doom = buffactive.Doom or false
	
	blue_magic_maps = {}
 
		blue_magic_maps.Enmity = S{
        'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific', 'Poison Breath', 'Blitzstrahl',
        'Sheep Song', 'Chaotic Eye', 'Soporific'
    }
		blue_magic_maps.Cure = S{
        'Wild Carrot', 'Healing Breeze'
    }
		blue_magic_maps.Buffs = S{
        'Cocoon', 'Refueling', 'Metallic Shell'
    }
    --this defines a spell map for each type of BLU spell you want to use.
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'CP', 'PDT', 'HP')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc', 'CP')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT')
    state.MagicalDefenseMode:options('MDT')
	
	state.CP = M(false, "Capacity Points Mode")
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP', 'Knockback', 'MP_Knockback'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')

    update_defense_mode()
    
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')
	send_command('bind @c gs c toggle CP')

    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = {legs="Caballarius Breeches"}
    sets.precast.JA['Holy Circle'] = {feet="Reverence Leggings +1"}
    sets.precast.JA['Shield Bash'] = {hands="Caballarius Gauntlets"}
    sets.precast.JA['Sentinel'] = {feet="Caballarius Leggings"}
    sets.precast.JA['Rampart'] = {head="Caballarius Coronet"}
    sets.precast.JA['Fealty'] = {body="Caballarius Surcoat"}
    sets.precast.JA['Divine Emblem'] = {feet="Creed Sabatons +2"}
    sets.precast.JA['Cover'] = {head="Reverence Coronet +1"}

    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = {
        head="Reverence Coronet +1",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Leviathan Ring",ring2="Aquasoul Ring",
        back="Weard Mantle",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        body="Gorney Haubert +1",hands="Reverence Gauntlets +1",ring2="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ammo="Incantor Stone",
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'Attack+28','Weapon skill damage +3%','VIT+5','Accuracy+14',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Loquac. Earring",
		right_ear="Magnetic Earring",
		left_ring="Apeile ring +1",
		right_ring="Apeile ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10',}}}

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {ammo="Ginsen",
		head={ name="Valorous Mask", augments={'Weapon skill damage +3%','STR+14',}},
		body="Sulevia's Plate. +1",
		hands="Sulev. Gauntlets +1",
		legs={ name="Valor. Hose", augments={'Accuracy+11 Attack+11','Weapon skill damage +4%','VIT+6','Accuracy+11','Attack+5',}},
		feet="Sulev. Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Ishvara Earring",
		right_ear="Brutal Earring",
		left_ring="Apate Ring",
		right_ring="Ifrit Ring",
		back="Atheling Mantle"}

    sets.precast.WS.Acc = {ammo="Ginsen",
        head="Yaoyotl Helm",
		neck="Fotia Gorget",
		ear1="Bladeborn Earring",
		ear2="Steelflash Earring",
        body="Gorney Haubert +1",
		hands="Buremte Gloves",
		ring1="Rajas Ring",
		ring2="Patricius Ring",
        back="Atheling Mantle",
		waist="Fotia Belt",
		legs="Cizin Breeches",
		feet="Whirlpool Greaves"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring1="Karka Ring",ring2="Aquasoul Ring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {ring1="Karka Ring"})

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {hands="Buremte Gloves",waist="Zoran's Belt"})
    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {waist="Zoran's Belt"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Ginsen",
        head="Reverence Coronet +1",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Shiva Ring",ring2="K'ayres Ring",
        back="Toro Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    
    sets.precast.WS['Atonement'] = {ammo="Staunch Tathlum",
		head={ name="Despair Helm", augments={'STR+15','Enmity+7','"Store TP"+3',}}, --7
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}}, --20
		hands={ name="Yorium Gauntlets", augments={'Enmity+10',}}, --14
		legs={ name="Odyssean Cuisses", augments={'Enmity+6','DEX+10','Accuracy+14','Attack+3',}}, --10
		feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}}, --15
		neck="Moonlight Necklace", --15
		waist="Creed baudrier", --5
		left_ear="Ishvara earring", --2
		right_ear="Friomisi Earring",
		left_ring="Apeile ring +1", --3
		right_ring="Apeile ring", --4
		back="Rudianos's Mantle",} --10
    
	sets.precast.WS['Aeolian Edge'] = {
		ammo="Staunch Tathlum",
		head={ name="Odyssean Helm", augments={'Mag. Acc.+5 "Mag.Atk.Bns."+5','Weapon skill damage +2%','MND+5','Mag. Acc.+5','"Mag.Atk.Bns."+15',}},
		body="Flamma Korazin +1",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Valor. Hose", augments={'Accuracy+11 Attack+11','Weapon skill damage +4%','VIT+6','Accuracy+11','Attack+5',}},
		feet="Sulev. Leggings +1",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Ishvara Earring",
		right_ear="Friomisi Earring",
		left_ring="Thundersoul Ring",
		right_ring="Apate Ring",
		back="Toro Cape",}
    --------------------------------------
    -- Midcast sets
    --------------------------------------
		--Fast Cast Set 27% FC
    sets.midcast.FastRecast = {
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'Attack+28','Weapon skill damage +3%','VIT+5','Accuracy+14',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Loquac. Earring",
		right_ear="Magnetic Earring",
		left_ring="Apeile ring +1",
		right_ring="Apeile ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10',}}}
        
		--Enmity set +110 Enmity WIP.
    sets.midcast.Enmity = {ammo="Paeapua",
		head={ name="Despair Helm", augments={'STR+15','Enmity+7','"Store TP"+3',}}, --7
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}}, --20
		hands={ name="Yorium Gauntlets", augments={'Enmity+10',}}, --14
		legs={ name="Odyssean Cuisses", augments={'Enmity+6','DEX+10','Accuracy+14','Attack+3',}}, --10
		feet={ name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}}, --15
		neck="Moonlight Necklace", --15
		waist="Creed baudrier", --5
		left_ear="Friomisi earring", --2
		right_ear="Odnowa Earring +1",
		left_ring="Apeile ring +1", --3
		right_ring="Apeile ring", --4
		back="Rudianos's Mantle",} --10

    sets.midcast.Flash = set_combine(sets.midcast.Enmity, {legs="Enif Cosciales"})
	
	sets.midcast.Provoke = set_combine(sets.midcast.Enmity)
	sets.midcast.HolyCircle = set_combine(sets.midcast.Enmity)
	sets.midcast.Sentinel = set_combine(sets.midcast.Enmity)
	sets.midcast.Rampart = set_combine(sets.midcast.Enmity)
	sets.midcast.Fealty = set_combine(sets.midcast.Enmity)
	sets.midcast.Palisade = set_combine(sets.midcast.Enmity)
    
    sets.midcast.Stun = sets.midcast.Flash
    
    sets.midcast.Cure = {ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Eschite Breast.", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		hands="Eschite gauntlets",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'Attack+28','Weapon skill damage +3%','VIT+5','Accuracy+14',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Magnetic Earring",
		right_ear="Nourish. Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonlight Cape",}

    sets.midcast['Enhancing Magic'] = {
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Eschite Breast.", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'Attack+28','Weapon skill damage +3%','VIT+5','Accuracy+14',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		left_ear="Loquac. Earring",
		right_ear="Magnetic Earring",
		left_ring="Apeile ring +1",
		right_ring="Apeile ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10',}}}
		
	sets.midcast['Phalanx'] = {main="Deacon Sword",
		ammo="Staunch Tathlum",
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Eschite Breast.", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Moonlight Necklace",
		waist="Flume Belt +1",
		left_ear="Magnetic Earring",
		right_ear="Halasz Earring",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back={ name="Weard Mantle", augments={'VIT+1','DEX+5','Enmity+5','Phalanx +4',}},
}
    
    sets.midcast.Protect = {ring1="Sheltered Ring"}
    sets.midcast.Shell = {ring1="Sheltered Ring"}
    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    sets.Reraise = {head="Twilight Helm", body="Twilight Mail"}
    
    sets.resting = {neck="Creed Collar",
        ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt"}
    

    -- Idle sets
    sets.idle = {ammo="Staunch Tathlum",
        head="Hjarrandi helm",
		neck="Creed Collar",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
        body="Hjarrandi breastplate",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		left_ring={name="Moonlight ring",bag="wardrobe2"},
		right_ring={name="Moonlight ring",bag="wardrobe3"},
        back="Moonlight Cape",
		waist="Flume Belt +1",
		legs="Carmine Cuisses +1",
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}}}
    
    
    sets.Kiting = {legs="Carmine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}
	
	sets.CP = {back="Aptitude Mantle"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
    sets.MP = {neck="Creed Collar",waist="Flume Belt"}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt +1",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {main="Excalibur",sub="Killedar Shield"} -- Ochain
    sets.MagicalShield = {main="Anahera Sword",sub="Aegis"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {ammo="Staunch Tathlum",
		main="Excalibur",
		sub="Aegis",
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring={name="Moonlight ring",bag="wardrobe2"},
		right_ring={name="Moonlight ring",bag="wardrobe3"},
		waist="Creed baudrier",
		back="Moonlight Cape"}

    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = {ammo="Staunch tathlum",
		main="Excalibur",
		sub="Aegis",
		head="Hjarrandi helm",
		body="Hjarrandi breastplate",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet="Sulev. Leggings +1",
		neck="Loricate Torque +1",
		waist="Creed baudrier",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring={name="Moonlight ring",bag="wardrobe2"},
		right_ring={name="Moonlight ring",bag="wardrobe3"},
		back="Moonlight Cape"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
    sets.engaged = {ammo="Ginsen",
		main="Excalibur",
		sub="Aegis",
		head="Flamma Zucchetto +1",
		body="Flamma Korazin +1",
		hands="Flamma Manopolas +1",
		legs="Flamma dirs +1",
		feet={ name="Carmine Greaves +1", augments={'Accuracy+12','DEX+12','MND+20',}},
		neck="Clotharius Torque",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Suppanomimi",
		left_ring="Rajas Ring",
		right_ring="Petrov Ring",
		back="Rudianos's Mantle",}

    sets.engaged.DW = {ammo="Ginsen",
		head="Flamma Zucchetto +1",
		body="Flamma Korazin +1",
		hands="Flamma Manopolas +1",
		legs="Carmine Cuisses +1",
		feet={ name="Carmine Greaves +1", augments={'Accuracy+12','DEX+12','MND+20',}},
		neck="Clotharius Torque",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Suppanomimi",
		left_ring="Rajas Ring",
		right_ring="Petrov Ring",
		back="Rudianos's Mantle",}
		
    sets.engaged.PDT = {ammo="Staunch Tathlum",
		main="Excalibur",
		sub="Aegis",
		head="Hjarrandi helm",
		body="Hjarrandi breastplate",
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Loricate Torque +1",
		left_ear="Odnowa Earring",
		ring_ear="Odnowa Earring +1",
		left_ring={name="Moonlight ring",bag="wardrobe2"},
		right_ring={name="Moonlight ring",bag="wardrobe3"},
		waist="Flume Belt +1",
		back="Moonlight Cape"}
		
    sets.engaged.HP = {ammo="Plumose Sachet",
		main="Excalibur",
		sub="Aegis",
		head={ name="Souv. Schaller +1", augments={'HP+105','VIT+12','Phys. dmg. taken -4',}},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%',}},
		neck="Creed Collar",
		left_ear="Odnowa Earring +1",
		right_ear="Odnowa Earring",
		left_ring={name="Moonlight ring",bag="wardrobe2"},
		right_ring={name="Moonlight ring",bag="wardrobe3"},
		waist="Creed baudrier",
		back="Moonlight Cape"}

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Doom = {legs="Shabti cuisses", neck="Nicander's Necklace"}
    sets.buff.Cover = {head="Reverence Coronet +1", body="Caballarius Surcoat"}
	
	sets.midcast.bluenmity ={ ammo="Staunch Tathlum",
		head={ name="Eschite Helm", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		body={ name="Eschite Breast.", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Odyssean Greaves", augments={'Attack+28','Weapon skill damage +3%','VIT+5','Accuracy+14',}},
		neck="Moonlight Necklace",
		waist="Creed Baudrier",
		--left_ear="Loquac. Earring",
		right_ear="Magnetic Earring",
		left_ring="Apeile ring +1",
		right_ring="Apeile Ring",
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10',}}} 
	--this is your enmity set for enmity gear, but it won't automatically call it until you set it for the spell types
 
-- Midcast sets
 
sets.midcast['Blue Magic'] = {}
sets.midcast['Blue Magic'].Enmity = sets.midcast.bluenmity --enmity gear gets called here
sets.midcast['Blue Magic'].Cure = sets.midcast.bluenmity
sets.midcast['Blue Magic'].Buffs = sets.midcast['Enhancing Magic']
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
        handle_equipping_gear(player.status)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        end
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 5)
    else
        set_macro_page(1, 5)
    end
end

