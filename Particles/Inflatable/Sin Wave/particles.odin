package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------


Particle :: struct {
	radius, friction, min_radius: f32,
	position:                     rl.Vector2,
	color:                        rl.Color,
	sunray_target:                bool,
}

// --------------------------------------------------------------------------------------------------------------------

create_particle :: proc(
	x_pos: f32,
	y_pos: f32,
	config: ^Config,
	particle_array: ^[dynamic]Particle,
) {
	new_particle: Particle = {
		radius   = rand.float32_range(20, 40),
		color    = config.particle_color,
		position = rl.Vector2{x_pos, y_pos},
	}
	new_particle.min_radius = new_particle.radius
	new_particle.color.r *= u8(math.round_f32(255 * new_particle.position.x / f32(config.width)))

	append(particle_array, new_particle)
}

// --------------------------------------------------------------------------------------------------------------------

draw_particles :: proc(particles: ^[dynamic]Particle) {
	for i in 0 ..< len(particles) {
		rl.DrawCircle(
			i32(particles[i].position.x),
			i32(particles[i].position.y),
			particles[i].radius + 1,
			rl.BLACK,
		)

		rl.DrawCircle(
			i32(particles[i].position.x),
			i32(particles[i].position.y),
			particles[i].radius,
			particles[i].color,
		)

		rl.DrawCircle(
			i32(particles[i].position.x - particles[i].radius * 0.2),
			i32(particles[i].position.y - particles[i].radius * 0.3),
			particles[i].radius * 0.6,
			rl.WHITE,
		)
	}
}

// --------------------------------------------------------------------------------------------------------------------

update_particles :: proc(particles: ^[dynamic]Particle) {
	for i in 0 ..< len(particles) {
		particles[i].radius -= 0.5

		if particles[i].radius < 0.1 {
			unordered_remove(particles, i)
		}
	}
}

// --------------------------------------------------------------------------------------------------------------------
