package require Tcl   8.6
package require Ttk   8.6
package provide fluxtheme 1.0

namespace eval ::funky::theme {
    variable default_theme  "arctic"
    variable default_dir    ""
    variable user_dir       ""
    variable src_dir        ""

    variable COL
    variable IMG
}

proc ::funky::theme::generate_image {srcimage col1 col2 col3} {

    #
    # Generate image with custom colors, nicely drawned and with
    # correct antialiasing things.
    #
    # The srcimage is made of 3 colors, each define the intencity of
    # one color on a pixel.
    #
    # col1 = will be eppended in output pixel at "red"   intencity
    # col2 = will be eppended in output pixel at "green" intencity
    # col3 = will be eppended in output pixel at "blue"  intencity
    #
    # LIMITATION: allowing only 3 custom colors per images.
    #
    #
    # The srcimage contains also a alpha value that is "on" (visible)
    # or "off" (fully transparent). This is a tcltk 8.6 limitation.
    #
    # LIMITATION: for each background value of the widget, a new image
    # must be drawned.
    #

    set h [image height $srcimage]
    set w [image width  $srcimage]

    set outimage [image create photo -format png -height $h -width $w]
    $outimage blank

    scan $col1 "#%2x%2x%2x" col1_r col1_g col1_b
    scan $col2 "#%2x%2x%2x" col2_r col2_g col2_b
    scan $col3 "#%2x%2x%2x" col3_r col3_g col3_b

    set outdata [list]
    for {set y 0} {$y < $h} {incr y} {
        set rowdata  [list]

        for {set x 0} {$x < $w} {incr x} {

            set color_intensity [$srcimage get $x $y]
            set col1_i [lindex $color_intensity 0]
            set col2_i [lindex $color_intensity 1]
            set col3_i [lindex $color_intensity 2]

            #
            # Initialize final rgb
            #
            set r 0
            set g 0
            set b 0

            #
            # Set intencity for collor 1
            #
            set r [expr {$r + ($col1_i * $col1_r)}]
            set g [expr {$g + ($col1_i * $col1_g)}]
            set b [expr {$b + ($col1_i * $col1_b)}]

            #
            # Set intencity for collor 2
            #
            set r [expr {$r + ($col2_i * $col2_r)}]
            set g [expr {$g + ($col2_i * $col2_g)}]
            set b [expr {$b + ($col2_i * $col2_b)}]

            #
            # Set intencity for collor 3
            #
            set r [expr {$r + ($col3_i * $col3_r)}]
            set g [expr {$g + ($col3_i * $col3_g)}]
            set b [expr {$b + ($col3_i * $col3_b)}]

            #
            # Final values
            #
            set r [expr {$r / 256}]
            set g [expr {$g / 256}]
            set b [expr {$b / 256}]
            if {$r > 255} {
                set r 255
            }
            if {$g > 255} {
                set g 255
            }
            if {$b > 255} {
                set b 255
            }

            #
            # Add value to the row
            #
            set col [format "#%02x%02x%02x" $r $g $b]
            lappend rowdata $col
        }
        lappend outdata $rowdata
    }

    #
    # Set image data
    #
    $outimage put $outdata

    #
    # Second pass to set fully transparent pixels
    #
    for {set y 0} {$y < $h} {incr y} {
        for {set x 0} {$x < $w} {incr x} {
            if {[$srcimage transparency get $x $y]} {
                $outimage transparency set $x $y true
            }
        }
    }

    return $outimage
}

