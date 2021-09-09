
namespace eval ::flutiou::ui::playzone::volume {
    variable canva
    variable canva_progress
    variable canva_progress_width
    variable canva_text
    variable scale
    variable value_true
    variable callback ""

}

proc ::flutiou::ui::playzone::volume::clear {} {
    font delete funcky_font
}

proc ::flutiou::ui::playzone::volume::setvalue {v} {

}

proc ::flutiou::ui::playzone::volume::scale_event {v} {
    set newx [expr int($v * $::flutiou::ui::playzone::volume::canva_progress_width)]
    set newpercent "[expr int($v * 100)]%"
    $::flutiou::ui::playzone::volume::canva itemconfigure \
        $::flutiou::ui::playzone::volume::canva_text -text $newpercent
    $::flutiou::ui::playzone::volume::canva moveto \
        $::flutiou::ui::playzone::volume::canva_progress $newx 0
    if { $::flutiou::ui::playzone::volume::callback != ""} {
        $::flutiou::ui::playzone::volume::user_callback $v
    }
}

proc ::flutiou::ui::playzone::volume::setup {w} {

    #
    # The canva
    #
    set bg [ttk::style lookup theme -background {} white]
    set fg [ttk::style lookup theme -foreground {} white]
    set width  120
    set height 30
    canvas $w.canva             \
        -width $width           \
        -height $height         \
        -background $bg         \
        -relief ridge           \
        -highlightthickness 0   \
        -borderwidth 0

    #
    # create a blue triangle
    #
    set triangle  "0 $height  $width 0  $width $height  0 $height"
    $w.canva create polygon $triangle -fill #5294e2

    #
    # And hide it with a bg color rectangle
    #
    set ::flutiou::ui::playzone::volume::canva_progress \
        [$w.canva create rectangle 0 0 $width $height -fill $bg -outline $bg]
    set ::flutiou::ui::playzone::volume::canva_progress_width $width



    set ::flutiou::ui::playzone::volume::canva $w.canva
    set ::flutiou::ui::playzone::volume::value_true  1.0

    #
    # Then create the percent text area. Create the font for the canva
    #
    set default_font_conf [font configure TkDefaultFont]
    font create funcky_font
    foreach {i j} $default_font_conf {
        font configure funcky_font $i $j
    }
    font configure funcky_font -size \
        [expr [font configure funcky_font -size] - 2]

    #
    # set it
    #
    set ::flutiou::ui::playzone::volume::canva_text  \
        [$w.canva create text 20 8 \
            -text "100%" -font funcky_font -fill $fg]

    #
    # The scale connected to the canva
    #
    set scale_width [expr $width + 6]
    ttk::scale $w.scale  \
        -orient horizontal      \
        -length $scale_width    \
        -command {::flutiou::ui::playzone::volume::scale_event}

    bind $w.scale <Button-4> { \
        event generate [focus -displayof %W] <MouseWheel> -delta  10}
    bind $w.scale <Button-5> { \
        event generate [focus -displayof %W] <MouseWheel> -delta -10}
    bind $w.scale <Enter> {focus %W}
    bind $w.scale <Leave> {focus .}
    bind $w.scale <MouseWheel> { \
        set increment [expr (%D/1)]; \
        if {$increment > 0} {event generate %W <Left>} \
        else {event generate %W <Right>} }


    #
    # pack everything
    #
    pack $w.scale -side bottom -fill x -expand 1
    pack $w.canva -side bottom -fill both -expand 1 -padx 6 -pady 5

}

