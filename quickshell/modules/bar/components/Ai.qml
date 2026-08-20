import QtQuick
import qs.components
import qs.config
import qs.services

StyledRect {
    id: root

    readonly property color colour: Colours.palette.m3primary

    implicitWidth: Config.bar.sizes.innerWidth
    implicitHeight: icon.implicitHeight + Appearance.padding.normal * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.full

    MaterialIcon {
        id: icon

        anchors.centerIn: parent

        animate: true
        text: Note.busy ? "sync" : "edit_note"
        fill: 0
        color: root.colour
        font.pointSize: Appearance.font.size.large + 1
        opacity: Note.busy ? 0.78 : 1

        SequentialAnimation on opacity {
            running: Note.busy
            loops: Animation.Infinite
            alwaysRunToEnd: true

            Anim {
                from: 0.78
                to: 0.38
                duration: Appearance.anim.durations.large
                easing.bezierCurve: Appearance.anim.curves.standardAccel
            }
            Anim {
                from: 0.38
                to: 0.78
                duration: Appearance.anim.durations.large
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }
    }
}
