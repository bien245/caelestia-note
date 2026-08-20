import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.config
import qs.services

ColumnLayout {
    id: root

    required property PopoutState popouts

    width: 470
    implicitWidth: width
    implicitHeight: 430
    spacing: Appearance.spacing.normal

    function saveNote(): void {
        const value = input.text.trim()
        if (value.length === 0 || Note.busy)
            return

        if (Note.createNote(value)) {
            input.text = ""
            input.forceActiveFocus()
        }
    }

    Connections {
        target: Note

        function onNoteCreated(title: string): void {
            statusText.text = qsTr("Saved to Obsidian: %1").arg(title)
            statusText.color = Colours.palette.m3primary
        }

        function onNoteFailed(error: string): void {
            statusText.text = error
            statusText.color = Colours.palette.m3error
        }
    }

    HoverHandler {
        id: hover
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.small

        MaterialIcon {
            text: "edit_note"
            font.pointSize: Appearance.font.size.large + 3
            color: Colours.palette.m3primary
        }

        StyledText {
            text: qsTr("Quick Note")
            font.pointSize: Appearance.font.size.large
            font.weight: 600
            color: Colours.palette.m3onSurface
            Layout.fillWidth: true
        }

        StyledText {
            text: qsTr("Obsidian")
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3outline
        }
    }

    StyledRect {
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: Appearance.rounding.large
        color: Colours.tPalette.m3surfaceContainer

        TextArea {
            id: input

            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            placeholderText: qsTr("Write a note...")
            placeholderTextColor: Colours.palette.m3outline
            color: Colours.palette.m3onSurface
            selectionColor: Colours.palette.m3primary
            selectedTextColor: Colours.palette.m3onPrimary
            wrapMode: TextEdit.Wrap
            font.pointSize: Appearance.font.size.normal
            background: Item {}

            Keys.onPressed: function(event) {
                if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                        && (event.modifiers & Qt.ControlModifier)) {
                    root.saveNote()
                    event.accepted = true
                }
            }

            Component.onCompleted: forceActiveFocus()
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.small

        StyledText {
            id: statusText

            text: Note.busy ? qsTr("Saving...") : qsTr("Ctrl + Enter to save")
            color: Colours.palette.m3outline
            font.pointSize: Appearance.font.size.small
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        StyledRect {
            implicitWidth: 100
            implicitHeight: 42
            radius: Appearance.rounding.full
            color: Note.busy
                ? Colours.tPalette.m3surfaceContainerHighest
                : Colours.palette.m3primaryContainer
            opacity: input.text.trim().length > 0 && !Note.busy ? 1 : 0.55

            Behavior on color {
                CAnim {}
            }

            MouseArea {
                anchors.fill: parent
                enabled: input.text.trim().length > 0 && !Note.busy
                cursorShape: Qt.PointingHandCursor
                onClicked: root.saveNote()
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: Appearance.spacing.small

                MaterialIcon {
                    text: Note.busy ? "progress_activity" : "send"
                    color: Colours.palette.m3onPrimaryContainer
                    font.pointSize: Appearance.font.size.normal
                }

                StyledText {
                    text: Note.busy ? qsTr("Saving") : qsTr("Send")
                    color: Colours.palette.m3onPrimaryContainer
                    font.weight: 600
                }
            }

            RotationAnimation on rotation {
                running: Note.busy
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 900
            }
        }
    }
}
