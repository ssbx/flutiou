namespace eval ::flutiou::ui::browse::layout {
    variable canva
}

proc ::flutiou::ui::browse::layout::setup {w} {

    variable canva [canvas $w.canv -background red]
    pack $w.canv -fill both -expand 1

}

proc ::flutiou::ui::browse::layout::add {child} {
    variable canva
    $canva create window 0 0 -window $child
}
