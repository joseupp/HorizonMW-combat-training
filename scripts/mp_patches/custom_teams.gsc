#define CONST_DLC_FACTIONS_ENABLED 1

main()
{
    replacefunc(maps\mp\gametypes\_teams::playercostume, ::playercostume_stub);
    replacefunc(maps\mp\gametypes\_teams::setteammodels, ::setteammodels_stub);
    replacefunc(maps\mp\gametypes\_teams::setghilliemodels, ::setghilliemodels_stub);
}

setghilliemodels_stub( env )
{
    level.environment = env;
    /*
    switch ( env )
    {
    case "desert":
    mptype_ally_ghillie_desert_precache();
    mptype_opforce_ghillie_desert_precache();
    game["allies_model"]["GHILLIE"] = ::mptype_ally_ghillie_desert_main;
    game["axis_model"]["GHILLIE"] = ::mptype_opforce_ghillie_desert_main;
    break;
    case "arctic":
    mptype_ally_ghillie_arctic_precache();
    mptype_opforce_ghillie_arctic_precache();
    game["allies_model"]["GHILLIE"] = ::mptype_ally_ghillie_arctic_main;
    game["axis_model"]["GHILLIE"] = ::mptype_opforce_ghillie_arctic_main;
    break;
    case "urban":
    mptype_ally_ghillie_urban_precache();
    mptype_opforce_ghillie_urban_precache();
    game["allies_model"]["GHILLIE"] = ::mptype_ally_ghillie_urban_main;
    game["axis_model"]["GHILLIE"] = ::mptype_opforce_ghillie_urban_main;
    break;
    case "forest":
    mptype_ally_ghillie_forest_precache();
    mptype_opforce_ghillie_forest_precache();
    game["allies_model"]["GHILLIE"] = ::mptype_ally_ghillie_forest_main;
    game["axis_model"]["GHILLIE"] = ::mptype_opforce_ghillie_forest_main;
    break;
    default:
    break;			
    }
    */
}

////////////////////////////////
//           TF141            //
////////////////////////////////

tf141_assault_precache()
{
    precachemodel( "body_h2_tf141_assault" );
    precachemodel( "head_h2_tf141_assault" );
    precachemodel( "viewhands_tf141" );
}

tf141_smg_precache()
{
    precachemodel( "body_h2_tf141_smg" );
    precachemodel( "head_h2_tf141_lmg" );
    precachemodel( "viewhands_tf141" );
}

tf141_lmg_precache()
{
    precachemodel( "body_h2_tf141_assault" );
    precachemodel( "head_h2_tf141_smg" );
    precachemodel( "viewhands_tf141" );
}

