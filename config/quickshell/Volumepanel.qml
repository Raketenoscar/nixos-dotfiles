import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import "config.js" as Config

Scope {
	id: root
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

		function onMutedChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	property bool shouldShowOsd: false
	property bool isMuted: Pipewire.defaultAudioSink?.audio.muted ?? false
	property real volume: Pipewire.defaultAudioSink?.audio.volume ?? 0

	function getVolumeIcon(): string {
		if (root.isMuted || root.volume === 0) return "󰖁";
		if (root.volume < 0.33) return "󰕿";
		if (root.volume < 0.66) return "󰖀";
		return "󰕾";
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 5
			exclusiveZone: 0

			implicitWidth: 300
			implicitHeight: 80
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				color: Config.colors.bg
				border.width: 2
				border.color: Config.colors.purple
				radius: 8

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					Text {
						text: root.getVolumeIcon()
						font.family: "JetBrainsMono Nerd Font"
						font.pointSize: 30
						color: root.isMuted ? Config.colors.gray : Config.colors.fg
					}

					Rectangle {
						Layout.fillWidth: true
						implicitHeight: 10
						radius: 20
						color: Config.colors.black

						Rectangle {
							color: root.isMuted ? Config.colors.gray : Config.colors.cyan
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}
							implicitWidth: parent.width * root.volume
							radius: parent.radius
						}
					}
				}
			}
		}
	}
}
