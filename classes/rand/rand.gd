class_name Rand
extends RefCounted


## Random Vector2 [X: 0..1, Y: 0..1]
static func v2() -> Vector2:
	return Vector2(randf(), randf())


## Random (offset) Vector2 [X: -1..1, Y: -1..1]
static func v2u() -> Vector2:
	return v2() * 2.0 - Vector2.ONE


## Random Vector2 fitting a unit circle, generated using Monte-Carlo method
static func v2m() -> Vector2:
	var res = v2u()
	if res.length_squared() > 1.0:
		return v2m()
	else:
		return res


## Random Vector3 [X: 0..1, Y: 0..1, Z: 0..1]
static func v3() -> Vector3:
	return Vector3(randf(), randf(), randf())


## Random (offset) Vector2 [X: -1..1, Y: -1..1, Z: -1..1]
static func v3u() -> Vector3:
	return v3() * 2 - Vector3.ONE


## Random Vector3 fitting a unit sphere, generated using Monte-Carlo method
static func v3m() -> Vector3:
	var res = v3u()
	if res.length_squared() > 1.0:
		return v3m()
	else:
		return res
