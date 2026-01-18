main()
{
    // h1-mod patches
    replacefunc(maps\mp\gametypes\_class::isvalidprimary, ::isvalidprimary);
    replacefunc(maps\mp\gametypes\_class::isvalidsecondary, ::isvalidsecondary);
    replacefunc(maps\mp\gametypes\_class::isvalidweapon, ::isvalidweapon);
    replacefunc(maps\mp\gametypes\_class::buildweaponname, ::buildweaponname);

    // h2m patches
    replacefunc(maps\mp\gametypes\_class::isvalidmeleeweapon, ::isvalidmeleeweapon);
    replacefunc(maps\mp\gametypes\_class::isvalidattachment, ::isvalidattachment);
    replacefunc(maps\mp\gametypes\_class::isvalidequipment, ::isvalidequipment);
    replacefunc(maps\mp\gametypes\_class::giveoffhand, ::giveoffhand);
    replacefunc(maps\mp\gametypes\_class::takeoffhand, ::takeoffhand);

    // use attachkits instead of furnitekits
    replacefunc(maps\mp\_utility::getmatchrulesspecialclass, ::getmatchrulesspecialclass);
    replacefunc(maps\mp\gametypes\_class::cac_getweaponfurniturekit, ::cac_getweaponfurniturekit);
    replacefunc(maps\mp\gametypes\_class::furniturekitnametoid, ::furniturekitnametoid);
    replacefunc(maps\mp\gametypes\_class::isvalidfurniturekit, ::isvalidfurniturekit);
    replacefunc(maps\mp\gametypes\_class::getloadout, ::getloadout);
    replacefunc(maps\mp\gametypes\_class::table_getweaponfurniturekit, ::table_getweaponfurniturekit);
    replacefunc(maps\mp\gametypes\_class::isvalidattachkit, ::isvalidattachkit);
    replacefunc(maps\mp\gametypes\_class::applyloadout, ::applyloadout);
    replacefunc(maps\mp\gametypes\_class::isvalidcamo, ::isvalidcamo);

    // j's hmw patches
    replacefunc(maps\mp\gametypes\_class::isvalidoffhand, ::isvalidoffhand);

    setthermalbodymaterial("m/white_scope_def");
}

is_perk_actually_weapon(perk)
{
    return (perk != "specialty_tacticalinsertion" && perk != "specialty_blastshield");
}

isvalidoffhand(offhand, var_1)
{
    offhand = maps\mp\_utility::strip_suffix( offhand, "_lefthand" );

    switch ( offhand )
    {
        case "h1_flashgrenade_mp":
        case "h1_concussiongrenade_mp":
        case "h1_smokegrenade_mp":
        case "h2_empgrenade_mp":
        case "h2_trophy_mp":
        case "specialty_null":
        case "none":
            return 1;
        default:
            if ( maps\mp\_utility::is_true( var_1 ) )
                maps\mp\gametypes\_class::foundinfraction( "Replacing invalid offhand: " + offhand );

            return 0;
    }
}

