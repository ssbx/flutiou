namespace eval ::flutiou::ui::browse::files::procs {
    variable cache [dict create]
    variable currentdir "/"
}


namespace eval ::flutiou::ui::browse::files::procs {

    proc setbinds {} {
        variable ::flutiou::ui::browse::files::layout::table
        variable ::flutiou::ui::browse::files::layout::pop
        variable ::flutiou::ui::browse::files::layout::controls
        variable currentdir

        $controls.repvalue configure -text $currentdir
        $pop.f.add_to_playlist configure \
            -command {::flutiou::ui::browse::files::procs::insert_in_playlist end}
        bind $table <B3-ButtonRelease> \
            {::flutiou::ui::browse::files::procs::popup_menu %x %y %W}
    }

    proc update_dircache {dirlist} {
        variable cache

        set newpath     [dict get $dirlist dir]
        set path        [file split $newpath]
        set dirs        [lsort -dictionary [dict get $dirlist dirlist]]
        set files       [lsort -dictionary [dict get $dirlist filelist]]

        if {[dict exist $cache {*}$path] == 0} {
            set cache [dict set cache {*}$path [dict create]]
        }

        set cache [dict set cache {*}$path filled 1]
        set cache [dict set cache {*}$path files $files]
        set cache [dict set cache {*}$path dirs  $dirs]

        set_dir $newpath
    }

    proc user_set_dir {} {
        variable ::flutiou::ui::browse::files::layout::table
        set select [$table selection]
        if {[llength $select] != 1} {
            return
        }
        set item [lindex $select 0]
        set requestdir [lindex [$table item $item -value] 0]
        puts "$requestdir"
        set_dir $requestdir
    }

    proc insert_in_playlist {index} {
        variable ::flutiou::ui::browse::files::layout::pop
        variable ::flutiou::ui::browse::files::layout::table

        $pop.f.add_to_playlist configure -state disabled

        set selection [$table selection]
        set validsndfiles [list]
        foreach item $selection {
            set tags [$table item $item -tags]
            if {[lsearch -exact "sndfile" $tags] >= 0} {
                set filepath [lindex [$table item $item -values] 0]
                set filekey [string trimleft $filepath "./"]
                set validsndfile [lappend validsndfile $filekey]
            }
        }

        ::flutiou::insert $validsndfile $index
        extrapopup forget $pop
    }

    proc popup_menu {x y w} {
        variable ::flutiou::ui::browse::files::layout::table
        variable ::flutiou::ui::browse::files::layout::pop

        $pop.f.other           configure -state disabled
        $pop.f.add_to_playlist configure -state disabled

        set region      [$table identify region $x $y]
        set selection   [$table selection]
        if {$region == "tree"} {
            set item_under [$table identify item $x $y]
            if {[lsearch -exact $selection $item_under] == -1} {
                $table selection set [list $item_under]
                set selection [list $item_under]
            }
        }

        if {[llength $selection] > 0} {
            foreach i $selection {
                set tags [$table item $i -tags]
                if {[lsearch -exact "sndfile" $tags] >= 0} {
                    $pop.f.add_to_playlist configure -state normal
                    break
                }
            }
        }
        extrapopup show $pop $x $y $w
    }

    proc set_dir {dir} {
        variable ::flutiou::ui::browse::files::layout::table
        variable ::flutiou::ui::browse::files::layout::controls
        variable cache
        variable currentdir

        set path [file split $dir]
        if {[dict exist $cache {*}$path] == 0} {
            puts "dict does not exists need to update cache"
            ::flutiou::update_dirlist $dir
            return
        }
        if {[dict exist $cache {*}$path filled] == 0} {
            puts "dict exists but emptydoes not exists need to update cache"
            ::flutiou::update_dirlist $dir
            return
        }

        set items [$table children {}]
        if {[llength $items] > 0} {
            $table delete $items
        }

        set dirs  [dict get $cache {*}$path dirs]
        set files [dict get $cache {*}$path files]


        set topdir [lreplace $path end end]
        if {[llength $topdir] > 0} {
            $table insert {} end                        \
                -text ".."                              \
                -values [list [file join {*}$topdir]]   \
                -tags [list "directory"]
        }
        foreach d $dirs {
            $table insert {} end                    \
                -text " $d"                         \
                -values [list [file join $dir $d]]  \
                -tags [list "directory" "folderimg"]
        }
        foreach f $files {
            $table insert {} end                    \
                -text $f                            \
                -values [list [file join $dir $f]]  \
                -tags [list "sndfile"]
        }
        set fake [string trimleft $dir "."]
        if {[string length $fake] == 0} {
            set fake "/"
        }
        set currentdir $fake
        $controls.repvalue configure -text $currentdir

    }
}


