

namespace eval ::flutiou::collection::filters {
    variable all [list]
}

# this namespace for filters
namespace eval ::flutiou::filter {
}


proc ::flutiou::collection::filters::all_filters {} {
    variable all
    return $all
}

proc ::flutiou::collection::filters::setup {} {

    set default_filter_dir  [file join $::flutiou::libdir lib_filters]
    set default_filters [glob           \
        -tails                          \
        -directory $default_filter_dir  \
        *.tcl]


    set user_filter_dir [file join $::flutiou::userdir filters]
    if {[file exist $user_filter_dir] && [file isdirectory $user_filter_dir]} {
        set user_filters [glob           \
            -tails                          \
            -directory $user_filter_dir     \
            *.tcl]
        foreach filter $user_filters {
            set id [lsearch -exact $default_filters $filter]
            if {$def_filter_id != -1} {
                set default_filters [lreplace $default_filters $id $id]
            }
        }
    } else {
        set user_filters [list]
    }

    set filters_path [list]
    foreach f $user_filters {
        lappend filters_path [file join $user_filter_dir $f]
    }
    foreach f $default_filters {
        lappend filters_path [file join $default_filter_dir $f]
    }

    foreach f $filters_path {
        source $f
    }

    set allf [list {*}$default_filters {*}$user_filters]
    variable all
    foreach f $allf {
        lappend all [file rootname $f]
    }
}

proc ::flutiou::collection::filters::call {name args} {
    set command [lindex $args 0]
    switch -exact $command {
        cellanchor {
            if {[catch [list ::flutiou::fliter::${name}::cellanchor]]} {
                return "w"
            }
            return [list ::flutiou::fliter::${name}::cellanchor]
        }
        headinganchor   {
            if {[catch [list ::flutiou::fliter::${name}::headinganchor]]} {
                return "w"
            }
            return [list ::flutiou::fliter::${name}::headinganchor]
        }
        cellstretch {
            if {[catch [list ::flutiou::fliter::${name}::cellstretch]]} {
                return 1
            }
            return [list ::flutiou::fliter::${name}::cellstretch]
        }
        heading {
            if {[catch [list ::flutiou::fliter::${name}::heading]]} {
                return [string totitle $name]
            }
            return [list ::flutiou::fliter::${name}::heading]
        }
        value {
            set colentry [lindex $args 1]
            if {[catch [list ::flutiou::filter::${name}::value $colentry]]} {
                return "no data"
            }
            return [::flutiou::filter::${name}::value $colentry]
        }
    }
}