proc ::funky::theme::generate_theme_ressources {outputdir} {
    variable COL
    variable src_dir

    set butt [image create photo                        \
                    -file [file join $src_dir button.png]   \
                    -format png]
    set butt_squared [image create photo                        \
                    -file [file join $src_dir button-squared.png]   \
                    -format png]
    set butt_box_left [image create photo               \
                    -file [file join $src_dir button-box-left.png]   \
                    -format png]
    set butt_box_center [image create photo               \
                    -file [file join $src_dir button-box-center.png]   \
                    -format png]
    set butt_box_right [image create photo               \
                    -file [file join $src_dir button-box-right.png]   \
                    -format png]
    set butt_unicolor [image create photo               \
                    -file [file join $src_dir button-unicolor.png]   \
                    -format png]
    set tv_heading [image create photo               \
                    -file [file join $src_dir treeview-heading.png]   \
                    -format png]
    set slider_trough    [image create photo                            \
                    -file [file join $src_dir slider-trough.png]   \
                    -format png]
    set slider_horiz [image create photo                            \
                    -file [file join $src_dir slider-horiz.png]   \
                    -format png]
    set slider_vert [image create photo                            \
                    -file [file join $src_dir slider-vert.png]   \
                    -format png]
    set arrow_down [image create photo                            \
                    -file [file join $src_dir arrow-down.png]   \
                    -format png]


    # button
    set outimage [generate_image $butt $COL(buttonborder) $COL(bg) $COL(buttonbg)]
    $outimage write [file join $outputdir button.png]
    set outimage [generate_image $butt_box_left $COL(buttonborder) $COL(bg) $COL(buttonbg)]
    $outimage write [file join $outputdir button-box-left.png]
    set outimage [generate_image $butt_box_right $COL(buttonborder) $COL(bg) $COL(buttonbg)]
    $outimage write [file join $outputdir button-box-right.png]
    set outimage [generate_image $butt_box_center $COL(buttonborder) $COL(bg) $COL(buttonbg)]
    $outimage write [file join $outputdir button-box-center.png]


    # button-active
    set outimage [generate_image $butt $COL(buttonactiveborder) $COL(bg) $COL(buttonactiveborder)]
    $outimage write [file join $outputdir button-active.png]
    set outimage [generate_image $butt_box_left $COL(buttonactiveborder) $COL(bg) $COL(buttonactiveborder)]
    $outimage write [file join $outputdir button-box-left-active.png]
    set outimage [generate_image $butt_box_right $COL(buttonactiveborder) $COL(bg) $COL(buttonactiveborder)]
    $outimage write [file join $outputdir button-box-right-active.png]
    set outimage [generate_image $butt_box_center $COL(buttonactiveborder) $COL(bg) $COL(buttonactiveborder)]
    $outimage write [file join $outputdir button-box-center-active.png]



    # button-hover
    set outimage [generate_image $butt $COL(buttonhoverborder) $COL(bg) $COL(buttonhoverbg)]
    $outimage write [file join $outputdir button-hover.png]
    set outimage [generate_image $butt_box_left $COL(buttonhoverborder) $COL(bg) $COL(buttonhoverbg)]
    $outimage write [file join $outputdir button-box-left-hover.png]
    set outimage [generate_image $butt_box_right $COL(buttonhoverborder) $COL(bg) $COL(buttonhoverbg)]
    $outimage write [file join $outputdir button-box-right-hover.png]
    set outimage [generate_image $butt_box_center $COL(buttonhoverborder) $COL(bg) $COL(buttonhoverbg)]
    $outimage write [file join $outputdir button-box-center-hover.png]


    # button-insensitive
    set outimage [generate_image $butt $COL(buttoninsensitiveborder) $COL(bg) $COL(buttoninsensitivebg)]
    $outimage write [file join $outputdir button-insensitive.png]
    set outimage [generate_image $butt_box_left $COL(buttoninsensitiveborder) $COL(bg) $COL(buttoninsensitivebg)]
    $outimage write [file join $outputdir button-box-left-insensitive.png]
    set outimage [generate_image $butt_box_right $COL(buttoninsensitiveborder) $COL(bg) $COL(buttoninsensitivebg)]
    $outimage write [file join $outputdir button-box-right-insensitive.png]
    set outimage [generate_image $butt_box_center $COL(buttoninsensitiveborder) $COL(bg) $COL(buttoninsensitivebg)]
    $outimage write [file join $outputdir button-box-center-insensitive.png]


    #
    # src/toolbutton.png
    #
    # toobutton
    #
    set outimage [generate_image $butt_unicolor $COL(bg) $COL(bg) $COL(bg)]
    $outimage write [file join $outputdir toolbutton.png]

    set outimage [generate_image $butt_unicolor $COL(buttonactivebg) $COL(buttonactivebg) $COL(buttonactivebg)]
    $outimage write [file join $outputdir toolbutton-active.png]

    set outimage [generate_image $butt_unicolor $COL(buttoninsensitivebg) $COL(buttoninsensitivebg) $COL(buttoninsensitivebg)]
    $outimage write [file join $outputdir toolbutton-insensitive.png]

    #
    # src/button.png
    #
    # entry
    #
    set outimage [generate_image $butt $COL(buttonborder) $COL(bg) $COL(fieldbg)]
    $outimage write [file join $outputdir entry-border-bg-solid.png]
    set outimage [generate_image $butt $COL(buttonborder) $COL(bg) $COL(fieldbg)]
    $outimage write [file join $outputdir entry-border-active-bg-solid.png]
    set outimage [generate_image $butt $COL(buttonborder) $COL(bg) $COL(fieldbg)]
    $outimage write [file join $outputdir entry-border-disabled-bg-solid.png]

    #
    # src/button-squared.png
    #
    # Treeview
    #
    set outimage [generate_image $butt_squared $COL(treeviewfieldborder) $COL(bg) $COL(fieldbg)]
    $outimage write [file join $outputdir treeview-field.png]

    set outimage [generate_image $tv_heading $COL(treeviewfieldborder) $COL(bg) $COL(bg)]
    $outimage write [file join $outputdir treeview-heading.png]


    #
    # scrollbar
    #
    set outimage [generate_image $slider_trough $COL(slidertrough) \
                                    $COL(slidertrough) $COL(slidertrough)]
    $outimage write [file join $outputdir slider-trough.png]


    # normal
    set outimage [generate_image $slider_vert $COL(normalscrollbar) \
                                    $COL(slidertrough) $COL(normalscrollbar) ]
    $outimage write [file join $outputdir slider-vert-normal.png]
    set outimage [generate_image $slider_horiz $COL(normalscrollbar) \
                                    $COL(slidertrough) $COL(normalscrollbar) ]
    $outimage write [file join $outputdir slider-horiz-normal.png]


    # active
    set outimage [generate_image $slider_vert $COL(selectbg) \
                                    $COL(slidertrough) $COL(selectbg)]
    $outimage write [file join $outputdir slider-vert-active.png]
    set outimage [generate_image $slider_horiz $COL(selectbg) \
                                    $COL(slidertrough) $COL(selectbg)]
    $outimage write [file join $outputdir slider-horiz-active.png]


    # prelight
    set outimage [generate_image $slider_vert $COL(prelightscrollbar) \
                                    $COL(slidertrough) $COL(prelightscrollbar) ]
    $outimage write [file join $outputdir slider-vert-prelight.png]
    set outimage [generate_image $slider_horiz $COL(prelightscrollbar) \
                                    $COL(slidertrough) $COL(prelightscrollbar) ]
    $outimage write [file join $outputdir slider-horiz-prelight.png]


    # insens
    set outimage [generate_image $slider_vert $COL(insensscrollbar) \
                                    $COL(slidertrough) $COL(insensscrollbar) ]
    $outimage write [file join $outputdir slider-vert-insens.png]
    set outimage [generate_image $slider_horiz $COL(insensscrollbar) \
                                    $COL(slidertrough) $COL(insensscrollbar) ]
    $outimage write [file join $outputdir slider-horiz-insens.png]


    #
    # Menubutton
    #
    set outimage [generate_image $arrow_down $COL(focuscolor) \
                                    $COL(buttonbg) $COL(buttonbg) ]
    $outimage write [file join $outputdir arrow-down.png]


    return 0
}

