extends Node

# Collection of static functions for the Steinhaus-Johnson-Trotter algorithm
# with Even's speedup.
# https://en.wikipedia.org/wiki/Steinhaus-Johnson-Trotter_algorithm

# Generate a list of all permutations from N=1 to N=9
# This should be pre-computed before exporting the game
# Run this by adding this script as an auto-loaded global object
func _ready():
	for index in range(9):
		var path = "res://scripts/util/iter_%d" % (index+1)
		var perms = sjte(index + 1)
		var file = File.new()
		file.open(path, file.WRITE)
		file.store_var(perms)
		file.close()

# SJT algorithm; returns a list of lists representing all permutations of
# numbers from 1 to N
static func sjte(N):
	
	# List of permutations to return
	var permutations = []
	
	# Initialize the list of numbers and the directions
	# In directions list, -1 means left and 1 means right, and 0 is undirected
	var directions = [0]
	var indicies = [1]
	for i in range(N-1):
		directions.append(-1)
		indicies.append(i+2)
	
	# Add the initial permutation to the list
	var indicies_dup = indicies.duplicate(true)
	indicies_dup.push_front(0)
	permutations.append(indicies_dup)
	
	# Continue as long as there is a "mobile" (not undirected) number
	var has_mobile = true
	while has_mobile:
		# Find the largest mobile number's index
		var max_mobile = -INF
		for i in range(N):
			if directions[i] != 0 and (max_mobile == -INF or indicies[i] > indicies[max_mobile]):
				max_mobile = i
		if max_mobile == -INF:
			# No mobile numbers; break out of loop
			has_mobile = false
			continue
		
		# Swap the largest mobile index with the neighbor it's looking at
		var new_max_mobile = max_mobile + directions[max_mobile]
		swap(indicies, max_mobile, max_mobile + directions[max_mobile])
		swap(directions, max_mobile, max_mobile + directions[max_mobile])
		max_mobile = new_max_mobile
		
		# If max_mobile is now first or last, it's direction changes to 0
		if max_mobile == 0 or max_mobile == N-1:
			directions[max_mobile] = 0
		# Additionally, if new neighbor it's looking at is bigger, direction changes to 0
		if indicies[max_mobile] < indicies[max_mobile+directions[max_mobile]]:
			directions[max_mobile] = 0
		
		# Change the direction of all numbers larger than the largest mobile
		# number with no direction so that they point toward max_mobile
		for i in range(N):
			if indicies[i] > indicies[max_mobile] and directions[i] == 0:
				if i < max_mobile:
					directions[i] = 1
				else:
					directions[i] = -1
		
		# Append a copy of the current permutation to list with 0 prepended
		var new_list = indicies.duplicate(true)
		new_list.push_front(0)
		permutations.append(new_list)
	
	# When algorithm terminates, return list of permuatations
	return permutations

# Swap 2 elements of a given list
static func swap(list, i, j):
	var temp = list[i]
	list[i] = list[j]
	list[j] = temp
