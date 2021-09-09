namespace eval ::w::extralabel {
    namespace export extralabel
    variable bg_color
    variable fg_color

    proc setfont {} {
        set default_font_conf [font configure TkDefaultFont]
        font create bold_font
        foreach {i j} $default_font_conf {
            font configure bold_font $i $j
        }
        font configure bold_font -weight bold
        set ::w::extralabel::initialized 1
    }

    proc setcolors {} {
        set current_style [ttk::style theme use]
        variable bg_color [ttk::style lookup $current_style -background {} white]
        variable fg_color [ttk::style lookup $current_style -foreground {} white]
    }

    setfont
    setcolors
}

proc ::w::extralabel::themechanged {w} {
    variable bg_color
    variable fg_color
    ::w::extralabel::setcolors
    $w configure -bg $bg_color
    $w configure -fg $fg_color

}

proc ::w::extralabel::extralabel {cmd args} {

    variable bg_color
    variable fg_color

    switch -- $cmd {

        #
        # new: Create a text widget. init must have bean called before
        #
        new {
            set w [lindex $args 0]

            text $w                       \
                -height     1             \
                -bd         0             \
                -cursor     {}            \
                -font       TkDefaultFont \
                -bg         $bg_color     \
                -fg         $fg_color     \
                -highlightthickness 0     \
                -takefocus  0             \
                -relief     flat

            bind $w <<ThemeChanged>> {::w::extralabel::themechanged %W}
            $w tag configure bold_tag -font bold_font
            $w configure -state disabled
            return $w
        }

        #
        # clear: clear the text widget.
        #
        clear {
            set w [lindex $args 0]
            $w delete 0.0 end
        }

        set {
            set w [lindex $args 0]
            set v [lindex $args 1]
            set chars [split $v "*"]
            puts $chars
            puts $chars

            $w configure -state normal
            $w delete 0.0 end

            set tag none_tag
            foreach {str} $chars {
                if {[string equal $tag none_tag]} {
                    $w insert end $str
                    set tag bold_tag
                } else {
                    $w insert end $str bold_tag
                    set tag none_tag
                }
            }
            $w configure -state disabled
        }

        #
        # Add strings to the text widget (normal or bold)
        #
        add {
            set w [lindex $args 0]
            set t [lindex $args 1]
            set v [lindex $args 2]
            $w configure -state normal
            switch -- $t {
                normal {
                    $w insert end $v
                }
                bold {
                    $w insert end $v bold_tag
                }
            }
            $w configure -state disabled
        }
    }
}

