# dicebag-godot

A Godot port of [Dicebag](https://github.com/8bitskull/dicebag) by [8bitskull](https://github.com/8bitskull), originally in Lua for Defold.

Dicebag is an addon of probability functions designed specifically for games.
Inspired by this excellent blog post: https://www.redblobgames.com/articles/probability/damage-rolls.html

## Installation
You can add Dicebag to your own projects by using the built-in Asset Library.
Once it is added to your project, you need to add an instance of Dicebag to your script, before the `_ready()` function:
```
onready var dicebag = Dicebag.new()
```
Then you can use Dicebag functions, for example:
```
var coin = dicebag.flip_coin()
```
#  Usage

###  dicebag.set_up_rng(seed)

Sets up the random seed and clears the first number of random rolls.

  

**PARAMETERS**

* `seed` (int) - optional seed, if not specified a seed will be generated using OS.get_unix_time().

  

**RETURNS**

* `seed` (int) - the number used to seed the random function.

  

###  dicebag.flip_coin()

Flip a coin.

  

**RETURNS**

* `result` (bool) - true or false (50% chance).

  

###  dicebag.roll_dice(num_dice, num_sides, modifier)

Roll a number of dice, D&D-style. An example would be rolling 3d6+2. Returns the sum of the resulting roll.

  

**PARAMETERS**

* `num_dice` (int) - Number of dice to roll.

* `num_sides` (int) - Number of sides on the dice.

* `modifier` (int) - Number to add to the result.

  

**RETURNS**

* `result` (int) - Sum of rolled dice plus modifier.

  

###  dicebag.roll_special_dice(num_sides, advantage, num_dice, num_results)

Roll a number of dice and choose one (or more) of the highest (advantage) or lowest (disadvantage) results. Returns the sum of the relevant dice rolls.

  

**PARAMETERS**

* `num_sides` (int) - Number of sides on the dice.

* `advantage` (bool) - If true, the highest rolls will be selected, otherwise the lowest values will be selected.

* `num_dice` (int) - Number of dice to roll.

* `num_results` (int) - How many of the highest (advantage) or lowest (disadvantage) dice to sum up.

  

**RETURNS**

* `result` (int) - Sum of the highest (advantage) or lowest (disadvantage) dice rolls.

  

###  dicebag.roll_custom_dice(sides)

Roll a custom die. This die can have sides with different weights and different values.

  

**PARAMETERS**

* `sides` (Array) - A table describing the sides of the die in the format `[[weight1, value1], [weight2, value2] ...]`. Note that the value can be any type, not just int.

  

**RETURNS**

* `value` (Variant) - The value as specified in Array `sides`.

  

###  dicebag.bag_create(id, num_success, num_fail, reset_on_success)

Create a marble bag of green (success) and red (fails) 'marbles'. This allows you to, for example, make an unlikely event more and more likely the more fails are accumulated.

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the marble bag.

* `num_success` (int) - The number of success marbles in the bag.

* `num_fails` (int) - The number of fails marbles in the bag.

* `reset_on_success` (bool) - Whether or not the bag should reset when a successful result is drawn. If false or nil the bag will reset when all marbles have been drawn.

  

###  dicebag.bag_draw(id)

Draw a marble from a previously created bag.

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the marble bag.

  

**RETURNS**

* `result` (bool)

  

###  dicebag.bag_reset(id)

Manually reset a marble bag. Will also be called when a marble bag is empty, or a success is drawn in a bag where `reset_on_success` is true.

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the marble bag.

  

###  dicebag.table_create(id, rollable_table)

Create a rollable table. This is similar to a marble bag, except each entry can have a different weight, and can return any value (not just a bool).

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the rollable table.

* `rollable_table` (Array) - A table of weights, values and reset flags.

  

Array `rollable_table` has the format: [[weight1, value1, {reset_on_roll1}], [weight2, value2, {reset_on_roll2}], ...] where the parameters are:

* `weight` (int) - The relative probability of drawing the value.

* `value` (Variant) - The value to be returned if drawn.

* `reset_on_roll` (bool; optional) - Whether or not the table should be reset when this value is drawn. If all of these are false, the table will reset when all values have been drawn.

  

###  dicebag.table_roll(id)

Draw a random value from the rollable table created in dicebag.table_create. The value will be removed from the table. If `reset_on_roll` is true, the table will reset. Otherwise, the table will reset when all values are drawn.

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the rollable table.

  

**RETURNS**

* `value` (Variant) - The value specified in dicebag.table_create.

  

###  dicebag.table_reset(id)

Manually reset a rollable table. Will also be called when the rollable table is empty, or a drawn value where `reset_on_roll` is true.

  

**PARAMETERS**

* `id` (String, int) - A unique identifier for the rollable table.
