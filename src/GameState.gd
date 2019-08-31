extends Resource

signal farmer_destroyed

var _resource_farmers_made = {
    # player_id : [number_of_resource_farmers, made_first_resource_farmer]
}

var won_player_name = "null! error! ERROR!!!!!! THINGS FALL APART! THINGS FALL APART!"

func _ready(): # testing code
    connect("farmer_destroyed", self, "_farmer_destroyed")

func init_resource_farmers(player_ids: Array):
    for p in player_ids:
        _resource_farmers_made[p] = [0, false]
    print(_resource_farmers_made)

func new_resource_farmer_made(id: int):
    _resource_farmers_made[id][0] += 1
    _resource_farmers_made[id][1] = true

func destroy_resource_farmer(id: int):
    _resource_farmers_made[id][0] -= 1
    emit_signal("farmer_destroyed")

func get_player_ids() -> Array:
    return _resource_farmers_made.keys()

func get_player_gamestate(in_id: int) -> Array:
    return _resource_farmers_made[in_id]

func _farmer_destroyed():
    print(_resource_farmers_made)