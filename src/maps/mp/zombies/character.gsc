register_character(name, set_func, unset_func)
{
    assertex(isstring(name), "'name' must be a string");
    if(!isstring(name)) return;

    if(!isdefined(level._registered_characters)) level._registered_characters = [];

    assertex(!isdefined(level._registered_characters[name]), "the character " + name + " already exists");
    if(isdefined(level._registered_characters[name])) return;

    assertex(isdefined(set_func), "'set_func' must be a function pointer");
    if(!isdefined(set_func)) return;

    character = spawnstruct();
    character.name = name;
    character.set_func = set_func;
    if(isdefined(unset_func)) character.unset_func = unset_func;

    level._registered_characters[name] = character;

    /#
    println("[^3GSC^7] [^3CHARACTERS^7] \"" + name + "\" registered");
    #/
}

is_character_registered(character_name)
{
    assertex(isstring(character_name), "'character' must be a string");
    if(!isstring(character_name)) return false;

    if(!isdefined(level._registered_characters)) return false;
    return isdefined(level._registered_characters[character_name]);
}

set_player_character(character_name)
{
    assertex(isdefined(self), "this method must be called on a entity");
    if(!isdefined(self)) return;

    assertex(isstring(character_name), "'character' must be a string");
    if(!isstring(character_name)) return;

    assertex(isdefined(level._registered_characters), "no character registered");
    if(!isdefined(level._registered_characters)) return;

    assertex(is_character_registered(character_name), "the character \"" + character_name + "\" isn't registered");
    if(!is_character_registered(character_name)) return;

    // Chama 'unset_func' do personagem atual, se estiver definido.
    if(isdefined(self._character) && isdefined(self._character.unset_func))
        self [[ self._character.unset_func ]]();

    self._character = level._registered_characters[character_name];
    self [[ self._character.set_func ]]();
}