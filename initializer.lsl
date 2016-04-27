list gScripts;

default
{
	link_message(integer sender_number, integer num, string msg, key id)
	{
		if(num != 300 || msg != "INIT") return;
		gScripts = [];
		integer numScripts = llGetInventoryNumber(INVENTORY_SCRIPT);
		integer i;
		for(i = 0; i < numScripts; i++)
		{
			string scriptName = llGetInventoryName(INVENTORY_SCRIPT, i);
			if(llSubStringIndex(scriptName, "telemetry_") == 0)
			{
				gScripts += [scriptName];
			}
		}
		state waiting;
	}
}

state waiting
{
	state_entry()
	{
		if(llGetListLength(gScripts) == 0) state initialized;
		llMessageLinked(LINK_THIS, -1, "INIT", NULL_KEY);
	}
	
	link_message(integer sender_num, integer num, string msg, key id)
	{
	}
}