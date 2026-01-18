init() 
{
   if( getdvar( "xblive_privatematch" ) == "0" )
   {
      setDvar( "force_ranking", 1 ); 
      setDvar( "scr_xpscale", 4 ); 
   }
}