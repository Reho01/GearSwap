-- Owner: AlanWarren, aka ~ Orestes 
-- current file resides @ https://github.com/AlanWarren/gearswap
--[[ 

 === Notes ===
 -- Set format is as follows:
    -- sets.midcast.RA.[CustomClass][CombatForm][CombatWeapon][RangedMode][CustomRangedGroup]
    -- You can create named sets based off any weapon in the rng_rema list below
    -- you can also append CustomRangedGroups to each other
 
 -- These are the available sets per category
 -- CombatForm = DW
 -- RangedMode = Normal, Mid, Acc

 === Helpful Commands ===
    //gs validate
    //gs showswaps
    //gs debugmode

--]]

--Windower Bindings Here.

	windower.send_command('wait 7;input /lockstyleset 79')

pName = player.name

-- Saying hello
windower.add_to_chat(8,'----- Welcome back to your RNG v2.03 Gearswap, '..pName..' -----')
 
function get_sets()
        mote_include_version = 2
        -- Load and initialize the include file.
        include('Mote-Include.lua')
        include('organizer-lib')
end

-- setup vars that are user-independent.
function job_setup()
        state.Buff.Barrage = buffactive.Barrage or false
        state.Buff.Camouflage = buffactive.Camouflage or false
        state.Buff.Overkill = buffactive.Overkill or false
        state.Buff['Double Shot'] = buffactive['Double Shot'] or false

        state.FlurryMode = M{['description']='Flurry Mode', 'Normal', 'Hi'}
        state.HasteMode = M{['description']='Haste Mode', 'Normal', 'Hi'}
        -- settings
        state.CapacityMode = M(false, 'Capacity Point Mantle')

        gear.Gun = "Annihilator"
        gear.Bow = "Yoichinoyumi"
        gear.Xbow = "Gastraphetes"
        
        rng_rema = S{'Annihilator', 'Armageddon', 'Fomalhaut', 'Gastraphetes', 'Yoichinoyumi', 'Gandiva', 'Fail-Not'}       

        rng_sub_weapons = S{'Malevolence', 'Tauret', 'Perun +1', 
            'Perun', 'Odium', 'Atoyac', 'Kaja Sword', 'Naegling'}
        
        -- sam_sj = player.sub_job == 'SAM' or false
        
        -- used for ammo swaps
        rng_xbows = S{'Gastraphetes', 'Illapa'}
        rng_guns = S{'Annihilator', 'Armageddon', 'Fomalhaut'}
        rng_bows = S{'Yoichinoyumi', 'Gandiva', 'Fail-Not'}
        state.GastraAmmo = M{['description']='Xbow Ammo', "Quelling Bolt", "Abrasion Bolt"}
        state.GunAmmo = M{['description']='Gun Ammo', "Chrono Bullet", "Eradicating Bullet"}
        state.AmmoToggle = M{['description']='Ammo Toggle', "Primary", "Secondary"}
        -- state.Ammo = M{['description']='Gastraphetes', "Bloody Bolt", "Achiyalabopa Bolt"}
        
        -- W.I.P ~
        DefaultAmmo = {[gear.Bow] = "Achiyalabopa arrow", [gear.Gun] = state.GunAmmo.current, [gear.Xbow] = state.GastraAmmo.current}
        -- U_Shot_Ammo = {[gear.Bow] = "Achiyalabopa arrow", [gear.Gun] = "Eradicating Bullet"} 

        update_combat_form()
        determine_haste_group()
        get_combat_weapon()
        get_custom_ranged_groups()
end
 
function user_setup()
        -- Options: Override default values
        state.OffenseMode:options('Normal', 'Melee')
        state.RangedMode:options('Normal', 'Mid', 'Acc')
        state.HybridMode:options('Normal', 'PDT')
        state.IdleMode:options('Normal', 'PDT')
        state.WeaponskillMode:options('Normal', 'Mid', 'Acc')
        state.PhysicalDefenseMode:options('PDT')
        state.MagicalDefenseMode:options('MDT')
 
        select_default_macro_book()

        send_command('bind != gs c toggle CapacityMode')
        send_command('bind f9 gs c cycle RangedMode')
        send_command('bind !f9 gs c cycle OffenseMode')
        send_command('bind ^f9 gs c cycle HybridMode')
        send_command('bind @f9 gs c cycle HasteMode')
        send_command('bind @= gs c cycle FlurryMode')
        -- send_command('bind ^] gs c cycle WeaponskillMode')
        -- send_command('bind !- gs equip sets.crafting')
        send_command('bind ^[ input /lockstyle on')
        send_command('bind ![ input /lockstyle off')
