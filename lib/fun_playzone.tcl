namespace eval ::flutiou::ui::playzone::procs {

    proc get_selection_index {} {
        variable ::flutiou::ui::playzone::playlist

        set select [$playlist selection]

        if {$select eq ""} {
            return 0
        } else {
            return [$playlist index [lindex $select 0]]
        }
    }

    proc insert {tracks position} {
        variable ::flutiou::ui::playzone::playlist
        set filters [::flutiou::collection::filters::all_filters]

        foreach track $tracks {

            if [dict exists $::flutiou::collection $track] {
                set collentry [dict get $::flutiou::collection $track]
                set itemdata [list]
                foreach f $filters {
                    lappend itemdata                             \
                        [::flutiou::collection::filters::call $f \
                            value $collentry]
                }
                $playlist insert {} end \
                    -values $itemdata   \
                    -tags   [list "music_sample"]
                }
        }

        set_playlist_color
    }

    proc set_playlist_color {} {
        variable ::flutiou::ui::playzone::playlist

        $playlist tag remove "odd"

        set setodd 1
        set oddlist [list]
        foreach item [$playlist children {}] {
            if {$setodd == 1} {
                set setodd 0
            } else {
                lappend oddlist $item
                set setodd 1
            }
        }
        $playlist tag add "odd" $oddlist
    }
}
