namespace eval ::flutiou::win::configure {
    variable w ".form_configure"
    variable closerequest ""
}

proc ::flutiou::win::configure::launch {} {

    #
    # Allmost opy paste from tk8.6/dialog.tcl
    #

    variable w
    destroy $w
    toplevel $w -class Dialog
    wm title $w "Flutiou [mc "configuration"]"
    wm iconname $w Dialog
    wm protocol $w WM_DELETE_WINDOW { }
    if {[winfo viewable [winfo toplevel [winfo parent $w]]] } {
        wm transient $w [winfo toplevel [winfo parent $w]]
    }

    ttk::label $w.hello -text "hello"
    ttk::button $w.close \
        -text "close" \
        -command {set ::flutiou::win::configure::closerequest "ok"}
    pack $w.hello -side top     -expand 1 -fill both
    pack $w.close -side bottom  -expand 0 -fill both

    #
    # Get position very center pixel of the root window so we
    # can place the dialog on the main window
    #
    set x_center [expr {[winfo x .] + ([winfo width .]  / 2)}]
    set y_top    [winfo y .]

    #
    # Elevate y of our modal dialog a bit, relative to the root height
    # and a little left near the menu buttons
    #
    set y_top [expr {$y_top + int([winfo height .] * 0.2  )}]

    #
    # Get the reqwidth of our modal dialog
    #
    set width   [winfo reqwidth $w]
    set height  [winfo reqheight $w]

    set x [expr {$x_center - ($width / 2)}]
    set y $y_top

    wm geometry $w ${width}x${height}+${x}+${y}

    tkwait visibility $w
    tk::SetFocusGrab $w $w

    vwait ::flutiou::win::configure::closerequest

    catch {
        bind $w <Destroy> {}
    }

    tk::RestoreFocusGrab $w $w

}