applyloadout()
{
    var_0 = self.loadout;

    if ( !isdefined( self.loadout ) )
        return;

    self.loadout = undefined;
    self.spectatorviewloadout = var_0;
    self takeallweapons();
    maps\mp\_utility::_clearperks();
    maps\mp\gametypes\_class::_detachall();
    self.changingweapon = undefined;

    if ( var_0.copycatloadout )
        self.curclass = "copycat";

    self.class_num = var_0.class_num;
    self.loadoutprimary = var_0.primary;
    self.loadoutprimarycamo = int( tablelookup( "mp/camoTable.csv", 1, var_0.primarycamo, 0 ) );
    self.loadoutsecondary = var_0.secondary;
    self.loadoutsecondarycamo = int( tablelookup( "mp/camoTable.csv", 1, var_0.secondarycamo, 0 ) );

    if ( !issubstr( var_0.primary, "iw5" ) && !issubstr( var_0.primary, "h1_" ) && !issubstr( var_0.primary, "h2_" ))
        self.loadoutprimarycamo = 0;

    if ( !issubstr( var_0.secondary, "iw5" ) && !issubstr( var_0.secondary, "h1_" ) && !issubstr( var_0.secondary, "h2_" ))
        self.loadoutsecondarycamo = 0;

    self.loadoutprimaryreticle = int( tablelookup( "mp/reticleTable.csv", 1, var_0.primaryreticle, 0 ) );
    self.loadoutsecondaryreticle = int( tablelookup( "mp/reticleTable.csv", 1, var_0.secondaryreticle, 0 ) );

    if ( !issubstr( var_0.primary, "iw5" ) && !issubstr( var_0.primary, "h1_" ) && !issubstr( var_0.primary, "h2_" ))
        self.loadoutprimaryreticle = 0;

    if ( !issubstr( var_0.secondary, "iw5" ) && !issubstr( var_0.secondary, "h1_" ) && !issubstr( var_0.secondary, "h2_" ))
        self.loadoutsecondaryreticle = 0;

    self.loadoutmelee = var_0.meleeweapon;

    if ( isdefined( var_0.juggernaut ) && var_0.juggernaut )
    {
        self.health = self.maxhealth;
        thread maps\mp\_utility::recipeclassapplyjuggernaut( maps\mp\_utility::isjuggernaut() );
        self.isjuggernaut = 1;
        self.juggmoveSpeedScaler = 0.7;
    }
    else if ( maps\mp\_utility::isjuggernaut() )
    {
        self notify( "lost_juggernaut" );
        self.isjuggernaut = 0;
        self.moveSpeedScaler = level.baseplayermovescale;
    }

    var_2 = var_0.secondaryname;

    if ( var_2 != "none" )
    {
        // Liam - 21/02/2024 onemanarmy implementation
        can_give_secondary = true;

        if (isdefined(var_0.perks) && var_0.perks.size > 0)
        {
            if (var_0.perks[0] == "specialty_onemanarmy" || var_0.perks[0] == "specialty_omaquickchange")
            {
                can_give_secondary = false;

                if( !maps\mp\_utility::invirtuallobby() )
                maps\mp\_utility::_giveweapon( "onemanarmy_mp" );
            }
        }

        if (can_give_secondary)
            maps\mp\_utility::_giveweapon( var_2 );

        if ( level.oldschool )
            maps\mp\gametypes\_oldschool::givestartammooldschool( var_2 );
    }

    if ( level.diehardmode )
        maps\mp\_utility::giveperk( "specialty_pistoldeath", 0 );

    maps\mp\gametypes\_class::loadoutallperks( var_0 );
    maps\mp\perks\_perks::applyperks();

    if (var_0.equipment == "specialty_tacticalinsertion")
    {
        self maps\mp\_utility::giveperk( "specialty_tacticalinsertion", 0 );
        self setlethalweapon( "flare_mp" );
    }
    else
        self setlethalweapon( var_0.equipment );

    if ( isdefined(var_0.equipment) && var_0.equipment != "specialty_null" &&
        (is_perk_actually_weapon(var_0.equipment) && self hasweapon(var_0.equipment)) )
    {
        self setweaponammoclip( var_0.equipment, weaponStartAmmo( var_0.equipment ) );
    }
    else
        giveoffhand( var_0.equipment );

    var_5 = var_0.primaryname;
    maps\mp\_utility::_giveweapon( var_5 );

    if ( level.oldschool )
        maps\mp\gametypes\_oldschool::givestartammooldschool( var_5 );

    if ( !isai( self ) && !maps\mp\_utility::ishodgepodgemm() )
        self switchtoweapon( var_5 );

    if ( var_0.setprimaryspawnweapon )
        self setspawnweapon( maps\mp\_utility::get_spawn_weapon_name( var_0 ) );
    self.pers["primaryWeapon"] = maps\mp\_utility::getbaseweaponname( var_5 );
    self.loadoutoffhand = var_0.offhand;
    self settacticalweapon( var_0.offhand );

    if ( !level.oldschool )
        giveoffhand( var_0.offhand );

    self setweaponammoclip( var_0.offhand, weaponStartAmmo( var_0.offhand ) );

    if ( level.oldschool )
        self setweaponammoclip( var_0.offhand, 0 );

    var_6 = var_5;
    self.primaryweapon = var_6;
    self.secondaryweapon = var_2;

    if ( var_0.clearammo )
    {
        self setweaponammoclip( self.primaryweapon, 0 );
        self setweaponammostock( self.primaryweapon, 0 );
    }

    self.issniper = weaponclass( self.primaryweapon ) == "sniper";
    maps\mp\_utility::_setactionslot( 1, "nightvision" );
    maps\mp\perks\_perks::giveperkinventory();
    maps\mp\_utility::_setactionslot( 4, "" );

    if ( !level.console )
    {
        maps\mp\_utility::_setactionslot( 5, "" );
        maps\mp\_utility::_setactionslot( 6, "" );
        maps\mp\_utility::_setactionslot( 7, "" );
        maps\mp\_utility::_setactionslot( 8, "" );
    }

    if ( maps\mp\_utility::_hasperk( "specialty_extraammo" ) )
    {
        self givemaxammo( var_5 );

        if ( var_2 != "none" )
            self givemaxammo( var_2 );
    }

    if ( issubstr(var_2, "akimbo") && maps\mp\_utility::getweaponclass( var_2 ) == "weapon_pistol" )
        self givemaxammo( var_2 );

    if ( !issubstr( var_0.class, "juggernaut" ) )
    {
        if ( isdefined( self.lastclass ) && self.lastclass != "" && self.lastclass != self.class )
            self notify( "changed_class" );

        self.pers["lastClass"] = self.class;
        self.lastclass = self.class;
    }

    if ( isdefined( self.gamemode_chosenclass ) )
    {
        self.pers["class"] = self.gamemode_chosenclass;
        self.pers["lastClass"] = self.gamemode_chosenclass;
        self.class = self.gamemode_chosenclass;

        if ( !isdefined( self.gamemode_carrierclass ) )
            self.lastclass = self.gamemode_chosenclass;

        self.gamemode_chosenclass = undefined;
    }

    self.gamemode_carrierclass = undefined;

    if ( !isdefined( level.iszombiegame ) || !level.iszombiegame )
    {
        if ( !isdefined( self.costume ) )
        {
            if ( isplayer( self ) )
                self.costume = maps\mp\gametypes\_class::cao_getactivecostume();
            else if ( isagent( self ) && self.agent_type == "player" )
                self.costume = maps\mp\gametypes\_teams::getdefaultcostume();
        }

        if ( maps\mp\_utility::invirtuallobby() && isdefined( level.vl_cac_getfactionteam ) && isdefined( level.vl_cac_getfactionenvironment ) )
        {
            var_7 = [[ level.vl_cac_getfactionteam ]]();
            var_8 = [[ level.vl_cac_getfactionenvironment ]]();
            maps\mp\gametypes\_teams::applycostume( var_6, var_7, var_8 );
        }
        else if ( level.teambased )
            maps\mp\gametypes\_teams::applycostume();
        else
            maps\mp\gametypes\_teams::applycostume( var_6, self.team );

        maps\mp\gametypes\_class::logplayercostume();
        self _meth_857C( var_0._id_A7ED );
    }

    self maps\mp\gametypes\_weapons::updatemovespeedscale( "primary" );

    maps\mp\perks\_perks::cac_selector();

    loadoutDeathStreak = var_0.deathstreak;

    // only give the deathstreak for the initial spawn for this life.
    if ( isdefined(loadoutDeathStreak) && loadoutDeathStreak != "specialty_null" && gettime() == self.spawnTime )
    {
        if( loadoutDeathStreak == "specialty_copycat" )
            deathVal = 3;
        else if( loadoutDeathStreak == "specialty_combathigh" )
            deathVal = 5;
        else
            deathVal = 4;

        if ( self maps\mp\_utility::_hasPerk( "specialty_rollover" ) )
            deathVal -= 1;

        if ( isdefined(self.pers["cur_death_streak"]) && self.pers["cur_death_streak"] >= deathVal )
        {
            self thread maps\mp\_utility::givePerk( loadoutDeathStreak );
        }
    }

    self notify( "changed_kit" );
    self notify( "applyloadout" );
}

table_getweaponfurniturekit( var_0, var_1, var_2 )
{
    return maps\mp\gametypes\_class::table_getweaponattachkit(var_0, var_1, var_2);
}

isvalidattachkit( var_0, var_1, var_2 )
{
    if ( !isdefined(var_0) || var_0 == "" || var_0 == "none" )
        return 1;

    var_3 = _func_304( "mp/attachkits.csv", 1, var_0 );

    if ( var_3 <= 0 )
    {
        if ( maps\mp\_utility::is_true( var_2 ) )
            foundinfraction( "Replacing invalid attachKit " + var_0 );

        return 0;
    }

    if ( var_1 == "h1_mp44" || var_1 == "h1_deserteagle" || var_1 == "h1_deserteagle55" )
    {
        var_4 = tablelookupbyrow( "mp/attachkits.csv", var_3, 7 );
        var_5 = getinventoryitemtype( var_4 );

        if ( var_5 == "default" )
        {
            if ( maps\mp\_utility::is_true( var_2 ) )
                foundinfraction( "Replacing invalid attachKit " + var_0 );

            return 0;
        }
    }

    var_6 = tablelookupbyrow( "mp/attachkits.csv", var_3, 6 );

    if ( var_6 == "" )
        return 1;

    var_7 = maps\mp\_utility::getweaponclass( var_1 );
    var_8 = "";

    switch ( var_7 )
    {
    case "weapon_assault":
        var_8 = "ast";
        break;
    case "weapon_smg":
        var_8 = "smg";
        break;
    case "weapon_lmg":
    case "weapon_heavy":
        var_8 = "lmg";
        break;
    case "weapon_sniper":
        var_8 = "snp";
        break;
    case "weapon_shotgun":
    case "weapon_secondary_shotgun":
        var_8 = "sht";
        break;
    case "weapon_pistol":
    case "weapon_secondary_machine_pistol":
        var_8 = "pst";
        break;
    default:
        break;
    }

    var_9 = 0;

    if ( var_8 != "" )
    {
        var_10 = strtok( var_6, " " );

        foreach ( var_12 in var_10 )
        {
            if ( var_12 == var_8 )
            {
                var_9 = 1;
                break;
            }
        }
    }

    if ( !var_9 && maps\mp\_utility::is_true( var_2 ) )
    {
        foundinfraction( "Replacing invalid attachKit " + var_0 );
        return 0;
    }

    return 1;
}

