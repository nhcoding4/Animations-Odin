package main

import "core:fmt"
import "core:math/rand"
import "core:strings"
import rl "vendor:raylib"

// --------------------------------------------------------------------------------------------------------------------


Config :: struct {
	width, height, target_fps, total_particles: i32,
	title:                                      cstring,
	background, particle_color:                 rl.Color,
}

// --------------------------------------------------------------------------------------------------------------------

main :: proc() {
	config: Config = {
		width           = 750,
		height          = 750,
		target_fps      = 144,
		total_particles = 2000,
		title           = "Base Effect Odin",
		background      = rl.WHITE,
		particle_color  = rl.Color{100, 0, 255, 255},
	}

	particles: [dynamic]Particle = create_particles(&config)
	mouse: Mouse = create_mouse(&config)

	rl.SetConfigFlags(
		{
			rl.ConfigFlag.WINDOW_RESIZABLE,
			rl.ConfigFlag.VSYNC_HINT,
			rl.ConfigFlag.MSAA_4X_HINT,
			rl.ConfigFlag.WINDOW_HIGHDPI,
		},
	)
	rl.InitWindow(config.width, config.height, config.title)
	rl.SetTargetFPS(config.target_fps)

	for !rl.WindowShouldClose() {
		defer free_all(context.temp_allocator)

		resize_window(&config, &particles)
		mouse_update(&mouse)
		mouse_inflate(&mouse, &particles)
		update_particles(&particles, &config)

		rl.BeginDrawing()

		rl.ClearBackground(config.background)
		fps_counter()
		draw_particles(&particles)

		rl.EndDrawing()

	}
	rl.CloseWindow()
	delete(particles)
}

// --------------------------------------------------------------------------------------------------------------------

fps_counter :: proc() {
	fps := rl.GetFPS()
	buffer := strings.Builder{}
	fmt.sbprintf(&buffer, "%v", fps)
	fps_string := strings.to_cstring(&buffer)

	rl.DrawText(fps_string, 0, 0, 40, rl.GREEN)
}

// --------------------------------------------------------------------------------------------------------------------

resize_window :: proc(config: ^Config, particles: ^[dynamic]Particle) {
	if rl.IsWindowResized() {
		config.width = rl.GetScreenWidth()
		config.height = rl.GetScreenHeight()

		for i in 0 ..< len(particles) {
			set_particle_position(&particles[i], config)
		}
	}
}

// --------------------------------------------------------------------------------------------------------------------