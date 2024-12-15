#!/bin/env python
import sys

from typing import TextIO

def part_one(source: str):
	left = []
	right = []
	for line in source.splitlines():
		(a, b, *_) = line.split()
		left.append(int(a.strip()))
		right.append(int(b.strip()))
	
	left.sort()
	right.sort()

	diffs = [ abs(a - b) for a, b in zip(left, right) ]
	return sum(diffs)


def part_two(source: str):

	# Yeah, I made a one-liner from the loop in the first one :3
	(left, right) = zip(*[ (int(a), int(b)) for a, b, *_  in map(lambda x: x.split(), source.splitlines()) ])

	# Me when list comprehensions
	similarity = [ x * right.count(x) for x in left ]	
	return sum(similarity)


if __name__ == "__main__":
	try:
		with (open(sys.argv[1])) as f:
			text = f.read()
	except IndexError:
		text = sys.stdin.read()
	
	print(f'Part 1: {part_one(text)}')
	print(f'Part 2: {part_two(text)}')