getloadout( var_0, player_info, random_bool, setprimaryspawnweapon, class_callback )
{
    if ( !isdefined( setprimaryspawnweapon ) )
        setprimaryspawnweapon = 1;

    if ( !isdefined( random_bool ) )
        random_bool = 1;

    clearammo = 0;
    class_number = undefined;
    is_custom_class = issubstr( player_info, "custom" );
    do_copycat_loadout = 0;
    loadoutPerks = [];
    isgamemodeclass = player_info == "gamemode";

    if ( issubstr( player_info, "axis" ) )
        player_team = "axis";
    else if ( issubstr( player_info, "allies" ) )
        player_team = "allies";
    else
        player_team = "none";

    copyCatLoadout = [];

    if ( isdefined( self.pers["copyCatLoadout"] ) && self.pers["copyCatLoadout"]["inUse"] && random_bool )
    {
        do_copycat_loadout = 1;
        is_custom_class = 0;
        class_number = maps\mp\_utility::getclassindex( "copycat" );
        copyCatLoadout = self.pers["copyCatLoadout"];
        loadoutPrimary = copyCatLoadout["loadoutPrimary"];
        loadoutPrimaryAttachKit = copyCatLoadout["loadoutPrimaryAttachKit"];
        loadoutPrimaryFurnitureKit = copyCatLoadout["loadoutPrimaryFurnitureKit"];
        loadoutPrimaryCamo = copyCatLoadout["loadoutPrimaryCamo"];
        loadoutPrimaryReticle = copyCatLoadout["loadoutPrimaryReticle"];
        loadoutSecondary = copyCatLoadout["loadoutSecondary"];
        loadoutSecondaryAttachKit = copyCatLoadout["loadoutSecondaryAttachKit"];
        loadoutSecondaryFurnitureKit = copyCatLoadout["loadoutSecondaryFurnitureKit"];
        loadoutSecondaryCamo = copyCatLoadout["loadoutSecondaryCamo"];
        loadoutSecondaryReticle = copyCatLoadout["loadoutSecondaryReticle"];
        loadoutEquipment = copyCatLoadout["loadoutEquipment"];
        loadoutOffhand = copyCatLoadout["loadoutOffhand"];

        for ( local_counter = 0; local_counter < 3; local_counter++ )
            loadoutPerks[local_counter] = copyCatLoadout["loadoutPerks"][local_counter];

        loadoutMelee = copyCatLoadout["loadoutMelee"];
    }
    else if ( player_team != "none" )
    {
        local_class_number = maps\mp\_utility::getclassindex( player_info );
        class_number = local_class_number;
        self.class_num = local_class_number;
        self.teamname = player_team;
        loadoutPrimary = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 0, "weapon" );

        if ( loadoutPrimary == "none" )
        {
            loadoutPrimary = "h1_ak47";
            loadoutPrimaryAttachKit = "none";
            loadoutPrimaryFurnitureKit = "none";
        }
        else
        {
            local_attachKit = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 0, "kit", "attachKit" );
            local_furnitureKit = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 0, "kit", "furnitureKit" );
            loadoutPrimaryAttachKit = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( local_attachKit ), 1 );
            loadoutPrimaryFurnitureKit = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( local_furnitureKit ), 1 );
        }

        loadoutPrimaryCamo = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 0, "camo" );
        loadoutPrimaryReticle = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 0, "reticle" );
        loadoutSecondary = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 1, "weapon" );
        local_attachKit = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 1, "kit", "attachKit" );
        local_furnitureKit = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 1, "kit", "furnitureKit" );
        loadoutSecondaryAttachKit = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( local_attachKit ), 1 );
        loadoutSecondaryFurnitureKit = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( local_furnitureKit ), 1 );
        loadoutSecondaryCamo = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 1, "camo" );
        loadoutSecondaryReticle = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "weaponSetups", 1, "reticle" );
        loadoutEquipment = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "equipment", 0 );
        loadoutOffhand = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "equipment", 1 );

        for ( local_counter = 0; local_counter < 3; local_counter++ )
            loadoutPerks[local_counter] = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "perkSlots", local_counter );

        loadoutMelee = getmatchrulesdata( "defaultClasses", player_team, "defaultClass", local_class_number, "class", "meleeWeapon" );

        if ( loadoutPrimary == "none" && loadoutSecondary != "none" )
        {
            loadoutPrimary = loadoutSecondary;
            loadoutPrimaryAttachKit = loadoutSecondaryAttachKit;
            loadoutPrimaryFurnitureKit = loadoutSecondaryFurnitureKit;
            loadoutPrimaryCamo = loadoutSecondaryCamo;
            loadoutPrimaryReticle = loadoutSecondaryReticle;
            loadoutSecondary = "none";
            loadoutSecondaryAttachKit = "none";
            loadoutSecondaryFurnitureKit = "none";
            loadoutSecondaryCamo = "none";
            loadoutSecondaryReticle = "none";
        }
        else if ( loadoutPrimary == "none" && loadoutSecondary == "none" )
        {
            clearammo = 1;
            loadoutPrimary = "h1_beretta";
            loadoutPrimaryAttachKit = "none";
            loadoutPrimaryFurnitureKit = "none";
        }
    }
    else if ( issubstr( player_info, "custom" ) )
    {
        class_number = maps\mp\_utility::getclassindex( player_info );
        loadoutPrimary = maps\mp\gametypes\_class::cac_getweapon( class_number, 0 );
        loadoutPrimaryAttachKit = maps\mp\gametypes\_class::cac_getweaponattachkit( class_number, 0 );
        loadoutPrimaryFurnitureKit = cac_getweaponfurniturekit( class_number, 0 );
        loadoutPrimaryCamo = maps\mp\gametypes\_class::cac_getweaponcamo( class_number, 0 );
        loadoutPrimaryReticle = maps\mp\gametypes\_class::cac_getweaponreticle( class_number, 0 );
        loadoutSecondary = maps\mp\gametypes\_class::cac_getweapon( class_number, 1 );
        loadoutSecondaryAttachKit = maps\mp\gametypes\_class::cac_getweaponattachkit( class_number, 1 );
        loadoutSecondaryFurnitureKit = cac_getweaponfurniturekit( class_number, 1 );
        loadoutSecondaryCamo = maps\mp\gametypes\_class::cac_getweaponcamo( class_number, 1 );
        loadoutSecondaryReticle = maps\mp\gametypes\_class::cac_getweaponreticle( class_number, 1 );
        loadoutEquipment = maps\mp\gametypes\_class::cac_getequipment( class_number, 0 );
        loadoutOffhand = maps\mp\gametypes\_class::cac_getequipment( class_number, 1 );

        for ( local_counter = 0; local_counter < 3; local_counter++ )
            loadoutPerks[local_counter] = maps\mp\gametypes\_class::cac_getperk( class_number, local_counter );

        loadoutMelee = maps\mp\gametypes\_class::cac_getmeleeweapon( class_number );
    }
    else if ( issubstr( player_info, "lobby" ) )
    {
        class_number = maps\mp\_utility::getclassindex( player_info );
        local_custom_class_location = maps\mp\_utility::cac_getcustomclassloc();
        local_loadout = [[ level.vl_loadoutfunc ]]( local_custom_class_location, class_number );
        loadoutPrimary = local_loadout["primary"];
        loadoutPrimaryAttachKit = local_loadout["primaryAttachKit"];
        loadoutPrimaryFurnitureKit = local_loadout["primaryFurnitureKit"];
        loadoutPrimaryCamo = local_loadout["primaryCamo"];
        loadoutPrimaryReticle = local_loadout["primaryReticle"];
        loadoutSecondary = local_loadout["secondary"];
        loadoutSecondaryAttachKit = local_loadout["secondaryAttachKit"];
        loadoutSecondaryFurnitureKit = local_loadout["secondaryFurnitureKit"];
        loadoutSecondaryCamo = local_loadout["secondaryCamo"];
        loadoutSecondaryReticle = local_loadout["secondaryReticle"];
        loadoutEquipment = local_loadout["equipment"];
        loadoutOffhand = local_loadout["offhand"];

        for ( local_counter = 0; local_counter < 3; local_counter++ )
            loadoutPerks[local_counter] = local_loadout["perk" + local_counter];

        loadoutMelee = local_loadout["meleeWeapon"];
    }
    else if ( isgamemodeclass )
    {
        local_loadout = self.pers["gamemodeLoadout"];
        loadoutPrimary = local_loadout["loadoutPrimary"];
        loadoutPrimaryAttachKit = local_loadout["loadoutPrimaryAttachKit"];
        loadoutPrimaryFurnitureKit = local_loadout["loadoutPrimaryFurnitureKit"];
        loadoutPrimaryCamo = local_loadout["loadoutPrimaryCamo"];
        loadoutPrimaryReticle = local_loadout["loadoutPrimaryReticle"];
        loadoutSecondary = local_loadout["loadoutSecondary"];
        loadoutSecondaryAttachKit = local_loadout["loadoutSecondaryAttachKit"];
        loadoutSecondaryFurnitureKit = local_loadout["loadoutSecondaryFurnitureKit"];
        loadoutSecondaryCamo = local_loadout["loadoutSecondaryCamo"];
        loadoutSecondaryReticle = local_loadout["loadoutSecondaryReticle"];
        loadoutEquipment = local_loadout["loadoutEquipment"];
        loadoutOffhand = local_loadout["loadoutOffhand"];

        if ( loadoutOffhand == "specialty_null" )
            loadoutOffhand = "none";

        for ( local_counter = 0; local_counter < 3; local_counter++ )
            loadoutPerks[local_counter] = local_loadout["loadoutPerks"][local_counter];

        loadoutMelee = local_loadout["loadoutMelee"];
    }
    else if ( player_info == "callback" )
    {
        if ( !isdefined( self.classcallback ) )
            common_scripts\utility::error( "self.classCallback function reference required for class 'callback'" );

        local_loadout = [[ self.classcallback ]]( class_callback );

        if ( !isdefined( local_loadout ) )
            common_scripts\utility::error( "array required from self.classCallback for class 'callback'" );

        loadoutPrimary = local_loadout["loadoutPrimary"];
        loadoutPrimaryAttachKit = local_loadout["loadoutPrimaryAttachKit"];
        loadoutPrimaryFurnitureKit = local_loadout["loadoutPrimaryFurnitureKit"];
        loadoutPrimaryCamo = local_loadout["loadoutPrimaryCamo"];
        loadoutPrimaryReticle = local_loadout["loadoutPrimaryReticle"];
        loadoutSecondary = local_loadout["loadoutSecondary"];
        loadoutSecondaryAttachKit = local_loadout["loadoutSecondaryAttachKit"];
        loadoutSecondaryFurnitureKit = local_loadout["loadoutSecondaryFurnitureKit"];
        loadoutSecondaryCamo = local_loadout["loadoutSecondaryCamo"];
        loadoutSecondaryReticle = local_loadout["loadoutSecondaryReticle"];
        loadoutEquipment = local_loadout["loadoutEquipment"];
        loadoutOffhand = local_loadout["loadoutOffhand"];
        loadoutPerks[0] = local_loadout["loadoutPerk1"];
        loadoutPerks[1] = local_loadout["loadoutPerk2"];
        loadoutPerks[2] = local_loadout["loadoutPerk3"];
        loadoutMelee = local_loadout["loadoutMelee"];
    }
    else
    {
        class_number = maps\mp\_utility::getclassindex( player_info );
        loadoutPrimary = maps\mp\gametypes\_class::table_getweapon( level.classtablename, class_number, 0 );
        loadoutPrimaryAttachKit = maps\mp\gametypes\_class::table_getweaponattachkit( level.classtablename, class_number, 0 );
        loadoutPrimaryFurnitureKit = table_getweaponfurniturekit( level.classtablename, class_number, 0 );
        loadoutPrimaryCamo = maps\mp\gametypes\_class::table_getweaponcamo( level.classtablename, class_number, 0 );
        loadoutPrimaryReticle = maps\mp\gametypes\_class::table_getweaponreticle( level.classtablename, class_number, 0 );
        loadoutSecondary = maps\mp\gametypes\_class::table_getweapon( level.classtablename, class_number, 1 );
        loadoutSecondaryAttachKit = maps\mp\gametypes\_class::table_getweaponattachkit( level.classtablename, class_number, 1 );
        loadoutSecondaryFurnitureKit = table_getweaponfurniturekit( level.classtablename, class_number, 1 );
        loadoutSecondaryCamo = maps\mp\gametypes\_class::table_getweaponcamo( level.classtablename, class_number, 1 );
        loadoutSecondaryReticle = maps\mp\gametypes\_class::table_getweaponreticle( level.classtablename, class_number, 1 );
        loadoutEquipment = maps\mp\gametypes\_class::table_getequipment( level.classtablename, class_number );
        loadoutOffhand = maps\mp\gametypes\_class::table_getoffhand( level.classtablename, class_number );
        loadoutPerks[0] = maps\mp\gametypes\_class::table_getperk( level.classtablename, class_number, 0 );
        loadoutPerks[1] = maps\mp\gametypes\_class::table_getperk( level.classtablename, class_number, 1 );
        loadoutPerks[2] = maps\mp\gametypes\_class::table_getperk( level.classtablename, class_number, 2 );
        loadoutMelee = "none";
    }

    public_lobby = issubstr( player_info, "custom" ) || issubstr( player_info, "lobby" );
    private_lobby = issubstr( player_info, "recipe" );

    if ( !isgamemodeclass && !private_lobby && !level.oldschool && !( isdefined( self.pers["copyCatLoadout"] ) && self.pers["copyCatLoadout"]["inUse"] && random_bool ) )
    {
        if ( !isvalidprimary( loadoutPrimary, 1 ) || level.rankedmatch && public_lobby && !self isitemunlocked( loadoutPrimary ) )
        {
            loadoutPrimary = maps\mp\gametypes\_class::table_getweapon( level.classtablename, 10, 0 );
            loadoutPrimaryCamo = "none";
            loadoutPrimaryReticle = "none";
            loadoutPrimaryAttachKit = "none";
            loadoutPrimaryFurnitureKit = "none";
        }

        if ( !maps\mp\gametypes\_class::isvalidcamo( loadoutPrimaryCamo, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::iscamounlocked( loadoutPrimary, loadoutPrimaryCamo ) )
            loadoutPrimaryCamo = maps\mp\gametypes\_class::table_getweaponcamo( level.classtablename, 10, 0 );

        if ( !maps\mp\gametypes\_class::isvalidreticle( loadoutPrimaryReticle, 1 ) )
            loadoutPrimaryReticle = maps\mp\gametypes\_class::table_getweaponreticle( level.classtablename, 10, 0 );

        if ( !maps\mp\gametypes\_class::isvalidattachkit( loadoutPrimaryAttachKit, loadoutPrimary, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::isattachkitunlocked( loadoutPrimary, loadoutPrimaryAttachKit ) )
            loadoutPrimaryAttachKit = maps\mp\gametypes\_class::table_getweaponattachkit( level.classtablename, 10, 0 );

        if ( !maps\mp\gametypes\_class::isvalidfurniturekit( loadoutPrimaryFurnitureKit, loadoutPrimary, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::isfurniturekitunlocked( loadoutPrimary, loadoutPrimaryFurnitureKit ) )
            loadoutPrimaryFurnitureKit = table_getweaponfurniturekit( level.classtablename, 10, 0 );

        has_specialty_twoprimaries = common_scripts\utility::array_contains( loadoutPerks, "specialty_twoprimaries" );

        if ( !isvalidsecondary( loadoutSecondary, has_specialty_twoprimaries, 1 ) || level.rankedmatch && public_lobby && !self isitemunlocked( loadoutSecondary ) )
        {
            loadoutSecondary = maps\mp\gametypes\_class::table_getweapon( level.classtablename, 10, 1 );
            loadoutSecondaryCamo = "none";
            loadoutSecondaryReticle = "none";
            loadoutSecondaryAttachKit = "none";
            loadoutSecondaryFurnitureKit = "none";
        }

        if ( !maps\mp\gametypes\_class::isvalidcamo( loadoutSecondaryCamo, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::iscamounlocked( loadoutSecondary, loadoutSecondaryCamo ) )
            loadoutSecondaryCamo = maps\mp\gametypes\_class::table_getweaponcamo( level.classtablename, 10, 1 );

        if ( !maps\mp\gametypes\_class::isvalidreticle( loadoutSecondaryReticle, 1 ) )
            loadoutSecondaryReticle = maps\mp\gametypes\_class::table_getweaponreticle( level.classtablename, 10, 1 );

        if ( !maps\mp\gametypes\_class::isvalidattachkit( loadoutSecondaryAttachKit, loadoutSecondary, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::isattachkitunlocked( loadoutSecondary, loadoutSecondaryAttachKit ) )
            loadoutSecondaryAttachKit = maps\mp\gametypes\_class::table_getweaponattachkit( level.classtablename, 10, 1 );

        if ( !isvalidfurniturekit( loadoutSecondaryFurnitureKit, loadoutSecondary, 1 ) || level.rankedmatch && public_lobby && !maps\mp\gametypes\_class::isfurniturekitunlocked( loadoutSecondary, loadoutSecondaryFurnitureKit ) )
            loadoutSecondaryFurnitureKit = table_getweaponfurniturekit( level.classtablename, 10, 1 );

        if ( !maps\mp\gametypes\_class::isvalidequipment( loadoutEquipment, 1 ) || level.rankedmatch && public_lobby && !self isitemunlocked( loadoutEquipment ) )
            loadoutEquipment = maps\mp\gametypes\_class::table_getequipment( level.classtablename, 10 );

        if ( loadoutEquipment == loadoutOffhand )
            loadoutEquipment = "specialty_null";

        if ( !maps\mp\gametypes\_class::isvalidoffhand( loadoutOffhand, 1 ) )
            loadoutOffhand = maps\mp\gametypes\_class::table_getoffhand( level.classtablename, 10 );

        if ( !maps\mp\gametypes\_class::isvalidmeleeweapon( loadoutMelee, 1 ) )
            loadoutMelee = "none";
    }

    for ( local_counter = 0; local_counter < 3; local_counter++ )
    {
        if ( loadoutPerks[local_counter] == "specialty_null" )
            continue;

        perk_equiped = loadoutPerks[local_counter];
        loadoutPerks[local_counter] = maps\mp\perks\_perks::validateperk( local_counter, loadoutPerks[local_counter] );

        if ( perk_equiped != loadoutPerks[local_counter] )
            foundinfraction( "^1Warning: Perk " + perk_equiped + " in wrong slot." );

        if ( local_counter == 0 && loadoutPerks[local_counter] != "specialty_null" && ( maps\mp\gametypes\_class::isgrenadelauncher( loadoutPrimaryAttachKit ) || maps\mp\gametypes\_class::isgrenadelauncher( loadoutSecondaryAttachKit ) ) )
        {
            foundinfraction( "^1Warning: Player has a perk " + perk_equiped + " in slot 1 and a grenade launcher too." );
            loadoutPerks[0] = "specialty_null";
        }

        if ( local_counter == 0 && loadoutPerks[local_counter] != "specialty_null" && ( maps\mp\gametypes\_class::isgrip( loadoutPrimaryAttachKit ) || maps\mp\gametypes\_class::isgrip( loadoutSecondaryAttachKit ) ) )
        {
            foundinfraction( "^1Warning: Player has a perk " + perk_equiped + " in slot 1 and a foregrip too." );
            loadoutPerks[0] = "specialty_null";
        }

        if ( local_counter == 0 && loadoutPerks[local_counter] == "specialty_specialgrenade" && loadoutOffhand == "h1_smokegrenade_mp" )
        {
            foundinfraction( "^1Warning: Player has perk specialty_specialgrenade in slot 1 and smoke grenades too." );
            loadoutPerks[0] = "specialty_null";
        }
    }

    emblemPatchIndex = 0;
    shouldApplyEmblemToWeapon = 0;
    shouldApplyEmblemToCharacter = 0;

    if ( maps\mp\_utility::invirtuallobby() )
    {
        emblemPatchIndex = self.emblemloadout.emblemindex;
        shouldApplyEmblemToWeapon = self.emblemloadout.shouldapplyemblemtoweapon;
        shouldApplyEmblemToCharacter = self.emblemloadout.shouldapplyemblemtocharacter;
    }
    else
    {
        emblemPatchIndex = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "emblemPatchIndex" );

        if ( isai( self ) )
        {
            shouldApplyEmblemToWeapon = self.pers["shouldApplyEmblemToWeapon"];
            shouldApplyEmblemToCharacter = self.pers["shouldApplyEmblemToCharacter"];
        }
        else
        {
            shouldApplyEmblemToWeapon = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "applyEmblemToWeapon" );
            shouldApplyEmblemToCharacter = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "applyEmblemToCharacter" );
        }
    }

    weaponEmblemPatchIndex = emblemPatchIndex;

    if ( !shouldApplyEmblemToWeapon )
        weaponEmblemPatchIndex = -1;

    characterCamoIndex = 0;

    if ( maps\mp\_utility::invirtuallobby() )
        characterCamoIndex = self.charactercamoloadout.camoindex;
    else
        characterCamoIndex = self getplayerdata( common_scripts\utility::getstatsgroup_common(), "characterCamoIndex" );

    final_loadout = spawnstruct();
    final_loadout.class = player_info;
    final_loadout.class_num = class_number;
    final_loadout.teamname = player_team;
    final_loadout.clearammo = clearammo;
    final_loadout.copycatloadout = do_copycat_loadout;
    final_loadout.cacloadout = is_custom_class;
    final_loadout.isgamemodeclass = isgamemodeclass;
    final_loadout.primary = loadoutPrimary;
    final_loadout.primaryattachkit = loadoutPrimaryAttachKit;
    final_loadout.primaryfurniturekit = loadoutPrimaryFurnitureKit;
    final_loadout.primarycamo = loadoutPrimaryCamo;
    final_loadout.primaryreticle = loadoutPrimaryReticle;
    loadoutPrimaryCamo = int( tablelookup( "mp/camoTable.csv", 1, final_loadout.primarycamo, 0 ) );
    loadoutPrimaryReticle = int( tablelookup( "mp/reticleTable.csv", 1, final_loadout.primaryreticle, 0 ) );
    final_loadout.primaryname = buildweaponname( final_loadout.primary, final_loadout.primaryattachkit, final_loadout.primaryfurniturekit, loadoutPrimaryCamo, loadoutPerks );
    final_loadout.secondary = loadoutSecondary;
    final_loadout.secondaryattachkit = loadoutSecondaryAttachKit;
    final_loadout.secondaryfurniturekit = loadoutSecondaryFurnitureKit;
    final_loadout.secondarycamo = loadoutSecondaryCamo;
    final_loadout.secondaryreticle = loadoutSecondaryReticle;
    loadoutSecondaryCamo = int( tablelookup( "mp/camoTable.csv", 1, final_loadout.secondarycamo, 0 ) );
    loadoutSecondaryReticle = int( tablelookup( "mp/reticleTable.csv", 1, final_loadout.secondaryreticle, 0 ) );
    final_loadout.secondaryname = buildweaponname( final_loadout.secondary, final_loadout.secondaryattachkit, final_loadout.secondaryfurniturekit, loadoutSecondaryCamo, loadoutPerks );
    final_loadout.equipment = loadoutEquipment;
    final_loadout.offhand = loadoutOffhand;
    final_loadout.perks = loadoutPerks;
    final_loadout.deathstreak = loadoutMelee;

    final_loadout.setprimaryspawnweapon = setprimaryspawnweapon;
    final_loadout.emblemindex = emblemPatchIndex;
    final_loadout.weaponemblemindex = weaponEmblemPatchIndex;
    final_loadout._id_A7EC = shouldApplyEmblemToCharacter;
    final_loadout._id_A7ED = characterCamoIndex;

    if ( maps\mp\_utility::is_true( level.movecompareactive ) && isdefined( level.movecompareloadoutfunc ) )
        final_loadout = self [[ level.movecompareloadoutfunc ]]();

    return final_loadout;
}

foundinfraction(why)
{
    print(why);
}

isvalidfurniturekit( var_0, var_1, var_2 )
{
    return maps\mp\gametypes\_class::isvalidattachkit(var_0, var_1, var_2);
}

furniturekitnametoid( var_0 )
{
    var_1 = tablelookup( "mp/attachkits.csv", 1, var_0, 0 );
    var_1 = int( var_1 );
    return var_1;
}

cac_getweaponfurniturekit( var_0, var_1, var_2 )
{
    var_3 = maps\mp\gametypes\_class::cac_getweaponfurniturekitid( var_0, var_1, var_2 );
    var_4 = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( var_3 ), 1 );
    return var_4;
}

