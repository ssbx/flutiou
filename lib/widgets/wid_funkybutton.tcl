namespace eval ::w::funkybutton {
    namespace export funkybutton
    variable ns [namespace current]
    variable line_width         2
    variable anim_fps           90
    variable anim_duration_ms   400
    variable anim_update_after  [expr {int(double(1000) / double($anim_fps))}]
    variable anim_update_steps  [expr \
        {double($anim_duration_ms) / double($anim_update_after)}]

    # Top bottom left right relief and base button colors in
    # normal, normal & over, selected and selected & over states.
    # relief colors
    variable hcolorlight_normal #e0e0e0
    variable hcolordark_normal  #c0c0c0
    variable vcolordark_normal  #a0a0a0
    variable vcolorlight_normal #f0f0f0

    # button states colors
    variable buttoncolor_normal        #d0d0d0
    variable buttoncolor_normal_over   #e4e4e4
    variable buttoncolor_selected      #f8f8f8
    variable buttoncolor_selected_over #ffffff

    # layout
    variable img_pady [list 10 10]

    # init colors from the current theme
    proc setcolors {} {
        #variable hcolorlight_normal $::funky::theme::colors(-bg)
        #variable hcolordark_normal  $::funky::theme::colors(-bg)
        #variable vcolordark_normal  $::funky::theme::colors(-bg)
        #variable vcolorlight_normal $::funky::theme::colors(-bg)

        #variable buttoncolor_normal        $::funky::theme::colors(-bg)
        #variable buttoncolor_normal_over   $::funky::theme::colors(-selectbg)
        #variable buttoncolor_selected      $::funky::theme::colors(-window)
        #variable buttoncolor_selected_over $::funky::theme::colors(-checklight)

    }

    setcolors
}

proc ::w::funkybutton::funkybutton {w img txt callback} {
    variable buttoncolor_normal
    variable hcolorlight_normal
    variable hcolordark_normal
    variable vcolorlight_normal
    variable vcolordark_normal
    variable line_width

    variable ns


    canvas $w \
        -highlightthickness 0 -borderwidth 0

    bind $w <Configure> {::w::funkybutton::conf  %W %w %h}
    bind $w <<ThemeChanged>> {::w::funkybutton::themechanged %W}
    bind $w <Enter>     {::w::funkybutton::enter %W}
    bind $w <Leave>     {::w::funkybutton::leave %W}
    bind $w <Button-1>  {::w::funkybutton::click %W}

    set arrowbias [expr {$line_width / 2}]

    $w create rectangle 0 0 900 400 \
        -tags [list "button"]       \
        -fill $buttoncolor_normal   \
        -outline ""

    $w create line 0 0 900 0        \
        -tags [list "topborder"]    \
        -fill $vcolorlight_normal   \
        -width $line_width          \
        -arrow both                 \
        -arrowshape [list 0 $arrowbias 0]

    $w create line 0 400 900 400    \
        -tags [list "bottomborder"] \
        -fill $vcolordark_normal    \
        -width $line_width          \
        -arrow both                 \
        -arrowshape [list 0 $arrowbias 0]

    $w create line 0 0 0 400        \
        -tags [list "leftborder"]   \
        -fill $hcolorlight_normal   \
        -width $line_width          \
        -arrow both                 \
        -arrowshape [list 0 $arrowbias 0]

    $w create line 900 0 900 400    \
        -tags [list "rightborder"]  \
        -fill $hcolordark_normal    \
        -width $line_width          \
        -arrow both                 \
        -arrowshape [list 0 $arrowbias 0]

    $w create text  100  50     \
        -text $txt              \
        -anchor center          \
        -angle 90               \
        -tags [list "content" "txt"]

    $w create image 100 110     \
        -image $img             \
        -anchor center          \
        -tags [list "content" "img"]

    set txt_bb [$w bbox "txt"]
    set txt_x1 [lindex $txt_bb 0]
    set txt_x2 [lindex $txt_bb 2]
    set txt_y1 [lindex $txt_bb 1]
    set txt_y2 [lindex $txt_bb 3]
    set ${ns}::${w}_txt_width [expr {$txt_x2 - $txt_x1}]
    set ${ns}::${w}_txt_height [expr {$txt_y2 - $txt_y1}]

    set img_bb [$w bbox "img"]
    set img_x1 [lindex $img_bb 0]
    set img_x2 [lindex $img_bb 2]
    set ${ns}::${w}_img_width [expr {$img_x2 - $img_x1}]
    set img_y1 [lindex $img_bb 1]
    set img_y2 [lindex $img_bb 3]
    set ${ns}::${w}_img_height [expr {$img_y2 - $img_y1}]

    set ${ns}::${w}_over  0
    set ${ns}::${w}_state normal
    set ${ns}::${w}_button_current_color $buttoncolor_normal
    set ${ns}::${w}_button_target_color  $buttoncolor_normal
    set ${ns}::${w}_callback $callback

    return $w
}