proc ::funky::theme::create {themename} {
    ttk::style theme create $themename \
        -parent default \
        -settings [list ::funky::theme::init $themename]
}

proc ::funky::theme::init {themename} {
    variable default_theme
    variable default_dir
    variable user_dir
    variable src_dir

    #
    # Check if theme exists in default or user dir or use the default
    # theme
    #
    set themedef [file join $default_dir "${themename}.colorscheme"]
    if {[file exists $themedef] != 1} {
        set themedef [file join $user_dir "${themename}.colorscheme"]
        if {[file exists $themedef] != 1} {
            puts "No $themename theme found $themedef. Going to default arctic theme"
            set themename $default_theme
            set themedef [file join $user_dir "${default_theme}.colorscheme"]
            if {[file exists $themedef] != 1} {
                puts "what?"
                exit
            }
        }
    }

    #
    # Load the colorscheme in the "colors" dict
    #
    set fd [open $themedef r]
    set fdata [split [read $fd] "\n"]
    close $fd

    variable COL
    foreach line $fdata  {
        scan $line "%s %s" k v
        set COL($k) $v
    }

    #
    # Check if ressources dir is created and succesffuly initialized
    #
    set themeressources [file join $user_dir "${themename}.ressources"]
    if {[file exists [file join $themeressources generate.ok]] != 1} {
        puts "do not exists [file join $themeressources generate.ok]"
        file delete -force $themeressources
        file mkdir $themeressources

        # generate all the stuff then
        if {[generate_theme_ressources $themeressources] == 1} {
            set genfd [open [file join $themeressources generate.ok] w]
            puts $genfd "done!"
        }

    }


    #
    # load images
    #
    variable IMG
    foreach f [glob -directory $themeressources *.png] {
        set imgname [file tail [file rootname $f]]
        set IMG($imgname) [image create photo -file $f -format png]
    }

    #
    # configure global things
    #
    ttk::style configure . \
        -borderwidth        1                \
        -background         $COL(bg)         \
        -foreground         $COL(fg)         \
        -troughcolor        $COL(bg)         \
        -font               TkDefaultFont    \
        -selectborderwidth  1                \
        -selectbackground   $COL(selectbg)   \
        -selectforeground   $COL(selectfg)   \
        -fieldbackground    $COL(window)     \
        -insertwidth        1                \
        -indicatordiamter   10               \
        -focuscolor         $COL(focuscolor) \
        -focusthickness     0

    ttk::style map . -foreground [list disabled $COL(disabledfg)]

    configure_Button
    configure_Toolbutton
    configure_Entry
    configure_Treeview
    configure_Scrollbar
    configure_MenuButton

}

