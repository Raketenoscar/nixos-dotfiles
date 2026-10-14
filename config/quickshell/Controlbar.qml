import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "config.js" as Config

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 55
    color: "transparent"
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
}
