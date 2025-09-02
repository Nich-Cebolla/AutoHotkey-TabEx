/*
    Github: https://github.com/Nich-Cebolla/AutoHotkey-TabEx
    Author: Nich-Cebolla
    Version: 1.0.0
    License: MIT
*/

; https://github.com/Nich-Cebolla/AutoHotkey-LibV2/blob/main/structs/Rect.ahk
#include <Rect>

#include TCITEMW.ahk

/**
 * The display area is the area within which the tab's controls are visible.
 *
 * The window area is the window's entire area, including tabs and margins.
 */
class TabEx extends Gui.Tab {
    static __New() {
        this.DeleteProp('__New')
        this.SetConstants()
        this.SetDpiAwarenessContext()
    }

    /**
     * Creates a new tab control and associated `TabEx` object.
     * @param {Gui} GuiObj - The Gui to which to add the tab control.
     * @param {String} Which - One of the following: "Tab", "Tab2", or "Tab3" (first parameter
     * of `Gui.Add`).
     * @param {String} [Opt] - The options to use when creating the tab control (second parameter
     * of `Gui.Add`).
     * @param {String[]} [Text] - The tab labels to create when instantiating the tab control
     * (third parameter of `Gui.Add`).
     */
    static Call(GuiObj, Which, Opt?, Text?) {
        tab := GuiObj.Add(Which, Opt ?? unset, Text ?? unset)
        ObjSetBase(tab, this.Prototype)
        return tab
    }

    /**
     * Converts an existing `Gui.Tab` object to a {@link TabEx} object.
     */
    static Convert(TabCtrl) {
        ObjSetBase(TabCtrl, this.Prototype)
    }

    static SetConstants() {
        global
        TCM_FIRST := 0x1300

        TCM_ADJUSTRECT := TCM_FIRST + 40
        TCM_DELETEALLITEMS := TCM_FIRST + 9
        ; TCM_DELETEITEM := TCM_FIRST + 8
        TCM_DESELECTALL := TCM_FIRST + 50
        TCM_GETCURFOCUS := TCM_FIRST + 47
        TCM_GETCURSEL := TCM_FIRST + 11
        TCM_GETEXTENDEDSTYLE := TCM_FIRST + 53
        TCM_GETIMAGELIST := TCM_FIRST + 2
        TCM_GETITEMW := TCM_FIRST + 60
        ; TCM_GETITEMA := TCM_FIRST + 5
        TCM_GETITEMCOUNT := TCM_FIRST + 4
        TCM_GETITEMRECT := TCM_FIRST + 10
        TCM_GETROWCOUNT := TCM_FIRST + 44
        ; TCM_GETTOOLTIPS := TCM_FIRST + 45
        TCM_HIGHLIGHTITEM := TCM_FIRST + 51
        TCM_HITTEST := TCM_FIRST + 13
        ; TCM_INSERTITEM := TCM_INSERTITEMW := TCM_FIRST + 62
        ; TCM_INSERTITEMA := TCM_FIRST + 7
        TCM_REMOVEIMAGE := TCM_FIRST + 42
        TCM_SETCURFOCUS := TCM_FIRST + 48
        TCM_SETCURSEL := TCM_FIRST + 12
        TCM_SETEXTENDEDSTYLE := TCM_FIRST + 52
        TCM_SETIMAGELIST := TCM_FIRST + 3
        TCM_SETITEMW := TCM_FIRST + 61
        ; TCM_SETITEMA := TCM_FIRST + 6
        ; TCM_SETITEMEXTRA := TCM_FIRST + 14
        TCM_SETITEMSIZE := TCM_FIRST + 41
        TCM_SETMINTABWIDTH := TCM_FIRST + 49
        TCM_SETPADDING := TCM_FIRST + 43
        ; TCM_SETTOOLTIPS := TCM_FIRST + 46

        ; TCHT_NOWHERE := 0x0001
        ; TCHT_ONITEMICON := 0x0002
        ; TCHT_ONITEMLABEL := 0x0004
        ; TCHT_ONITEM := TCHT_ONITEMICON | TCHT_ONITEMLABEL


        TCS_EX_FLATSEPARATORS    := 0x00000001
        TCS_EX_REGISTERDROP      := 0x00000002

        TCIF_TEXT                := 0x0001
        TCIF_IMAGE               := 0x0002
        TCIF_RTLREADING          := 0x0004
        TCIF_PARAM               := 0x0008
        TCIF_STATE               := 0x0010

        TCIS_BUTTONPRESSED       := 0x0001
        TCIS_HIGHLIGHTED         := 0x0002
    }

