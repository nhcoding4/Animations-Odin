package main

import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------

Mouse :: struct {
	position:                                 rl.Vector2,
	radius, angle, angle_speed, x_div, y_div: f32,
}

// --------------------------------------------------------------------------------------------------------------------

create_mouse :: proc(config: ^Config) -> Mouse {
	mouse: Mouse = {
		radius      = 50,
		position    = rl.Vector2{f32(config.width / 2), f32(config.height / 2)},
		angle       = 0,
		angle_speed = rand.float32_range(0.1, 1.0),
		x_div       = 540,
		y_div       = 180,
	}

	return mouse
}

// --------------------------------------------------------------------------------------------------------------------

mouse_create :: proc(mouse: ^Mouse, particles: ^[dynamic]Particle, config: ^Config) {
	x_offset := rand.float32_range(-1 * mouse.radius, mouse.radius)
	y_offset := rand.float32_range(-1 * mouse.radius, mouse.radius)
	particle_x := mouse.position.x + x_offset
	particle_y := mouse.position.y + y_offset

	create_particle(particle_x, particle_y, config, particles)
}

// --------------------------------------------------------------------------------------------------------------------

mouse_update :: proc(mouse: ^Mouse, config: ^Config) {
	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
		mouse.position = rl.GetMousePosition()
	} else {
		mouse.angle += mouse.angle_speed

		mouse.position.x =
			(f32(config.width) - mouse.radius) /
				2 *
				math.sin(mouse.angle * math.PI / mouse.x_div) +
			(f32(config.width) / 2 - mouse.radius)

		mouse.position.y =
			(f32(config.height) - mouse.radius) /
				2 *
				math.cos(mouse.angle * math.PI / mouse.y_div) +
			(f32(config.height) / 2 - mouse.radius)

		if mouse.position.x - mouse.radius * 2 < 0 {
			mouse.position.x = mouse.radius * 2
		}
		if mouse.position.x + mouse.radius * 2 > f32(config.width) {
			mouse.position.x = f32(config.width) - mouse.radius * 2
		}
		if mouse.position.y - mouse.radius * 2 < 0 {
			mouse.position.y = mouse.radius * 2
		}
		if mouse.position.y + mouse.radius * 2 > f32(config.height) {
			mouse.position.y = f32(config.height) - mouse.radius * 2
		}
	}
}
// --------------------------------------------------------------------------------------------------------------------
