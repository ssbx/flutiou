
namespace eval ::flutiou::ui::statusbar {
}

proc ::flutiou::ui::statusbar::setup {w} {

    variable volume_ctrl
    set fpad $::flutiou::ui::fpad
    set wpad $::flutiou::ui::wpad

    #
    # Frame containers
    #
    ttk::frame $w.progress   -borderwidth 1 -relief groove
    ttk::frame $w.modes      -borderwidth 1 -relief groove
    ttk::frame $w.short_info -borderwidth 1 -relief groove
    ttk::frame $w.track_info -borderwidth 1 -relief groove
    pack $w.progress   -side right -padx "$fpad 0" -fill y
    pack $w.modes      -side right -padx "$fpad 0" -fill y
    pack $w.short_info -side right -padx "$fpad 0" -fill y
    pack $w.track_info -side right -padx "0     0" -fill both -expand 1


    #
    # track progress and ffw rwd scale button
    #
    set f $w.progress
    ttk::label $f.tot_time -text "5:10"
    ttk::label $f.rem_time -text "2:34"
    ttk::scale $f.scale_time -orient horizontal -length 300
    pack $f.tot_time      -side right -padx "$wpad 10" -pady $wpad
    pack $f.scale_time    -side right -padx "0 0" -pady $wpad
    pack $f.rem_time      -side right -padx "10 $wpad" -pady $wpad


    #
    # Next the two "random" and "loop" buttons play modes
    #
    set custompad [expr $wpad * 2]
    set f $w.modes
    ttk::checkbutton $f.random -style Rand.TCheckbutton
    ttk::checkbutton $f.loop   -style Loop.TCheckbutton
    pack $f.random -side right -padx "0 $custompad" -pady $wpad
    pack $f.loop   -side right -padx "$custompad $custompad" -pady $wpad


    #
    # Then the playlist status
    #
    set f $w.short_info
    ttk::label $f.sinfo -text [format "9 %s (1:47)" [mc tracks]]
    pack $f.sinfo -side right -padx "$wpad $wpad" -pady $wpad


    #
    # the track info with extra label supporting bold
    #
    set f $w.track_info
    extralabel new $f.tinfo

    extralabel set $f.tinfo [                                   \
        mc {Playing: %1$s by %2$s %3$s}                         \
        "*The Dark Side of the Moon*" "*Pink Floyd*" "(4:35)"   \
    ]
    pack $f.tinfo -side left -padx "$wpad $wpad" -expand 1 -fill x
}