getmatchrulesspecialclass( var_0, var_1 )
{
    var_2 = [];
    var_2["loadoutPrimary"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 0, "weapon" );
    var_3 = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 0, "kit", "attachKit" );
    var_4 = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 0, "kit", "furnitureKit" );
    var_2["loadoutPrimaryAttachKit"] = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( var_3 ), 1 );
    var_2["loadoutPrimaryFurnitureKit"] = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( var_4 ), 1 );
    var_2["loadoutPrimaryCamo"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 0, "camo" );
    var_2["loadoutPrimaryReticle"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 0, "reticle" );
    var_2["loadoutSecondary"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 1, "weapon" );
    var_3 = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 1, "kit", "attachKit" );
    var_4 = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 1, "kit", "furnitureKit" );
    var_2["loadoutSecondaryAttachKit"] = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( var_3 ), 1 );
    var_2["loadoutSecondaryFurnitureKit"] = tablelookup( "mp/attachkits.csv", 0, common_scripts\utility::tostring( var_4 ), 1 );
    var_2["loadoutSecondaryCamo"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 1, "camo" );
    var_2["loadoutSecondaryReticle"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "weaponSetups", 1, "reticle" );
    var_2["loadoutEquipment"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "equipment", 0 );
    var_2["loadoutOffhand"] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "equipment", 1 );

    for ( var_5 = 0; var_5 < 3; var_5++ )
        var_2["loadoutPerks"][var_5] = getmatchrulesdata( "defaultClasses", var_0, "defaultClass", var_1, "class", "perkSlots", var_5 );

    var_2["loadoutMelee"] = "none";
    return var_2;
}

