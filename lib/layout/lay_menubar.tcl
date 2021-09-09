
namespace eval ::flutiou::ui::menubar {}

proc ::flutiou::ui::menubar::setup {w} {

    ttk::frame $w.menu

    set bg [ttk::style lookup theme -background]
    set fg [ttk::style lookup theme -foreground]
    set sbg [ttk::style lookup theme -selectbackground]
    set sfg [ttk::style lookup theme -selectforeground]
    menu $w.menu.flutiou \
        -tearoff 0 \
        -borderwidth 1 \
        -background $bg \
        -foreground $fg \
        -activebackground $sbg \
        -activeforeground $sfg

    $w.menu.flutiou add command -command ::flutiou::win::configure::launch -label "[mc Configure]..." \
        -underline 0 -image $::flutiou::images(system-log-out) -compound left
    $w.menu.flutiou add separator
    $w.menu.flutiou add command -command { exit } -label [mc Quit] -underline 0 -accelerator "<Ctrl-Q>" -image $::flutiou::images(system-log-out) -compound left

    menu $w.menu.playlist \
        -tearoff 0 \
        -borderwidth 1 \
        -background $bg \
        -foreground $fg \
        -activebackground $sbg \
        -activeforeground $sfg

    $w.menu.playlist add command -command { exit } -label [mc Clear] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add command -command { exit } -label [mc Undo] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add command -command { exit } -label [mc Redo] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add separator

    $w.menu.playlist add command -command { exit } -label [mc Play] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add command -command { exit } -label [mc Pause] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add command -command { exit } -label [mc Previous] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    $w.menu.playlist add command -command { exit } -label [mc Next] -underline 0 -accelerator "<Ctrl-P>" -image $::flutiou::images(system-log-out) -compound left

    ttk::menubutton $w.menu.flutiou_button \
        -text Flutiou \
        -takefocus 1 \
        -direction below \
        -menu $w.menu.flutiou \
        -underline 0 \
        -style Toolbutton

    ttk::menubutton $w.menu.browse_button \
        -text [ mc Browse ] \
        -takefocus 1 \
        -direction below \
        -menu $w.menu.flutiou \
        -underline 0 \
        -style Toolbutton

    ttk::menubutton $w.menu.playlist_button \
        -text [ mc Playlist ] \
        -direction below \
        -menu $w.menu.playlist \
        -underline 0 \
        -style Toolbutton

    ttk::menubutton $w.menu.appearance_button \
        -text [ mc Appearance ] \
        -direction below \
        -menu $w.menu.playlist \
        -underline 0 \
        -style Toolbutton

    pack $w.menu.flutiou_button -side left -fill y
    pack $w.menu.browse_button -side left -fill y
    pack $w.menu.playlist_button -side left -fill y -padx { 5 0 }
    pack $w.menu.appearance_button -side left -fill y -padx { 10 0 }
    pack $w.menu -side top -fill x -padx 0 -pady 0
}