proc ::funky::theme::configure_MenuButton {} {
    variable IMG

    ttk::style layout TMenubutton {
        Menubutton.button -children {
            Menubutton.focus -children {
                Menubutton.padding -children {
                    Menubutton.indicator -side right
                    Menubutton.indicator2 -side right
                    Menubutton.label -side right -expand true
                }
            }
        }
    }
    ttk::style element create Menubutton.button \
        image [list             $IMG(button) \
                    pressed     $IMG(button-active) \
                    active      $IMG(button-hover) \
                    disabled    $IMG(button-insensitive) \
        ] -sticky news -border 3 -padding {3 2}

    ttk::style element create Menubutton.indicator2 \
        image [list             $IMG(arrow-down) \
                    active      $IMG(arrow-down) \
                    pressed     $IMG(arrow-down) \
                    disabled    $IMG(arrow-down) \
        ] -sticky ns -width 1



    ttk::style element create Menubutton.indicator \
        image [list             $IMG(arrow-down) \
                    active      $IMG(arrow-down) \
                    pressed     $IMG(arrow-down) \
                    disabled    $IMG(arrow-down) \
        ] -sticky e -width 20


    ttk::style configure TMenubutton -padding {8 4 4 4}
}

proc ::funky::theme::configure_Scrollbar {} {
    variable IMG
    variable COL


    ttk::style layout Vertical.TScrollbar {
        Vertical.Scrollbar.trough -sticky ns -children {
            Vertical.Scrollbar.thumb -expand true
        }
    }

    ttk::style layout Horizontal.TScrollbar {
        Horizontal.Scrollbar.trough -sticky ew -children {
            Horizontal.Scrollbar.thumb -expand true
        }
    }

    ttk::style element create Horizontal.Scrollbar.trough \
        image $IMG(slider-trough)

    ttk::style element create Horizontal.Scrollbar.thumb \
        image [list                     $IMG(slider-horiz-normal)     \
                    {pressed !disabled} $IMG(slider-horiz-active)     \
                    {active !disabled}  $IMG(slider-horiz-prelight)   \
                    disabled            $IMG(slider-horiz-insens)     \
    ] -border 6 -sticky ew

    ttk::style element create Vertical.Scrollbar.trough \
        image $IMG(slider-trough)

    ttk::style element create Vertical.Scrollbar.thumb  \
        image [list                     $IMG(slider-vert-normal)     \
                    {pressed !disabled} $IMG(slider-vert-active)     \
                    {active !disabled}  $IMG(slider-vert-prelight)   \
                    disabled            $IMG(slider-vert-insens)     \
        ] -border 6 -sticky ns
}

