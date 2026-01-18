#include maps\mp\bots\_bots;
/*
    Mod: Autobots
    Developed by DoktorSAS
	Difficulty addition by Kalitos
	Tested by BoxOfMysteriez
*/

init()
{
    level thread onPlayerConnect();
    level thread serverBotFill();
	level thread setDiffBots();
	
}
onPlayerConnect()
{
    level endon("game_ended");
    for (;;)
    {
        level waittill("connected", player);
        if (!player isentityabot())
        {
            player thread kickBotOnJoin();
        }
    }
}

isentityabot()
{
    return isSubStr(self getguid(), "bot");
}
serverBotFill()
{
    level endon("game_ended");
    level waittill("connected", player);
    for (;;)
    {
        while (level.players.size < 11 && !level.gameended)
        {
            self spawnBots(11);
            wait 1;
        }
        if (level.players.size >= 11 && contBots() > 0)
            kickbot();

        wait 0.05;
    }
}

contBots()
{
    bots = 0;
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            bots++;
        }
    }
    return bots;
}

spawnBots(a)
{
    spawn_bots(a, "autoassign");
}

kickbot()
{
    level endon("game_ended");
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            player bot_drop();
            break;
        }
    }
}

kickBotOnJoin()
{
    level endon("game_ended");
    foreach (player in level.players)
    {
        if (player isentityabot())
        {
            player bot_drop();
            break;
        }
    }
}

/*
	Set Bot difficulty below with the setDiffBots function
	Level 1 - 2 "recruit"
	Level 21 - 29 "regular"
	Level 41 - 49 "hardened" 
	Level 51+ with Prestige - "Veteran"
	
	Add aditional slots for mixed difficulty. Example: [ "hardened, "veteran" ] 
*/

setDiffBots()
{
	for(;;)
	{
		level waittill("connected", player);
		if(isBot(player))
		{
			player maps\mp\bots\_bots_util::bot_set_difficulty( common_scripts\utility::random( [ "regular", "veteran" ] ), undefined );
		}
	}
}
