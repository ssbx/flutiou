# w_extrapopup

namespace eval ::w::extrapopup {
    namespace export extrapopup
    variable ::w::extrapopup::window 0
    variable frames [list]

    bind all <Button-3> {
        if {$::w::extrapopup::window != 0} {
            set c "%W"
            set ischild 0
            while { $c != "." } {
                set c [winfo parent $c]
                if {$c == $::w::extrapopup::window} {
                    set ischild 1
                    break
                }
            }
            if {$ischild == 0} {
                place forget $::w::extrapopup::window
                set ::w::extrapopup::window 0
            }
        }
    }
    bind all <Button-1> {
        if {$::w::extrapopup::window != 0} {
            set c "%W"
            set ischild 0
            while { $c != "." } {
                set c [winfo parent $c]
                if {$c == $::w::extrapopup::window} {
                    set ischild 1
                    break
                }
            }
            if {$ischild == 0} {
                place forget $::w::extrapopup::window
                set ::w::extrapopup::window 0
            }
        }
    }
}

proc ::w::extrapopup::priv_extrapopup_show {W w x y } {
    place $w -x $x -y $y -i $W
    set ::w::extrapopup::window $w
}

proc ::w::extrapopup::extrapopup {cmd args} {
    variable frames
    switch -- $cmd {
        new {
            set w [lindex $args 0]
            set wpath [string cat ".extrapopup" [string map {"." "_"} $w]]

            lappend frames $wpath
            return [ttk::frame $wpath]
        }
        show {
            set w [lindex $args 0]
            set x [lindex $args 1]
            set y [lindex $args 2]
            set W [lindex $args 3]
            after 0 "::w::extrapopup::priv_extrapopup_show $W $w $x $y"
        }
        forget {
            set w [lindex $args 0]
            if {$::w::extrapopup::window == $w} {
                place forget $::w::extrapopup::window
                set ::w::extrapopup::window 0
            }
        }
    }
}

proc ::w::extrapopup::clear {} {
    variable frames
    foreach f $frames {
        place forget $f
        destroy $f
    }
    set frames {}

}
