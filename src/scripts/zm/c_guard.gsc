precache()
{
    precachemodel("c_zom_player_grief_guard_fb");
    precachemodel("c_zom_grief_guard_viewhands");
}

set_character()
{
    self setmodel("c_zom_player_grief_guard_fb");
    self setviewmodel("c_zom_grief_guard_viewhands");
    self.voice = "american";
    self.skeleton = "base";
    self maps\mp\zombies\_zm_utility::set_player_is_female(false);
}

init()
{
    precache();

    maps\mp\zombies\character::register_character("guard", ::set_character);
}