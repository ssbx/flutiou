
namespace eval ::flutiou::ui {

    variable rpad 2
    variable mpad 3
    variable fpad 3
    variable wpad 3
    variable pad_b 5

    variable callback_play
    variable callback_stop
    variable callback_exit
    variable callback_skip_backward
    variable callback_skip_forward

}

proc ::flutiou::ui::setup_window {} {
    #
    # configure window manager things
    #
    wm title    . "Flutiou music player"
    wm geometry . "1050x650+300+300"
    wm protocol . WM_DELETE_WINDOW { exit }
    pack [ttk::frame .root] -expand 1 -fill both
    ::flutiou::ui::setup_layout .root
}

proc ::flutiou::ui::setup_layout {w} {

    #
    # Create the application layout
    #
    ttk::panedwindow $w.mainpane -orient horizontal
    $w.mainpane add [ttk::frame $w.mainpane.browse]
    $w.mainpane add [ttk::frame $w.mainpane.playzone]
    ttk::frame $w.menubar
    ttk::frame $w.statusbar
    ttk::frame $w.selector
    #  ----------------------------------------------------------------------
    # | .menubar                                                             |
    #  ----------------------------------------------------------------------
    # |  |                      |                                            |
    # |  |                      |                                            |
    # |.selector                |                                            |
    # |  |                      |                                            |
    # |  |                  .mainpane                                        |
    # |  |                      |                                            |
    # |  |                      |                                            |
    # |  | .mainpane.browse     |           .mainpane.playzone               |
    # |  |                      |                                            |
    # |  |                      |                                            |
    #  ----------------------------------------------------------------------
    # | .statusbar                                                           |
    #  ----------------------------------------------------------------------
    pack $w.menubar   -fill x    -expand 0 -side top    -padx 0 -pady 0 -expand 0
    pack $w.statusbar -fill x    -expand 0 -side bottom -padx 0 -pady 0 -expand 0
    pack $w.selector  -fill y    -expand 0 -side left                   -expand 0
    pack $w.mainpane  -fill both -expand 1


    #
    # Top bottom bars
    #
    ::flutiou::ui::menubar::setup       $w.menubar
    ::flutiou::ui::statusbar::setup     $w.statusbar

    #
    # The main playzone/playlist controls
    #
    ::flutiou::ui::playzone::setup      $w.mainpane.playzone

    #
    # The left button selector and browsers
    #
    ::flutiou::ui::selector::setup      $w.selector

    #
    # The animated browser thing
    #
    variable canv $w.mainpane.browse.canv
    #canvas $canv -background $::funky::theme::COL(bg)
    canvas $canv -background white \
        -insertborderwidth 0 \
        -insertwidth 0 \
        -highlightthickness 0 \
        -selectborderwidth 0 \
        -borderwidth 0
    pack $canv -fill both -expand 1
    ttk::frame $canv.f
    ttk::frame $canv.c
    ::flutiou::ui::browse::files::layout::setup $canv.f
    ::flutiou::ui::browse::collection::layout::setup $canv.c
    bind $canv <Configure> {::flutiou::ui::canresize %W %w %h}
    variable fileframe      [$canv create window 0 0 -window $canv.f -anchor nw]
    variable colectionframe [$canv create window 0 0 -window $canv.c -anchor nw]

    ::flutiou::ui::canresize $canv [winfo width $canv] [winfo height $canv]
    variable browser_current_index 0

    #
    # some other intializations
    #
    ::flutiou::ui::browse::files::procs::setbinds

    # done!
    #after idle ::flutiou::ui::startanimtest
}

proc ::flutiou::ui::startanimtest {} {
    #
    # "yview moveto $x" when x go from 0.0 to 0.5 in 1 seconds
    variable anim_span 9000
    variable anim_from 0.5
    variable anim_to   0.0
    variable anim_start [clock milliseconds]
    after idle ::flutiou::ui::animate
}

proc ::flutiou::ui::animate {} {
    variable canv
    variable anim_span
    variable anim_from
    variable anim_to
    variable anim_start

    set now [clock milliseconds]
    set pos [expr {$now - $anim_start}]
    if {$pos > $anim_span} {
        $canv yview moveto $anim_to
        return
    }

    set yspan [expr {$anim_to - $anim_from}]
    set ypos [expr {$anim_from + (($yspan / $anim_span) * $pos)}]
    $canv yview moveto $ypos
    after 1 ::flutiou::ui::animate
}

proc ::flutiou::ui::canresize {w x y} {
    variable fileframe
    variable colectionframe
    $w configure -scrollregion [list 0 0 $x [expr {$y * 2}]]
    $w itemconfigure $fileframe      -width $x -height $y -anchor nw
    $w itemconfigure $colectionframe -width $x -height $y -anchor nw
    if {1} {
        $w moveto $colectionframe   0 0
        $w moveto $fileframe        0 $y
    } else {
        $w moveto $colectionframe 0 $y
        $w moveto $fileframe 0 0
    }

}

################################################################################
#  Used by funkytheme_editor
################################################################################
proc ::flutiou::ui::clear {w} {
    ::flutiou::ui::playzone::volume::clear
    ::w::extrapopup::clear
    pack forget $w.menubar
    pack forget $w.statusbar
    pack forget $w.mainpane
    pack forget $w.selector
    destroy $w.menubar
    destroy $w.statusbar
    destroy $w.mainpane
    destroy $w.selector
}

proc ::flutiou::ui::demo {} {
    set test_set { \
        ../test/test-1.wav
        ../test/test-2.wav
        ../test/test-3.wav
        ../test/test-4.wav
        ../test/test-5.wav
        ../test/test-6.wav
        ../test/test-7.wav
        ../test/test-8.wav
        ../test/test-9.wav
        ../test/test-10.wav
        ../test/test-11.wav
        ../test/test-12.wav
        ../test/test-13.wav
        ../test/test-14.wav
        ../test/test-15.wav
        ../test/test-16.wav
        ../test/test-17.wav
        ../test/test-18.wav
        ../test/test-19.wav
        ../test/test-20.wav
        ../test/test-21.wav \
    }

    foreach music_file $test_set {
        $::flutiou::ui::playzone::playlist insert {} end \
            -values [list $music_file] \
            -tags   [list "music_sample"]
    }
    set setodd 1
    set oddlist [list]
    foreach {i} [$::flutiou::ui::playzone::playlist children {}] {
        if {$setodd == 1} {
            set setodd 0
        } else {
            lappend oddlist $i
            set setodd 1
        }
    }
    $::flutiou::ui::playzone::playlist tag add "odd" $oddlist
}

