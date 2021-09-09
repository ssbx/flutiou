namespace eval ::flutiou::filter::album {

    proc heading {} {
        return [::msgcat::mc Album]
    }

    proc value {track} {

        if {[dict exists $track ALBUM]} {
            return [string trim [join {*}[dict get $track ALBUM]] " \t"]
        } else {
            return ""
        }
    }

    proc sort {track1 track2} {
        return [string compare [str $track1] [str $track2]]
    }
}
