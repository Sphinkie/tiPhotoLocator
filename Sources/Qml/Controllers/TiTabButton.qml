import QtQuick
import "../Vues"

// warning obsolete
TiTabButtonForm {

    property string filter

    onClicked: _suggestionCategoryProxyModel.setFilterValue(filter)
}
