package main

import "core:math"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------

Mouse :: struct {
	position:           rl.Vector2,
	pressed:            bool,
	radius, push_power: f32,
}

// --------------------------------------------------------------------------------------------------------------------

create_mouse :: proc(config: ^Config) -> Mouse {
	mouse: Mouse = {
		pressed    = false,
		radius     = 200,
		position   = rl.Vector2{f32(config.width / 2), f32(config.height / 2)},
		push_power = 1,
	}
	
	return mouse
}

// --------------------------------------------------------------------------------------------------------------------

mouse_push :: proc(mouse: ^Mouse, particles: ^[dynamic]Particle) {
	if mouse.pressed {
		for i in 0 ..< len(particles) {
			dx: f32 = particles[i].position.x - mouse.position.x
			dy: f32 = particles[i].position.y - mouse.position.y
			distance: f32 = math.hypot(dx, dy)

			if distance < mouse.radius {
				power: f32 = (mouse.radius / distance) * mouse.push_power
				angle: f32 = math.atan2(dy, dx)
				particles[i].push_x = math.cos(angle) * power
				particles[i].push_y = math.sin(angle) * power
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
