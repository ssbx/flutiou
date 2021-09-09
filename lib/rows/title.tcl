namespace eval ::flutiou::filter::title {

    proc heading {} {
        return [::msgcat::mc Title]
    }

    proc value {track} {

        if {[dict exists $track TITLE]} {
            return [string trim [join  [dict get $track TITLE] " "] " \t"]
        } else {
            return ""
        }
    }

    proc sort {track1 track2} {
        return [string compare [str $track1] [str $track2]]
    }

}
