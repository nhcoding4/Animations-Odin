package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------


Particle :: struct {
	radius, push_x, push_y, friction: f32,
	position, movement:               rl.Vector2,
	color:                            rl.Color,
	sunray_target:                    bool,
}

// --------------------------------------------------------------------------------------------------------------------

create_particles :: proc(config: ^Config) -> [dynamic]Particle {
	create_particle := proc(config: ^Config) -> Particle {
		new_particle: Particle = {
			radius   = rand.float32_range(10, 20),
			movement = rl.Vector2{rand.float32_range(-1.0, 1.0), rand.float32_range(-1.0, 1.0)},
			color    = config.particle_color,
		}
		set_particle_position(&new_particle, config)

		if new_particle.radius <= 12 {
			new_particle.friction = 0.99
		} else if new_particle.radius <= 17 {
			new_particle.friction = 0.97
		} else {
			new_particle.friction = 0.95
		}

		return new_particle
	}

	particles: [dynamic]Particle

	for i in 0 ..< int(config.total_particles) {
		new_particle: Particle = create_particle(config)

		if i % config.sunray_modulo == 0 {
			new_particle.sunray_target = true
		}

		append(&particles, new_particle)
	}

	return particles
}

// --------------------------------------------------------------------------------------------------------------------

draw_particles :: proc(particles: ^[dynamic]Particle) {
	for i in 0 ..< len(particles) {
		rl.DrawCircle(
			i32(particles[i].position.x),
			i32(particles[i].position.y),
			particles[i].radius,
			rl.WHITE,
		)

		rl.DrawCircle(
			i32(particles[i].position.x),
			i32(particles[i].position.y),
			particles[i].radius,
			particles[i].color,
		)
	}
}

// --------------------------------------------------------------------------------------------------------------------

set_particle_position :: proc(particle: ^Particle, config: ^Config) {
	particle.position = rl.Vector2 {
		rand.float32_range(particle.radius, f32(config.width) - particle.radius),
		rand.float32_range(particle.radius, f32(config.height) - particle.radius),
	}
}

// --------------------------------------------------------------------------------------------------------------------

update_particles :: proc(particles: ^[dynamic]Particle, config: ^Config) {
	for i in 0 ..< len(particles) {
		particles[i].position.x += (particles[i].movement.x + math.round_f32(particles[i].push_x))
		particles[i].position.y += (particles[i].movement.y + math.round_f32(particles[i].push_y))

		particles[i].push_x *= particles[i].friction
		particles[i].push_y *= particles[i].friction

		if particles[i].position.x - particles[i].radius < 0 {
			particles[i].position.x = particles[i].radius
			particles[i].movement.x *= -1
		}

		if particles[i].position.x + particles[i].radius > f32(config.width) {
			particles[i].position.x = f32(config.width) - particles[i].radius
			particles[i].movement.x *= -1
		}

		if particles[i].position.y - particles[i].radius < 0 {
			particles[i].position.y = particles[i].radius
			particles[i].movement.y *= -1
		}

		if particles[i].position.y + particles[i].radius > f32(config.height) {
			particles[i].position.y = f32(config.height) - particles[i].radius
			particles[i].movement.y *= -1
		}

		opacity := math.round_f32(255 / (f32(config.height) / particles[i].position.y))

		particles[i].color.a = u8(opacity)
	}
}

// --------------------------------------------------------------------------------------------------------------------