proc ::w::funkybutton::gonormal {w state} {
}

proc ::w::funkybutton::click {w} {

    variable ns
    variable buttoncolor_normal
    variable buttoncolor_normal_over
    variable buttoncolor_selected
    variable buttoncolor_selected_over
    variable hcolorlight_normal
    variable hcolordark_normal
    variable vcolorlight_normal
    variable vcolordark_normal


    set cb [set ${ns}::${w}_callback]

    set state [set ${ns}::${w}_state]
    if {$state == "normal"} {
        #
        # From normal, go to selected
        #
        set ${ns}::${w}_state selected
        $cb $w selected


        # invert line colors
        $w itemconfigure "topborder"    -fill $vcolordark_normal
        $w itemconfigure "bottomborder" -fill $vcolorlight_normal
        $w itemconfigure "leftborder"   -fill $hcolordark_normal
        $w itemconfigure "rightborder"  -fill $hcolorlight_normal

        # start animation to the new button color
        if {[set ${ns}::${w}_over] == 1} {
            ::w::funkybutton::start_color_anim $w $buttoncolor_selected_over
        } else {
            ::w::funkybutton::start_color_anim $w $buttoncolor_selected
        }

    } elseif {$state == "selected"} {
        #
        # from selected go to intermed
        #
        set ${ns}::${w}_state intermed
        $cb $w intermed

        # invert line colors
        $w itemconfigure "topborder"    -fill $vcolorlight_normal
        $w itemconfigure "bottomborder" -fill $vcolordark_normal
        $w itemconfigure "leftborder"   -fill $hcolorlight_normal
        $w itemconfigure "rightborder"  -fill $hcolordark_normal

        # start animation to the new button color
        if {[set ${ns}::${w}_over] == 1} {
            ::w::funkybutton::start_color_anim $w $buttoncolor_normal_over
        } else {
            ::w::funkybutton::start_color_anim $w $buttoncolor_normal
        }
    } else {
        #
        # From intermed go to selected
        #
        set ${ns}::${w}_state intermed
        $cb $w intermed
    }
}

proc ::w::funkybutton::start_color_anim {w target} {
    variable ns
    variable anim_duration_ms
    variable anim_fps
    variable anim_update_steps

    #
    # First if target color is the same as the one in target_color data
    # it is allready handled
    #
    if {[set ${ns}::${w}_button_target_color] == $target} {
        return
    }

    #
    # Next set target color. Other anim will stop if it is not the same
    #
    set ${ns}::${w}_button_target_color $target

    #
    # Now extract r g b from colors:
    # - current real (if in middle of anim)
    # - target color for animation
    #
    set current [set ${ns}::${w}_button_current_color]

    scan $current "#%2x%2x%2x" current_r current_g current_b
    scan $target  "#%2x%2x%2x" target_r target_g target_b

    #
    # Set the increment value added to each r g and b so the target
    # color is reached in "update_steps" count
    #
    set R_step [expr {double($target_r - $current_r) / double($anim_update_steps)}]
    set G_step [expr {double($target_g - $current_g) / double($anim_update_steps)}]
    set B_step [expr {double($target_b - $current_b) / double($anim_update_steps)}]


    set R_current [expr {double($current_r)}]
    set G_current [expr {double($current_g)}]
    set B_current [expr {double($current_b)}]
    set R_target  [expr {double($target_r)}]
    set G_target  [expr {double($target_g)}]
    set B_target  [expr {double($target_b)}]

    after 0 ::w::funkybutton::animate    \
        $w $target                       \
        $R_current $G_current $B_current \
        $R_step    $G_step    $B_step    \
        $R_target  $G_target  $B_target

}