isvalidcamo( var_0, var_1 )
{
    switch ( var_0 )
    {
    case "none":
    case "camo016":
    case "camo017":
    case "camo018":
    case "camo019":
    case "camo020":
    case "camo021":
    case "camo022":
    case "camo023":
    case "camo024":
    case "camo025":
    case "camo026":
    case "camo027":
    case "camo028":
    case "camo029":
    case "camo030":
    case "camo031":
    case "camo032":
    case "camo033":
    case "camo034":
    case "camo035":
    case "camo036":
    case "camo037":
    case "camo038":
    case "camo039":
    case "camo040":
    case "camo041":
    case "camo042":
    case "camo043":
    case "camo044":
    case "camo045":
    case "camo046":
    case "camo047":
    case "camo048":
    case "camo049":
    case "camo050":
    case "camo051":
    case "camo052":
    case "camo053":
    case "camo054":
    case "toxicwaste":
    case "camo056":
    case "camo057":
    case "camo058":
	case "camo059":
    case "golddiamond":
    case "gold":
	case "camo060":
    case "camo061":
	case "camo062":
        return 1;
    default:
        if ( maps\mp\_utility::is_true( var_1 ) )
            maps\mp\gametypes\_class::foundinfraction( "Replacing invalid camo: " + var_0 );

        return 0;
    }
}

