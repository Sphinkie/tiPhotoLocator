import QtQuick
import "../Vues"

TiTabButtonForm
{

    property string filter

    onClicked: _suggestionCategoryProxyModel.setFilterValue(filter);

}
