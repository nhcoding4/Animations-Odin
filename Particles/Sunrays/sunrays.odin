package main

import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------

create_sunray_array :: proc(particles: ^[dynamic]Particle) -> [dynamic]^Particle {
	sunray_array: [dynamic]^Particle

	for i in 0 ..< len(particles) {
		if particles[i].sunray_target {
			append(&sunray_array, &particles[i])
		}
	}
	return sunray_array
}

// --------------------------------------------------------------------------------------------------------------------

draw_sunrays :: proc(sunray_array: ^[dynamic]^Particle, mouse: ^Mouse) {
	for i in 0 ..< len(sunray_array) {
		rl.DrawLineEx(sunray_array[i].position, mouse.position, 1.5, rl.Color{255, 255, 255, 50})
	}
}

// --------------------------------------------------------------------------------------------------------------------
