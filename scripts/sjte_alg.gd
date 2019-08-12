extends Node

# Collection of static functions for the Steinhaus-Johnson-Trotter algorithm
# with Even's speedup.
# https://en.wikipedia.org/wiki/Steinhaus-Johnson-Trotter_algorithm

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
	permutations.append(indicies.duplicate(true))
	
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
		
		# Append a copy of the current permutation to list
		permutations.append(indicies.duplicate(true))
	
	# When algorithm terminates, return list of permuatations
	return permutations

# Swap 2 elements of a given list
static func swap(list, i, j):
	var temp = list[i]
	list[i] = list[j]
	list[j] = temp
