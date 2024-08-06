package main

import "core:math"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------

Mouse :: struct {
	position: rl.Vector2,
	pressed:  bool,
	radius:   f32,
}

// --------------------------------------------------------------------------------------------------------------------

create_mouse :: proc(config: ^Config) -> Mouse {
	mouse: Mouse = {
		pressed  = false,
		radius   = 50,
		position = rl.Vector2{f32(config.width / 2), f32(config.height / 2)},
	}

	return mouse
}

// --------------------------------------------------------------------------------------------------------------------

mouse_inflate :: proc(mouse: ^Mouse, particles: ^[dynamic]Particle) {

	for i in 0 ..< len(particles) {
		if mouse.pressed {
			if particles[i].radius > 50 {
				continue
			}

			dx := particles[i].position.x - mouse.position.x
			dy := particles[i].position.y - mouse.position.y
			distance := math.hypot(dx, dy)

			if distance <= mouse.radius {
				particles[i].radius += 1
			}

		} else {
			if particles[i].radius > particles[i].min_radius {
				particles[i].radius -= 0.1
			}
		}
	}
}

// --------------------------------------------------------------------------------------------------------------------

mouse_update :: proc(mouse: ^Mouse) {
	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
		mouse.position = rl.GetMousePosition()
		mouse.pressed = true
	} else {
		mouse.pressed = false
	}
}
// --------------------------------------------------------------------------------------------------------------------
