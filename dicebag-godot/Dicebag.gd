extends Reference

class_name Dicebag

var rng = RandomNumberGenerator.new()

var bags = {}
var tables = {}

#Set up random number generator and clear bad rolls. Returns seed value used.
func set_up_rng(_seed = null) -> int:
	var dseed = _seed
	if !dseed: dseed = OS.get_unix_time() << 35 # 35 is an arbitrary number but produces enough entropy
	# the original function used a modulo blown out by a large number (100000000000000 * (socket.gettime() % 1)), but the unix timestamp func provided by godot is not a float unlike lua's socket lib, which results in the (% 1) being always 0.
	seed(dseed)
	rng.seed = dseed
	for i in range(1, 20):
		randf()

	return dseed

#Flip a coin: 50% chance of returning true or false
func flip_coin() -> bool:
	return randf() > 0.5

#D&D-style dice roll, for example 3d6+2. Returns resulting roll value.
func roll_dice(num_dice = 1, num_sides = 6, modifier = 0) -> int:
	var result = modifier

	for i in range(0, num_dice):
		result += rng.randi_range(1, num_sides)

	return result

#Roll one or more dice with advantage or disadvantage (if advantage is not true rolls are disadvantaged). Returns the num_results sum of the highest (advantage) or lowest (disadvantage) value of all rolls.
func roll_special_dice(num_sides = 6, advantage = true, num_dice = 2, num_results = 1) -> int:
	var rolls = []
	var num_rolls = 0
	var roll

	var replace_value
	var replace_id

	for i in range(0, num_dice):
		roll = roll_dice(1, num_sides)

		num_rolls = rolls.size()

		if num_rolls < num_results:
			rolls.append(roll)
		elif advantage:
			replace_value = num_sides - 1
			replace_id = null
			for j in range(1, num_rolls):
				if roll > rolls[j - 1] && rolls[j - 1] < replace_value:
					replace_id = j - 1
					replace_value = rolls[j - 1]

			if replace_id:
				rolls[replace_id] = roll
		else:
			replace_value = 0
			replace_id = null
			for j in range(1, num_rolls):
				if roll < rolls[j - 1] && rolls[j - 1] > replace_value:
					replace_id = j - 1
					replace_value = rolls[j - 1]

			if replace_id:
				rolls[replace_id] = roll
	
	var result = 0

	for i in range(0, num_rolls):
		result += rolls[i]

	return result

# Roll a custom die. Parameter sides is an array in the format [[weight1, value1], [weight2, value2] ...]. Returns the value of the rolled side.
func roll_custom_dice(sides):
	var total_weight = 0
	var num_sides = sides.size()

	# count up the total weight
	for i in range(0, num_sides):
		total_weight += sides[i][0]

	var weight_result = randf() * total_weight

	var processed_weight = 0
	for i in range(1, num_sides):
		if weight_result <= sides[i][0] + processed_weight:
			return sides[i][1]
		else:
			processed_weight += sides[i][0]

	return 0

#Create a bag of green (success) and red (fail) "marbles" that you can draw from. If reset_on_success is true, the bag will be reset after the first green (success) marble is drawn, otherwise the bag will reset when all marbles have been drawn.
func bag_create(id, num_success, num_fail, reset_on_success) -> void:
	bags[id] = {success = num_success, fail = num_fail, full_success = num_success, full_fail = num_fail, reset_on_success = reset_on_success}

#Draw a marble from marble bag id. Returns true or false.
func bag_draw(id) -> bool:
	if not bags[id]:
		return false

	var result = rng.randi_range(1, bags[id].success + bags[id].fail)

	if result > bags[id].fail:
		result = true
		if bags[id].reset_on_success:
			bag_reset(id)
		else:
			bags[id].success -= 1
	else:
		result = false
		bags[id].fail -= 1

	return result

#Refill a marble bag to its default number of marbles.
func bag_reset(id) -> void:
	if !bags[id]:
		return

	bags[id].success = bags[id].full_success
	bags[id].fail = bags[id].full_fail

#Create a rollable table where entries are removed as they are rolled. Parameter rollable table format: [[weight1, value1, {reset_on_roll1}], [weight2, value2, {reset_on_roll2}], ...]
func table_create(id, rollable_table: Array) -> void:
	tables[id] = {active = rollable_table.duplicate(true), original = rollable_table.duplicate(true)}

#Roll a value from a rollable table. Returns the value specified in the table.
func table_roll(id):
	if !tables[id]:
		return
	
	var target_table = tables[id].active
	var total_weight = 0
	var num_entries = target_table.size()

	#count up the total weight
	for i in range(0, num_entries):
		total_weight += target_table[i][0]

	var weight_result = randf() * total_weight

	#find and return the resulting value
	var result
	var processed_weight = 0
	for i in range(0, num_entries):
		if weight_result <= target_table[i][0] + processed_weight:
			result = target_table[i][1]

			if target_table[i][2] or num_entries == 1:
				table_reset(id)
			else:
				target_table.remove(i)

			return result

		else:
			processed_weight += target_table[i][0]

#Reset a rollable table to its' original contents.
func table_reset(id):
	if !tables[id]:
		return
	
	tables[id].active = tables[id].original.duplicate(true)
