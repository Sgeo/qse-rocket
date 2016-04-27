float MAX_FLOAT = 3.4028235E38; // TODO: Find different notation
float lastAlt;

default
{
    state_entry()
    {
        llSetForce(ZERO_VECTOR, FALSE);
    }

    link_message(integer sender_number, integer num, string msg, key id)
    {
        if(num == -1 && msg == "LAUNCH")
        {
            llSetTimerEvent(10.0);
            vector pos = llGetPos();
            lastAlt = pos.z;
            llSetBuoyancy(1.0);
            llSetForce(<0.0, 0.0, MAX_FLOAT>, FALSE);
        }
    }

    timer()
    {
        vector pos = llGetPos();
        if(pos.z < lastAlt)
        {
            llMessageLinked(LINK_THIS, 0, "EMERGENCY STOP", NULL_KEY);
            llResetScript();
        }
        lastAlt = pos.z;
    }
}