proc ::funky::theme::configure_Treeview {} {
    variable IMG
    variable COL

    ttk::style element create Treeview.field \
        image $IMG(treeview-field) -border 1 -padding 0
    ttk::style element create Treeheading.cell \
        image [list $IMG(treeview-heading) pressed $IMG(treeview-heading)]       \
           -border 2 -padding 5 -sticky ewns
    ttk::style configure Treeview -background $COL(window)
    ttk::style configure Treeview.Heading -padding {5 0 0 0}
    ttk::style configure Treeview.Item -padding {5 0 0 0}
    ttk::style map Treeview \
        -background [list selected $COL(selectbg)] \
        -foreground [list selected $COL(selectfg)]
}

proc ::funky::theme::configure_Entry {} {
    variable IMG
    variable COL


    ttk::style element create Entry.field                     \
        image [list      $IMG(entry-border-bg-solid)            \
                focus    $IMG(entry-border-active-bg-solid)     \
                disabled $IMG(entry-border-disabled-bg-solid)]  \
        -border 4 -padding {6 4} -sticky news
}

proc ::funky::theme::configure_Toolbutton {} {
    variable IMG
    variable COL

    # TODO custom image "squared"
    ttk::style element create Toolbutton.button     \
        image [list             $IMG(toolbutton)        \
            selected            $IMG(toolbutton)       \
            pressed             $IMG(toolbutton-insensitive)        \
            {active !disabled}  $IMG(toolbutton-insensitive)  \
    ] -border 3 -padding {2 2} -sticky news

    ttk::style layout Toolbutton {
        Toolbutton.button -children {
            Toolbutton.focus -children {
                Toolbutton.padding -children {
                    Toolbutton.label -side left -expand false
                }
            }
        }
    }

    ttk::style configure Toolbutton -anchor left
}


