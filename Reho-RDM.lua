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

	windower.send_command('wait 7;input /lockstyleset 20')

pName = player.name

-- Saying hello
windower.add_to_chat(8,'----- Welcome back to your RDM v1.20 Gearswap, '..pName..' -----')

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Saboteur = buffactive.saboteur or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Enspell', 'DT', 'Hybrid')
    state.HybridMode:options('Normal', 'PhysicalDef', 'MagicalDef')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT')

    gear.default.obi_waist = "Sekhmet Corset"
    
    select_default_macro_book()

	lockstyleset = 20
	
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Vitivation Tabard +1"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Carmine mask",
        body="Jhakri robe +2",
		hands="Amalric gages +1",
        back="Refraction Cape",
		legs="Ayanmo cosciales +1",
		feet="Carmine greaves +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    -- 80% Fast Cast (including trait) for all spells, plus 5% quick cast
    -- No other FC sets necessary.
    sets.precast.FC = {
        head="Carmine Mask", --12
		ear2="Malignance Earring", --4
        body="Vitiation Tabard +1", --13
		ring1="Weatherspoon Ring", --5
		ring2="Kishar ring", --4
        legs="Ayanmo cosciales +1", --5
		feet="Carmine greaves +1"} --8

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty,body="Twilight Cloak"})
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    -- sets.precast.WS = {
        -- head="Atrophy Chapeau +1",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        -- body="Atrophy Tabard +1",hands="Yaoyotl Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        -- back="Atheling Mantle",waist="Caudata Belt",legs="Hagondes Pants",feet="Hagondes Sabots"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, 
        {neck="Fotia Gorget",
		ear1="Brutal Earring",
		ear2="Moonshade Earring",
        ring1="Aquasoul Ring",
		ring2="Aquasoul Ring",
		waist="Fotia Belt"})

    sets.precast.WS['Sanguine Blade'] = {ammo="Witchstone",
		head="Pixie Hairpin +1",
        neck="Sanctity necklace",
		ear1="Friomisi Earring",
		ear2="Malignance earring",
		body="Amalric doublet +1",
        --body="Cohort Cloak +1",
		hands="Jhakri Cuffs +2",
		ring1="Strendu Ring",
		ring2="Epaminondas's Ring",
		waist="Orpheus's Sash",
        --waist="Eschan stone",
		back="Seshaw cape",
		legs="Amalric slops +1",
		feet="Amalric nails +1"}
		
	sets.precast.WS['Seraph Blade'] = {ammo="Witchstone",
        neck="Sanctity necklace",
		ear1="Moonshade Earring",
		ear2="Malignance earring",
        body="Cohort Cloak +1",
		hands="Jhakri Cuffs +2",
		ring1="Weatherspoon Ring",
		ring2="Epaminondas's Ring",
		waist="Orpheus's Sash",
        --waist="Eschan stone",
		back="Seshaw cape",
		legs="Amalric slops +1",
		feet="Amalric nails +1"}
	
    sets.precast.WS['Savage Blade'] = {
        head="Despair helm",
		neck="Fotia gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
        body="Jhakri robe +2",
		hands="Jhakri cuffs +2",
		ring1="Ifrit Ring",
		ring2="Epaminondas's Ring",
		waist="Grunfeld rope",
        back={name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		legs="Ayanmo cosciales +1",
		feet="Carmine greaves +1"}
		
	sets.precast.WS['Chant du Cygne'] = {ammo="Jukukik Feather",
		head={ name="Taeon Chapeau", augments={'Accuracy+16 Attack+16','"Snapshot"+5','"Snapshot"+5',}},
		body="Ayanmo Corazza +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear="Thunder Pearl",
		left_ring="Begrudging Ring",
		right_ring="Thundersoul Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}}

    	sets.precast.WS['Evisceration'] = {
        head="Despair helm",
		neck="Fotia gorget",
		ear1="Bladeborn earring",ear2="Ishvara Earring",
        body="Jhakri robe +2",
		hands="Jhakri cuffs +2",
		ring1="Rajas Ring",
		ring2="Apate Ring",
		waist="Fotia belt",
        back={name="Sucellos's Cape", augments={'STR+30','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		legs="Ayanmo cosciales +1",
		feet="Carmine greaves +1"}
		
    -- Midcast Sets
    
    sets.midcast.FastRecast = {
        head="Carmine Mask",
		ear2="Loquacious Earring",
        body="Vitivation Tabard +1",
		hands="Chironic Gages",
		ring1="Weatherspoon Ring",
        back="Swith Cape",
		waist="Witful Belt",
		legs="Ayanmo cosciales +1",
		feet="Carmine greaves +1"}

    sets.midcast.Cure = {
        head="Vanya hood",
		neck="Colossus's Torque",
		ear1="Lifestorm Earring",
		ear2="Loquacious Earring",
        body="Vanya robe",
		hands="Kaykaus cuffs",
		ring1="Karka ring",
		ring2="Aquasoul Ring",
        back="Ghostfyre cape",
		waist="Porous rope",
		legs="Atrophy Tights +1",
		feet="Kaykaus boots"}
        
    sets.midcast.Curaga = sets.midcast.Cure
    sets.midcast.CureSelf = {ring1="Kunaji Ring",ring2="Asklepian Ring"}

    sets.midcast['Enhancing Magic'] = {
        head="Carmine mask",
		neck="Colossus's Torque",
        body="Vitivation Tabard +1",
		hands="Atrophy Gloves +1",
		ring1="Prolix Ring",
        back="Sucellos's Cape",
		waist="Olympus Sash",
		legs="Atrophy Tights +1",
		feet="Lethargy Houseaux +1"}

    sets.midcast.Refresh = {body="Atrophy Tabard +2", legs="Lethargy Fuseau +1"}

    sets.midcast.Stoneskin = {waist="Siegel Sash"}
    
    sets.midcast['Enfeebling Magic'] = {ammo="Witchstone",
        head="Vitiation chapeau +1",
		neck="Duelist's Torque +2",
		ear1="Enfeebling Earring",
		ear2="Psystorm Earring",
        body="Atrophy tabard +2",
		hands="Lethargy gantherots +1",
		ring1="Kishar Ring",ring2="Ayanmo Ring",
        back="Sucellos's Cape",
		waist="Casso Sash",
		legs="Psycloth lappas",
		feet="Vitiation boots +1"}

    sets.midcast['Dia III'] = set_combine(sets.midcast['Enfeebling Magic'], {main="Daybreak",
	head="Vitivation Chapeau +1"})

    sets.midcast['Slow II'] = set_combine(sets.midcast['Enfeebling Magic'], {head="Vitivation Chapeau +1"})
    
    sets.midcast['Elemental Magic'] = {main="Lehbrailg +2",sub="Elder's Grip +1",ammo="Witchstone",
        head="Merlinic hood",
		neck="Sanctity necklace",
		ear1="Friomisi Earring",
		ear2="Malignance Earring",
        body="Amalric doublet +1",
		hands="Amalric gages +1",
		ring1="Strendu Ring",
        back="Seshaw cape",
		waist="Eschan stone",
		legs="Amalric slops +1",
		feet="Amalric nails +1"}
        
    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {head=empty,body="Twilight Cloak"})

    sets.midcast['Dark Magic'] = {main="Lehbrailg +2",
		sub="Mephitis Grip",
		ammo="Kalboron Stone",
        head="Atrophy Chapeau +1",
		neck="Weike Torque",
		ear1="Lifestorm Earring",
		ear2="Psystorm Earring",
        body="Vanir Cotehardie",
		hands="Gendewitha Gages",
		ring1="Prolix Ring",
		ring2="Sangoma Ring",
        back="Refraction Cape",
		waist="Goading Belt",
		legs="Bokwus Slops",
		feet="Bokwus Boots"}

    --sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {})

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {ring1="Excelsis Ring", waist="Fucho-no-Obi"})

    sets.midcast.Aspir = sets.midcast.Drain


    -- Sets for special buff conditions on spells.

    sets.midcast.EnhancingDuration = {hands="Atrophy Gloves +1",back="Sucellos's Cape",feet="Lethargy Houseaux +1"}
        
    sets.buff.ComposureOther = {head="Estoqueur's Chappel +2",
        --body="Lethargy Sayon +1",
        legs="Lethargy Fuseau +1",feet="Lethargy Houseaux +1"}

    sets.buff.Saboteur = {hands="Lethargy Gantherots +1"}
    

    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {main="Chatoyant Staff",
        head="Vitivation Chapeau +1",
		neck="Wiglen Gorget",
        body="Jhakri robe +2",
		hands="Serpentes Cuffs",
		ring1="Sheltered Ring",
		ring2="Paguroidea Ring",
        waist="Austerity Belt",
		legs="Nares Trews",
		feet="Chelona Boots +1"}
    

    sets.Kiting = {legs="Caramine Cuisses +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}
	
	-- Sets idle
    sets.idle = {ammo="Homiliary",
		head={ name="Viti. Chapeau +1", augments={'Enhances "Dia III" effect','Enhances "Slow II" effect',}},
		body="Jhakri Robe +2",
		hands="Malignance gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck="Loricate torque +1",
		waist="Flume Belt +1",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Dark Ring",
		back="Moonlight Cape",
}
	-- Sets Idle PDT
	sets.idle.PDT = {ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		neck="Loricate torque +1",
		ear1="Odnowa earring",
		ear2="Odnowa earring +1",
		hands="Malignance gloves",
		ring1="Defending Ring",
		back="Moonlight cape",
		waist="Flume belt +1",
		legs="Malignance tights",
		feet="Malignance Boots",
		
}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = { ammo="Ginsen",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Eabani Earring",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}}
	
	sets.engaged.Hybrid = { ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Windbuffet Belt +1",
		left_ear="Eabani Earring",
		right_ear="Telos Earring",
		left_ring="Defending Ring",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}}
		
	sets.engaged.Enspell = { ammo="Ginsen",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Goading belt",
		--waist="Orpheus's Sash",
		left_ear="Telos Earring",
		right_ear="Eabani Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}}
		
		
	sets.engaged.DT = {ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		neck="Loricate torque +1",
		ear1="Odnowa earring",
		ear2="Odnowa earring +1",
		hands="Malignance gloves",
		ring1="Defending Ring",
		back="Moonlight cape",
		waist="Flume belt +1",
		legs="Malignance tights",
		feet="Malignance Boots",
		}
		
	sets.defense.PDT = {ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Ayanmo Corazza +2",
		neck="Loricate torque +1",
		ear1="Odnowa earring",
		ear2="Odnowa earring +1",
		hands="Malignance gloves",
		ring1="Defending Ring",
		back="Moonlight cape",
		waist="Flume belt +1",
		legs="Malignance tights",
		feet="Malignance Boots",
		}
		

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enfeebling Magic' and state.Buff.Saboteur then
        equip(sets.buff.Saboteur)
    elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.EnhancingDuration)
        if buffactive.composure and spell.target.type == 'PLAYER' then
            equip(sets.buff.ComposureOther)
        end
    elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'None' then
            enable('main','sub','range')
        else
            disable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 1)
    else
        set_macro_page(1, 1)
    end
end

