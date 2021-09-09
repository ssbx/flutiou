
namespace eval ::flutiou::ui::playzone::playing {
    variable canva
    variable lpadx 20
}

proc ::flutiou::ui::playzone::playing::setup {w} {
    variable canva

    canvas $w.canva             \
        -highlightthickness 0   \
        -borderwidth 0

    bind $w <Configure> {::flutiou::ui::playzone::playing::conf %w %h}

    set rect  "0 0 400 400"
    $w.canva create rectangle $rect \
        -fill #5294e2 \
        -tags [list "rect"] \
        -outline ""

    $w.canva create text 10 10  \
        -text "hello"           \
        -anchor w               \
        -tags [list "txt"]

    pack $w.canva -side top -fill both -expand 1 -padx 0 -pady 0
    set canva $w.canva

}

proc ::flutiou::ui::playzone::playing::conf {w h} {
    variable canva
    variable lpadx
    $canva coords "rect" 0 0 $w $h
    $canva coords "txt" $lpadx [expr {$h / 2}]

}
