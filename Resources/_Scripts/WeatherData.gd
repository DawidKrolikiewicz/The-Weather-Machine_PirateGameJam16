extends Resource
class_name WeatherData

## Name of the weather effect
## @experimental
@export_placeholder("Name here") var name: String

## Indicates how much this weather effect will affect water parameter
## Negative values mean it will subtract from total
@export_range(-10, 10, 1) var water_per_tick: int = 0

## Indicates how much this weather effect will affect food parameter
## Negative values mean it will subtract from total
@export_range(-10, 10, 1) var food_per_tick: int = 0

## Indicates how much this weather effect will affect happy parameter
## Negative values mean it will subtract from total
@export_range(-10, 10, 1) var happy_per_tick: int = 0

## Weather effect will apply it's effects that many times per second
@export_range(0.1, 5, 0.1, "suffix:/s") var tick_rate: float = 1

## Movement speed of the weather effect
@export_range(0, 100, 1) var speed: int = 40

## Definies a movement speed multiplier for weather effect for when it's being dragged by the player
@export_range(0.1, 10, 0.1) var speed_mult: int = 3

## Acceleration of weather effects's rotation value 
## NOTE: THIS IS ACCELERATION PER FRAME FOR A TIMEBEING - SHOULD PROBABLY MULT BY DELTA
@export_range(0, 20, 1) var rotation_acceleration: int = 3

## Max rotation per second that weather effect can perform
@export_range(0, 180, 1, "suffix:°") var max_rotation_velocity: int = 30

## Time it takes for the weather effect to grow into it's full size
@export_range(0, 15, 0.1, "suffix:s") var form_time: float = 5

## Time it takes for the weather effect to shrink from it's current size to 0 before disappearing
@export_range(0, 15, 0.1, "suffix:s") var dissolve_time: float = 5

## Minimal width of fully grown weather zone[br]
## WARNING: IT CAN'T CHECK IF MIN <= MAX AND WILL CRASH IF IT'S WRONG
## @experimental
@export_range(30, 300, 1) var min_full_size: int = 70

## Maximal width of fully grown weather zone[br]
## WARNING: IT CAN'T CHECK IF MIN <= MAX AND WILL CRASH IF IT'S WRONG
## @experimental
@export_range(30, 300, 1) var max_full_size: int = 140

## Minimal lifetime of weather effect[br]
## NOTE: Currently lifetime is defined as time weather effect spends while FULLY grown[br]
## WARNING: IT CAN'T CHECK IF MIN <= MAX AND WILL CRASH IF IT'S WRONG
@export_range(0, 60, 0.1, "suffix:s") var min_lifetime: float = 10

## Maximal lifetime of weather effect[br]
## NOTE: Currently lifetime is defined as time weather effect spends while FULLY grown[br]
## WARNING: IT CAN'T CHECK IF MIN <= MAX AND WILL CRASH IF IT'S WRONG
@export_range(0, 60, 0.1, "suffix:s") var max_lifetime: float = 30

## Modulate to be applied to the sprite
@export var debug_color: Color = Color("0000ff")