proc ::funky::theme::configure_Button {} {
    variable IMG
    variable COL

    #
    # Normal PadS and PadXS buttons
    #
    ttk::style element create Button.button \
        image [list     $IMG(button)       \
            pressed     $IMG(button-active)       \
            active      $IMG(button-hover)        \
            disabled    $IMG(button-insensitive)  \
    ] -border 3 -padding {2 2 2 2} -sticky ewns

    # Custom layout using element
    ttk::style layout TButton {
        Button.button -children {
            Button.focus -children {
                Button.padding -children {
                    Button.label -side left -expand true
                }
            }
        }
    }

    # Configure default style
    ttk::style configure TButton \
        -padding    {8 4 8 4} \
        -width      -10       \
        -anchor     center

    # Configure Pad small
    ttk::style configure PadS.TButton \
        -padding    {6 2 4 2} \
        -width      -8        \
        -anchor     center

    # Configure Pad extra small
    ttk::style configure PadXS.TButton \
        -padding    {2 0 2 0} \
        -width      -2        \
        -anchor     center

    #
    # ButtonGroup left/center/right
    #
    ttk::style element create Left.Group.Button.button  \
        image [list     $IMG(button-box-left)             \
            pressed     $IMG(button-box-left-active)      \
            active      $IMG(button-box-left-hover)       \
            disabled    $IMG(button-box-left-insensitive) \
    ] -border 3 -padding {2 2 2 2} -sticky ewns

    ttk::style element create Right.Group.Button.button  \
        image [list     $IMG(button-box-right)             \
            pressed     $IMG(button-box-right-active)      \
            active      $IMG(button-box-right-hover)       \
            disabled    $IMG(button-box-right-insensitive) \
    ] -border 3 -padding {1 2 2 2} -sticky ewns

    ttk::style element create Center.Group.Button.button \
        image [list     $IMG(button-box-center)             \
            pressed     $IMG(button-box-center-active)      \
            active      $IMG(button-box-center-hover)       \
            disabled    $IMG(button-box-center-insensitive) \
    ] -border 3 -padding {1 2 2 2} -sticky ewns

    ttk::style layout Left.Group.TButton {
        Left.Group.Button.button -children {
            Button.focus -children {
                Button.padding -children {
                    Button.label -side left -expand true
                }
            }
        }
    }

    ttk::style layout Right.Group.TButton {
        Right.Group.Button.button -children {
            Button.focus -children {
                Button.padding -children {
                    Button.label -side left -expand true
                }
            }
        }
    }

    ttk::style layout Center.Group.TButton {
        Center.Group.Button.button -children {
            Button.focus -children {
                Button.padding -children {
                    Button.label -side left -expand true
                }
            }
        }
    }

    ttk::style configure Group.TButton \
        -width      -10       \
        -anchor     center

    # normal
    ttk::style configure Right.Group.TButton \
        -padding    {8 4 8 4}
    ttk::style configure Left.Group.TButton \
        -padding    {8 4 8 4}
    ttk::style configure Center.Group.TButton \
        -padding    {8 4 8 4}

    # medium
    ttk::style configure PadS.Right.Group.TButton \
        -padding    {6 2 4 2}
    ttk::style configure PadS.Left.Group.TButton \
        -padding    {6 2 4 2}
    ttk::style configure PadS.Center.Group.TButton \
        -padding    {6 2 4 2}

    # small
    ttk::style configure PadXS.Right.Group.TButton \
        -padding    {2 0 2 0}
    ttk::style configure PadXS.Left.Group.TButton \
        -padding    {2 0 2 0}
    ttk::style configure PadXS.Center.Group.TButton \
        -padding    {2 0 2 0}

}

