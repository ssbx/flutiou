
namespace eval ::flutiou::ui::playzone {
    variable playcurrent_item ""
    variable playcurrent_canvwidget
    variable playlist
    variable playlist_scrollbar
    variable playlist_headmenu
    variable menu_head
    variable button_skip_backward
    variable button_skip_forward
    variable button_playpause
    variable button_stop
    variable tv_columns [list]
}

proc ::flutiou::ui::playzone::update_canvwidget_position {} {
    variable playlist
    variable playcurrent_item
    variable playcurrent_canvwidget
    set b [$playlist bbox $playcurrent_item]

    if {[llength $b] == 0} {
        place forget $playcurrent_canvwidget
    } else {
        set x [lindex $b 0]
        set y [lindex $b 1]
        set w [lindex $b 2]
        set h [lindex $b 3]
        place $playcurrent_canvwidget \
            -in $playlist \
            -x $x -y $y \
            -height $h \
            -relwidth 1.0 -width -2
    }
}

proc ::flutiou::ui::playzone::update_current {index} {
    variable playcurrent_item
    variable playlist

    set playcurrent_item [lindex [$playlist children {}] $index]
    ::flutiou::ui::playzone::update_canvwidget_position
}


proc ::flutiou::ui::playzone::setup {w} {
    set rpad $::flutiou::ui::rpad
    set mpad $::flutiou::ui::mpad

    ttk::frame $w.toolbox
    ttk::frame $w.playlist
    ttk::frame $w.controls

    pack $w.toolbox  -side top -fill x    -padx $rpad -pady "$mpad 0"
    pack $w.playlist -side top -fill both -padx $rpad -pady "$mpad 0" -expand 1
    pack $w.controls -side top -fill x    -padx $rpad -pady "$mpad 0"

    ::flutiou::ui::playzone::setup_toolbox $w.toolbox
    ::flutiou::ui::playzone::setup_treeview $w.playlist
    ::flutiou::ui::playzone::setup_controls $w.controls
    ::flutiou::ui::playzone::setup_playcurrent $w
}

###############################################################################
# PLAYLIST TOOLBOX
###############################################################################
proc ::flutiou::ui::playzone::setup_playcurrent {w} {
    set ::flutiou::ui::playzone::playcurrent_canvwidget [ttk::frame $w.canvwidget]
    ::flutiou::ui::playzone::playing::setup $w.canvwidget

}

proc ::flutiou::ui::playzone::setup_toolbox {w} {
    set f [ttk::frame $w.tools]

    ttk::button $f.save  \
        -image $::flutiou::images(list-add) \
        -style PadS.TButton \
        -command { tk_getOpenFile }

    ttk::button $f.clear \
        -image $::flutiou::images(edit-clear) \
        -style PadS.Left.Group.TButton
    ttk::button $f.undo  \
        -image $::flutiou::images(edit-undo) \
        -style PadS.Center.Group.TButton
    ttk::button $f.redo \
        -image $::flutiou::images(edit-redo) \
        -style PadS.Right.Group.TButton
    ttk::label  $f.search_text -text [format "%s: " [mc Filter]]
    ttk::entry $f.search
    ttk::button $f.advanced -text "..." -style PadS.TButton

    pack $f.save -side left -padx {0 5}
    pack $f.clear -side left
    pack $f.undo -side left
    pack $f.redo -side left
    pack $f.search_text -side left -padx {40 0}
    pack $f.search -side left -expand 1 -fill x -anchor s
    pack $f.advanced -side left -anchor s
    pack $f -side top -expand 1 -fill x -pady {4 2}

}

###############################################################################
# PLAYLIST TREEVIEW
###############################################################################
proc ::flutiou::ui::playzone::scroll_treeview {c y} {
    $::flutiou::ui::playzone::playlist yview $c $y
    ::flutiou::ui::playzone::update_canvwidget_position
}
proc ::flutiou::ui::playzone::scroll_treeview_set {first last} {
    $::flutiou::ui::playzone::playlist_scroll set $first $last
    ::flutiou::ui::playzone::update_canvwidget_position
}

