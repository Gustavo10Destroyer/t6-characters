process_message(message)
{
    level endon("end_game");
    self endon("disconnect");

    /#
    iprintlnbold("Processing message: ^3" + message + "^7...");
    #/

    args = strtok(message, " ");
    assertex(args.size > 0, "empty message");
    if(args.size == 0) return;

    command = tolower(args[0]);
    assertex(command.size > 0, "empty message");
    if(command.size == 0) return;

    arrayremoveindex(args, 0);

    switch(command)
    {
        case "!char":
        case "!character":
            character_name = args[0];
            if(!isdefined(character_name))
            {
                self iprintln("Usage: " + command + " <character_name>");
                break;
            }

            if(!maps\mp\zombies\character::is_character_registered(character_name))
            {
                self iprintln("[^1ERR!^7] The character ^3\"" + character_name + "\"^7 isn't registered or doesn't exists!");
                break;
            }

            maps\mp\zombies\character::set_player_character(character_name);
            self iprintln("[^2INFO^7] Character changed!");
            break;
        default:
            /#
            iprintlnbold("Unknown command: ^3" + command);
            #/
            break;
    }
}

on_say()
{
    level endon("end_game");

    while(true)
    {
        level waittill("say", message, player);
        player thread process_message(message);
    }
}

on_say_team()
{
    level endon("end_game");

    while(true)
    {
        level waittill("say_team", message, player);
        player thread process_message(message);
    }
}

init()
{
    thread on_say();
    thread on_say_team();
}