proc ::funky::theme::editor {} {
    wm title    . "Funky Editor"
    wm geometry . "1050x650+300+300"
    bind all <Escape> exit
    ::funky::theme::create

    #
    # Root with scrollbars
    #
    ttk::frame .root
    ttk::scrollbar .vscroll -orient vertical
    ttk::scrollbar .hscroll -orient horizontal
    grid .root      -row 0 -column 0 -sticky news
    grid .vscroll   -row 0 -column 1 -sticky ns
    grid .hscroll   -row 1 -column 0 -sticky ew
    grid columnconfigure . 0 -weight 1
    grid columnconfigure . 1 -weight 0
    grid rowconfigure . 0 -weight 1
    grid rowconfigure . 1 -weight 0

    #
    # Simple Buttons
    #
    ttk::frame .root.buttons -style Custom.TFrame
    grid .root.buttons -row 0 -column 0 -sticky news -pady 10 -padx 10

    ttk::button .root.buttons.xsmall_button -text "Small Button" -style Small.TButton
    ttk::button .root.buttons.small_button -text "Medium Button" -style Medium.TButton
    ttk::button .root.buttons.normal_button -text "Normal button"
    ttk::button .root.buttons.normal_toolbutton -text "Tools" \
        -style Toolbutton
    grid .root.buttons.xsmall_button -row 0 -column 0 -pady 5
    grid .root.buttons.small_button -row 1 -column 0 -pady 5
    grid .root.buttons.normal_button -row 2 -column 0 -pady 5
    grid .root.buttons.normal_toolbutton -row 3 -column 0 -pady 10 -sticky ew


    #
    # Button groups
    #
    ttk::labelframe .root.buttongroups -text "Buttons Groups"
    grid .root.buttongroups -row 0 -column 1 -sticky news -pady 10 -padx 10
    ttk::frame .root.buttongroups.small
    ttk::frame .root.buttongroups.medium
    ttk::frame .root.buttongroups.normal

    # smalls
    ttk::button .root.buttongroups.small.groupleft \
        -text "left" -style Small.Left.Group.TButton
    ttk::button .root.buttongroups.small.groupcenter \
        -text "center" -style Small.Center.Group.TButton
    ttk::button .root.buttongroups.small.groupright \
        -text "right" -style Small.Right.Group.TButton
    grid .root.buttongroups.small.groupleft -row 0 -column 1 -sticky ew
    grid .root.buttongroups.small.groupcenter -row 0 -column 2 -sticky ew
    grid .root.buttongroups.small.groupright -row 0 -column 3 -sticky ew

    grid .root.buttongroups.small  \
        -row 0 -column 0 -sticky news -pady 10 -padx 10

    # mediums
    ttk::button .root.buttongroups.medium.groupleft \
        -text "left" -style Medium.Left.Group.TButton
    ttk::button .root.buttongroups.medium.groupcenter \
        -text "center" -style Medium.Center.Group.TButton
    ttk::button .root.buttongroups.medium.groupright \
        -text "right" -style Medium.Right.Group.TButton
    grid .root.buttongroups.medium.groupleft -row 0 -column 1 -sticky ew
    grid .root.buttongroups.medium.groupcenter -row 0 -column 2 -sticky ew
    grid .root.buttongroups.medium.groupright -row 0 -column 3 -sticky ew
    grid .root.buttongroups.medium -row 1 -column 0 -sticky news -pady 10 -padx 10

    # normal
    ttk::button .root.buttongroups.normal.groupleft \
        -text "left" -style Left.Group.TButton
    ttk::button .root.buttongroups.normal.groupcenter \
        -text "center" -style Center.Group.TButton
    ttk::button .root.buttongroups.normal.groupright \
        -text "right" -style Right.Group.TButton
    grid .root.buttongroups.normal.groupleft -row 0 -column 1 -sticky ew
    grid .root.buttongroups.normal.groupcenter -row 0 -column 2 -sticky ew
    grid .root.buttongroups.normal.groupright -row 0 -column 3 -sticky ew
    grid .root.buttongroups.normal -row 2 -column 0 -sticky news -pady 10 -padx 10
    puts [ttk::style lookup theme -foreground]
}

if {$::argv0 == [info script]} {
    ::funky::theme::editor
}

namespace eval ::funky::theme::opts {
    variable all [list      \
        -background             \
        -foreground             \
        -darkcolor              \
        -padding                \
        -lightcolor             \
        -bordercolor            \
        -compound               \
        -relief                 \
        -font                   \
        -arrowsize              \
        -selectbackground       \
        -selectforeground       \
        -highlightcolor         \
        -fieldbackground        \
        -insertwidth            \
        -insertcolor            \
        -troughcolor            \
        -arrowcolor             \
        -selectborderwidth      \
        -gripcount              \
        -indicatorcolor         \
        -indicatorbackground    \
        -indicatormargin        \
        -indicatorrelief        \
        -troughrelief           \
        -sashpad                \
        -sashrelief             \
        -sashthickness          \
        -borderwidth            \
        -width                  \
        -postoffset             \
        -anchor                 \
        -handlepad              \
        -handlesize             \
        -expand                 \
        -groovewidth            \
        -labelmargin            \
        -sliderwidth            \
        -labeloutside           \
        -focusfill              \
        -highlightthickness     \
        -tabmargins             \
        -tabposition            \
        -shiftrelief            \
        -indicatorcolor         \
        -arrowcolor]
}