find_in_table(csv, weap)
{
    rows = tablegetrowcount(csv);

    for (i = 0; i < rows; i++)
    {
        if (tablelookupbyrow(csv, i, 0) == weap)
        {
            return true;
        }
    }

    return false;
}

get_attachment_override(weapon, attachment)
{
    csv = "mp/attachoverrides.csv";
    rows = tablegetrowcount(csv);

    if (!issubstr(weapon, "_mp"))
    {
        weapon += "_mp";
    }

    for (i = 0; i < rows; i++)
    {
        if (tablelookupbyrow(csv, i, 0) == weapon && tablelookupbyrow(csv, i, 1) == attachment)
        {
            return tablelookupbyrow(csv, i, 2);
        }
    }
}

get_attachment_name(weapon, attachment)
{
    name = tablelookup("mp/attachkits.csv", 1, attachment, 2);
    override = get_attachment_override(weapon, name);

    if (isdefined(override) && override != "")
    {
        return override;
    }

    return name;
}

is_custom_weapon(weap)
{
    return find_in_table("mp/customweapons.csv", weap);
}

h2_buildweaponname( baseName, attachment1, attachment2, camo, perks )
{
    print("CAMO: " + camo);

    weaponName = baseName;

    attachments = [];
    attachments[attachments.size] = attachment1;

    perk1 = "";
    if (isdefined(perks) && typeof(perks) == "array" && perks.size > 0)
    {
        perk1 = perks[0];
    }

    if (perk1 == "specialty_bling" || perk1 == "specialty_secondarybling" )
        attachments[attachments.size] = attachment2;

    attachments = common_scripts\utility::array_remove( attachments, "none" );
    
    if (h2_shouldaddscope(weaponName, attachments))
    {        
        scope_suffix = (weaponName == "h2_usr_mp" && h2_isanimatedcamo(camo)) ? "scpalt" : "scope";
        attachments[attachments.size] = h2_getsniperscope(weaponName, scope_suffix);
    }

    weapon_class = maps\mp\_utility::getweaponclass(weaponName);
    if (weapon_class == "weapon_sniper")
    {
        if (isdefined(self.pers["class"]))
        {
            class_index = maps\mp\_utility::getclassindex(self.pers["class"]);
            if (isdefined(class_index))
            {
                should_use_classic = self getcacplayerdata(class_index, "use2dScopes");
                if (should_use_classic)
                {
                    attachments = common_scripts\utility::array_remove(attachments, "acogh2");
                    attachments = common_scripts\utility::array_remove(attachments, "thermal");
				
                    if (issubstr(weaponname, "msr") || issubstr(weaponname, "as50") || issubstr(weaponname, "l118a"))
						{
					   attachments[attachments.size] = "ogscopeiw5";
					   }
					else if (issubstr(weaponname, "usr"))
					{
						attachments[attachments.size] = "ogscopeusr";
					}
                    else
                        attachments[attachments.size] = "ogscope";
                }
            }
        }
    }

    if ( IsDefined( attachments.size ) && attachments.size )
    {
        attachments = common_scripts\utility::alphabetize( attachments );
    }

    foreach ( attachment in attachments )
    {
        name = get_attachment_name(baseName, attachment);
        if (isdefined(name) && name != "")
            attachment = name;

        if (issubstr(weaponName, "_" + attachment))
            weaponName = weaponName;
        else
            weaponName += "_" + attachment;

        if (attachment == "gl" || attachment == "glak47")
            weaponName += "_glpre";

        if (attachment == "sho")
            weaponName += "_shopre";
    }

    if ( isSubStr(weaponName, "at4_") || isSubStr(weaponName, "stinger_") || isSubStr(weaponName, "javelin_") || IsSubStr( weaponName, "h2_" ) || IsSubStr( weaponName, "h1_" ) )
    {
        weaponName = maps\mp\gametypes\_class::buildweaponnamecamo(weaponName, camo);
    }
    else if ( !isValidWeapon( weaponName + "_mp", false ) )
    {
        weaponName = baseName + "_mp";
    }
    else
    {
        weaponName = maps\mp\gametypes\_class::buildweaponnamecamo(weaponName, camo);
        weaponName += "_mp";
    }

    return weaponName;
}

