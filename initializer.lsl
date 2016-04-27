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
            if(llSubStringIndex(scriptName, "subsystem_") == 0)
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
        if(num != -1 || llSubStringIndex(msg, "INITED: ") != 0) return;
        string scriptName = llGetSubString(msg, llStringLength("INITED: "), -1);
        integer index = llListFindList(gScripts, [scriptName]);
        if(index != -1)
        {
            gScripts = llDeleteSubList(gScripts, index, index);
        }
        if(llGetListLength(gScripts) == 0) state initialized;
    }
}

state initialized
{
    state_entry()
    {
        llMessageLinked(LINK_THIS, -1, "READY", NULL_KEY);
        llMessageLinked(LINK_THIS, 0, "Subsystems initialized.", NULL_KEY);
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {
        if(num != 300 || msg != "LAUNCH") return;
        state launched;
    }
}

state launched
{
    state_entry()
    {
        llMessageLinked(LINK_THIS, -1, "LAUNCH", NULL_KEY);
    }
}