/*
 * QML Material - An application framework implementing Material Design.
 *
 * Copyright (C) 2014-2016 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import QtQuick 2.7
import QtQuick.Window 2.2
import DesktopControls 0.1 as Desktop
import QtGraphicalEffects 1.0

/*!
   \qmltype Icon
   \inqmlmodule Material

   \brief Displays an icon from the Material Design and FontAwesome icon collections.
*/
Item {
    id: icon

    property string iconColor
    property string backgroundColor: Desktop.Theme.primaryColor
    property color color: iconColor ? iconColor :
                                      Desktop.Theme.lightDark(icon.backgroundColor,
                                          Desktop.Theme.light.iconColor,
                                          Desktop.Theme.dark.iconColor)
    property real size: 26 * Desktop.Units.dp

    /*!
       The name of the icon to display.

       \sa source
    */
    property string name
    property string awesome

    /*!
       A URL pointing to an image to display as the icon. By default, this is
       a special URL representing the icon named by \l name from the Material Design
       icon collection or FontAwesome. The icon will be colorized using the specified \l color,
       unless you put ".color." in the filename, for example, "app-icon.color.svg".

       \sa name
      */
    property string source: name ? "icon://" + name :
                                   awesome ? "icon://awesome/" + awesome : ""

    implicitWidth: size
    implicitHeight: size

    Image {
        id: image

        anchors.fill: parent
        visible: icon.source.indexOf("icon://awesome/") !== 0
        mipmap: true
        smooth: true

        source: {
            if (icon.source.indexOf("icon://awesome/") == 0) {
                return ''
            } else if (icon.source.indexOf('icon://') === 0) {
                var name = icon.source.substring(7)

                if (name) {
                    if (Desktop.Theme.iconsRoot.indexOf('qrc') !== -1)
                        return Desktop.Theme.iconsRoot + '/' + name + '.svg'
                    else
                        return Desktop.Theme.iconsRoot + '/' + name.replace('/', '_') + '.svg'
                } else {
                    return ""
                }
            } else {
                return icon.source
            }
        }

        sourceSize {
            width: size * Screen.devicePixelRatio
            height: size * Screen.devicePixelRatio
        }
    }

    ColorOverlay {
        id: overlay

        anchors.fill: parent
        source: image
        color: Desktop.Theme.alpha(icon.color, 1)
        cached: true
        visible: image.source != ""
        opacity: icon.color.a
    }

    Desktop.AwesomeIcon {
        id: awesomeIcon

        anchors.centerIn: parent
        size: icon.size * 0.9
        visible: icon.source.indexOf("icon://awesome/") === 0
        color: icon.color

        name: {
            if (icon.source.indexOf("icon://awesome/") == 0) {
                return icon.source.substring(15)
            } else {
                return ''
            }
        }
    }
}