buildweaponname(var_0, var_1, var_2, var_3, perks, var_5)
{
    if (!isdefined(var_0) || var_0 == "none" || var_0 == "")
    {
        return var_0;
    }

    if (!isdefined(level.lettertonumber))
    {
        level.lettertonumber = maps\mp\gametypes\_class::makeletterstonumbers();
    }

    var_6 = "";

    if (issubstr(var_0, "iw5_") || issubstr(var_0, "h1_") || issubstr(var_0, "h2_") || var_0 == "at4" || var_0 == "stinger" || var_0 == "javelin")
    {
        var_7 = var_0 + "_mp";
        var_8 = var_0.size;

        if (issubstr(var_0, "h1_") || issubstr(var_0, "h2_") || var_0 == "at4" || var_0 == "stinger" || var_0 == "javelin")
        {
            var_6 = getsubstr(var_0, 3, var_8);
        }
        else
        {
            var_6 = getsubstr(var_0, 4, var_8);
        }
    }
    else
    {
        var_7 = var_0;
        var_6 = var_0;
    }

    if (var_7 == "h1_junsho_mp")
    {
        var_1 = "akimbohidden";
    }

    var_9 = isdefined(var_1) && var_1 != "none";
    var_10 = isdefined(var_2) && var_2 != "none";

    if (!var_10)
    {
        var_11 = tablelookuprownum("mp/furniturekits/base.csv", 0, var_7);

        if (var_11 >= 0)
        {
            var_2 = "base";
            var_10 = 1;
        }
    }

    if (issubstr(var_7, "h2_") || issubstr(var_7, "h1_") || var_7 == "at4_mp" || var_7 == "stinger_mp" || var_7 == "javelin_mp")
    {
        if (var_2 == "base")
            var_2 = "none";
        return h2_buildweaponname( var_7, var_1, var_2, var_3, perks);
    }

    if (!issubstr(var_0, "h1_") && !issubstr(var_0, "h2_"))
    {
        if (var_9)
        {
            name = get_attachment_name(var_0, var_1);
            if (isdefined(name) && name != "")
            {
                var_7 += "_" + name;
            }
        }
    }
    else if (var_9 || var_10)
    {
        if (!var_9)
            var_1 = "none";

        if (!var_10)
            var_2 = "base";

        if (issubstr(var_0, "h2_"))
            var_2 = "none";

        var_7 += ("_a#" + var_1);
        var_7 += ("_f#" + var_2);
    }
    else if (issubstr(var_7, "iw5_") || issubstr(var_7, "h1_"))
    {
        /*
        var_7 = maps\mp\gametypes\_class::buildweaponnamereticle(var_7, var_4);
        var_7 = maps\mp\gametypes\_class::buildweaponnameemblem(var_7, var_5);
        */
        var_7 = maps\mp\gametypes\_class::buildweaponnamecamo(var_7, var_3);
        return var_7;
    }
    else if (!isvalidweapon(var_7 + "_mp"))
    {
        return var_0 + "_mp";
    }
    else
    {
        /*
        var_7 = maps\mp\gametypes\_class::buildweaponnamereticle(var_7, var_4);
        var_7 = maps\mp\gametypes\_class::buildweaponnameemblem(var_7, var_5);
        */
        var_7 = maps\mp\gametypes\_class::buildweaponnamecamo(var_7, var_3);
        return var_7 + "_mp";
    }
}

h2_shouldaddscope(weap, attachments)
{
    return weaponclass(weap) == "sniper" && !common_scripts\utility::array_contains(attachments, "acogh2") && !common_scripts\utility::array_contains(attachments, "thermal");
}

h2_isanimatedcamo(camo)
{
    if (issubstr(camo, "35")
    || issubstr(camo, "36")
    || issubstr(camo, "37")
    || issubstr(camo, "38")
    || issubstr(camo, "39")
    || issubstr(camo, "40")
    || issubstr(camo, "41")
    || issubstr(camo, "44")
    ) return true;

    return false;
}

h2_getsniperscope(weap, scope_suffix)
{
    weap_name_prefix = strtok(weap, "_")[1];

    if (isdefined(weap_name_prefix))
        return weap_name_prefix + scope_suffix;        
}

isvalidweapon(var_0, var_1)
{
    if (!isdefined(level.weaponrefs))
    {
        level.weaponrefs = [];

        foreach (var_3 in level.weaponlist)
        {
            level.weaponrefs[var_3] = 1;
        }
    }

    if (isdefined(level.weaponrefs[var_0]))
    {
        return 1;
    }

    return 0;
}

