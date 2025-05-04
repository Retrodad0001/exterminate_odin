package exterminate


//TODO readme and github text and picture
//TODO add memory leak detection (in only debug mode)
//TODO build debug and release to correct dir (windows) * delete dir every time and old stuff
//TODO ignore build dir in git
//TODO add picture in readme
//TODO show atlas
//TODO setup debug with tooling
//TODO setup draw with tooling


import "base:runtime"
import "core:log" //TODO remove me and use debug
import "core:mem"
import sdl "vendor:sdl3"


//import image "vendor:sdl3/image"


sdl_log :: proc "c" (
	userdata: rawptr,
	category: sdl.LogCategory,
	priority: sdl.LogPriority,
	message: cstring,
) {
	context = (cast(^runtime.Context)userdata)^
	level: log.Level
	switch priority {
	case .INVALID, .TRACE, .VERBOSE, .DEBUG:
		level = .Debug
	case .INFO:
		level = .Info
	case .WARN:
		level = .Warning
	case .ERROR:
		level = .Error
	case .CRITICAL:
		level = .Fatal
	}
	log.logf(level, "SDL {}: {}", category, message) //TODO remove me and use debug
}

main :: proc() {
	context.logger = log.create_console_logger()
	log.debug("starting game")

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				log.error("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					log.error("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				log.error("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					log.error("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	//last_ticks := sdl.GetTicks()

	main_loop: for {


		//	new_ticks := sdl.GetTicks()
		//	delta_time := f32(new_ticks - last_ticks) / 1000
		//	last_ticks = new_ticks

		// process events
		ev: sdl.Event
		for sdl.PollEvent(&ev) {

			#partial switch ev.type {
			case .QUIT:
				break main_loop
			case .KEY_DOWN:
				if ev.key.scancode == .ESCAPE do break main_loop
			}
		}

	}
}