# REMAINDER ttk::style options by order of usages
#
# -background:
#   button, checkbutton, combobox, frame, label, TLabelframe.Label,
#   menubutton, notebook, TNotebook.Tab, pandewindow, V/Horizontal.Sash,
#   progressbar, radiobutton, scale, scrollbar, separator, sizegrip,
#   spinbox
#
# -foreground:
#   button, checkbutton, combobox, entry, label, TLabelframe.Label,
#   menubutton, notebook, TNotebook.Tab, radiobutton, scrollbar, spinbox
#
# -darkcolor:
#   button, combobox, entry, labelframe, notebook, progressbar,
#   scale, scrollbar, spinbox
#
# -padding:
#   button, checkbutton, combobox, entry, menubutton, notebook,
#   TNotebook.Tab, radiobutton, spinbox
#
# -lightcolor:
#   button, combobox, entry, labelframe, notebook,
#   V/Horizontal.Sash, progressbar, scale, spinbox
#
# -bordercolor:
#   button, combobox, entry, labelframe, notebook, TNotebook.Tab,
#   V/Horizontal.Sash, progressbar, scrollbar, spinbox
#
# -compound:
#   button, checkbutton, label, menubutton, TNotebook.Tab, radiobutton
#
# -relief:
#   button, entry, frame, labelframe, menubutton
#
# -font:
#   button, label, TLabelframe.Label, menubutton, TNotebook.Tab
#
# -arrowsize:
#   combobox, menubutton, scrollbar, spinbox
#
# -selectbackground:
#   combobox, entry, labelframe, spinbox
#
# -selectforeground:
#   combobox, entry, spinbox
#
# -highlightcolor:
#   button, combobox, scrollbar
#
# -fieldbackground:
#   combobox, entry, spinbox
#
# -insertwidth:
#   combobox, entry, spinbox
#
# -insertcolor:
#   combobox, entry, spinbox
#
# -troughcolor:
#   progressbar, scale, scrollbar
#
# -arrowcolor:
#   combobox, scrollbar, spinbox
#
# -selectborderwidth:
#   entry, labelframe
#
# -gripcount:
#   V/Horizontal.Sash, scrollbar
#
# -indicatorcolor:
#   checkbutton, radiobutton
#
# -indicatorbackground:
#   checkbutton, radiobutton
#
# -indicatormargin:
#   checkbutton, radiobutton
#
# -indicatorrelief:
#   checkbutton, radiobutton
#
# -troughrelief:
#   scale
#
# -sashpad:
#   V/Horizontal.Sash
#
# -sashrelief:
#   V/Horizontal.Sash
#
# -sashthickness:
#   V/Horizontal.Sash
#
# -borderwidth:
#   scale
#
# -width:
#   menubutton
#
# -postoffset:
#   combobox
#
# -anchor:
#   button
#
# -handlepad:
#   V/Horizontal.Sash
#
# -handlesize:
#   V/Horizontal.Sash
#
# -expand:
#   TNotebook.Tab
#
# -groovewidth:
#   scale
#
# -labelmargin:
#   labelframe
#
# -sliderwidth:
#   scale
#
# -labeloutside:
#   labelframe
#
# -focusfill:
#   combobox
#
# -highlightthickness:
#   button
#
# -tabmargins:
#   notebook
#
# -tabposition:
#   notebook
#
# -shiftrelief:
#   button
#
# -indicatorcolor:
#   checkbutton
#
# -arrowcolor:
#   combobox

