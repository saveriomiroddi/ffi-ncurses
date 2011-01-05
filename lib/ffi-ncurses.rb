#!/usr/bin/env ruby -w
# ruby-ffi wrapper for ncurses
#
# Sean O'Halpin
#
# repo: http://github.com/seanohalpin/ffi-ncurses
#
# - version 0.1.0 - 2008-12-04
# - version 0.2.0 - 2009-01-18
# - version 0.3.0 - 2009-01-31
# - version 0.3.3 - 2010-08-24
# - version 0.3.4 - 2010-08-28

require 'ffi'

module FFI
  module NCurses
    VERSION = "0.3.4"
    extend FFI::Library

    # Use `RUBY_FFI_NCURSES_LIB` to specify a colon-separated list of
    # libs you want to try to load, e.g.
    #
    #     RUBY_FFI_NCURSES_LIB=XCurses:ncurses
    #
    # to try to load XCurses (from PDCurses) first, then ncurses.
    if ENV["RUBY_FFI_NCURSES_LIB"].to_s != ""
      LIB_HANDLE = ffi_lib(ENV["RUBY_FFI_NCURSES_LIB"].split(/:/)).first
    else
      LIB_HANDLE = ffi_lib(['ncursesw', 'libncursesw', 'ncurses']).first
    end

    begin
      # These global variables are defined in `ncurses.h`:
      #
      #     chtype acs_map[];
      #     WINDOW * curscr;
      #     WINDOW * newscr;
      #     WINDOW * stdscr;
      #     char ttytype[];
      #     int COLORS;
      #     int COLOR_PAIRS;
      #     int COLS;
      #     int ESCDELAY;
      #     int LINES;
      #     int TABSIZE;
      #
      # Note that the symbol table entry in a shared lib for an
      # exported variable contains a *pointer to the address* of
      # the variable which will be initialized in the process's
      # bss (uninitialized) data segment when the process is
      # initialized.

      # This is unlike methods, where the symbol table entry points to
      # the entry point of the method itself.

      # Variables need another level of indirection because they are
      # *not* shared between process instances - only code is shared.

      # So we define convenience methods to perform the lookup for
      # us. We can't just stash the value returned by
      # `read_pointer` at load time because it's not initialized
      # until after `initscr` has been called.
      symbols = [
                 ["acs_map", :pointer],
                 ["curscr", :pointer],
                 ["newscr", :pointer],
                 ["stdscr", :pointer],
                 ["ttytype", :string],
                 ["COLORS", :int],
                 ["COLOR_PAIRS", :int],
                 ["COLS", :int],
                 ["ESCDELAY", :int],
                 ["LINES", :int],
                 ["TABSIZE", :int],
                ]
      if LIB_HANDLE.respond_to?(:find_symbol)
        symbols.each do |sym, type|
          if handle = LIB_HANDLE.find_symbol(sym)
            define_method sym do
              handle.send("read_#{type}")
            end
            module_function sym
          else
            warn "{sym.inspect} not defined"
          end
        end
      else
        warn "#find_symbol not available - #{symbols.inspect} not defined"
      end
    rescue => e
    end

    # this list of function signatures was generated by the file
    # generate-ffi-ncurses-function-signatures.rb and inserted here by hand
    functions =
      [
       [:COLOR_PAIR, [:int], :int],
       [:PAIR_NUMBER, [:int], :int],
       [:_nc_tracebits, [], :string],
       [:_traceattr, [:ulong], :string],
       [:_traceattr2, [:int, :ulong], :string],
       [:_tracecchar_t, [:pointer], :string],
       [:_tracecchar_t2, [:int, :pointer], :string],
       [:_tracechar, [:int], :string],
       [:_tracechtype, [:ulong], :string],
       [:_tracechtype2, [:int, :ulong], :string],
       [:_tracedump, [:string, :pointer], :void],
       [:_tracef, [:string, :varargs], :void],
       [:_tracemouse, [:pointer], :string],
       [:add_wch, [:pointer], :int],
       [:add_wchnstr, [:pointer, :int], :int],
       [:add_wchstr, [:pointer], :int],
       [:addch, [:ulong], :int],
       [:addchnstr, [:pointer, :int], :int],
       [:addchstr, [:pointer], :int],
       [:addnstr, [:string, :int], :int],
       [:addnwstr, [:pointer, :int], :int],
       [:addstr, [:string], :int],
       [:addwstr, [:pointer], :int],
       [:assume_default_colors, [:int, :int], :int],
       [:attr_get, [:pointer, :pointer, :pointer], :int],
       [:attr_off, [:ulong, :pointer], :int],
       [:attr_on, [:ulong, :pointer], :int],
       [:attr_set, [:ulong, :short, :pointer], :int],
       [:attroff, [:ulong], :int],
       [:attron, [:ulong], :int],
       [:attrset, [:ulong], :int],
       [:baudrate, [], :int],
       [:beep, [], :int],
       [:bkgd, [:ulong], :int],
       [:bkgdset, [:ulong], :void],
       [:bkgrnd, [:pointer], :int],
       [:bkgrndset, [:pointer], :void],
       [:border, [:ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong], :int],
       [:border_set, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int],
       [:box, [:pointer, :ulong, :ulong], :int],
       [:box_set, [:pointer, :pointer, :pointer], :int],
       [:can_change_color, [], :int],
       [:cbreak, [], :int],
       [:chgat, [:int, :ulong, :short, :pointer], :int],
       [:clear, [], :int],
       [:clearok, [:pointer, :int], :int],
       [:clrtobot, [], :int],
       [:clrtoeol, [], :int],
       [:color_content, [:short, :pointer, :pointer, :pointer], :int],
       [:color_set, [:short, :pointer], :int],
       [:copywin, [:pointer, :pointer, :int, :int, :int, :int, :int, :int, :int], :int],
       [:curs_set, [:int], :int],
       [:curses_version, [], :string],
       [:def_prog_mode, [], :int],
       [:def_shell_mode, [], :int],
       [:define_key, [:string, :int], :int],
       [:delay_output, [:int], :int],
       [:delch, [], :int],
       [:deleteln, [], :int],
       [:delscreen, [:pointer], :void],
       [:delwin, [:pointer], :int],
       [:derwin, [:pointer, :int, :int, :int, :int], :pointer],
       [:doupdate, [], :int],
       [:dupwin, [:pointer], :pointer],
       [:echo, [], :int],
       [:echo_wchar, [:pointer], :int],
       [:echochar, [:ulong], :int],
       [:endwin, [], :int],
       [:erase, [], :int],
       [:erasechar, [], :char],
       [:erasewchar, [:pointer], :int],
       [:filter, [], :void],
       [:flash, [], :int],
       [:flushinp, [], :int],
       [:get_escdelay, [], :int],
       [:get_wch, [:pointer], :int],
       [:get_wstr, [:pointer], :int],
       [:getattrs, [:pointer], :int],
       [:getbegx, [:pointer], :int],
       [:getbegy, [:pointer], :int],
       [:getbkgd, [:pointer], :ulong],
       [:getbkgrnd, [:pointer], :int],
       [:getcchar, [:pointer, :pointer, :pointer, :pointer, :pointer], :int],
       [:getch, [], :int],
       [:getcurx, [:pointer], :int],
       [:getcury, [:pointer], :int],
       [:getmaxx, [:pointer], :int],
       [:getmaxy, [:pointer], :int],
       [:getmouse, [:pointer], :int],
       [:getn_wstr, [:pointer, :int], :int],
       [:getnstr, [:string, :int], :int],
       [:getparx, [:pointer], :int],
       [:getpary, [:pointer], :int],
       [:getstr, [:string], :int],
       [:getwin, [:pointer], :pointer],
       [:halfdelay, [:int], :int],
       [:has_colors, [], :int],
       [:has_ic, [], :int],
       [:has_il, [], :int],
       [:has_key, [:int], :int],
       [:has_mouse, [], :int],
       [:hline, [:ulong, :int], :int],
       [:hline_set, [:pointer, :int], :int],
       [:idcok, [:pointer, :int], :void],
       [:idlok, [:pointer, :int], :int],
       [:immedok, [:pointer, :int], :void],
       [:in_wch, [:pointer], :int],
       [:in_wchnstr, [:pointer, :int], :int],
       [:in_wchstr, [:pointer], :int],
       [:inch, [], :ulong],
       [:inchnstr, [:pointer, :int], :int],
       [:inchstr, [:pointer], :int],
       [:init_color, [:short, :short, :short, :short], :int],
       [:init_pair, [:short, :short, :short], :int],
       [:initscr, [], :pointer],
       [:innstr, [:string, :int], :int],
       [:innwstr, [:pointer, :int], :int],
       [:ins_nwstr, [:pointer, :int], :int],
       [:ins_wch, [:pointer], :int],
       [:ins_wstr, [:pointer], :int],
       [:insch, [:ulong], :int],
       [:insdelln, [:int], :int],
       [:insertln, [], :int],
       [:insnstr, [:string, :int], :int],
       [:insstr, [:string], :int],
       [:instr, [:string], :int],
       [:intrflush, [:pointer, :int], :int],
       [:inwstr, [:pointer], :int],
       [:is_cleared, [:pointer], :int],
       [:is_idcok, [:pointer], :int],
       [:is_idlok, [:pointer], :int],
       [:is_immedok, [:pointer], :int],
       [:is_keypad, [:pointer], :int],
       [:is_leaveok, [:pointer], :int],
       [:is_linetouched, [:pointer, :int], :int],
       [:is_nodelay, [:pointer], :int],
       [:is_notimeout, [:pointer], :int],
       [:is_scrollok, [:pointer], :int],
       [:is_syncok, [:pointer], :int],
       [:is_term_resized, [:int, :int], :int],
       [:is_wintouched, [:pointer], :int],
       [:isendwin, [], :int],
       [:key_defined, [:string], :int],
       [:key_name, [:ushort], :string],
       [:keybound, [:int, :int], :string],
       [:keyname, [:int], :string],
       [:keyok, [:int, :int], :int],
       [:keypad, [:pointer, :int], :int],
       [:killchar, [], :char],
       [:killwchar, [:pointer], :int],
       [:leaveok, [:pointer, :int], :int],
       [:longname, [], :string],
       [:mcprint, [:string, :int], :int],
       [:meta, [:pointer, :int], :int],
       [:mouse_trafo, [:pointer, :pointer, :int], :int],
       [:mouseinterval, [:int], :int],
       [:mousemask, [:ulong, :pointer], :ulong],
       [:move, [:int, :int], :int],
       [:mvadd_wch, [:int, :int, :pointer], :int],
       [:mvadd_wchnstr, [:int, :int, :pointer, :int], :int],
       [:mvadd_wchstr, [:int, :int, :pointer], :int],
       [:mvaddch, [:int, :int, :ulong], :int],
       [:mvaddchnstr, [:int, :int, :pointer, :int], :int],
       [:mvaddchstr, [:int, :int, :pointer], :int],
       [:mvaddnstr, [:int, :int, :string, :int], :int],
       [:mvaddnwstr, [:int, :int, :pointer, :int], :int],
       [:mvaddstr, [:int, :int, :string], :int],
       [:mvaddwstr, [:int, :int, :pointer], :int],
       [:mvchgat, [:int, :int, :int, :ulong, :short, :pointer], :int],
       [:mvcur, [:int, :int, :int, :int], :int],
       [:mvdelch, [:int, :int], :int],
       [:mvderwin, [:pointer, :int, :int], :int],
       [:mvget_wch, [:int, :int, :pointer], :int],
       [:mvget_wstr, [:int, :int, :pointer], :int],
       [:mvgetch, [:int, :int], :int],
       [:mvgetn_wstr, [:int, :int, :pointer, :int], :int],
       [:mvgetnstr, [:int, :int, :string, :int], :int],
       [:mvgetstr, [:int, :int, :string], :int],
       [:mvhline, [:int, :int, :ulong, :int], :int],
       [:mvhline_set, [:int, :int, :pointer, :int], :int],
       [:mvin_wch, [:int, :int, :pointer], :int],
       [:mvin_wchnstr, [:int, :int, :pointer, :int], :int],
       [:mvin_wchstr, [:int, :int, :pointer], :int],
       [:mvinch, [:int, :int], :ulong],
       [:mvinchnstr, [:int, :int, :pointer, :int], :int],
       [:mvinchstr, [:int, :int, :pointer], :int],
       [:mvinnstr, [:int, :int, :string, :int], :int],
       [:mvinnwstr, [:int, :int, :pointer, :int], :int],
       [:mvins_nwstr, [:int, :int, :pointer, :int], :int],
       [:mvins_wch, [:int, :int, :pointer], :int],
       [:mvins_wstr, [:int, :int, :pointer], :int],
       [:mvinsch, [:int, :int, :ulong], :int],
       [:mvinsnstr, [:int, :int, :string, :int], :int],
       [:mvinsstr, [:int, :int, :string], :int],
       [:mvinstr, [:int, :int, :string], :int],
       [:mvinwstr, [:int, :int, :pointer], :int],
       [:mvprintw, [:int, :int, :string, :varargs], :int],
       [:mvscanw, [:int, :int, :string, :varargs], :int],
       [:mvvline, [:int, :int, :ulong, :int], :int],
       [:mvvline_set, [:int, :int, :pointer, :int], :int],
       [:mvwadd_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwadd_wchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwadd_wchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwaddch, [:pointer, :int, :int, :ulong], :int],
       [:mvwaddchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwaddchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwaddnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwaddnwstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwaddstr, [:pointer, :int, :int, :string], :int],
       [:mvwaddwstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwchgat, [:pointer, :int, :int, :int, :ulong, :short, :pointer], :int],
       [:mvwdelch, [:pointer, :int, :int], :int],
       [:mvwget_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwget_wstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwgetch, [:pointer, :int, :int], :int],
       [:mvwgetn_wstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwgetnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwgetstr, [:pointer, :int, :int, :string], :int],
       [:mvwhline, [:pointer, :int, :int, :ulong, :int], :int],
       [:mvwhline_set, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwin, [:pointer, :int, :int], :int],
       [:mvwin_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwin_wchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwin_wchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwinch, [:pointer, :int, :int], :ulong],
       [:mvwinchnstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwinchstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwinnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwinnwstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwins_nwstr, [:pointer, :int, :int, :pointer, :int], :int],
       [:mvwins_wch, [:pointer, :int, :int, :pointer], :int],
       [:mvwins_wstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwinsch, [:pointer, :int, :int, :ulong], :int],
       [:mvwinsnstr, [:pointer, :int, :int, :string, :int], :int],
       [:mvwinsstr, [:pointer, :int, :int, :string], :int],
       [:mvwinstr, [:pointer, :int, :int, :string], :int],
       [:mvwinwstr, [:pointer, :int, :int, :pointer], :int],
       [:mvwprintw, [:pointer, :int, :int, :string, :varargs], :int],
       [:mvwscanw, [:pointer, :int, :int, :string, :varargs], :int],
       [:mvwvline, [:pointer, :int, :int, :ulong, :int], :int],
       [:mvwvline_set, [:pointer, :int, :int, :pointer, :int], :int],
       [:napms, [:int], :int],
       [:newpad, [:int, :int], :pointer],
       [:newterm, [:string, :pointer, :pointer], :pointer],
       [:newwin, [:int, :int, :int, :int], :pointer],
       [:nl, [], :int],
       [:nocbreak, [], :int],
       [:nodelay, [:pointer, :int], :int],
       [:noecho, [], :int],
       [:nofilter, [], :void],
       [:nonl, [], :int],
       [:noqiflush, [], :void],
       [:noraw, [], :int],
       [:notimeout, [:pointer, :int], :int],
       [:overlay, [:pointer, :pointer], :int],
       [:overwrite, [:pointer, :pointer], :int],
       [:pair_content, [:short, :pointer, :pointer], :int],
       [:pecho_wchar, [:pointer, :pointer], :int],
       [:pechochar, [:pointer, :ulong], :int],
       [:pnoutrefresh, [:pointer, :int, :int, :int, :int, :int, :int], :int],
       [:prefresh, [:pointer, :int, :int, :int, :int, :int, :int], :int],
       [:printw, [:string, :varargs], :int],
       [:putp, [:string], :int],
       [:putwin, [:pointer, :pointer], :int],
       [:qiflush, [], :void],
       [:raw, [], :int],
       [:redrawwin, [:pointer], :int],
       [:refresh, [], :int],
       [:reset_prog_mode, [], :int],
       [:reset_shell_mode, [], :int],
       [:resetty, [], :int],
       [:resize_term, [:int, :int], :int],
       [:resizeterm, [:int, :int], :int],
       [:ripoffline, [:int, :pointer], :int],
       [:savetty, [], :int],
       [:scanw, [:string, :varargs], :int],
       [:scr_dump, [:string], :int],
       [:scr_init, [:string], :int],
       [:scr_restore, [:string], :int],
       [:scr_set, [:string], :int],
       [:scrl, [:int], :int],
       [:scroll, [:pointer], :int],
       [:scrollok, [:pointer, :int], :int],
       [:set_escdelay, [:int], :int],
       [:set_tabsize, [:int], :int],
       [:set_term, [:pointer], :pointer],
       [:setcchar, [:pointer, :pointer, :ulong, :short, :pointer], :int],
       [:setscrreg, [:int, :int], :int],
       [:slk_attr, [], :ulong],
       [:slk_attr_off, [:ulong, :pointer], :int],
       [:slk_attr_on, [:ulong, :pointer], :int],
       [:slk_attr_set, [:ulong, :short, :pointer], :int],
       [:slk_attroff, [:ulong], :int],
       [:slk_attron, [:ulong], :int],
       [:slk_attrset, [:ulong], :int],
       [:slk_clear, [], :int],
       [:slk_color, [:short], :int],
       [:slk_init, [:int], :int],
       [:slk_label, [:int], :string],
       [:slk_noutrefresh, [], :int],
       [:slk_refresh, [], :int],
       [:slk_restore, [], :int],
       [:slk_set, [:int, :string, :int], :int],
       [:slk_touch, [], :int],
       [:slk_wset, [:int, :pointer, :int], :int],
       [:standend, [], :int],
       [:standout, [], :int],
       [:start_color, [], :int],
       [:subpad, [:pointer, :int, :int, :int, :int], :pointer],
       [:subwin, [:pointer, :int, :int, :int, :int], :pointer],
       [:syncok, [:pointer, :int], :int],
       [:term_attrs, [], :ulong],
       [:termattrs, [], :ulong],
       [:termname, [], :string],
       [:tigetflag, [:string], :int],
       [:tigetnum, [:string], :int],
       [:tigetstr, [:string], :string],
       [:timeout, [:int], :void],
       [:touchline, [:pointer, :int, :int], :int],
       [:touchwin, [:pointer], :int],
       [:tparm, [:string, :varargs], :string],
       [:trace, [:uint], :void],
       [:typeahead, [:int], :int],
       [:unctrl, [:ulong], :string],
       [:unget_wch, [:ushort], :int],
       [:ungetch, [:int], :int],
       [:ungetmouse, [:pointer], :int],
       [:untouchwin, [:pointer], :int],
       [:use_default_colors, [], :int],
       [:use_env, [:int], :void],
       [:use_extended_names, [:int], :int],
       [:use_legacy_coding, [:int], :int],
       [:vid_attr, [:ulong, :short, :pointer], :int],
       [:vidattr, [:ulong], :int],
       [:vline, [:ulong, :int], :int],
       [:vline_set, [:pointer, :int], :int],
       [:wadd_wch, [:pointer, :pointer], :int],
       [:wadd_wchnstr, [:pointer, :pointer, :int], :int],
       [:wadd_wchstr, [:pointer, :pointer], :int],
       [:waddch, [:pointer, :ulong], :int],
       [:waddchnstr, [:pointer, :pointer, :int], :int],
       [:waddchstr, [:pointer, :pointer], :int],
       [:waddnstr, [:pointer, :string, :int], :int],
       [:waddnwstr, [:pointer, :pointer, :int], :int],
       [:waddstr, [:pointer, :string], :int],
       [:waddwstr, [:pointer, :pointer], :int],
       [:wattr_get, [:pointer, :pointer, :pointer, :pointer], :int],
       [:wattr_off, [:pointer, :ulong, :pointer], :int],
       [:wattr_on, [:pointer, :ulong, :pointer], :int],
       [:wattr_set, [:pointer, :ulong, :short, :pointer], :int],
       [:wattroff, [:pointer, :int], :int],
       [:wattron, [:pointer, :int], :int],
       [:wattrset, [:pointer, :int], :int],
       [:wbkgd, [:pointer, :ulong], :int],
       [:wbkgdset, [:pointer, :ulong], :void],
       [:wbkgrnd, [:pointer, :pointer], :int],
       [:wbkgrndset, [:pointer, :pointer], :void],
       [:wborder, [:pointer, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong, :ulong], :int],
       [:wborder_set, [:pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer, :pointer], :int],
       [:wchgat, [:pointer, :int, :ulong, :short, :pointer], :int],
       [:wclear, [:pointer], :int],
       [:wclrtobot, [:pointer], :int],
       [:wclrtoeol, [:pointer], :int],
       [:wcolor_set, [:pointer, :short, :pointer], :int],
       [:wcursyncup, [:pointer], :void],
       [:wdelch, [:pointer], :int],
       [:wdeleteln, [:pointer], :int],
       [:wecho_wchar, [:pointer, :pointer], :int],
       [:wechochar, [:pointer, :ulong], :int],
       [:wenclose, [:pointer, :int, :int], :int],
       [:werase, [:pointer], :int],
       [:wget_wch, [:pointer, :pointer], :int],
       [:wget_wstr, [:pointer, :pointer], :int],
       [:wgetbkgrnd, [:pointer, :pointer], :int],
       [:wgetch, [:pointer], :int],
       [:wgetn_wstr, [:pointer, :pointer, :int], :int],
       [:wgetnstr, [:pointer, :string, :int], :int],
       [:wgetparent, [:pointer], :pointer],
       [:wgetscrreg, [:pointer, :pointer, :pointer], :int],
       [:wgetstr, [:pointer, :string], :int],
       [:whline, [:pointer, :ulong, :int], :int],
       [:whline_set, [:pointer, :pointer, :int], :int],
       [:win_wch, [:pointer, :pointer], :int],
       [:win_wchnstr, [:pointer, :pointer, :int], :int],
       [:win_wchstr, [:pointer, :pointer], :int],
       [:winch, [:pointer], :ulong],
       [:winchnstr, [:pointer, :pointer, :int], :int],
       [:winchstr, [:pointer, :pointer], :int],
       [:winnstr, [:pointer, :string, :int], :int],
       [:winnwstr, [:pointer, :pointer, :int], :int],
       [:wins_nwstr, [:pointer, :pointer, :int], :int],
       [:wins_wch, [:pointer, :pointer], :int],
       [:wins_wstr, [:pointer, :pointer], :int],
       [:winsch, [:pointer, :ulong], :int],
       [:winsdelln, [:pointer, :int], :int],
       [:winsertln, [:pointer], :int],
       [:winsnstr, [:pointer, :string, :int], :int],
       [:winsstr, [:pointer, :string], :int],
       [:winstr, [:pointer, :string], :int],
       [:winwstr, [:pointer, :pointer], :int],
       [:wmouse_trafo, [:pointer, :pointer, :pointer, :int], :int],
       [:wmove, [:pointer, :int, :int], :int],
       [:wnoutrefresh, [:pointer], :int],
       [:wprintw, [:pointer, :string, :varargs], :int],
       [:wredrawln, [:pointer, :int, :int], :int],
       [:wrefresh, [:pointer], :int],
       [:wresize, [:pointer, :int, :int], :int],
       [:wscanw, [:pointer, :string, :varargs], :int],
       [:wscrl, [:pointer, :int], :int],
       [:wsetscrreg, [:pointer, :int, :int], :int],
       [:wstandend, [:pointer], :int],
       [:wstandout, [:pointer], :int],
       [:wsyncdown, [:pointer], :void],
       [:wsyncup, [:pointer], :void],
       [:wtimeout, [:pointer, :int], :void],
       [:wtouchln, [:pointer, :int, :int, :int], :int],
       [:wunctrl, [:pointer], :pointer],
       [:wvline, [:pointer, :ulong, :int], :int],
       [:wvline_set, [:pointer, :pointer, :int], :int],
      ]
    # end of autogenerated function list

    @unattached_functions = []
    class << self
      def unattached_functions
        @unattached_functions
      end
    end

    # Attach functions.
    functions.each do |func|
      begin
        attach_function(*func)
      rescue Object => e
        # This is used for debugging.
        unattached_functions << func[0]
      end
    end

    module Colour
      COLOR_BLACK   = BLACK   = 0
      COLOR_RED     = RED     = 1
      COLOR_GREEN   = GREEN   = 2
      COLOR_YELLOW  = YELLOW  = 3
      COLOR_BLUE    = BLUE    = 4
      COLOR_MAGENTA = MAGENTA = 5
      COLOR_CYAN    = CYAN    = 6
      COLOR_WHITE   = WHITE   = 7
    end
    Color = Colour
    include Colour

    # FIXME: remove this code when JRuby gets find_sym
    # fixup for JRuby 1.1.6 - doesn't have find_sym
    # can hack for stdscr but not curscr or newscr (no methods return them)
    # this will all be removed when JRuby 1.1.7 is released
    module FixupInitscr
      if !NCurses.respond_to?(:stdscr)

        def initscr
          @stdscr = NCurses._initscr
        end

        def stdscr
          @stdscr
        end
      else
        def initscr
          NCurses._initscr
        end
      end
    end
    include FixupInitscr

    module Attributes
      # The following definitions have been copied (almost verbatim)
      # from `ncurses.h`.
      NCURSES_ATTR_SHIFT = 8
      def self.NCURSES_BITS(mask, shift)
        ((mask) << ((shift) + NCURSES_ATTR_SHIFT))
      end

      WA_NORMAL     = A_NORMAL     = (1 - 1)
      WA_ATTRIBUTES = A_ATTRIBUTES = NCURSES_BITS(~(1 - 1),0)
      WA_CHARTEXT   = A_CHARTEXT   = (NCURSES_BITS(1,0) - 1)
      WA_COLOR      = A_COLOR      = NCURSES_BITS(((1) << 8) - 1,0)
      WA_STANDOUT   = A_STANDOUT   = NCURSES_BITS(1,8)  # best highlighting mode available
      WA_UNDERLINE  = A_UNDERLINE  = NCURSES_BITS(1,9)  # underlined text
      WA_REVERSE    = A_REVERSE    = NCURSES_BITS(1,10) # reverse video
      WA_BLINK      = A_BLINK      = NCURSES_BITS(1,11) # blinking text
      WA_DIM        = A_DIM        = NCURSES_BITS(1,12) # half-bright text
      WA_BOLD       = A_BOLD       = NCURSES_BITS(1,13) # extra bright or bold text
      WA_ALTCHARSET = A_ALTCHARSET = NCURSES_BITS(1,14)
      WA_INVIS      = A_INVIS      = NCURSES_BITS(1,15)
      WA_PROTECT    = A_PROTECT    = NCURSES_BITS(1,16)
      WA_HORIZONTAL = A_HORIZONTAL = NCURSES_BITS(1,17)
      WA_LEFT       = A_LEFT       = NCURSES_BITS(1,18)
      WA_LOW        = A_LOW        = NCURSES_BITS(1,19)
      WA_RIGHT      = A_RIGHT      = NCURSES_BITS(1,20)
      WA_TOP        = A_TOP        = NCURSES_BITS(1,21)
      WA_VERTICAL   = A_VERTICAL   = NCURSES_BITS(1,22)
    end
    include Attributes

    module Constants
      FALSE = 0
      TRUE = 1

      ERR = -1
      OK = 0
    end
    include Constants

    require 'ffi-ncurses/winstruct'
    include WinStruct

    # These following 'functions' are implemented as macros in ncurses.
    module EmulatedFunctions
      # Note that I'm departing from the NCurses API here - it makes
      # no sense to force people to use pointer return values when
      # these methods have been implemented as macros to make them
      # easy to use in *C*. We have multiple return values in Ruby, so
      # let's use them.
      def getyx(win)
        [NCurses.getcury(win), NCurses.getcurx(win)]
      end

      def getbegyx(win)
        [NCurses.getbegy(win), NCurses.getbegx(win)]
      end

      def getparyx(win)
        [NCurses.getpary(win), NCurses.getparx(win)]
      end

      def getmaxyx(win)
        [NCurses.getmaxy(win), NCurses.getmaxx(win)]
      end

      # These have been transliterated from `ncurses.h`.
      #
      # FIXME: convert to use :bool type.
      def getsyx
        if (is_leaveok(newscr) == NCurses::TRUE)
			    [-1, -1]
        else
          getyx(newscr)
        end
      end

      def setsyx(y, x)
        if y == -1 && x == -1
			    leaveok(newscr, NCurses::TRUE)
        else
			    leaveok(newscr, NCurses::FALSE)
			    wmove(newscr, y, x)
        end
      end

      def self.fixup(function, &block)
        if NCurses.unattached_functions.include?(function)
          block.call
        end
      end

      # Hack for XCurses (PDCurses 3.3) - many more to come I suspect.
      fixup :getch do
        def getch
          wgetch(stdscr)
        end
      end
    end
    include EmulatedFunctions

    # Include fixes for Mac OS X (mostly macros directly referencing
    # the `WINDOW` struct).
    if defined?(::FFI::Platform::OS) && ::FFI::Platform::OS == "darwin"
      require 'ffi-ncurses/darwin'
      include NCurses::Darwin
    end

    # Make all those instance methods module methods too.
    extend self

  end
end

# Include key definitions.
require 'ffi-ncurses/keydefs'
