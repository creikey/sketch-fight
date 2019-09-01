extends Resource

signal gamestate_update

var _player_gamestate = {
    # player_id : [number_of_ships, made_first_ship]
}

var won_player_name = "null! error! ERROR!!!!!! THINGS FALL APART! THINGS FALL APART!"

func init_player_gamestate(player_ids: Array):
    for p in player_ids:
        _player_gamestate[p] = [0, false]
#    print(_resource_farmers_made)

func new_ship_made(id: int):
    _player_gamestate[id][0] += 1
    _player_gamestate[id][1] = true

func destroy_ship(id: int):
    _player_gamestate[id][0] -= 1
    emit_signal("gamestate_update")

func get_player_ids() -> Array:
    return _player_gamestate.keys()

func get_player_gamestate(in_id: int) -> Array:
    return _player_gamestate[in_id]