tf141_assault_main()
{
    self setviewmodel("viewhands_tf141");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

tf141_smg_main()
{
    self setviewmodel("viewhands_tf141");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

tf141_lmg_main()
{
    self setviewmodel("viewhands_tf141");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//           OPFOR            //
////////////////////////////////

opfor_assault_precache()
{
    precachemodel( "body_h2_opforce_assault" );
    precachemodel( "head_h2_opforce_assault" );
    precachemodel( "viewhands_h1_arab_desert_mp_camo" );
}

opfor_smg_precache()
{
    precachemodel( "body_h2_opforce_smg" );
    precachemodel( "head_h2_opforce_smg" );
    precachemodel( "viewhands_h1_arab_desert_mp_camo" );
}

opfor_lmg_precache()
{
    precachemodel( "body_h2_opforce_lmg" );
    precachemodel( "head_h2_opforce_lmg" );
    precachemodel( "viewhands_h1_arab_desert_mp_camo" );
}

opfor_assault_main()
{
    self setviewmodel("viewhands_h1_arab_desert_mp_camo");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

opfor_smg_main()
{
    self setviewmodel("viewhands_h1_arab_desert_mp_camo");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

opfor_lmg_main()
{
    self setviewmodel("viewhands_h1_arab_desert_mp_camo");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//          SPETSNAZ          //
////////////////////////////////

spetsnaz_assault_precache()
{
    precachemodel( "body_h2_airborne_assault" );
    precachemodel( "head_h2_airborne_assault" );
    precachemodel( "globalViewhands_mw2_airborne" );
}

spetsnaz_smg_precache()
{
    precachemodel( "body_h2_airborne_smg" );
    precachemodel( "head_h2_airborne_smg" );
    precachemodel( "globalViewhands_mw2_airborne" );
}

spetsnaz_lmg_precache()
{
    precachemodel( "body_h2_airborne_lmg" );
    precachemodel( "head_h2_airborne_lmg" );
    precachemodel( "globalViewhands_mw2_airborne" );
}

spetsnaz_assault_main()
{
    self setviewmodel("globalViewhands_mw2_airborne");
    self.voice = "russian";
    self setclothtype( "vestlight" );
}

spetsnaz_smg_main()
{
    self setviewmodel("globalViewhands_mw2_airborne");
    self.voice = "russian";
    self setclothtype( "vestlight" );
}

spetsnaz_lmg_main()
{
    self setviewmodel("globalViewhands_mw2_airborne");
    self.voice = "russian";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//          RANGERS           //
////////////////////////////////

rangers_assault_precache()
{
    precachemodel( "body_h2_us_army_ar" );
    precachemodel( "head_h2_us_army_assault" );
    precachemodel( "viewhands_rangers" );
}

rangers_smg_precache()
{
    precachemodel( "body_h2_us_army_smg" );
    precachemodel( "head_h2_us_army_smg" );
    precachemodel( "viewhands_rangers" );
}

rangers_lmg_precache()
{
    precachemodel( "body_h2_us_army_lmg" );
    precachemodel( "head_h2_us_army_lmg" );
    precachemodel( "viewhands_rangers" );
}

rangers_assault_main()
{
    self setviewmodel("viewhands_rangers");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

rangers_smg_main()
{
    self setviewmodel("viewhands_rangers");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

rangers_lmg_main()
{
    self setviewmodel("viewhands_rangers");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//           SEALS            //
////////////////////////////////

seals_assault_precache()
{
    precachemodel( "body_h2_seal_assault" );
    precachemodel( "head_h2_seal_assault" );
    precachemodel( "viewhands_udt" );
}

seals_smg_precache()
{
    precachemodel( "body_h2_seal_smg" );
    precachemodel( "head_h2_seal_smg" );
    precachemodel( "viewhands_udt" );
}

seals_lmg_precache()
{
    precachemodel( "body_h2_seal_assault" );
    precachemodel( "head_h2_seal_lmg" );
    precachemodel( "viewhands_udt" );
}

seals_assault_main()
{
    self setviewmodel("viewhands_udt");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

seals_smg_main()
{
    self setviewmodel("viewhands_udt");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

seals_lmg_main()
{
    self setviewmodel("viewhands_udt");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//          MILITIA           //
////////////////////////////////

militia_assault_precache()
{
    precachemodel( "body_h2_militia_assault" );
    precachemodel( "head_h2_militia_assault" );
    precachemodel( "globalViewhands_mw2_militia" );
}

militia_smg_precache()
{
    precachemodel( "body_h2_militia_smg" );
    precachemodel( "head_h2_militia_smg" );
    precachemodel( "globalViewhands_mw2_militia" );
}

militia_lmg_precache()
{
    precachemodel( "body_h2_militia_lmg" );
    precachemodel( "head_h2_militia_lmg" );
    precachemodel( "globalViewhands_mw2_militia" );
}

militia_assault_main()
{
    self setviewmodel("globalViewhands_mw2_militia");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

militia_smg_main()
{
    self setviewmodel("globalViewhands_mw2_militia");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

militia_lmg_main()
{
    self setviewmodel("viewhands_udt");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

allies_ghillie_precache()
{
    precachemodel( "viewhands_h2_ghillie" );
}

allies_ghillie_setviewmodel()
{
    self setviewmodel("viewhands_h2_ghillie");
}

axis_ghillie_precache()
{
    precachemodel( "viewhands_h2_ghillie" );
}

axis_ghillie_setviewmodel()
{
    self setviewmodel("viewhands_h2_ghillie");
}

////////////////////////////////
//          gign           //
////////////////////////////////

gign_paris_assault_precache()
{
    precachemodel( "mp_body_gign_paris_assault" );
    precachemodel( "head_gign_a" );
    precachemodel( "viewhands_sas" );
}

gign_paris_smg_precache()
{
    precachemodel( "mp_body_gign_paris_smg" );
    precachemodel( "head_gign_b" );
    precachemodel( "viewhands_sas" );
}

gign_paris_lmg_precache()
{
    precachemodel( "mp_body_gign_paris_lmg" );
    precachemodel( "head_gign_c" );
    precachemodel( "viewhands_sas" );
}

gign_paris_assault_main()
{
    self detachall();
    self setmodel( "mp_body_gign_paris_assault" );
    self.headModel = "head_gign_a";
    self attach( "head_gign_a",  "", true );

    self setviewmodel("viewhands_sas");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

gign_paris_smg_main()
{
    self detachall();
    self setmodel( "mp_body_gign_paris_smg" );
    self.headModel = "head_gign_b";
    self attach( "head_gign_b",  "", true );

    self setviewmodel("viewhands_sas");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

gign_paris_lmg_main()
{
    self detachall();
    self setmodel( "mp_body_gign_paris_lmg" );
    self.headModel = "head_gign_c";
    self attach( "head_gign_c",  "", true );

    self setviewmodel("viewhands_sas");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//          pmc           //
////////////////////////////////

pmc_assault_precache()
{
    precachemodel( "mp_body_pmc_africa_assault_a" );
    precachemodel( "head_pmc_africa_a" );
    precachemodel( "viewhands_pmc" );
}

pmc_smg_precache()
{
    precachemodel( "mp_body_pmc_africa_smg_a" );
    precachemodel( "head_pmc_africa_b" );
    precachemodel( "viewhands_pmc" );
}

pmc_lmg_precache()
{
    precachemodel( "mp_body_pmc_africa_lmg_a" );
    precachemodel( "head_pmc_africa_c" );
    precachemodel( "viewhands_pmc" );
}

pmcmw3_assault_main()
{
    self detachall();
    self setmodel( "mp_body_pmc_africa_assault_a" );
    self.headModel = "head_pmc_africa_a";
    self attach( "head_pmc_africa_a",  "", true );

    self setviewmodel("viewhands_pmc");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

pmcmw3_smg_main()
{
    self detachall();
    self setmodel( "mp_body_pmc_africa_smg_a" );
    self.headModel = "head_pmc_africa_n";
    self attach( "head_pmc_africa_b",  "", true );

    self setviewmodel("viewhands_pmc");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

pmcmw3_lmg_main()
{
    self detachall();
    self setmodel( "mp_body_pmc_africa_lmg_a" );
    self.headModel = "head_pmc_africa_c";
    self attach( "head_pmc_africa_c",  "", true );

    self setviewmodel("viewhands_pmc");
    self.voice = "american";
    self setclothtype( "vestlight" );
}
////////////////////////////////
//           ic            //
////////////////////////////////

ic_assault_precache()
{
    precachemodel( "mp_body_henchmen_assault_a" );
    precachemodel( "head_henchmen_a" );
    precachemodel( "viewhands_henchmen" );
}

ic_smg_precache()
{
    precachemodel( "mp_body_henchmen_smg_a" );
    precachemodel( "head_henchmen_b" );
    precachemodel( "viewhands_henchmen" );
}

ic_lmg_precache()
{
    precachemodel( "mp_body_henchmen_lmg_a" );
    precachemodel( "head_henchmen_c" );
    precachemodel( "viewhands_henchmen" );
}

ic_assault_main()
{
    self detachall();
    self setmodel( "mp_body_henchmen_assault_a" );
    self.headModel = "head_henchmen_a";
    self attach( "head_henchmen_a",  "", true );

    self setviewmodel("viewhands_henchmen");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

ic_smg_main()
{
    self detachall();
    self setmodel( "mp_body_henchmen_smg_a" );
    self.headModel = "head_henchmen_b";
    self attach( "head_henchmen_b",  "", true );

    self setviewmodel("viewhands_henchmen");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

ic_lmg_main()
{
    self detachall();
    self setmodel( "mp_body_henchmen_lmg_a" );
    self.headModel = "head_henchmen_c";
    self attach( "head_henchmen_c",  "", true );

    self setviewmodel("viewhands_henchmen");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

////////////////////////////////
//           africa            //
////////////////////////////////

africa_assault_precache()
{
    precachemodel( "mp_body_africa_militia_assault_a" );
    precachemodel( "head_africa_militia_a_mp" );
    precachemodel( "viewhands_african_militia" );
}

africa_smg_precache()
{
    precachemodel( "mp_body_africa_militia_smg_b" );
    precachemodel( "head_africa_militia_b_mp" );
    precachemodel( "viewhands_african_militia" );
}

africa_lmg_precache()
{
    precachemodel( "mp_body_africa_militia_lmg_b" );
    precachemodel( "head_africa_militia_c_mp" );
    precachemodel( "viewhands_african_militia" );
}

africa_assault_main()
{
    self detachall();
    self setmodel( "mp_body_africa_militia_assault_a" );
    self.headModel = "head_africa_militia_a_mp";
    self attach( "head_africa_militia_a_mp",  "", 1 );

    self setviewmodel("viewhands_african_militia");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

africa_smg_main()
{  
    self detachall();
    self setmodel( "mp_body_africa_militia_smg_b" );
    self.headModel = "head_africa_militia_b_mp";
    self attach( "head_africa_militia_b_mp",  "", 1 );

    self setviewmodel("viewhands_african_militia");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

africa_lmg_main()
{  
    self detachall();
    self setmodel( "mp_body_africa_militia_lmg_b" );
    self.headModel = "head_africa_militia_c_mp";
    self attach( "head_africa_militia_c_mp",  "", 1 );

    self setviewmodel("viewhands_african_militia");
    self.voice = "american";
    self setclothtype( "vestlight" );
}
////////////////////////////////
//           delta            //
////////////////////////////////

delta_assault_precache()
{
    precachemodel( "mp_body_delta_elite_assault_aa" );
    precachemodel( "head_delta_elite_c" );
    precachemodel( "viewhands_delta" );
}

delta_smg_precache()
{
    precachemodel( "mp_body_delta_elite_smg_a" );
    precachemodel( "head_delta_elite_b" );
    precachemodel( "viewhands_delta" );
}

delta_lmg_precache()
{
    precachemodel( "mp_body_delta_elite_lmg_a" );
    precachemodel( "head_delta_elite_a" );
    precachemodel( "viewhands_delta" );
}

delta_assault_main()
{  
    self detachall();
    self setmodel( "mp_body_delta_elite_assault_aa" );
    self.headModel = "head_delta_elite_c";
    self attach( "head_delta_elite_c",  "", true );


    self setviewmodel("viewhands_delta");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

delta_smg_main()
{     
    self detachall();
    self setmodel( "mp_body_delta_elite_smg_a" );
    self.headModel = "head_delta_elite_b";
    self attach( "head_delta_elite_b",  "", true );

    self setviewmodel("viewhands_delta");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

delta_lmg_main()
{      
    self detachall();
    self setmodel( "mp_body_delta_elite_lmg_a" );
    self.headModel = "head_delta_elite_a"; 
    self attach( "head_delta_elite_a",  "", true );

    self setviewmodel("viewhands_delta");
    self.voice = "american";
    self setclothtype( "vestlight" );
}

setteammodels_stub( team, charSet )
{
    precachemodel( "mp_body_ally_sniper_ghillie_desert" );
    precachemodel( "head_op_sniper_ghillie_desert" );

    tf141_assault_precache();
    tf141_smg_precache();
    tf141_lmg_precache();

    opfor_assault_precache();
    opfor_smg_precache();
    opfor_lmg_precache();

    spetsnaz_assault_precache();
    spetsnaz_smg_precache();
    spetsnaz_lmg_precache();

    rangers_assault_precache();
    rangers_smg_precache();
    rangers_lmg_precache();

    seals_assault_precache();
    seals_smg_precache();
    seals_lmg_precache();

    militia_assault_precache();
    militia_smg_precache();
    militia_lmg_precache();

    allies_ghillie_precache();
    axis_ghillie_precache();
	
    if( CONST_DLC_FACTIONS_ENABLED )
    {
        africa_assault_precache();
        africa_smg_precache();
        africa_lmg_precache();

        pmc_assault_precache();
        pmc_smg_precache();
        pmc_lmg_precache();

        ic_assault_precache();
        ic_smg_precache();
        ic_lmg_precache();

        delta_assault_precache();
        delta_smg_precache();
        delta_lmg_precache();

        gign_paris_assault_precache();
        gign_paris_lmg_precache();
        gign_paris_smg_precache();

        factions = ["tf141", "seals", "rangers", "russian", "opfor", "militia", "pmcmw3", "africa", "ic", "delta", "gign"];
    }
    else
    {
        factions = ["tf141", "seals", "rangers", "russian", "opfor", "militia"];
    }

    if ( maps\mp\_utility::invirtuallobby() || level.virtuallobbyactive)
    {
        if( isDefined( level.factions_registered ) )
            return;

        level.factions_registered = true;

        foreach( charSet in factions )
            register_charSet( charSet, charSet );
    }
    else
    {
        register_charSet( charSet, team );
    }
}

register_charset( charSet, team )
{
    switch (charSet)
    {
    case "tf141":
        game[team + "_model"]["LMG"] = ::tf141_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::tf141_assault_main;
        game[team + "_model"]["SMG"] = ::tf141_smg_main;
        break;
    case "russian":
        game[team + "_model"]["LMG"] = ::spetsnaz_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::spetsnaz_assault_main;
        game[team + "_model"]["SMG"] = ::spetsnaz_smg_main;
        break;
    case "rangers":
        game[team + "_model"]["LMG"] = ::rangers_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::rangers_assault_main;
        game[team + "_model"]["SMG"] = ::rangers_smg_main;
        break;
    case "seals":
        game[team + "_model"]["LMG"] = ::seals_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::seals_assault_main;
        game[team + "_model"]["SMG"] = ::seals_smg_main;
        break;
    case "militia":
        game[team + "_model"]["LMG"] = ::militia_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::militia_assault_main;
        game[team + "_model"]["SMG"] = ::militia_smg_main;
        break;
    case "africa":
        game[team + "_model"]["LMG"] = ::africa_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::africa_assault_main;
        game[team + "_model"]["SMG"] = ::africa_smg_main;
        break;
    case "pmcmw3":
        game[team + "_model"]["LMG"] = ::pmcmw3_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::pmcmw3_assault_main;
        game[team + "_model"]["SMG"] = ::pmcmw3_smg_main;
        break;
    case "ic": 
        game[team + "_model"]["LMG"] = ::ic_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::ic_assault_main;
        game[team + "_model"]["SMG"] = ::ic_smg_main;
        break;
    case "delta": 
        game[team + "_model"]["LMG"] = ::delta_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::delta_assault_main;
        game[team + "_model"]["SMG"] = ::delta_smg_main;
        break;
    case "gign": 
        game[team + "_model"]["LMG"] = ::gign_paris_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::gign_paris_assault_main;
        game[team + "_model"]["SMG"] = ::gign_paris_smg_main;
        break;
    default:
        game[team + "_model"]["LMG"] = ::opfor_lmg_main;
        game[team + "_model"]["ASSAULT"] = ::opfor_assault_main;
        game[team + "_model"]["SMG"] = ::opfor_smg_main;
        break;
    }
}

playercostume_stub(weapon, team, environment)
{
    if ( isagent( self ) && !getdvarint( "virtualLobbyActive", 0 ) )
    {
        self thread apply_iw4_costumes();
        return 1;
    }

    if ( isdefined( weapon ) )
        weapon = maps\mp\_utility::getbaseweaponname( weapon );

    if ( isdefined( weapon ) )
        weapon = weapon + "_mp";

    self setcostumemodels( self.costume, weapon, team, environment );

    // if ( maps\mp\_utility::invirtuallobby() || level.virtuallobbyactive)
    // {
    //     return 1;
    // }

    self thread apply_iw4_costumes();

    return 1;
}

apply_iw4_costumes()
{
    self endon("disconnect");
    level endon("game_ended");

    self waittill("player_model_set");

    // returning here is fine if its not valid, because the function seems to call again with a valid primaryweapon on the same player
    if (!isdefined(self.primaryweapon))
    {
        return;
    }

    if ( maps\mp\_utility::invirtuallobby() || level.virtuallobbyactive)
    {
        team = level.vl_selectedfaction;
        weaponClass = weaponClass( self.primaryweapon );

        if( weaponClass == "sniper" )
        {
            self detachall();
            self setmodel( "mp_body_ally_sniper_ghillie_desert" );			
            self attach( "head_op_sniper_ghillie_desert", "", true );
            self.headmodel = "head_op_sniper_ghillie_desert";
            self allies_ghillie_setviewmodel();
            return;
        }

        switch( team )
        {
        case 0:
            prefix = "h2_tf141"; 
            charSet = "tf141";
            break;
        case 1:
            prefix = "h2_seal";
            charSet = "seals";
            break;
        case 2:
            prefix = "h2_us_army";
            charSet = "rangers";
            break;
        case 3:
            prefix = "h2_airborne";
            charset = "russian";
            break;
        case 4:
            prefix = "h2_opforce";
            charSet = "opfor";
            break;
        case 5:
            prefix = "h2_militia"; 
            charSet = "militia";
            break;
        case 6:
            prefix = "h2_africa";
            charSet = "africa";
            break;
        case 7:
            prefix = "h2_pmcmw3";
            charSet = "pmcmw3";
            break;
        case 8:
            prefix = "h2_ic";
            charSet = "ic";
            break;
        case 9:
            prefix = "h2_delta";
            charSet = "delta";
            break;
        default:
            prefix = "h2_gign";
            charSet = "gign";
            break;
        }

        switch( weaponClass )
        {			
        case "smg":
            type = "SMG";
            model = "_smg"; break;

        case "mg":
            type = "LMG";
            model = "_lmg"; break;

        default:
            type = "ASSAULT";
            model = "_assault"; break;
        }

        if( team <= 5 ) //non-dlc faction
        {
            self detachall();

            if( type == "LMG" && prefix == "h2_seal" )
                self setmodel( "body_h2_seal_smg" );
            else if( type == "ASSAULT" && prefix == "h2_us_army" )
                self setmodel( "body_h2_us_army_ar" );
            else if( type == "LMG" && prefix == "h2_tf141" )
                self setmodel( "body_h2_tf141_assault" );
            else
                self setmodel( "body_" + prefix + model );

            self attach( "head_" + prefix + model, "", true );
            self.headModel = "head_" + prefix + model;
        }

        [[game[charSet + "_model"][type]]]();

        return;
    }

    weapon = self.primaryweapon;

    if ( isdefined( weapon ) )
        weapon = maps\mp\_utility::getbaseweaponname( weapon );

    weaponClass = tablelookup( "mp/statstable.csv", 4, weapon, 2 );

    switch ( weaponClass )
    {
    case "weapon_smg":
        [[game[self.team+"_model"]["SMG"]]]();
        break;
    case "weapon_assault":
        [[game[self.team+"_model"]["ASSAULT"]]]();
        break;
    case "weapon_sniper":
        if (self.team == "allies")
            allies_ghillie_setviewmodel();
        else
            axis_ghillie_setviewmodel();
        break;
    case "weapon_lmg":
    case "weapon_heavy":
        [[game[self.team+"_model"]["LMG"]]]();
        break;
    default:
        // print ("[WARNING] weaponClass '" + weaponClass + "' does not match any valid types.");
        //self iprintln ("^3[WARNING] weaponClass '" + weaponClass + "' does not match any valid types.");
        self randomBotCostume();
        break;
    }
}

randomBotCostume()
{
    weapon_classes = [];
    weapon_classes[0] = "weapon_smg";
    weapon_classes[1] = "weapon_assault";
    weapon_classes[2] = "weapon_sniper";
    weapon_classes[3] = "weapon_heavy";

    chosen_weapon_class = weapon_classes[randomInt(weapon_classes.size)];

    switch ( chosen_weapon_class )
    {
    case "weapon_smg":
        [[game[self.team+"_model"]["SMG"]]]();
        break;
    case "weapon_assault":
        [[game[self.team+"_model"]["ASSAULT"]]]();
        break;
    case "weapon_sniper":
        if (self.team == "allies")
            allies_ghillie_setviewmodel();
        else
            axis_ghillie_setviewmodel();
        break;
    case "weapon_lmg":
    case "weapon_heavy":
        [[game[self.team+"_model"]["LMG"]]]();
        break;
    default:
        break;
    }
}