proc ::flutiou::ui::playzone::setup_treeview {w} {

    #
    # The treeveiw widget container
    #
    ttk::frame $w.container -borderwidth 0

    #
    # our columns
    #
    variable tv_columns
    set tv_columns [::flutiou::collection::filters::all_filters]

    set bg  [ttk::style lookup theme -background]
    set fg  [ttk::style lookup theme -foreground]
    set sbg [ttk::style lookup theme -selectbackground]
    set sfg [ttk::style lookup theme -selectforeground]

    set ::flutiou::ui::playzone::playlist_headmenu [                                  \
        menu $w.container.head_menu \
            -tearoff 0 \
            -borderwidth 1 \
            -background $bg \
            -foreground $fg \
            -activebackground $sbg \
            -activeforeground $sfg]

    $::flutiou::ui::playzone::playlist_headmenu add command -command { exit } \
        -label [mc {Edit filters}]
    $::flutiou::ui::playzone::playlist_headmenu add command -command { exit } \
        -label [mc {Configure column heading...}]



    #
    # create and configure the treeview
    #
    set ::flutiou::ui::playzone::playlist [                      \
        ttk::treeview $w.container.treeview         \
            -columns $tv_columns                       \
            -yscroll {::flutiou::ui::playzone::scroll_treeview_set}     \
            -show headings \
            -selectmode extended]

    set popframe [extrapopup new $w.container.treeview.testpopup]
    ttk::label $popframe.echo -text "hello"
    pack $popframe.echo -fill both -expand 1
    set ::flutiou::ui::playzone::menu_head $popframe

    #$::flutiou::ui::playzone::playlist column #0 -stretch no -width 40 -anchor w
    $::flutiou::ui::playzone::playlist tag configure "odd" \
        -background $bg
    $::flutiou::ui::playzone::playlist tag configure "playing" \
                                -image $::flutiou::images(small-go-up)
    bind $::flutiou::ui::playzone::playlist <Button-3> {
        # todo: select on right click if not allready
        # todo: specific head menu to
        extrapopup show $::flutiou::ui::playzone::menu_head %x %y %W
    }

    foreach c $tv_columns {
        $::flutiou::ui::playzone::playlist heading $c \
            -anchor [::flutiou::collection::filters::call $c headinganchor]  \
            -text   [::flutiou::collection::filters::call $c heading]

        $::flutiou::ui::playzone::playlist column $c  \
            -anchor  [::flutiou::collection::filters::call $c cellanchor]  \
            -stretch [::flutiou::collection::filters::call $c cellstretch]
    }

    #$t heading "col_title"  -anchor w -text " Title"
    #$t column  "col_title"  -anchor w -stretch 1

    #$t heading "col_artist" -anchor w -text " Artist"
    #$t column  "col_artist" -anchor w -stretch 1

    #$t heading "col_album"  -anchor w -text " Album"
    #$t column  "col_album"  -anchor w -stretch 1

    #$t heading "col_length" -anchor w -text " Length"
    #$t column  "col_length" -anchor e -stretch 0 -width 80

    #$t heading "col_rate"   -anchor w -text " Rate"
    #$t column  "col_rate"   -anchor e -stretch 0 -width 80

    #
    # The scrollbar
    #
    set ::flutiou::ui::playzone::playlist_scroll [ttk::scrollbar $w.container.vscroll \
        -orient vertical                \
        -command {::flutiou::ui::playzone::scroll_treeview}]

    #
    # pack everything
    #
    pack $w.container          -expand 1 -fill both
    grid $w.container.treeview  -row 0 -column 0 -sticky news
    grid $w.container.vscroll   -row 0 -column 1 -sticky news
    grid rowconfigure $w.container 0 -weight 1
    grid columnconfigure $w.container 0 -weight 1
    grid columnconfigure $w.container 1 -weight 0

    autoscrollbar  $w.container.vscroll
}

###############################################################################
# PLAYER CONTROLS
###############################################################################
proc ::flutiou::ui::playzone::setup_controls {w} {
    set fpad   $::flutiou::ui::fpad
    set wpad   $::flutiou::ui::wpad

    variable button_skip_backward
    variable button_skip_forward
    variable button_playpause
    variable button_stop


    #
    # left control frame
    #
    ttk::frame $w.playcontrols

    set f $w.playcontrols
    set button_skip_backward [ttk::button $f.skip_backward \
        -image $::flutiou::images(media-skip-backward)  -style Left.Group.TButton]
    set button_playpause [ttk::button $f.playpause \
        -image $::flutiou::images(media-playback-start) -style Center.Group.TButton]
    set button_stop [ttk::button $f.stop \
        -image $::flutiou::images(media-playback-stop)  -style Center.Group.TButton]
    set button_skip_forward [ttk::button $f.skip_forward  \
        -image $::flutiou::images(media-skip-forward)   -style Right.Group.TButton]

    pack $f -side left -fill y -padx $fpad -pady $fpad
    pack $f.skip_backward -side left
    pack $f.playpause     -side left
    pack $f.stop          -side left
    pack $f.skip_forward  -side left


    #
    # middle visualizer frame
    #
    ttk::frame $w.visualizer
    pack $w.visualizer -side left -fill both -expand 1


    #
    # Right volume control with custom scale widget
    #
    ttk::frame $w.volume
    ::flutiou::ui::playzone::volume::setup $w.volume
    pack $w.volume -side right -fill y -padx "$fpad 0"

}
