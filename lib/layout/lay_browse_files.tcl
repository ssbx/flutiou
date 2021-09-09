namespace eval ::flutiou::ui::browse::files::layout {
    variable table
    variable pop
    variable controls
}

proc ::flutiou::ui::browse::files::layout::setup {w} {

    set rpad $::flutiou::ui::rpad
    set mpad $::flutiou::ui::mpad
    set pad_b $::flutiou::ui::pad_b

    ttk::frame $w.controls
    ttk::frame $w.view

    pack $w.controls -side top -fill x -pady $mpad -padx "5 0"
    pack $w.view -side bottom -fill both  -pady "0 $mpad" -padx "$pad_b 0" -expand 1

    ::flutiou::ui::browse::files::layout::setup_controls $w.controls
    ::flutiou::ui::browse::files::layout::setup_view     $w.view

}

proc ::flutiou::ui::browse::files::layout::setup_controls {w} {
    variable controls
    set rpad 5

    set controls [ttk::frame $w.controls]
    ttk::label $controls.replabel -text "[ mc Directory ]:"
    ttk::menubutton $controls.repvalue
    ttk::button $controls.home \
        -image $::flutiou::images(small-user-home) \
        -style PadS.Left.Group.TButton
    ttk::button $controls.up \
        -image $::flutiou::images(small-go-up) \
        -style PadS.Center.Group.TButton
    ttk::button $controls.refresh \
        -image $::flutiou::images(small-view-refresh) \
        -style PadS.Right.Group.TButton

    pack $controls.replabel -side left -padx $rpad
    pack $controls.repvalue -side left -expand 1 -fill x -padx "0 $rpad"
    pack $controls.home -side left
    pack $controls.up -side left
    pack $controls.refresh -side left
    pack $controls -side top -expand 1 -fill x -pady {0 0}

}

proc ::flutiou::ui::browse::files::layout::setup_view {w} {

    variable pop
    variable table
    ttk::treeview $w.table          \
        -show tree                  \
        -yscroll  "$w.scrolly set"
        #-xscroll  "$w.scrollx set"

    $w.table tag configure "folderimg" -image $::flutiou::images(small-folder)

    set pop [extrapopup new $w.table.ppo]
    ttk::frame $pop.f -relief groove
    pack $pop.f -fill both -expand 1

    ttk::button $pop.f.add_to_playlist  \
        -text [ mc "Add" ]              \
        -style Toolbutton               \
        -compound left                  \
        -image $::flutiou::images(small-folder)


    ttk::button $pop.f.other  \
        -text [ mc "otherlksqdjflksdfj" ]              \
        -style Toolbutton \
        -image $::flutiou::images(small-folder) \
        -compound left

    pack $pop.f.add_to_playlist -side top -fill x -expand 1 -anchor w
    pack $pop.f.other           -side top -fill x -expand 1 -anchor w

    bind $w.table <B3-ButtonRelease> \
        "::flutiou::ui::browse::files::procs::popup_menu %x %y %W"

    #ttk::scrollbar $w.scrollx -orient horizontal -command "$w.table xview"
    ttk::scrollbar $w.scrolly -orient vertical   -command "$w.table yview"

    grid $w.table   -row 0 -column 0 -sticky nsew
    #grid $w.scrollx -row 1 -column 0 -sticky nsew
    grid $w.scrolly -row 0 -column 1 -sticky nsew

    grid columnconfigure $w 0 -weight 1
    grid columnconfigure $w 1 -weight 0
    grid rowconfigure    $w 0 -weight 1
    grid rowconfigure    $w 1 -weight 0

    autoscrollbar $w.scrolly
    #autoscrollbar $w.scrollx

    set table $w.table
}
