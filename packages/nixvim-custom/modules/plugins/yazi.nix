{
  plugins.yazi = {
    enable = true;
    autoLoad = true;
    settings = {
      enable_mouse_support = true;
      floating_window_scaling_factor = 0.9;

      # these keymappings are in yazi interface, not in vim
      keymaps = {
        copy_relative_path_to_selected_files = "<c-y>";
        cycle_open_buffers = "<tab>";
        grep_in_directory = "<c-f>";
        open_file_in_horizontal_split = "<c-,>";
        open_file_in_tab = "<c-/>";
        open_file_in_vertical_split = "<c-.>";
        replace_in_directory = "<c-g>";
        send_to_quickfix_list = "<c-q>";
        show_help = "<f1>";
      };
    };
  };
}
