import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

RowLayout {

    CheckBox {
        id: checkBox1
        text: qsTr("undated")
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectUndated()
            else
                _photoModel.resetSelection()
        }
        ToolTip {
            visible: parent.hovered
            text: qsTr("Select all photos without a date")
            delay: 500
            y: -height - 4
        }
    }

    CheckBox {
        id: checkBox2
        text: qsTr("unlocalized")
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectUnlocalized()
            else
                _photoModel.resetSelection()
        }
        ToolTip {
            visible: parent.hovered
            text: qsTr("Select all photos without location")
            delay: 500
            y: -height - 4
        }
    }

    CheckBox {
        id: checkBox3
        text: qsTr("select all")
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectAll()
            else
                _photoModel.resetSelection()
        }
        ToolTip {
            visible: parent.hovered
            text: qsTr("Select all photos")
            delay: 500
            y: -height - 4
        }
    }

    RoundButton {
        flat: true
        display: AbstractButton.IconOnly
        icon.source: "qrc:/Images/bt-filter.png"
        checkable: true
        highlighted: checked
        onClicked: {
            _selectedPhotoProxyModel.filterEnabled = checked
        }
    }
}
