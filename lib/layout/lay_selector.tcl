namespace eval ::flutiou::ui::selector {
    variable buttons [list]
}

proc ::flutiou::ui::selector::setup {w} {
    ttk::frame $w.f -relief flat -width 30
    pack $w.f -side left -fill y -expand 0 -pady 3 -padx {3 0}

    # confbutton
    ttk::button $w.f.conf -image $::flutiou::images(list-add) -style PadXS.TButton

    # index 0
    funkybutton $w.f.browse_context      \
        $::flutiou::images(small-folder) \
        "[mc Context]" \
        ::flutiou::ui::selector::buttonclick

    # index 1
    funkybutton $w.f.browse_collection   \
        $::flutiou::images(small-folder) \
        "[mc Collection]"   \
        ::flutiou::ui::selector::buttonclick

    # index 3
    funkybutton $w.f.browse_playlists    \
        $::flutiou::images(small-folder) \
        "[mc Playlists]"    \
        ::flutiou::ui::selector::buttonclick

    # index 2
    funkybutton $w.f.browse_files        \
        $::flutiou::images(small-folder) \
        "[mc Files]"    \
        ::flutiou::ui::selector::buttonclick

    variable buttons [list \
        $w.f.browse_context \
        $w.f.browse_collection \
        $w.f.browse_playlist \
        $w.f.browse_files ]

    set pady 2
    grid propagate $w.f 0
    grid $w.f.conf              -row 0 -column 0 -pady "0 $pady" -sticky news
    grid $w.f.browse_context    -row 1 -column 0 -pady "0 $pady" -sticky ns
    grid $w.f.browse_collection -row 2 -column 0 -pady "0 $pady" -sticky ns
    grid $w.f.browse_playlists  -row 3 -column 0 -pady "0 $pady" -sticky ns
    grid $w.f.browse_files      -row 4 -column 0 -pady "0 0"     -sticky ns
    grid rowconfigure $w.f 1 -weight 1 -uniform a
    grid rowconfigure $w.f 2 -weight 1 -uniform a
    grid rowconfigure $w.f 3 -weight 1 -uniform a
    grid rowconfigure $w.f 4 -weight 1 -uniform a
    grid columnconfigure $w.f 0 -weight 1

}

proc ::flutiou::ui::selector::buttonclick {w state} {
    puts "$w was clicked with $state"
}
