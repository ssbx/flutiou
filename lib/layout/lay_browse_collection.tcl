namespace eval ::flutiou::ui::browse::collection::layout {
}

proc ::flutiou::ui::browse::collection::layout::setup {w} {

    set pad_b $::flutiou::ui::pad_b
    set mpad  $::flutiou::ui::mpad

    $w configure -padding [list $pad_b $mpad 0 $mpad]

    #
    # From top to bottom
    #

    # ctrls
    ttk::frame $w.ctrl
    ttk::menubutton $w.ctrl.filter -image $::flutiou::images(configure) -style PadS.TButton
    ttk::button     $w.ctrl.but1 -image $::flutiou::images(configure) -style PadS.Left.Group.TButton
    ttk::button     $w.ctrl.but2 -image $::flutiou::images(list-add) -style PadS.Center.Group.TButton
    ttk::button     $w.ctrl.but3 -image $::flutiou::images(list-add) -style PadS.Right.Group.TButton
    ttk::button     $w.ctrl.but4 -image $::flutiou::images(list-add) -style PadS.Left.Group.TButton
    ttk::button     $w.ctrl.but5 -image $::flutiou::images(list-add) -style PadS.Right.Group.TButton

    pack $w.ctrl.filter -side left -fill none -padx {0 4}

    pack $w.ctrl.but1 -side left -fill y
    pack $w.ctrl.but2 -side left -fill y
    pack $w.ctrl.but3 -side left -fill y -padx {0 4}

    pack $w.ctrl.but4 -side left -fill y
    pack $w.ctrl.but5 -side left -fill y

    pack $w.ctrl -side top -fill x -expand 0 -pady {0 3}

    # search frame
    ttk::frame  $w.search
    ttk::button $w.search.clear -image $::flutiou::images(list-add) -style PadS.TButton
    ttk::entry  $w.search.entry
    ttk::button $w.search.advanced -text "..." -style PadS.TButton

    pack $w.search.clear -side left -fill none -expand 0 -padx {0 2}
    pack $w.search.entry -side left -fill x -expand 1
    pack $w.search.advanced -side left -fill none -expand 0 -padx {2 0}

    pack $w.search -side top -fill x -expand 0 -pady {0 3}

    # added filter
    ttk::menubutton $w.mb -text "Entire Collection"
    pack $w.mb -side top -fill x -expand 0 -padx 0 -pady "0 3"

    # the collection
    ttk::treeview   $w.tv
    pack $w.tv -side bottom -fill both -expand 1 -padx 0 -pady 0
}
