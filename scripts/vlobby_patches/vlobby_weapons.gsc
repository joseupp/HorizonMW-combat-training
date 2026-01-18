vl_main()
{
    replacefunc(maps\mp\_vl_firingrange::monitorweaponammo, ::monitorweaponammo_stub);
    replacefunc(maps\mp\_vl_avatar::playerteleportavatartoweaponroom, ::playerteleportavatartoweaponroom_stub);
}

playerteleportavatartoweaponroom_stub( var_0, var_1, var_2 )
{
    if( !isDefined( var_0.delaymineWasSet ) ) //give Ninja perk to the avatar so he won't be identified by heartbeat sensors
    {
        var_0 maps\mp\_utility::_setperk( "specialty_heartbreaker", 0 );
        var_0.delaymineWasSet = true;
    }

    if(issubstr( var_0.primaryweapon, "akimbo" ))
    {
        struct = common_scripts\utility::getstruct( "characterShotgun", "targetname" );
        var_1.scenenode = struct.scenenode;
        var_0 unlink();
        var_0 agentplaylobbyanimakimbo( var_1.scenenode, 1 );
    }
    else
    {
        var_3 = maps\mp\_vl_base::getweaponroomstring( var_0.primaryweapon );
        var_4 = "character" + var_3;
        var_5 = common_scripts\utility::getstruct( var_4, "targetname" );
        var_1.scenenode = var_5.scenenode;
        var_0 unlink();
        var_0 maps\mp\_vl_avatar::agentplaylobbyanim( var_1.scenenode, var_0.primaryweapon, var_2 );
    }
}

agentplaylobbyanimakimbo( var_0, var_2 )
{
    var_5 = "idle";
    var_6 = "lobby_shotgun" + var_5;

    if ( !isdefined( self.lastanim ) || self.lastanim != var_6 )
    {
        var_7 = 0.0;

        if ( maps\mp\_utility::is_true( var_2 ) )
            var_7 = randomfloat( 1.0 );

        self setanimclass( "vlobby_animclass" );
        self setanimstate( "lobby_shotgun_ranger", var_5, 1, var_7 );
        self.lastanim = var_6;
        self scragentsetscripted( 1 );
        self scragentsetphysicsmode( "noclip" );
        self scragentsynchronizeanims( 0, 0, var_0, "j_prop_1", "tag_origin" );
    }

    maps\mp\_vl_avatar::show_avatar( self );
}

monitorweaponammo_stub( player )
{
    player endon( "enter_vlobby" );

    for (;;)
    {
        var_1 = player getweaponslistall();

        foreach ( var_3 in var_1 )
        {
            player thread monitor_weapon_ammo_count( var_3 );
            continue;
        }

        player waittill( "applyLoadout" );
    }
}

monitor_weapon_ammo_count( player )
{
    self endon( "enter_lobby" );
    self endon( "applyLoadout" );

    while ( level.in_firingrange )
    {
        var_1 = self getfractionmaxammo( player );

        if ( var_1 <= 0.25 )
        {
            self givemaxammo( player );
            continue;
        }

        wait 0.5;
    }
}
