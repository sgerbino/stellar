/***************************************************************************
* Copyright (c) 2016 Steve Gerbino <steve@gerbino.co>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/


import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

Rectangle {
    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            //errorMessage.color = "steelblue"
            //errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            //errorMessage.color = "red"
            //errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
	
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        visible: primaryScreen
	
	Rectangle {
	    anchors.right: parent.right
	    anchors.top: parent.top
	    anchors.topMargin: 5
	    z: 100
	    width: 350

            opacity: 0.7
	    gradient: Gradient {
                GradientStop { position: 0.0; color: "#1c1c1c" }
                GradientStop { position: 1.0; color: "#000000" }
            }

            border.color: "transparent"
            border.width: 0

	    Row {
                spacing: 4

                ComboBox {
                    id: session
                    font.pixelSize: 14

                    //arrowIcon: "angle-down.png"

                    model: sessionModel
                    index: sessionModel.lastIndex
		    
                    KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                }

		LayoutBox {
                    id: layoutBox
                    font.pixelSize: 14

                    //arrowIcon: "angle-down.png"

                    KeyNavigation.backtab: session; KeyNavigation.tab: layoutBox
                }
                
                Button {
                    id: shutdownButton
                    text: textConstants.shutdown
		    
                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: rebootButton
                }

                Button {
                    id: rebootButton
                    text: textConstants.reboot

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                }
            }
	}

        Rectangle {
            anchors.centerIn: parent
	    width: Math.max(320, mainColumn.implicitWidth + 100)
	    height: mainColumn.implicitHeight + 50
	    opacity: 0.7
	    gradient: Gradient {
                GradientStop { position: 0.0; color: "#1c1c1c" }
                GradientStop { position: 1.0; color: "#000000" }
            }
	    radius: 10

            border.color: "transparent"
            border.width: 0

            ColumnLayout {
                id: mainColumn
		anchors.fill: parent
		anchors.margins: parent.width/20

                TextBox {
                    id: name
		    height: 30
		    Layout.fillWidth: true
                    text: userModel.lastUser
                    font.pixelSize: 14
		    font.bold: true
		    textColor: "#ffffff"
		    color: "#000000"
		    opacity: 0.8
		    borderColor: "transparent"
		    radius: 10
		    
		    KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password
		    
		    Keys.onPressed: {
		        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
			    sddm.login(name.text, password.text, session.index)
			    event.accepted = true
                        }
                    }
                }

                PasswordBox {
                    id: password
		    Layout.fillWidth: true
                    font.pixelSize: 14
		    color: "#000000"
		    textColor: "#ffffff"
		    opacity: 0.8
		    tooltipBG: "#1c1c1c"
		    borderColor: "transparent"
		    radius: 10
		    
		    KeyNavigation.backtab: name; KeyNavigation.tab: session
		    
		    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, session.index)
                            event.accepted = true
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
