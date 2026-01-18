init()
{
    setdvar("r_smodelinstancedthreshold", 2);
    setdvar("r_primaryLightUseTweaks", 0);
    setdvar("r_primaryLightTweakDiffuseStrength", 0);
    setdvar("r_primaryLightTweakSpecularStrength", 0);
    setdvar("r_viewModelPrimaryLightUseTweaks", 0);
    setdvar("r_viewModelPrimaryLightTweakDiffuseStrength", 0);
    setdvar("r_viewModelPrimaryLightTweakSpecularStrength", 1);
    setdvar("r_colorScaleUseTweaks", 0);
    setdvar("r_diffuseColorScale", 0);
    setdvar("r_specularColorScale", 0);
    setdvar("r_veil", 0);
    setdvar("r_veilusetweaks", 0);
    setdvar("r_veilStrength", 0.087);
    setdvar("r_veilBackgroundStrength", 0.913);
    //resets film values to off after returning to lobby
    setdvar( "r_filmusetweaks", 0 );
    setdvar( "r_filmTweakEnable", 0 );
}

is_not_h1_map()
{
    map = getdvar("mapname");
    switch(map)
    {
    case "mp_rust":
    case "mp_afghan":
    case "mp_derail":
    case "mp_estate":
    case "mp_favela":
    case "mp_highrise":
    case "mp_invasion":
    case "mp_checkpoint":
    case "mp_quarry":
    case "mp_rundown":
    case "mp_boneyard":
    case "mp_nightshift":
    case "mp_subbase":
    case "mp_terminal":
    case "mp_underpass":
    case "mp_brecourt":
    case "mp_complex":
    case "mp_compact":
    case "mp_storm":
    case "mp_abandon":
    case "mp_fuel2":
    case "mp_trailerpark":
    case "mp_underground":
    case "mp_lambeth":
    case "mp_bravo":
    case "mp_alpha":
    case "mp_dome":
    case "mp_paris":
    case "mp_bootleg":
    case "mp_hardhat":
	case "mp_plaza2":
	case "mp_mogadishu":
	case "mp_seatown":
        return true;
    default:
        return false;
    }
}
