package slideshow_simple

import c "core:c"
import fmt "core:fmt"
import la "core:math/linalg"
import n "core:math/linalg/hlsl"
import rand "core:math/rand"
import mem "core:mem"
import os "core:os"
import "core:runtime"
import "core:slice"
import "core:sort"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"
import rl "vendor:raylib"

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: false
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false
IS_DEBUG_MODE :: true

DEBUG_FILTERING_SEARCH :: false // this is for main debug

DEBUG_READ_ERRORN :: false
COUNT_TOTAL_PROGRAMS_PATH :: false
TEST_STATEMENT :: false

FILE_MAGIC :: "#lang slideshow/simple"


MAX_SLIDES :: 1024 // 2 ^ 10 // stay minimalist, even on memory usage...
MAX_STRING_LEN_BY_LINE :: 80

Presentation :: struct {
  slide_strs_arr:   [MAX_SLIDES][MAX_STRING_LEN_BY_LINE]string,
  slide:        map[int]string,
  total_number: int,
}

texto_to_lines_int :: proc(
  file_text: string,
  allocator := context.allocator,
) -> []string {

  split_string: []string = strings.split_after(file_text, "\n")

  strings_values: []string = split_string[:len(split_string) - 1]

  arr_values: [dynamic]string
  // defer delete(arr_values)

  for item, index in strings_values {
    // TODO : leak
    item_trim := strings.trim_space(item)
    append(&arr_values, item_trim)
  }

  return arr_values[:]
}


read_entire_file_from_path :: proc(file_path_name: string) -> (string, bool) {

  data_text_digest, ok := os.read_entire_file(
    file_path_name,
    context.allocator,
  )
  if !ok {
    // could not read file
    fmt.println("cannot read file")
    return "", false
  }
  // defer delete(data_text_digest, context.allocator)

  return string(data_text_digest), ok
}

parse_slide_file :: proc(file: string) -> (ret: Presentation) {

  /// TODOO: implemet this
  return ret
}

check_file_name_extention_and_content :: proc(
  file: string,
  allocator := context.allocator,
) -> (
  ret: bool,
) {

  ret = strings.contains(file, ".rkt")

  file_str, ok := read_entire_file_from_path(file)
  if !ok {
    ret = false
    return ret
  }

  file_str_arr: []string = texto_to_lines_int(file_str, allocator)
  first_line_file_str := strings.trim_space(file_str_arr[0])

  ret_value_check := strings.compare(first_line_file_str, FILE_MAGIC)

  if ret_value_check == 0 {
    ret = ret && true
  } else {
    ret = ret && false
  }

  return ret
}

main_source :: proc() {

  file_name: string

  if len(os.args) > 1 {

    file_name = os.args[1]
  } else {
    fmt.println(
      "file name not pass, shout be\nslideshow-simple.bin <file_name>.rkt",
    )
    return
  }

  {
    if !check_file_name_extention_and_content(file_name) {
      fmt.println(
        "file do not is a valid slideshow file format or extension\nshout be extension .rkt of lang Slideshow-simple",
      )
      return
    }


    file_str, ok := read_entire_file_from_path(file_name)
    if !ok {
      fmt.println("not been able to open or read file")
      return
    }

    when true {
      file_str_arr: []string = texto_to_lines_int(file_str, context.allocator)

      for item in file_str_arr {
        fmt.println(item)
      }
      fmt.println("file lenght", len(file_str_arr))
    }

  }

  when INTERFACE_RAYLIB {

    display := rl.GetCurrentMonitor()
    windown_dim :: n.int2{800, 600}
    old_windown_dim := n.int2 {
      rl.GetMonitorWidth(display),
      rl.GetMonitorHeight(display),
    }


    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)
  }

  when INTERFACE_RAYLIB {


    keyfor: rl.KeyboardKey
    keyfor = rl.GetKeyPressed()


    is_running :: true


    when !IS_DEBUG_MODE {
      if (rl.IsWindowFullscreen()) {
        // if we are full screen, then go back to the windowed size
        rl.SetWindowSize(windown_dim.x, windown_dim.y)
      } else {

        // if we are not full screen, set the window size to match the monitor we are on
        rl.SetWindowSize(
          rl.GetMonitorWidth(display),
          rl.GetMonitorHeight(display),
        )
      }

      // toggle the state
      rl.ToggleFullscreen()
    }

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