    /**
     * Sets the dpi awareness context value used when calling a method with the "_S" suffix.
     * See {@link TabEx.Prototype.__Call}.
     */
    static SetDpiAwarenessContext(Value := -4) {
        this.Prototype.DpiAwarenessContext := Value
    }

    /**
     * @description - Delets all tabs.
     */
    DeleteAll() {
        return SendMessage(TCM_DELETEALLITEMS, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @param {Boolean} [Scope=false] - Flag that specifies the scope of the item deselection. If this
     * parameter is set to FALSE, all tab items will be reset. If it is set to TRUE, then all tab
     * items except for the one currently selected will be reset.
     */
    DeselectAll(Scope := false) {
        SendMessage(TCM_DESELECTALL, Scope, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - The input is a display rectangle, and the output is the window rectangle
     * necessary for a tab control to have a display rectangle of the input dimensions.
     * @param {Rect} rc - The display rectangle.
     * @returns {Rect} - The window rectangle (same object with new values)
     */
    DisplayToWindow(rc) {
        SendMessage(TCM_ADJUSTRECT, true, rc, this.hWnd, this.Gui.hWnd)
        return rc
    }

    /**
     * @description - Returns the control's display rectangle relative to the parent window.
     * @returns {Rect}
     */
    GetClientDisplayRect() {
        rc := Rect()
        if !DllCall('GetWindowRect', 'ptr', this.hWnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        rc.ToClient(this.Gui.hWnd, true)
        SendMessage(TCM_ADJUSTRECT, false, rc, this.hWnd, this.Gui.hWnd)
        return rc
    }

    /**
     * @description - Returns the control's window rectangle relative to the parent window.
     * @returns {Rect}
     */
    GetClientWindowRect() {
        rc := Rect()
        if !DllCall('GetWindowRect', 'ptr', this.hWnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        rc.ToClient(this.Gui.hWnd, true)
        return rc
    }

    /**
     * @description - Returns the index of the item that has the focus in a tab control.
     * @returns {Integer}
     */
    GetCurFocus() {
        return SendMessage(TCM_GETCURFOCUS, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Determines the currently selected tab in a tab control.
     * @returns {Integer} - Returns the index of the selected tab if successful, or -1 if no tab is
     * selected.
     */
    GetCurSel() {
        return SendMessage(TCM_GETCURSEL, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Calculates the top-left corner of a tab control's display area relative to the
     * gui window.
     *
     * The display area is the area within which the tab's controls are visible.
     *
     * @param {VarRef} [OutTabDisplayRect] - A variable that will receive the `RECT` object representing
     * the tab's display area that is generated by the function.
     * @returns {POINT}
     */
    GetDisplayTopLeft(&OutTabDisplayRect?) {
        this.GetPos(&tabx, &taby, &tabw, &tabh)
        OutTabDisplayRect := Rect(tabx, taby, tabw + tabx, taby + tabh)
        SendMessage(TCM_ADJUSTRECT, false, OutTabDisplayRect, this.hWnd, this.Gui.hWnd)
        return POINT(tabx + OutTabDisplayRect.l, taby + OutTabDisplayRect.t)
    }

    /**
     * @description - Retrieves the extended styles that are currently in use for the tab control.
     * @returns {Integer} - Returns a DWORD value that represents the extended styles currently in
     * use for the tab control. This value is a combination of tab control extended styles.
     */
    GetExtendedStyle() {
        return SendMessage(TCM_GETEXTENDEDSTYLE, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Retrieves the image list associated with a tab control.
     * @returns {Integer} - Returns the handle to the image list if successful, or NULL otherwise.
     */
    GetImageList() {
        return SendMessage(TCM_GETIMAGELIST, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Retrieves the number of tabs in the tab control.
     * @returns {Integer} - Returns the number of items if successful, or zero otherwise.
     */
    GetItemCount() {
        return SendMessage(TCM_GETITEMCOUNT, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Retrieves the bounding rectangle for a tab in a tab control.
     * @returns {Rect}
     * @throws {OSError} - If the `SendMessage` call fails.
     */
    GetItemRect(Index) {
        rc := Rect()
        if !SendMessage(TCM_GETITEMRECT, Index, rc, this.hWnd, this.Gui.hWnd) {
            throw OSError('Failed to get item rect.', -1)
        }
        return rc
    }

    /**
     * @description - Retrieves the current number of rows of tabs in a tab control.
     * @returns {Integer} - The number of rows of tabs.
     */
    GetRowCount() {
        return SendMessage(TCM_GETROWCOUNT, 0, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Returns the control's display rectangle relative to the screen.
     * @returns {Rect}
     */
    GetScreenDisplayRect() {
        rc := Rect()
        if !DllCall('GetWindowRect', 'ptr', this.hWnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        SendMessage(TCM_ADJUSTRECT, false, rc, this.hWnd, this.Gui.hWnd)
        return rc
    }

    /**
     * @description - Returns the control's window rectangle relative to the screen.
     * @returns {Rect}
     */
    GetScreenWindowRect() {
        rc := Rect()
        if !DllCall('GetWindowRect', 'ptr', this.hWnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        return rc
    }

    /**
     * @param {Integer} Index - The index of the tab for which to get the text.
     * @param {Integer} MaxChars - The maximum characters to copy to the buffer. This can be an
     * overestimate.
     * @returns {String} - The tab's text, or an empty string if the operation failed.
     */
    GetTabText(Index, MaxChars) {
        tcitem := TCITEMW(TCIF_TEXT, , , , MaxChars)
        if SendMessage(TCM_GETITEMW, Index, tcitem.Ptr, this.hWnd, this.Gui.hWnd) {
            return tcitem.pszText
        } else {
            return ''
        }
    }

    /**
     * @param {Integer} Index - The index of the tab to highlight / remove higlighting.
     * @param {Boolean} [Value = true] - If true, activates the highlight state. If false, deactivates
     * the highlight state.
     * @returns {Integer} - 1 if successful, 0 if unsuccessful.
     */
    HighlightItem(Index, Value := true) {
        return SendMessage(TCM_HIGHLIGHTITEM, Index, (0 & 0xFFFF) << 16 | (Value & 0xFFFF), this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Determines if a tab is at the input coordinate.
     * @param {Integer} X - The x-coordinate.
     * @param {Integer} Y - The y-coordinate.
     * @returns {Integer} - One of the following values:
     * - 1: The position is not over a tab.
     * - 2: The position is over a tab's icon.
     * - 4: The position is over a tab's text.
     * - 6: The position is over a tab but not over its icon or its text. For owner-drawn tab
     * controls, this value is specified if the position is anywhere over a tab.
     */
    HitTest(X, Y) {
        HitTest := Buffer(12)
        NumPut('int', X, 'int', Y, HitTest, 0)
        SendMessage(TCM_HITTEST, 0, HitTest.ptr, this.hWnd, this.Gui.hWnd)
        return NumGet(HitTest, 8, 'uint')
    }

    /**
     * Returns the index position of the first tab with a label that is the same as the input `Text`.
     * The index position is 0-based.
     *
     * @param {String} Text - The text to compare with the tab labels.
     * @param {Integer} [StartIndex = 0] - The index at which to begin searching.
     * @param {Integer} [EndIndex] - The index at which to stop searching. If unset, all tabs beginning
     * from `StartIndex` are searched.
     * @param {Boolean} [CaseSensitive] - If true, the search is case sensitive.
     * @param {Integer} [MaxChars = 100] - The maximum characters to copy to the buffer.
     * @returns {Integer}
     */
    FindTab(Text, StartIndex := 0, EndIndex?, CaseSensitive := false, MaxChars := 100) {
        if !IsSet(EndIndex) {
            EndIndex := this.GetItemCount() - 1
        }
        tcitem := TCITEMW(TCIF_TEXT, , , , MaxChars)
        if CaseSensitive {
            loop EndIndex - StartIndex + 1 {
                SendMessage(TCM_GETITEMW, StartIndex, tcitem.Ptr, this.hWnd, this.Gui.hWnd)
                if Text == tcitem.pszText {
                    return StartIndex
                }
                StartIndex++
            }
        } else {
            loop EndIndex - StartIndex + 1 {
                SendMessage(TCM_GETITEMW, StartIndex, tcitem.Ptr, this.hWnd, this.Gui.hWnd)
                if Text = tcitem.pszText {
                    return StartIndex
                }
                StartIndex++
            }
        }
    }

    /**
     * Returns the index position of the first tab with a label that matches with the input `Pattern`.
     * The index position is 0-based.
     *
     * @param {String} Pattern - RegEx pattern.
     * @param {Integer} [StartIndex = 0] - The index at which to begin searching.
     * @param {Integer} [EndIndex] - The index at which to stop searching. If unset, all tabs beginning
     * from `StartIndex` are searched.
     * @param {Integer} [MaxChars = 100] - The maximum characters to copy to the buffer.
     * @param {VarRef} [OutMatch] - A variable that will receive the `RegExMatchInfo` object if a
     * match is found.
     * @returns {Integer}
     */
    FindTabRegEx(Pattern, StartIndex := 0, EndIndex?, MaxChars := 100, &OutMatch?) {
        if !IsSet(EndIndex) {
            EndIndex := this.GetItemCount() - 1
        }
        tcitem := TCITEMW(TCIF_TEXT, , , , MaxChars)
        loop EndIndex - StartIndex + 1 {
            SendMessage(TCM_GETITEMW, StartIndex, tcitem.Ptr, this.hWnd, this.Gui.hWnd)
            if RegExMatch(tcitem.pszText, Pattern, &OutMatch) {
                return StartIndex
            }
            StartIndex++
        }
    }

    /**
     * @description - Adjusts the size and position of the control to produce a display area with
     * the input dimensions. If a value is not provided, the current value is used.
     * @param {Integer} [X] - The x-coordinate.
     * @param {Integer} [Y] - The y-coordinate.
     * @param {Integer} [W] - The width.
     * @param {Integer} [H] - The height.
     * @returns {Rect} - The window rectangle.
     */
    MoveEx(X?, Y?, W?, H?) {
        rc := Rect()
        if !DllCall('GetWindowRect', 'ptr', this.hWnd, 'ptr', rc, 'int') {
            throw OSError()
        }
        rc.ToClient(this.Gui.hWnd, true)
        SendMessage(TCM_ADJUSTRECT, false, rc, this.hWnd, this.Gui.hWnd)
        rc := Rect(X ?? rc.X, Y ?? rc.Y, (W ?? rc.W) + (X ?? rc.X), (H ?? rc.H) + (Y ?? rc.Y))
        SendMessage(TCM_ADJUSTRECT, true, rc, this.hWnd, this.Gui.hWnd)
        this.Move(rc.X, rc.Y, rc.W, rc.H)
        return rc
    }

    /**
     * @description - Removes an image from a tab control's image list.
     * @param {Integer} Index - The index of the image to remove.
     */
    RemoveImage(Index) {
        SendMessage(TCM_REMOVEIMAGE, Index, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Sets the focus to a specified tab in a tab control.
     * @param {Integer} Index - The index of the tab to focus.
     */
    SetCurFocus(Index) {
        SendMessage(TCM_SETCURFOCUS, Index, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Selects a tab in a tab control.
     * @param {Integer} Index - The index of the tab to select.
     */
    SetCurSel(Index) {
        SendMessage(TCM_SETCURSEL, Index, 0, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @param {Integer} Style - One of the following:
     * - 1: TCS_EX_FLATSEPARATORS
     * - 2: TCS_EX_REGISTERDROP
     * @param {Integer} Value - Either 1 or 0 to enable or clear the style, respectively.
     */
    SetExtendedStyle(Style, Value) {
        return SendMessage(TCM_SETEXTENDEDSTYLE, Style, Value, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Assigns an image list to a tab control.
     * {@link https://learn.microsoft.com/en-us/windows/win32/controls/tcm-setimagelist}
     * @param {Integer} Index - The index of the image to remove.
     * @returns {Integer} - Returns the handle to the previous image list, or NULL if there is no
     * previous image list.
     */
    SetImageList(Handle) {
        SendMessage(TCM_SETIMAGELIST, 0, Handle, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - Sets the width and height of tabs in a fixed-width or owner-drawn tab control.
     * @param {Integer} Width - The width in pixels.
     * @param {Integer} Height - The height in pixels.
     * @param {VarRef} [OutOldWidth] - A variable that will receive the previous width in pixels
     * @param {VarRef} [OutOldHeight] - A variable that will receive the previous height in pixels
     */
    SetItemSize(Width, Height, &OutOldWidth?, &OutOldHeight?) {
        old := SendMessage(TCM_SETITEMSIZE, 0, (Height & 0xFFFF) << 16 | (Width & 0xFFFF), this.hWnd, this.Gui.hWnd)
        OutOldWidth := old & 0xFFFF
        OutOldHeight := (old >> 16)
    }

    /**
     * @description - Sets the minimum tab width.
     * @param {Integer} Width - The minimum tab width in pixels.
     * @returns {Integer} - The previous minimum tab width.
     */
    SetMinTabWidth(Width) {
        return SendMessage(TCM_SETMINTABWIDTH, 0, Width, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @param {Integer} Index - The index of the tab which will have its text changed.
     * @param {String} NewText - The new text.
     * @returns {Integer} - 1 if successful, 0 otherwise.
     */
    SetTabText(Index, NewText) {
        tcitem := TCITEMW(TCIF_TEXT, , , NewText)
        return SendMessage(TCM_SETITEMW, Index, tcitem.Ptr, this.hWnd, this.Gui.hWnd)
    }

    /**
     * @description - The input is a window rectangle, and the output is the display rectangle
     * area for a tab control with the input dimensions.
     * @param {Rect} rc - The window rectangle. If unset, the control's current dimensions
     * are used.
     * @returns {Rect} - The display rectangle (same object with new values)
     */
    WindowToDisplay(rc) {
        SendMessage(TCM_ADJUSTRECT, false, rc, this.hWnd, this.Gui.hWnd)
        return rc
    }

    /**
     * Enables the usage of the "_S" suffix.
     *
     * When calling a method, you can add "_S" or "_S<n>" (where <n> is an integer representing a
     * dpi awareness context constant 1, 2, 3 or 4) to set the dpi awareness context to that value
     * (multiplied by -1) prior to calling the method.
     */
    __Call(Name, Params) {
        Split := StrSplit(Name, '_')
        if Split.Length == 2 && this.HasMethod(Split[1]) && SubStr(Split[2], 1, 1) = 'S' {
            if StrLen(Split[2]) == 2 {
                DllCall('SetThreadDpiAwarenessContext', 'ptr', -SubStr(Split[2], 2, 1), 'ptr')
            } else {
                DllCall('SetThreadDpiAwarenessContext', 'ptr', this.DpiAwarenessContext, 'ptr')
            }
            if Params.Length {
                return this.%Split[1]%(Params*)
            } else {
                return this.%Split[1]%()
            }
        } else {
            throw PropertyError('Property not found.', -1, Name)
        }
    }
}
