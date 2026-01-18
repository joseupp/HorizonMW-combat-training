// modified by CnR
// modified by svindler, thanks to Shockeh (6/4/2025)
#include common_scripts\utility;

init()
{
    level.mapvote = [];
    level.mapvote_duration = 30;
    level.mapvote_active = false;
    level.mapvote_players = [];

    setDvar("mapvote_timeleft", level.mapvote_duration);
    setDvar("sv_mapvote_active", false);

    level thread onPlayerConnect();
}

start()
{
    setDvar("sv_mapvote_active", true);
    rotation = strTok(getdvar("sv_maprotation", ""), " ");
    level.mapvote_maps = getRandomMaps(rotation);
    level.mapvote_modes = getRandomModes(rotation);

    setVotingPool();
    updateClientsCounters();

    foreach(player in level.players)
    {
        openMapVote(player);
    }
    level.mapvote_active = true;

    for (i = level.mapvote_duration; i >= 0; i--)
    {
        if (i < 11)
        {
            foreach(player in level.players)
            {
                player playsound("match_countdown_tick");
            }
        }

        foreach(player in level.players)
        {
            player setclientdvar("mapvote_timeleft", i);
        }
        wait 1;
    }

    topVote = getWinningMap();
    level notify("end_mapvote");

    setdvar("g_gametype", topVote["mode"]);
    wait .5;
    executecommand("map " + topVote["name"]);
}

onPlayerConnect()
{
    level endon("end_mapvote");

    for (;;)
    {
        level waittill("connected", player);
        player thread handlePlayerConnect();
        player thread onPlayerDisconnect();
    }
}

onPlayerDisconnect()
{
    level endon("end_mapvote");

    self waittill("disconnect");
    wait .5;
    if (level.mapvote_active)
    {
        updateClientsCounters();
    }
}

handlePlayerConnect()
{
    wait .5;
    self thread onMapvoteSelect();

    if (level.mapvote_active)
    {
        updateClientsCounters();
        updateClientMapVoteInfo(self);
        openMapVote(self);
    }
    else
    {
        self clientResetMapVoteInfo();
    }
}

setVotingPool()
{
    for (i = 0; i < 3; i++)
    {
        map = random(level.mapvote_maps);
        mode = random(level.mapvote_modes);
        addMap(map, mode);
    }
}

addMap(map, mode)
{
    id = level.mapvote.size;
    level.mapvote[id] = [];
    level.mapvote[id]["name"] = map;
    level.mapvote[id]["mode"] = mode;
    level.mapvote[id]["votes"] = 0;

    foreach(player in level.players)
    {
        player setclientdvar("ui_mapvote_name_" + id, map);
        player setclientdvar("ui_mapvote_mode_" + id, mode);
    }
    removeMap(map);
}

removeMap(mapToRemove) // removes mapToRemove from avail maps - avoids dupe maps
{
    new = [];
    foreach (map in level.mapvote_maps) {
        if (map != mapToRemove)
        {
            new[new.size] = map;
        }
    }
    level.mapvote_maps = new;
}

getWinningMap()
{
    topVote = level.mapvote[randomInt(level.mapvote.size)];
    for (i = 0; i < level.mapvote.size; i++)
    {
        if (level.mapvote[i]["votes"] > topVote["votes"])
        {
            topVote = level.mapvote[i];
        }
    }
    return topVote;
}

getRandomMaps(rotation)
{
    maps = [];
    foreach(map in rotation)
    {
        switch (map)
        {
            // blacklist
            case "gametype":
            case "map":
            case "dm":
            case "war":
            case "sd":
            case "dom":
            case "conf":
            case "sab":
            case "koth":
            case "hp":
            case "gun":
            case "gtnw":
			case "dz":
                break;
            default:
                maps[maps.size] = map;
                break;
        }
    }
    return maps;
}

getRandomModes(rotation)
{
    modes = [];
    foreach(mode in rotation)
    {
        switch (mode)
        {
            // whitelist
            case "dm":
            case "war":
            case "sd":
            case "dom":
            case "conf":
            case "sab":
            case "koth":
            case "hp":
            case "gun":
            case "gtnw":
            case "dz":
                modes[modes.size] = mode;
                break;
            default:
                break;
        }
    }
    return modes;
}

onMapvoteSelect()
{
    self endon("disconnect");
    self.vote = -1;

    for (;;)
    {
        self waittill("luinotifyserver", action, id);

        if (action != "mapvote" || self.vote == id)
            continue;

        if (self.vote != -1)
            level.mapvote[self.vote]["votes"]--;

        oldVoteId = self.vote;
        self.vote = id;
        level.mapvote[self.vote]["votes"]++;

        updateClientsCounters();

        foreach(player in level.players)
        {
            player luinotifyevent(&"mapvote", 2, self.vote, level.mapvote[self.vote]["votes"]);
            if (oldVoteId != -1) player luinotifyevent(&"mapvote", 2, oldVoteId, level.mapvote[oldVoteId]["votes"]);
        }
    }
}

openMapVote(player)
{
    player setclientdvar("sv_open_menu_mapvote", true);
    wait 0.15;
    player setclientdvar("sv_open_menu_mapvote", false);
}

updateClientMapVoteInfo(player)
{
    player setclientdvar("ui_mapvote_name_0", level.mapvote[0]["name"]);
    player setclientdvar("ui_mapvote_mode_0", level.mapvote[0]["mode"]);
    player setclientdvar("ui_mapvote_name_1", level.mapvote[1]["name"]);
    player setclientdvar("ui_mapvote_mode_1", level.mapvote[1]["mode"]);
    player setclientdvar("ui_mapvote_name_2", level.mapvote[2]["name"]);
    player setclientdvar("ui_mapvote_mode_2", level.mapvote[2]["mode"]);
}

updateClientsCounters()
{
    players = level.players;
    maxClients = getdvarint("sv_maxclients");

    foreach(player in players)
    {
        player setclientdvar("ui_mapvote_maxclients", maxClients);
        id = 1;

        foreach(player1 in players)
        {
            player setclientdvar("ui_mapvote_player_"+id+"_name", player1.name);
            player setclientdvar("ui_mapvote_player_"+id+"_voted", player1.vote != -1);
            id = id + 1;
        }

        player setclientdvar("ui_mapvote_currentclients", players.size, 0);
        remainingPlayers = maxClients - players.size;

        // Reset empty slots, they may not be empty if player count decreased;
        if (remainingPlayers > 0)
        {
            for (currId = players.size; currId < maxClients; currId++)
            {
                player setclientdvar("ui_mapvote_player_"+id+"_name", "");
                player setclientdvar("ui_mapvote_player_"+id+"_voted", false);
            }
        }
    }
}

clientResetMapVoteInfo()
{
    max_players = getdvarint("sv_maxclients", "") + 1;
    self setclientdvar("mapvote_timeleft", level.mapvote_duration);

    for (i = 0; i < max_players; i++)
    {
        self setclientdvar("ui_mapvote_player_"+i+"_name", "");
        self setclientdvar("ui_mapvote_player_"+i+"_voted", false);
    }
}
