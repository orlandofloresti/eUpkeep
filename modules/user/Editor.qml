import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

import "qrc:/dialogs/"
import "qrc:/settings"
import "qrc:/modules/user/Function.js" as User

Page {
    //Flag if a error passed saving or update user
    property bool errorSaving: false

    //Flag to determinate if a new user is creating
    property bool newUserState

    //Signals to create new user or update new one
    signal newUser()
    signal updateUser(int varPassword,string varName, string varZone, string varBuilding, string varMap)
    onNewUser: {
        moduleName = "New User"
        newUserState = true

        passwordField.text = ""
        nameField.text = ""

        mapComboBox.currentIndex = -1
        buildingComboBox.currentIndex = -1
        zoneComboBox.currentIndex = -1

        saveLabel.text = "Save"
        passwordField.enabled = true
    }

    onUpdateUser: {
            moduleName = "Update User"

            newUserState = false

            passwordField.text  = varPassword
            nameField.text = varName

            //Determine the index of the listModel
            var i = 0;

            for(i = 0; i < mapListModel.count; i++){
                if(varMap ===mapListModel.get(i).name){
                    mapComboBox.currentIndex = parseInt(i);
                }
            }

            //Determine the index of the listModel
            for(i = 0; i < buildingListModel.count; i++){
                if(varBuilding === buildingListModel.get(i).name){
                    buildingComboBox.currentIndex = parseInt(i);
                }
            }

            //Determine the index of the listModel
            for(i = 0; i < zoneListModel.count; i++){
                if(varZone === zoneListModel.get(i).name){
                    zoneComboBox.currentIndex = parseInt(i);
                }
            }

            saveLabel.text = "Update"
            passwordField.enabled = false

    }

    /*Load the ListModel of UserType on the beginning
    Component.onCompleted: {
        User.loadTypeList("UserType")
    }*/

    //Create the dialog to show problems or complete operations
    DialogMessage{
        id: userDialog
        standardButtons: Dialog.Ok
        onAccepted: User.errorSavingUser()
    }

    //Page settings
    id:userSettings

    //Main page
    Flickable{
        anchors.fill: parent
        contentHeight: columnUser .height
        //boundsBehavior: Flickable.StopAtBounds
        ScrollIndicator.vertical: ScrollIndicator { }


        ColumnLayout{
            id: columnUser
            width: parent.width
            Layout.topMargin: space
            Item{
                id: userItem
                implicitHeight: newUserImage.height
                Layout.fillWidth: true
                Layout.leftMargin: space
                Layout.rightMargin: space
                Layout.topMargin: space
                //Layout.bottomMargin: space

                Image {
                    width: 100
                    height: 100
                    id: newUserImage
                    anchors.centerIn: parent
                    source: "qrc:/images/avatar-default.png"
                }
            }

            GridLayout{
                //Layout.topMargin: space
                Layout.leftMargin: space
                Layout.rightMargin: space
                columnSpacing:space
                columns: 2

                Label {
                    text: "Password"
                    //Layout.fillWidth: true
                }
                TextField {
                    id: passwordField
                    selectByMouse: true
                    placeholderText: "Password"
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDialableCharactersOnly
                }
                Label {
                    text: "Name"
                    //Layout.fillWidth: true
                    //Layout.leftMargin: space
                    //Layout.rightMargin: space
                }
                TextArea {
                    id: nameField
                    selectByMouse: true
                    placeholderText: "Full name"
                    Layout.fillWidth: true
                    wrapMode: TextArea.Wrap
                    //Layout.leftMargin: space
                    //Layout.rightMargin: space
                }

                Label {
                    text: "Map"
                    //Layout.fillWidth: true
                }
                ComboBox{
                    id: mapComboBox
                    model:mapListModel
                    Layout.fillWidth: true
                    onCurrentTextChanged: User.loadBuildingList(mapComboBox.currentText)
                }

                Label {
                    text: "Building"
                    //Layout.fillWidth: true
                }
                ComboBox{
                    id: buildingComboBox
                    model:buildingListModel
                    Layout.fillWidth: true
                    onCurrentTextChanged: User.loadZoneList(buildingComboBox.currentText,
                                                            mapComboBox.currentText)

                }

                Label {
                    text: "Zone"
                    //Layout.fillWidth: true
                }
                ComboBox{
                    id: zoneComboBox
                    model:zoneListModel
                    Layout.fillWidth: true
                }
            }



            Button{
                Label{
                    id: saveLabel
                    anchors.centerIn: parent
                    color: "Black"
                }
                Layout.fillWidth: true
                Layout.leftMargin: space
                Layout.rightMargin: space
                Layout.bottomMargin: space
                onClicked: User.savingUser(newUserState)
            }

        }

    }
}
