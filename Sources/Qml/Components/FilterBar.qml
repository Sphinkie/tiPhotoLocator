import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

RowLayout {

    CheckBox {
        id: checkBox1
        text: qsTr("undated")
        ToolTip.text: qsTr("Select all photos without a date")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectUndated()
            else
                _photoModel.resetSelection()
        }
    }

    CheckBox {
        id: checkBox2
        text: qsTr("unlocalized")
        ToolTip.text: qsTr("Select all photos without location")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectUnlocalized()
            else
                _photoModel.resetSelection()
        }
    }

    CheckBox {
        id: checkBox3
        text: qsTr("all")
        ToolTip.text: qsTr("Select all photos")
        ToolTip.visible: hovered
        ToolTip.delay: 500
        checked: false
        onClicked: {
            if (checked)
                _photoModel.selectAll()
            else
                _photoModel.resetSelection()
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