end

-- Called when this job file is unloaded (eg: job change)
function file_unload()
    send_command('unbind f9')
    send_command('unbind ^f9')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind @=')
    send_command('unbind ^-')
end
 
function init_gear_sets()
        
    sets.Obi = { waist="Korin Obi" }
    -- Augmented gear
    TaeonHands = {}
    TaeonHands.TA = {name="Taeon Gloves", augments={'DEX+6','Accuracy+17 Attack+17','"Triple Atk."+2'}}
    TaeonHands.Snap = {name="Taeon Gloves", augments={'"Snapshot"+5', 'Attack+22','"Snapshot"+5'}}
    
    TaeonHead = {}
    TaeonHead.Snap = { name="Taeon Chapeau", augments={'Accuracy+20 Attack+20','"Snapshot"+5','"Snapshot"+4',}}
    
    HercFeet = {}
    HercHead = {}
    HercLegs = {}
    HercHands = {}
    HercBody = {}

    -- HercHands.R = { name="Herculean Gloves", augments={'AGI+9','Accuracy+3','"Refresh"+1',}}
    -- HercHands.MAB = { name="Herculean Gloves", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','INT+4','Mag. Acc.+8','"Mag.Atk.Bns."+13',}}
    
    -- HercFeet.MAB = { name="Herculean Boots", augments={'Mag. Acc.+30','"Mag.Atk.Bns."+25','Accuracy+3 Attack+3','Mag. Acc.+12 "Mag.Atk.Bns."+12',}}
    -- HercFeet.TP = { name="Herculean Boots", augments={'Accuracy+21 Attack+21','"Triple Atk."+4','DEX+8',}}
    
    -- HercBody.MAB = { name="Herculean Vest", augments={'Haste+1','"Mag.Atk.Bns."+27','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}
    -- HercBody.WSD = { name="Herculean Vest", augments={'"Blood Pact" ability delay -4','AGI+3','Weapon skill damage +9%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}
    
    -- HercHead.MAB = {name="Herculean Helm", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +3%','INT+1','Mag. Acc.+3','"Mag.Atk.Bns."+8',}}
    -- HercHead.TP = { name="Herculean Helm", augments={'Accuracy+25','"Triple Atk."+4','AGI+6','Attack+14',}}
    -- HercHead.DM = { name="Herculean Helm", augments={'Pet: STR+9','Mag. Acc.+10 "Mag.Atk.Bns."+10','Weapon skill damage +9%','Accuracy+12 Attack+12',}}

    -- HercLegs.MAB = { name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+14',}}
    -- HercLegs.TH = { name="Herculean Trousers", augments={'Phys. dmg. taken -1%','VIT+10','"Treasure Hunter"+2','Accuracy+10 Attack+10','Mag. Acc.+19 "Mag.Atk.Bns."+19',}} 
    
    -- AdhemarLegs = {}
    -- AdhemarLegs.Snap = { name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}}
    -- AdhemarLegs.TP = { name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}}

    -- Belenus = {}
    -- Belenus.STP = { name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10','Damage taken-5%',}}
    -- Belenus.WSD = { name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
    -- Belenus.MAB  = { name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}}
    -- Belenus.Snap = {name="Belenus's Cape", augments={'"Snapshot"+10',}}

    sets.Organizer = {
        ear2="Reraise Earring",
        back="Linkpearl",
    }
    -- Misc. Job Ability precasts
    sets.precast.JA['Bounty Shot'] = {hands="Amini Glovelettes +1", waist="Chaac Belt", legs=HercLegs.TH }
    sets.precast.JA['Double Shot'] = {head="Amini Gapette"}
    sets.precast.JA['Camouflage'] = {body="Orion Jerkin +3"}
    sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +3"}
    sets.precast.JA['Velocity Shot'] = {body="Amini Caban +1",}
    sets.precast.JA['Scavenge'] = {feet="Orion Socks +1"}
    sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +2"}

    sets.CapacityMantle = {back="Mecistopins Mantle"}

    sets.precast.JA['Eagle Eye Shot'] = set_combine(sets.midcast.RA, {
        head="Meghanada Visor +2", 
        ear1="Sherida Earring",
        ear2="Enervating Earring",
        body="Nisroch Jerkin",
        hands="Malignance Gloves",
        waist="Kwahu Kachina Belt",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        legs="Arcadian Braccae +3", 
        feet="Arcadian Socks +3"
    })

    sets.precast.FC = {
        head=HercHead.TP,
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        body="Dread Jupon",
        legs="Quiahuiz Trousers",
        hands="Leyline Gloves",
        ring1="Prolix Ring",
        ring2="Weatherspoon Ring",
    }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })
    
    sets.idle = {
        --sub="Nusku Shield",
        head="Malignance Chapeau",
        neck="Loricate Torque +1",
        ear1="Odnowa Earring",
        ear2="Odnowa Earring +1",
		body="Arc. Jerkin +3",
        --body="Malignance Tabard",
        hands="Malignance Gloves",
        ring1="Defending Ring",
        ring2="Chirich Ring +1",
        waist="Flume Belt +1",
        legs="Malignance Tights",
        feet="Malignance Boots", -- 10
		back="Moonlight Cape"
    }

    -- Engaged sets
    sets.engaged =  {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+15 Attack+15','"Triple Atk."+3','DEX+3','Accuracy+5','Attack+9',}},
		neck="Clotharius Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Apate Ring",
		right_ring="Petrov Ring",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }
    sets.engaged.PDT = set_combine(sets.engaged, {
        hands="Malignance Gloves",
        body="Malignance Tabard",
        ring1="Dark Ring",
        legs="Malignance Tights", 
    })
    sets.engaged.Bow = set_combine(sets.engaged, {})

    sets.engaged.Melee = {
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+15 Attack+15','"Triple Atk."+3','DEX+3','Accuracy+5','Attack+9',}},
		neck="Clotharius Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Mache Earring +1",
		left_ring="Apate Ring",
		right_ring="Petrov Ring",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }
    -- sets.engaged.Bow.Melee = sets.engaged.Melee

    sets.engaged.Melee.PDT = {
		head="Malignance chapeau", --5/0
        body="Meg. Cuirie +2", --8/0
        hands="Malignance gloves", --7/5
        neck="Loricate Torque +1", --6/6
		ear1="Odnowa Earring",
        ear2="Odnowa Earring +1", --0/3
        ring1="Gelatinous Ring", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
		legs="Mummu Kecks +1",
        waist="Flume Belt +1",
    }
    ------------------------------------------------------------------
    -- Preshot / Snapshot sets 
    -- 50 snap in gear will cap
    -- Pieces that provide delay reduction via velocity shot, do NOT
    -- count towards cap.
    -- TODO: Yemaya Belt + Pursuer's Pants
    ------------------------------------------------------------------
    sets.precast.RA = {
		--head="Orion Beret +2",
		head="Taeon chapeau", --10
		body="Amini Caban +1",
		hands="Carmine Fin. Ga. +1",
		legs="Adhemar Kecks +1",
		feet="Meghanada jambeaux +2",
		--feet="Arcadian Socks +3",
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}} -- 10
    }
    
    ------------------------------------------------------------------
    -- Default Base Gear Sets for Ranged Attacks. Geared for Gastraphetes
    ------------------------------------------------------------------
    sets.midcast.RA = { 
		head={ name="Arcadian Beret +2", augments={'Enhances "Recycle" effect',}},
		body="Orion Jerkin +1",
		hands="Malignance Gloves",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		left_ear="Telos Earring",
		right_ear="Dedition Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }
    
    -- Double Shot 
    sets.midcast.RA.DoubleShot = {
		head="Orion Beret +2",
		body="Amini Caban +1",
		legs={ name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
		neck="Scout's Gorget +2",
		waist="Yemaya Belt",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }

    -- Annihilator
    -- TODO: get crit+10% cape
    sets.midcast.RA.Annihilator = set_combine(sets.midcast.RA, {
        -- head="Meghanada Visor +2",
        body="Nisroch Jerkin",
        ring2="Regal Ring",
    })
    sets.midcast.RA.Annihilator.Mid = set_combine(sets.midcast.RA.Mid, {
        body="Nisroch Jerkin",
    })
    sets.midcast.RA.Annihilator.Acc = set_combine(sets.midcast.RA.Acc, {
        --ammo="Eradicating Bullet"
    })
    sets.midcast.RA.DoubleShot.Annihilator = sets.midcast.RA.DoubleShot
    sets.midcast.RA.DoubleShot.Annihilator.Mid = sets.midcast.RA.DoubleShot.Mid
    sets.midcast.RA.DoubleShot.Annihilator.Acc = sets.midcast.RA.DoubleShot.Acc

    -- Yoichinoyumi
    sets.midcast.RA.Yoichinoyumi = {
        head="Malignance Chapeau",
        neck="Scout's Gorget +2",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        body="Nisroch Jerkin",
        hands="Malignance Gloves",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        waist="Kwahu Kachina Belt",
        legs="Malignance Tights", 
        feet="Malignance Boots"
    }
    sets.midcast.RA.Yoichinoyumi.Mid = set_combine(sets.midcast.RA.Yoichinoyumi, {
        ear1="Enervating Earring",
        hands="Malignance Gloves",
        body="Malignance Tabard", 
        legs="Malignance Tights", 
    })
    sets.midcast.RA.Yoichinoyumi.Acc = set_combine(sets.midcast.RA.Yoichinoyumi.Mid, {
        ear1="Beyla Earring",
        hands="Malignance Gloves",
        body="Orion Jerkin +3",
        ring2="Longshot Ring",
    })
    
    -- Weaponskill sets  
    sets.precast.WS = {
        head="Orion Beret +3",
        neck="Scout's Gorget +2",
        ear1="Sherida Earring",
        ear2="Ishvara Earring",
        body=HercBody.WSD,
        hands="Meghanada Gloves +2",
        -- ring1="Dingir Ring",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        waist="Kwahu Kachina Belt",
        legs="Arcadian Braccae +3", 
        feet="Arcadian Socks +3"
    }
    sets.precast.WS.Mid = set_combine(sets.precast.WS, {
        body="Arcadian Jerkin +3",
    })
    sets.precast.WS.Acc = set_combine(sets.precast.WS.Mid, {
        body="Orion Jerkin +3",
    })
    sets.precast.WS['Savage Blade'] = {
		head={ name="Herculean Helm", augments={'Weapon skill damage +5%','DEX+7','Accuracy+8','Attack+11',}},
		body="Adhemar Jacket +1",
		hands="Meghanada gloves +2",
		legs={ name="Herculean Trousers", augments={'Weapon skill damage +4%','STR+15','Attack+12',}},
		feet={ name="Herculean Boots", augments={'Accuracy+15','Weapon skill damage +4%','DEX+9','Attack+12',}},
		neck="Anu torque",
		waist="Grunfeld rope",
		left_ear="Ishvara Earring",
		right_ear="Moonshade Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Ifrit Ring",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }
    -- WILDFIRE
    sets.precast.WS['Wildfire'] = {
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Herculean Gloves", augments={'"Mag.Atk.Bns."+20','Weapon skill damage +3%',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Weapon skill damage +4%','STR+3','Mag. Acc.+6','"Mag.Atk.Bns."+4',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+12 "Mag.Atk.Bns."+12','Weapon skill damage +2%','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Weather. Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','"Mag.Atk.Bns."+10',}}
    }
    -- sets.precast.WS['Wildfire'].Mid = set_combine(sets.precast.WS['Wildfire'], {
        -- ear1="Friomisi Earring",
        -- ear2="Moonshade Earring",
        -- neck="Sanctity necklace"",
        -- hands="Carmine Finger Gauntlets +1",
        -- body="Cohort cloak +1",
        -- ring1="Epaminondas's ring",
        -- ring2="Weatherspoon Ring",
        -- back=Belenus.MAB,
        -- waist="Sveltesse Gouriz +1",
        -- legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+24','Weapon skill damage +2%','INT+7',}},
        -- --legs="Arcadian Braccae +3", 
        -- feet={ name="Herculean Boots", augments={'Mag. Acc.+12 "Mag.Atk.Bns."+12','Weapon skill damage +2%','"Mag.Atk.Bns."+11',}},
    -- })
    
    sets.precast.WS['Trueflight'] = {
		body={ name="Cohort Cloak +1", augments={'Path: A',}},
		hands={ name="Herculean Gloves", augments={'"Mag.Atk.Bns."+20','Weapon skill damage +3%',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+13 "Mag.Atk.Bns."+13','Weapon skill damage +4%','STR+3','Mag. Acc.+6','"Mag.Atk.Bns."+4',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+12 "Mag.Atk.Bns."+12','Weapon skill damage +2%','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Weather. Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'AGI+20','"Mag.Atk.Bns."+10',}},
    }
    -- sets.precast.WS['Trueflight'].Mid = set_combine(sets.precast.WS['Trueflight'], {
        -- head=HercHead.MAB,
        -- legs="Arcadian Braccae +3", 
        -- hands=HercHands.MAB,
        -- --legs="Arcadian Braccae +3", 
    -- })
    -- sets.precast.WS['Trueflight'].Acc = set_combine(sets.precast.WS['Trueflight'].Mid, {
        -- body="Samnuha Coat",
        -- legs="Arcadian Braccae +3", 
        --head="Mummu Bonnet +2",
        --body="Mummu Jacket +2",
        -- legs="Mummu Kecks +2",
        -- hands="Mummu Wrists +2",
    -- })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Trueflight'], {
    })

    -- CORONACH
    sets.precast.WS['Coronach'] = set_combine(sets.precast.WS, {
        neck="Scout's Gorget +2",
        ear1="Sherida Earring",
        ear2="Ishvara Earring",
        body=HercBody.WSD,
        waist="Thunder Belt",
        ring1="Dingir Ring",
        ring2="Regal Ring",
        legs="Arcadian Braccae +3", 
    })
    sets.precast.WS['Coronach'].Mid = set_combine(sets.precast.WS['Coronach'], {
    })
    sets.precast.WS['Coronach'].Acc = set_combine(sets.precast.WS['Coronach'].Mid, {
        body="Orion Jerkin +3", 
        legs="Arcadian Braccae +3", 
    })

    -- LAST STAND
    sets.precast.WS['Last Stand'] = {
		head="Orion Beret +2",
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		legs={ name="Arc. Braccae +3", augments={'Enhances "Eagle Eye Shot" effect',}},
		feet={ name="Herculean Boots", augments={'Accuracy+15','Weapon skill damage +4%','DEX+9','Attack+12',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Apate Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Belenus's Cape", augments={'DEX+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}
    }
    -- sets.precast.WS['Last Stand'].Mid = set_combine(sets.precast.WS['Last Stand'], {
        -- body="Arcadian Jerkin +3",
    -- })
    -- sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'].Mid, {
        -- legs="Arcadian Braccae +3", 
        -- feet="Meghanada Jambeaux +2"
    -- })

    -- DETONATOR
    sets.Detonator = {
        ear2="Moonshade Earring",
        neck="Flame Gorget",
        waist="Light Belt",
    }
    sets.precast.WS['Detonator'] = set_combine(sets.precast.WS, sets.Detonator)
    sets.precast.WS['Detonator'].Mid = set_combine(sets.precast.WS.Mid, sets.Detonator)
    sets.precast.WS['Detonator'].Acc = set_combine(sets.precast.WS.Acc, sets.Detonator)
    
    -- SLUG SHOT
    sets.SlugShot = {
        neck="Breeze Gorget",
        ear2="Moonshade Earring",
        waist="Light Belt",
    }
    sets.precast.WS['Slug Shot'] = set_combine(sets.precast.WS, sets.SlugShot)
    sets.precast.WS['Slug Shot'].Mid = set_combine(sets.precast.WS.Mid, sets.SlugShot)
    sets.precast.WS['Slug Shot'].Acc = set_combine(sets.precast.WS.Acc, sets.SlugShot)
    
    sets.precast.WS['Heavy Shot'] = set_combine(sets.precast.WS, sets.SlugShot)
    sets.precast.WS['Heavy Shot'].Mid = set_combine(sets.precast.WS.Mid, sets.SlugShot)
    sets.precast.WS['Heavy Shot'].Acc = set_combine(sets.precast.WS.Acc, sets.SlugShot)

    -- NAMAS
    sets.Namas = {
        neck="Aqua Gorget",
        waist="Light Belt",
    }
    sets.precast.WS['Namas Arrow'] = set_combine(sets.precast.WS, sets.Namas)
    sets.precast.WS['Namas Arrow'].Mid = set_combine(sets.precast.WS.Mid, sets.Namas)
    sets.precast.WS['Namas Arrow'].Acc = set_combine(sets.precast.WS.Acc, sets.Namas)
    
    -- JISHNUS
    sets.Jishnus = {
        neck="Flame Gorget",
        ear2="Moonshade Earring",
        waist="Light Belt",
        body="Nisroch Jerkin",
        ring2="Mummu Ring",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        legs="Arcadian Braccae +3", 
        feet="Thereoid Greaves"
    }
    sets.precast.WS['Jishnu\'s Radiance'] = set_combine(sets.precast.WS, sets.Jishnus)
    sets.precast.WS['Jishnu\'s Radiance'].Mid = set_combine(sets.precast.WS.Mid, {
        neck="Flame Gorget",
        ear2="Moonshade Earring",
        waist="Light Belt",
        legs="Arcadian Braccae +3", 
        feet="Mummu Gamashes +2"

    })
    sets.precast.WS['Jishnu\'s Radiance'].Acc = set_combine(sets.precast.WS.Acc, {
        neck="Flame Gorget",
        ear2="Moonshade Earring",
        waist="Light Belt"
    })
    -- just a test (it works)
    -- sets.precast.WS['Jishnu\'s Radiance'].Yoichinoyumi = set_combine(sets.precast.WS['Jishnu\'s Radiance'], {
    --     neck="Iskur Gorget"
    -- })

    -- SIDEWINDER
    sets.Sidewinder = {
        neck="Aqua Gorget",
        ear2="Moonshade Earring",
        waist="Light Belt",
    }
    sets.precast.WS['Sidewinder'] = set_combine(sets.precast.WS, sets.Sidewinder)
    sets.precast.WS['Sidewinder'].Mid = set_combine(sets.precast.WS.Mid, sets.Sidewinder)
    sets.precast.WS['Sidewinder'].Acc = set_combine(sets.precast.WS.Acc, sets.Sidewinder)

    sets.precast.WS['Refulgent Arrow'] = sets.precast.WS['Sidewinder']
    sets.precast.WS['Refulgent Arrow'].Mid = sets.precast.WS['Sidewinder'].Mid
    sets.precast.WS['Refulgent Arrow'].Acc = sets.precast.WS['Sidewinder'].Acc

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        head="Adhemar Bonnet +1",
        neck="Scout's Gorget +2",
        ear1="Sherida Earring",
        ear2="Odr Earring",
        body="Mummu Jacket +2",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        hands="Mummu Wrists +2",
        -- back=Belenus.WSD,
        legs="Arcadian Braccae +3", 
        feet="Thereoid Greaves"
    })
    
    -- Resting sets
    sets.resting = {}
    
    -- Defense sets
    sets.defense.PDT = set_combine(sets.idle, {})
    sets.defense.MDT = set_combine(sets.idle, {})
    --sets.Kiting = {feet="Fajin Boots"}
    
    sets.buff.Barrage = {
        head="Arcadian Beret +2",
        neck="Scout's Gorget +2",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        body="Nisroch Jerkin",
        hands="Hunter's Bracers +2",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        waist="Kwahu Kachina Belt",
        legs="Malignance Tights",
        feet="Malignance Boots"
    }
    sets.buff.Camouflage =  {body="Orion Jerkin +1"}

    -- sets.Overkill =  {
    --     body="Arcadian Jerkin +3"
    -- }
    -- sets.Overkill.Preshot = set_combine(sets.precast.RA, sets.Overkill)

end

function job_pretarget(spell, action, spellMap, eventArgs)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
end 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
 
function job_precast(spell, action, spellMap, eventArgs)
        
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    -- Safety checks for weaponskills 
    if spell.type:lower() == 'weaponskill' then
        if player.tp < 1000 then
            eventArgs.cancel = true
            return
        end
        if spell.target.distance > 22 then
            add_to_chat(122,"Outside WS Range! /Canceling")
            eventArgs.cancel = true
            return
        end
    end
end
 
-- Run after the default precast() is done.
-- eventArgs is the same one used in job_precast, in case information needs to be persisted.
-- This is where you place gear swaps you want in precast but applied on top of the precast sets
function job_post_precast(spell, action, spellMap, eventArgs)
    if state.Buff.Camouflage then
        equip(sets.buff.Camouflage)
    end
    -- elseif state.Buff.Overkill then
    --     equip(sets.Overkill.Preshot)
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Trueflight' then
            if world.weather_element == 'Light' or world.day_element == 'Light' then
                equip(sets.Obi)
            end
        end
        if state.CapacityMode.value then
            equip(sets.CapacityMantle)
        end
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Camouflage then
        equip(sets.buff.Camouflage)
    end
    if spell.action_type == 'Ranged Attack' and state.CapacityMode.value then
        equip(sets.CapacityMantle)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if buffactive["Barrage"] then
        equip(sets.buff.Barrage)
    end
end

 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if state.Buff[spell.name] ~= nil then
        state.Buff[spell.name] = not spell.interrupted or buffactive[spell.english]
    end
end
 
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    --if S{"courser's roll"}:contains(buff:lower()) then
    --if string.find(buff:lower(), 'samba') then

    if buff == 'Double Shot' and gain then
        windower.send_command('wait 90;input /echo **DOUBLE SHOT OFF**;wait 90;input /echo **DOUBLE SHOT READY**')
    elseif buff == 'Decoy Shot' and gain then
        windower.send_command('wait 170;input /echo **DECOY SHOT** Wearing off in 10 Sec.];wait 120;input /echo **DECOY SHOT READY**')
    end

    -- DoubleShot CombatForm
    if (buff == 'Double Shot' and gain or buffactive['Double Shot']) then
        state.CombatForm:set('DoubleShot')
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    else
        if state.CombatForm.current ~= 'DW' then
            state.CombatForm:reset()
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
    
    if buff == "Camouflage" then
        if gain then
            equip(sets.buff.Camouflage)
            disable('body')
        else
            enable('body')
        end
    end

    -- if buff == "Camouflage" or buff == "Overkill" or buff == "Samurai Roll" or buff == "Courser's Roll" then
    --     if not midaction() then
    --         handle_equipping_gear(player.status)
    --     end
    -- end

    if (( string.find(buff:lower(), 'flurry') and gain ) or buff:startswith('Aftermath')) then
        get_custom_ranged_groups()
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end

-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(status, eventArgs)
    --select_earring()
end
 
function customize_idle_set(idleSet)
    if state.HybridMode.value == 'PDT' then
        state.IdleMode.value = 'PDT'
    elseif state.HybridMode.value ~= 'PDT' then
        state.IdleMode.value = 'Normal'
    end
    if state.Buff.Camouflage then
        idleSet = set_combine(idleSet, sets.buff.Camouflage)
    end
    if player.hpp < 90 then
        idleSet = set_combine(idleSet, sets.idle.Regen)
    end
    return idleSet
end
 
function customize_melee_set(meleeSet)
    if state.Buff.Camouflage then
        meleeSet = set_combine(meleeSet, sets.buff.Camouflage)
    end
    if state.Buff.Overkill then
        meleeSet = set_combine(meleeSet, sets.Overkill)
    end
    if state.CapacityMode.value then
        meleeSet = set_combine(meleeSet, sets.CapacityMantle)
    end
    return meleeSet
end
 
function job_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Engaged' then
        update_combat_form()
        get_combat_weapon()
    end
    if camo_active() then
        disable('body')
    else
        enable('body')
    end
end
 

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
 
-- Called for custom player commands.
-- function job_self_command(cmdParams, eventArgs)
-- end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    get_combat_weapon()
    get_custom_ranged_groups()
    -- sam_sj = player.sub_job == 'SAM' or false
    -- called here incase buff_change failed to update value
    state.Buff.Camouflage = buffactive.camouflage or false
    state.Buff.Overkill = buffactive.overkill or false

    if camo_active() then
        disable('body')
    else
        enable('body')
    end
end
 
-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    add_to_chat(122, 'Ranged: '..state.RangedMode.value..'/'..state.HybridMode.value..', WS: '..state.WeaponskillMode.value)
    
    eventArgs.handled = true
 
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function get_combat_weapon()
    state.CombatWeapon:reset()
    if rng_rema:contains(player.equipment.range) then
        state.CombatWeapon:set(player.equipment.range)
    end
end

function get_custom_ranged_groups()
    
    classes.CustomRangedGroups:clear()
    -- Flurry I = 265, Flurry II = 581
    if buffactive['Flurry'] then
        if state.FlurryMode.value == 'Hi' then
            classes.CustomRangedGroups:append('F2')
        else
            classes.CustomRangedGroups:append('F1')
        end

    end
    
    -- relic aftermath is just "Aftermath", while empy + mythic are numbered
    if buffactive.Aftermath then
        classes.CustomRangedGroups:append('AM')
    elseif buffactive['Aftermath: Lv.1'] then
        classes.CustomRangedGroups:append('AM1')
    elseif buffactive['Aftermath: Lv.2'] then
        classes.CustomRangedGroups:append('AM2')
    elseif buffactive['Aftermath: Lv.3'] then
        classes.CustomRangedGroups:append('AM2')
    end
end

function update_combat_form()
    state.CombatForm:reset()
    if S{'NIN', 'DNC'}:contains(player.sub_job) and rng_sub_weapons:contains(player.equipment.sub) then
        state.CombatForm:set("DW")
    end
    
    if buffactive['Double Shot'] then
        state.CombatForm:set('DoubleShot')
    end
end

function determine_haste_group()

    classes.CustomMeleeGroups:clear()
    -- assuming +4 for marches (ghorn has +5)
    -- Haste (white magic) 15%
    -- Haste Samba (Sub) 5%
    -- Haste (Merited DNC) 10% (never account for this)
    -- Victory March +0/+3/+4/+5    9.4/14%/15.6%/17.1% +0
    -- Advancing March +0/+3/+4/+5  6.3/10.9%/12.5%/14%  +0
    -- Embrava 30% with 500 enhancing skill
    -- Mighty Guard - 15%
    -- buffactive[580] = geo haste
    -- buffactive[33] = regular haste
    -- buffactive[604] = mighty guard
    -- state.HasteMode = toggle for when you know Haste II is being cast on you
    -- Hi = Haste II is being cast. This is clunky to use when both haste II and haste I are being cast
    if state.HasteMode.value == 'Hi' then
        if ( ( (buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604]) ) or
                ( buffactive[33] and (buffactive[580] or buffactive.embrava) ) or
                ( buffactive.march == 2 and buffactive[604] ) ) then
            add_to_chat(8, '-------------Max-Haste Mode Enabled--------------')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( ( buffactive[580] or buffactive[33] or buffactive.march == 2 ) or
                ( buffactive.march == 1 and buffactive[604] ) ) then
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif ( buffactive.march == 1 or buffactive[604] ) then
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        end
    else
        if ( buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or  -- geo haste + anything
            ( buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604]) ) or  -- embrava + anything
            ( buffactive.march == 2 and (buffactive[33] or buffactive[604]) ) or  -- two marches + anything
            ( buffactive[33] and buffactive[604] and buffactive.march ) then -- haste + mighty guard + any marches
            add_to_chat(8, '-------------Max Haste Mode Enabled--------------')
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif ( buffactive.march == 2 ) or -- two marches from ghorn
            ( (buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
            ( buffactive[580] ) or  -- geo haste
            ( buffactive[33] and buffactive[604] ) then  -- haste with MG
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        end
    end

end

function job_state_change(stateField, newValue, oldValue)
    -- W.I.P ~
    -- if stateField == 'Ammo Toggle' then
    --     -- if player.equipment.range 
    --     if rng_xbows:contains(player.equipment.range) then
    --         send_command('@input /console gs c cycle GastraAmmo')
    --     elseif rng_guns:contains(player.equipment.range) then
    --         send_command('@input /console gs c cycle GunAmmo')
    --     end
    -- end
    if stateField == 'Xbow Ammo' then 
        if rng_xbows:contains(player.equipment.range) then
            equip({ammo=newValue})
        end
    elseif stateField == 'Gun Ammo' then 
        if rng_guns:contains(player.equipment.range) then
            equip({ammo=newValue})
        end
    end
end


function camo_active()
    return state.Buff['Camouflage']
end
-- Orestes uses Samurai Roll. The total comes to 5!
--function detect_cor_rolls(old,new,color,newcolor)
--    if string.find(old,'uses Samurai Roll. The total comes to') then
--        add_to_chat(122,"SAM Roll")
--    end
--end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR'then
            set_macro_page(1, 3)
    elseif player.sub_job == 'DNC' then
            set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
end
