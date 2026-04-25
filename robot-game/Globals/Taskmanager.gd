extends Node

#This is the global point for signals, variables, player inventory items

#Materials (How many materials are needed)
var metal: int = 100
var copper: int 
var helliorb: int 
var gunpowder: int 
var raycrystal: int 

#Robots (True or False has the Robot been crafted)
var Robot1: bool 
var Robot2: bool 
var Robot3: bool 
var Robot4: bool 
var Robot5: bool 

var robot_equipped: String

#signals
signal spiked
signal computer_hacked

#computer
var hacked: bool = true

#Player Stats
var max_health: int = 100
var current_health: int = 100
var lives: int = 3
var start_position: Vector2

signal player_respawn
signal health_changed(new_value)

#Room Changing System
var activate: bool = false
var PlayerPos: Vector2
var PlayerJumpOnEnter: bool