isvalidsecondary(var_0, var_1, var_2)
{
    switch (var_0)
    {
    case "none":
    case "h2_pp2000":
    case "h2_glock":
    case "h2_beretta393":
    case "h2_tmp":
    case "h2_usp":
    case "h2_coltanaconda":
    case "h2_mp412":
    case "h2_m9":
    case "h2_colt45":
    case "h2_deserteagle":
    case "h2_spas12":
    case "h2_aa12":
    case "h2_ksg":
    case "h2_striker":
    case "h2_ranger":
    case "h2_winchester1200":
    case "h2_m1014":
    case "h2_model1887":
    case "at4":
    case "h2_m79":
    case "h2_m320":
    case "stinger":
    case "javelin":
    case "h2_rpg":
    case "h2_shovel":
    case "h2_karambit":
    case "h2_hatchet":
    case "h2_icepick":
    case "h2_sickle":
    case "h2_fmg9":
	case "h2_p226":
        return 1;
    default:
        //maps\mp\gametypes\_class::foundinfraction(va("%s is not valid secondary", var_0));
        return 0;
    }

    return 0;
}

isvalidprimary(var_0, var_1)
{
    switch (var_0)
    {
    case "h2_m4":
    case "h2_famas":
    case "h2_scar":
    case "h2_tavor":
    case "h2_fal":
    case "h2_cm901":
    case "h2_m16":
	case "h2_g36c":
    case "h2_masada":
    case "h2_fn2000":
    case "h2_ak47":
    case "h2_mp5k":
    case "h2_ump45":
    case "h2_kriss":
    case "h2_p90":
    case "h2_pm9":
    case "h2_uzi":
    case "h2_mp7":
    case "h2_ak74u":
    case "h2_cheytac":
    case "h2_as50":
    case "h2_barrett":
    case "h2_d25s":
    case "h2_wa2000":
    case "h2_m21":
    case "h2_msr":
    case "h2_m40a3":
    case "h2_sa80":
    case "h2_rpd":
	case "h2_pkm":
    case "h2_mg4":
    case "h2_aug":
    case "h2_m240":
    case "h2_inspect":
	case "h2_mp5":
	case "h2_l118a":
	case "h2_iw5acr":
	case "h2_aac":
	case "h2_usr":

        return 1;
    default:
        return 0;
    }

    return 0;
}

isvalidequipment( var_0, var_1 )
{
    var_0 = maps\mp\_utility::strip_suffix( var_0, "_lefthand" );

    switch ( var_0 )
    {
    case "specialty_null":
    case "h1_fraggrenade_mp":
    case "h2_semtex_mp":
    case "iw9_throwknife_mp":
    case "specialty_tacticalinsertion":
   // case "specialty_blastshield":
    case "h1_claymore_mp":
    case "h1_c4_mp":
        return 1;
    default:
        if ( maps\mp\_utility::is_true( var_1 ) )
            maps\mp\gametypes\_class::foundinfraction( "Replacing invalid equipment: " + var_0 );

        return 0;
    }
}

giveoffhand( var_0 )
{
    var_1 = maps\mp\_utility::strip_suffix( var_0, "_lefthand" );

    switch ( var_1 )
    {
    case "specialty_tacticalinsertion":
        self giveweapon("flare_mp");
        break;
    case "h1_fraggrenade_mp":
    case "h2_semtex_mp":
    case "iw9_throwknife_mp":
    case "h1_claymore_mp":
    case "h1_c4_mp":
    case "h1_smokegrenade_mp":
    case "h1_concussiongrenade_mp":
    case "h1_flashgrenade_mp":
    case "h2_empgrenade_mp":
	case "h2_trophy_mp":
        self giveweapon(var_0);
        break;
    case "none":
    case "specialty_null":
    //case "specialty_blastshield":
    default:
        break;
    }
}

takeoffhand( var_0 )
{
    var_1 = maps\mp\_utility::strip_suffix( var_0, "_lefthand" );

    switch ( var_1 )
    {
    case "h1_fraggrenade_mp":
    case "h2_semtex_mp":
    case "iw9_throwknife_mp":
    case "specialty_tacticalinsertion":
   // case "specialty_blastshield":
    case "h1_claymore_mp":
    case "h1_c4_mp":
    case "h1_smokegrenade_mp":
    case "h1_concussiongrenade_mp":
    case "h1_flashgrenade_mp":
    case "h2_empgrenade_mp":
	case "h2_trophy_mp":
        self takeweapon( var_0 );
        break;
    case "none":
    case "specialty_null":
    default:
        break;
    }
}

is_lethal_equipment( var_0 )
{
    if ( !isdefined( var_0 ) )
        return 0;

    switch ( var_0 )
    {
    case "h1_fraggrenade_mp":
    case "h2_semtex_mp":
    case "iw9_throwknife_mp":
    case "specialty_tacticalinsertion":
  //  case "specialty_blastshield":
    case "h1_claymore_mp":
    case "h1_c4_mp":
        return 1;
    default:
        return 0;
    }
}

isvalidmeleeweapon( var_0, var_1 )
{
    switch ( var_0 )
    {
    case "none":
    case "specialty_combathigh":
    case "specialty_copycat":
    case "specialty_finalstand":
    case "specialty_grenadepulldeath":
        return 1;
    default:
        if ( maps\mp\_utility::is_true( var_1 ) )
            foundinfraction( "Replacing invalid melee weapon: " + var_0 );

        return 0;
    }
}

isvalidattachment( var_0, var_1, var_2 )
{
    var_3 = 0;

    switch ( var_0 )
    {
    case "none":
    case "thermal":
    case "stock":
    case "shotgun":
    case "sho":
    case "shopre":
    case "gl":
    case "glmwr":
    case "masterkeymwr":
    case "glpremwr":
    case "glpre":
    case "masterkeypremwr":
    case "tacknifemwr":
    case "akimbo":
    case "zoomscope":
    case "ironsights":
    case "acog":
    case "acogsmg":
    case "reflex":
    case "reflexsmg":
    case "reflexlmg":
    case "silencer":
    case "silencer02":
    case "silencer03":
    case "grip":
    case "gp25":
    case "m320":
    case "thermalsmg":
    case "heartbeat":
    case "fmj":
    case "rof":
    case "xmags":
    case "dualmag":
    case "eotech":
    case "eotechsmg":
    case "eotechlmg":
    case "tactical":
    case "scopevz":
    case "hamrhybrid":
    case "hybrid":
    case "parabolicmicrophone":
    case "opticsreddot":
    case "opticsacog2":
    case "opticseotech":
    case "opticsthermal":
    case "silencer01":
    case "sensorheartbeat":
    case "foregrip":
    case "variablereddot":
    case "opticstargetenhancer":
    case "firerate":
    case "longrange":
    case "quickdraw":
    case "lasersight":
    case "thorscopevz":
    case "trackrounds":
    case "stabilizer":
    case "heatsink":
    case "rw1scopebase":
    case "crossbowscopebase":
    case "silencerpistol":
    case "silencersniper":
    case "acogmwr":
    case "gripmwr":
    case "reflexmwr":
    case "silencermwr":
    case "akimbomwr":
    case "heartbeatmwr":
    case "holosightmwr":
    case "longbarrelmwr":
    case "reflexvarmwr":
    case "thermalmwr":
    case "varzoommwr":
    case "xmagmwr":
        var_3 = 1;
        break;
    default:
        var_3 = 0;
        break;
    }

    if ( var_3 && var_0 != "none" )
    {
        var_4 = maps\mp\_utility::getweaponattachmentarrayfromstats( var_1 );
        var_3 = common_scripts\utility::array_contains( var_4, var_0 );
    }

    if ( !var_3 && maps\mp\_utility::is_true( var_2 ) )
        foundinfraction( "Replacing invalid attachment: " + var_0 );

    return var_3;
}
