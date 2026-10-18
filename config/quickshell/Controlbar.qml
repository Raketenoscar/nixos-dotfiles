import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Window
import "config.js" as Config

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 55
    color: "transparent"

    // Tray
    readonly property var trayItems: SystemTray.items.values.filter(item => item.status !== Status.Passive)
    property var activeTrayItem: null
    property Item activeTrayAnchor: null
    property bool trayMenuOpen: false
    property var submenuStack: []
    readonly property int submenuDepth: submenuStack.length
    readonly property var currentChildren: submenuDepth > 0
        ? submenuStack[submenuDepth - 1].opener.children
        : trayMenuOpener.children
    property bool menuLevelSettling: false

    function trayIconSource(icon) {
        return String(icon || "")
    }

    function iconIsSymbolic(icon) {
        return String(icon || "").split("?")[0].slice(-9) === "-symbolic"
    }

    Timer {
        id: menuLevelSettleTimer
        interval: 250
        onTriggered: root.menuLevelSettling = false
    }

    function settleMenuLevel() {
        root.menuLevelSettling = true
        menuLevelSettleTimer.restart()
    }

    function resetTrayMenu() {
        root.menuLevelSettling = false
        menuLevelSettleTimer.stop()
        var openers = root.submenuStack
        root.submenuStack = []
        for (var i = openers.length - 1; i >= 0; i--) openers[i].opener.destroy()
    }

    function enterSubmenu(entry, title) {
        var opener = submenuOpenerComponent.createObject(root, { menu: entry })
        if (!opener) return
        root.submenuStack = root.submenuStack.concat([{ opener: opener, title: title }])
        settleMenuLevel()
    }

    function leaveSubmenu() {
        if (root.submenuStack.length === 0) return
        var stack = root.submenuStack.slice()
        var top = stack.pop()
        root.submenuStack = stack
        top.opener.destroy()
        settleMenuLevel()
    }

    function openTrayMenu(item, anchorItem) {
        if (!item || !item.menu) return
        var wasOpen = root.trayMenuOpen
        resetTrayMenu()
        menuFlick.contentY = 0
        root.activeTrayItem = item
        root.activeTrayAnchor = anchorItem
        root.trayMenuOpen = true
        if (wasOpen) trayMenuPopup.anchor.updateAnchor()
    }

    onTrayMenuOpenChanged: if (!trayMenuOpen) resetTrayMenu()

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 45
        radius: 10
        color: Config.colors.bg
        border {
            color: Config.colors.purple
            width: 2
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 12
        Repeater {
            model: 9
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                Layout.alignment: Qt.AlignVCenter
                text: index + 1
                color: isActive ? Config.colors.cyan : (ws ? Config.colors.blue : Config.colors.gray)
                font {
                    pixelSize: Config.bar.fontSize
                    bold: true
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
        // Clock
        Text { 
            id: clock
            color: Config.colors.blue
            font { pixelSize: Config.bar.fontSize; bold: true } 
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "HH:mm")
            Timer { 
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm") 
            } 
        }
        // Tray, packed left of the network icon
        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 10
            Repeater {
                model: root.trayItems
                TrayItem {}
            }
        }
        // Ethernet
        Item {
            id: ethWidget
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: ethIcon.implicitWidth
            implicitHeight: ethIcon.implicitHeight

            property bool isConnected: false
            property string iface: ""

            property string icon: isConnected ? "󰈀" : "󰈃"

            Text {
                id: ethIcon
                anchors.centerIn: parent
                text: ethWidget.icon
                color: ethWidget.isConnected ? Config.colors.cyan : Config.colors.gray
                font {
                    pixelSize: Config.bar.fontSize
                    bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: netLaunch.running = true
                }
            }

            Process {
                id: netLaunch
                command: ["foot", "-e", "nmtui"]
            }

            Process {
                id: ethPoll
                command: [
                    "bash", "-c",
                    "nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2==\"ethernet\" && $3==\"connected\" { print $1; exit }'"
                ]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        let iface = text.trim()
                        ethWidget.iface = iface
                        ethWidget.isConnected = iface.length > 0
                    }
                }
            }

            Timer {
                interval: 3000
                running: true
                repeat: true
                onTriggered: {
                    ethPoll.running = false
                    ethPoll.running = true
                }
            }
        }
        // Audio
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            text: "󰕾"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: audioLaunch.running = true
            }
        }

        Process {
            id: audioLaunch
            command: ["foot", "-e", "wiremix"]
        }
        // CPU
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            text: "󰍛"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: cpuLaunch.running = true
            }
        }

        Process {
            id: cpuLaunch
            command: ["foot", "-e", "btop"]
        }
        
        
    }

    QsMenuOpener {
        id: trayMenuOpener
        menu: root.activeTrayItem ? root.activeTrayItem.menu : null
    }

    Component {
        id: submenuOpenerComponent
        QsMenuOpener {}
    }

    HyprlandFocusGrab {
        active: root.trayMenuOpen
        windows: [trayMenuPopup, root]
        onCleared: root.trayMenuOpen = false
    }

    PopupWindow {
        id: trayMenuPopup
        anchor.item: root.activeTrayAnchor
        anchor.adjustment: PopupAdjustment.Slide
        visible: root.trayMenuOpen
        color: "transparent"
        implicitWidth: 250
        implicitHeight: menuHeader.visible ? menuHeader.height + menuFlickHeight + 16 : menuFlickHeight + 16

        readonly property int menuFlickHeight: Math.min(menuCol.implicitHeight, 340)

        onVisibleChanged: {
            if (!visible) root.trayMenuOpen = false
            else card.forceActiveFocus()
        }

        Rectangle {
            id: card
            anchors.fill: parent
            color: Config.colors.bg
            border.color: Config.colors.purple
            border.width: 2
            radius: 10
            focus: true

            Keys.onEscapePressed: root.trayMenuOpen = false

            Column {
                id: menuLayout
                anchors.fill: parent
                anchors.margins: 8
                spacing: 0

                Item {
                    id: menuHeader
                    width: menuLayout.width
                    height: root.submenuDepth > 0 ? 28 : 0
                    visible: root.submenuDepth > 0

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        width: 24
                        horizontalAlignment: Text.AlignHCenter
                        text: "‹"
                        color: Config.colors.fg
                        font {
                            family: Config.bar.fontFamily
                            pixelSize: 18
                            bold: true
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 26
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        text: root.submenuDepth > 0 ? root.submenuStack[root.submenuDepth - 1].title : ""
                        elide: Text.ElideRight
                        color: Config.colors.fg
                        font {
                            family: Config.bar.fontFamily
                            pixelSize: 15
                            bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.menuLevelSettling) return
                            menuFlick.contentY = 0
                            root.leaveSubmenu()
                        }
                    }
                }

                Rectangle {
                    visible: menuHeader.visible
                    width: menuLayout.width
                    height: 1
                    color: Config.colors.gray
                    opacity: 0.5
                }

                Flickable {
                    id: menuFlick
                    width: menuLayout.width
                    height: menuLayout.height - menuHeader.height - (menuHeader.visible ? 1 : 0)
                    contentWidth: width
                    contentHeight: menuCol.implicitHeight
                    clip: true
                    interactive: contentHeight > height
                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.VerticalFlick

                    Column {
                        id: menuCol
                        width: menuFlick.width
                        spacing: 0

                        Repeater {
                            model: root.currentChildren

                            delegate: Item {
                                id: menuRow
                                required property var modelData
                                required property int index

                                width: menuCol.width
                                readonly property bool atRoot: root.submenuDepth === 0
                                readonly property bool rootTitleEntry: atRoot && index === 0 && modelData.hasChildren
                                    && String(modelData.text || "").toLowerCase() === String(root.activeTrayItem ? root.activeTrayItem.title : "").toLowerCase()
                                readonly property bool leadingSeparator: atRoot && modelData.isSeparator && index <= 1
                                readonly property bool hidden: rootTitleEntry || leadingSeparator
                                readonly property string rowText: String(modelData.text || "")
                                visible: !hidden
                                implicitHeight: hidden ? 0 : (modelData.isSeparator ? 11 : 30)

                                Rectangle {
                                    visible: menuRow.modelData.isSeparator
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: 1
                                    color: Config.colors.gray
                                    opacity: 0.5
                                }

                                Rectangle {
                                    visible: !menuRow.modelData.isSeparator
                                    anchors.fill: parent
                                    radius: 6
                                    color: rowMouse.containsMouse && menuRow.modelData.enabled
                                        ? Config.colors.black
                                        : "transparent"
                                }

                                Text {
                                    visible: !menuRow.modelData.isSeparator && menuRow.modelData.buttonType !== QsMenuButtonType.None
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    width: 22
                                    horizontalAlignment: Text.AlignHCenter
                                    text: menuRow.modelData.checkState === Qt.Checked ? "" : ""
                                    color: Config.colors.fg
                                    font {
                                        family: Config.bar.fontFamily
                                        pixelSize: 13
                                    }
                                }

                                Image {
                                    id: menuIcon
                                    visible: !menuRow.modelData.isSeparator && String(menuRow.modelData.icon || "") !== ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 24
                                    width: 16
                                    height: 16
                                    fillMode: Image.PreserveAspectFit
                                    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                                    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                                    source: menuRow.modelData.icon
                                }

                                Text {
                                    visible: !menuRow.modelData.isSeparator
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: menuIcon.visible ? 46 : 28
                                    anchors.right: submenuArrow.left
                                    anchors.rightMargin: 8
                                    text: menuRow.rowText
                                    elide: Text.ElideRight
                                    opacity: menuRow.modelData.enabled ? 1.0 : 0.45
                                    color: Config.colors.fg
                                    font {
                                        family: Config.bar.fontFamily
                                        pixelSize: 15
                                    }
                                }

                                Text {
                                    id: submenuArrow
                                    visible: !menuRow.modelData.isSeparator && menuRow.modelData.hasChildren
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    text: "›"
                                    opacity: menuRow.modelData.enabled ? 1.0 : 0.45
                                    color: Config.colors.fg
                                    font {
                                        family: Config.bar.fontFamily
                                        pixelSize: 15
                                    }
                                }

                                MouseArea {
                                    id: rowMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    enabled: !menuRow.modelData.isSeparator && menuRow.modelData.enabled
                                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: {
                                        if (root.menuLevelSettling) return
                                        if (menuRow.modelData.hasChildren) {
                                            menuFlick.contentY = 0
                                            root.enterSubmenu(menuRow.modelData, menuRow.rowText)
                                        } else {
                                            menuRow.modelData.triggered()
                                            root.trayMenuOpen = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component TrayIcon: Item {
        id: trayIconRoot
        required property var icon
        readonly property bool symbolic: root.iconIsSymbolic(icon)

        Image {
            id: trayIconImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            sourceSize.width: Math.round(Math.min(width, height) * Screen.devicePixelRatio)
            sourceSize.height: Math.round(Math.min(width, height) * Screen.devicePixelRatio)
            source: root.trayIconSource(trayIconRoot.icon)
            visible: !trayIconRoot.symbolic
            layer.enabled: trayIconRoot.symbolic
        }

        MultiEffect {
            anchors.fill: trayIconImage
            source: trayIconImage
            visible: trayIconRoot.symbolic
            colorization: 1.0
            colorizationColor: Config.colors.fg
        }
    }

    component TrayItem: Item {
        id: trayItemRoot
        required property var modelData

        visible: modelData.status !== Status.Passive
        implicitWidth: visible ? 20 : 0
        implicitHeight: visible ? 20 : 0

        TrayIcon {
            anchors.centerIn: parent
            width: 20
            height: 20
            icon: trayItemRoot.modelData.icon
        }

        MouseArea {
            id: trayMouse
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onPressed: function(mouse) {
                if (mouse.button === Qt.RightButton) {
                    root.openTrayMenu(trayItemRoot.modelData, trayItemRoot)
                    mouse.accepted = true
                }
            }

            onClicked: function(mouse) {
                if (mouse.button === Qt.RightButton) {
                    mouse.accepted = true
                } else if (mouse.button === Qt.MiddleButton) {
                    trayItemRoot.modelData.secondaryActivate()
                } else if (trayItemRoot.modelData.onlyMenu) {
                    root.openTrayMenu(trayItemRoot.modelData, trayItemRoot)
                } else {
                    trayItemRoot.modelData.activate()
                }
            }

            onWheel: function(wheel) {
                trayItemRoot.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
