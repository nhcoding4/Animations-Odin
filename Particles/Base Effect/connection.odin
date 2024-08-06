package main

import "core:math"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------

Connector :: struct {
	color:              rl.Color,
	start, end:         rl.Vector2,
	opacity, thickness: f32,
}

// --------------------------------------------------------------------------------------------------------------------

create_connectors :: proc(particles: ^[dynamic]Particle, config: ^Config) -> [dynamic]Connector {
	connectors: [dynamic]Connector

	length := len(particles)

	for i in 0 ..< length {
		for j in i ..< length {
			if j == i {
				continue
			}

			dx: f32 = particles[i].position.x - particles[j].position.x
			dy: f32 = particles[i].position.y - particles[j].position.y
			distance := math.hypot(dx, dy)

			if distance <= config.connection_distance {
				new_connector: Connector = {
					start     = rl.Vector2{particles[i].position.x, particles[i].position.y},
					end       = rl.Vector2{particles[j].position.x, particles[j].position.y},
					opacity   = 1 - (distance / config.connection_distance),
					color     = config.connection_color,
					thickness = config.line_thickness,
				}
				new_connector.color.a = u8(math.round_f32(255 * new_connector.opacity))

				append(&connectors, new_connector)
			}
		}
	}

	return connectors
}
// --------------------------------------------------------------------------------------------------------------------

draw_connectors :: proc(connectors: ^[dynamic]Connector) {
	for i in 0 ..< len(connectors) {
		rl.DrawLineEx(
			connectors[i].start,
			connectors[i].end,
			connectors[i].thickness,
			rl.Color{255, 255, 255, connectors[i].color.a + 20},
		)
		rl.DrawLineEx(
			connectors[i].start,
			connectors[i].end,
			connectors[i].thickness,
			connectors[i].color,
		)
	}
}

// --------------------------------------------------------------------------------------------------------------------
