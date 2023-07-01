package spawn_rune

import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rl "vendor:raylib"
import rand "core:math/rand"
import "core:strings"
import "core:slice"
import os "core:os"
import c "core:c"
import mem "core:mem"
import "core:runtime"
import "core:unicode/utf8"
import "core:unicode"
import "core:sort"

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: true
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false

DEBUG_FILTERING_SEARCH :: false // this is for main debug

DEBUG_READ_ERRORN :: false
COUNT_TOTAL_PROGRAMS_PATH :: false
TEST_STATEMENT :: false

main_source :: proc() {


  windown_dim :: n.int2{400, 100}

  when INTERFACE_RAYLIB {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)
  }

  when INTERFACE_RAYLIB {


    keyfor: rl.KeyboardKey
    keyfor = rl.GetKeyPressed()


    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    pause: bool = false

    when TEST_MODE {
      fmt.println("counter :: ", counter)
    }

    for is_running && rl.WindowShouldClose() == false {

      keyfor = rl.GetKeyPressed()

      if keyfor == rl.KeyboardKey.ENTER {

      } else if (keyfor >= rl.KeyboardKey.A) && (keyfor <= rl.KeyboardKey.Z) {


      } else if keyfor == rl.KeyboardKey.BACKSPACE {

      } else if keyfor == rl.KeyboardKey.SPACE {

      } else if keyfor == rl.KeyboardKey.PERIOD {

      } else if (keyfor == rl.KeyboardKey.MINUS) ||
         (keyfor == rl.KeyboardKey.KP_SUBTRACT) {

      } else if keyfor == rl.KeyboardKey.TAB {

      }

      rl.ClearBackground(rl.WHITE)

      rl.DrawText("Hello World", 100, 100, 20, rl.DARKGRAY)


      rl.DrawText(
        "hello World",
        (windown_dim.x / 2) - 190,
        (windown_dim.y / 2) + 30,
        20,
        rl.BLACK,
      )


      rl.EndDrawing()
    }
  }
}

when !TEST_MODE {
  main_test_fail :: proc() {

  }
}

main_scheduler :: proc() {

  // put LUA stuff here

  // main_proc() // still not working propely

  main_source()
}

main :: proc() {

  when SHOW_LEAK {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
  }

  when !TEST_MODE {
    main_scheduler()
  } else {
    testing()
  }

  when SHOW_LEAK {
    for _, leak in track.allocation_map {
      fmt.printf("%v leaked %v bytes\n", leak.location, leak.size)
    }
    for bad_free in track.bad_free_array {
      fmt.printf(
        "%v allocation %p was freed badly\n",
        bad_free.location,
        bad_free.memory,
      )
    }
  }
  return
}