proc ::w::funkybutton::animate {         \
        w target                         \
        R_current  G_current B_current   \
        R_step     G_step    B_step      \
        R_target   G_target  B_target} {
    variable anim_update_after
    variable ns

    #
    # If target is diffrent another animate has started so cancel
    #
    if {[set ${ns}::${w}_button_target_color] !=  $target} {
        return
    }

    #
    # create new color.
    #
    set R_current_new [expr {double($R_current + $R_step)}]
    set G_current_new [expr {double($G_current + $G_step)}]
    set B_current_new [expr {double($B_current + $B_step)}]

    #
    # Check if some colors are out off bounds
    #
    set R_diff [expr {abs(double($R_current) - double($R_target))}]
    set G_diff [expr {abs(double($G_current) - double($G_target))}]
    set B_diff [expr {abs(double($B_current) - double($B_target))}]
    set R_diff_new [expr {abs(double($R_current_new) - double($R_target))}]
    set G_diff_new [expr {abs(double($G_current_new) - double($G_target))}]
    set B_diff_new [expr {abs(double($B_current_new) - double($B_target))}]
    if {$R_diff_new > $R_diff || $G_diff_new > $G_diff || $B_diff_new > $B_diff} {
        # Out of bound, we last call
        set newcolor $target
    } else {
        set newcolor [                       \
            format #%02x%02x%02x             \
                [expr {int($R_current_new)}] \
                [expr {int($G_current_new)}] \
                [expr {int($B_current_new)}] \
        ]
    }

    #
    # Set the color
    #
    $w itemconfigure "button" -fill $newcolor
    set ${ns}::${w}_button_current_color $newcolor

    #
    # Continue until target is reached
    #
    if {$newcolor != $target} {
        after $anim_update_after ::w::funkybutton::animate               \
                            $w $target                                   \
                            $R_current_new $G_current_new $B_current_new \
                            $R_step        $G_step        $B_step        \
                            $R_target      $G_target      $B_target
    }

}


proc ::w::funkybutton::enter {w} {
    variable ns
    variable buttoncolor_normal_over
    variable buttoncolor_selected_over

    if {[set ${ns}::${w}_state] == "normal"} {
        ::w::funkybutton::start_color_anim $w $buttoncolor_normal_over
    } else {
        ::w::funkybutton::start_color_anim $w $buttoncolor_selected_over
    }
    set ${ns}::${w}_over 1

}

proc ::w::funkybutton::leave {w} {
    variable ns
    variable buttoncolor_normal
    variable buttoncolor_selected

    if {[set ${ns}::${w}_state] == "normal"} {
        ::w::funkybutton::start_color_anim $w $buttoncolor_normal
    } else {
        ::w::funkybutton::start_color_anim $w $buttoncolor_selected
    }
    set ${ns}::${w}_over 0
}

proc ::w::funkybutton::themechanged {w} {
    ::w::funkybutton::setcolors
}

proc ::w::funkybutton::conf {win w h} {

    variable ns
    variable img_pady

    # border relief
    $win coords "button"        0  0  $w $h
    $win coords "topborder"     0  0  $w 0
    $win coords "bottomborder"  0  $h $w $h
    $win coords "leftborder"    0  0  0  $h
    $win coords "rightborder"   $w 0  $w $h


    # txt and images
    set xcenter [expr {$w / 2}]
    set ih [set ${ns}::${win}_img_height]
    set th [set ${ns}::${win}_txt_height]
    set pad_bottom  [lindex $img_pady 0]
    set pad_top     [lindex $img_pady 1]

    set yimage [expr {$h - $pad_bottom - ($ih / 2)}]
    $win coords "img" $xcenter $yimage

    set ytext [expr {$yimage - $pad_top - ($th / 2)}]
    $win coords txt $xcenter $ytext

}

if {$::argv0 eq [info script]} {
    bind all <Escape> exit
    ttk::frame .root
    pack .root -fill both -expand 1
    ttk::label .root.head -text "hello canva"
    set img [image create photo -file "lib_icons/xicon-small-audio-file.png" -format png]
    set txt "Hello"
    ::w::funkybutton::funkybutton .root.canv $img $txt

    pack .root.head -side top -fill x -expand 0
    pack .root.canv -side top -fill both -expand 1

    set c .root.canv
}
