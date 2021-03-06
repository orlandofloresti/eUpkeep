import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

import Qt.labs.calendar 1.0

import "qrc:/dialogs/"
import "qrc:/settings"

import "qrc:/modules/device/Function.js" as Def

Page{

    //Flag if a error passed saving or update user
    property bool errorSaving: false

    //Flag to determinate if a new user is creating
    property bool newState

    //property to password
    property string categoryPassword
    property string brandPassword
    //property string numberPassword

    signal updatePasswordDevice()

    onUpdatePasswordDevice: {
        passwordField.text = categoryPassword + brandPassword + numberField.text
    }

    //Signals to create new user or update new one
    signal newItem()
    signal updateItem(string varPassword,string varCategory,string varBrand,string varDescription,string varModel,string varSerial)

    onNewItem: {
        moduleName = "New Device"
        newState = true

        numberField.enabled = true
        numberField.clear()
        descriptionField.clear()
        modelField.clear()
        serialNumberField.clear()
        categoryComboBox.currentIndex = -1
        brandComboBox.currentIndex = -1
        categoryComboBox.enabled = true
        brandComboBox.enabled = true
        brandPassword = ""
        categoryPassword = ""
        passwordField.clear()

        button.text = "Save"
        //passwordField.enabled = true
    }

    onUpdateItem:{
        moduleName = "Update Device"
        newState = false

        numberField.enabled = false
        descriptionField.text = varDescription
        modelField.text = varModel
        serialNumberField.text = varSerial

        //Determine the index of the listModel
        var i = 0;

        for(i = 0; i < categoryListModel.count; i++){
            if(varCategory === categoryListModel.get(i).description){
                categoryComboBox.currentIndex = parseInt(i);
            }
        }

        for(i = 0; i < brandListModel.count; i++){
            if(varBrand === brandListModel.get(i).name){
                brandComboBox.currentIndex = parseInt(i);
            }
        }

        categoryComboBox.enabled = false
        brandComboBox.enabled = false

        passwordField.text = varPassword

        button.text = "Update"
        //passwordField.enabled = false
    }

    //Create the dialog to show problems or complete operations
    DialogMessage{
        id: dialog
        standardButtons: Dialog.Ok
        onAccepted: Def.errorSavingItem()
    }

    //Page settings
    id:page

    //Main page
    Flickable{
        anchors.fill: parent
        contentHeight: columnLayout.height
        ScrollIndicator.vertical: ScrollIndicator { }

        ColumnLayout{
            id: columnLayout
            width: parent.width

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
                    source: "qrc:/images/media-flash.png"
                }
            }
/*
            Label {
                text: "<b>Device information</b>"
                Layout.topMargin: space
                Layout.fillWidth: true
                Layout.leftMargin: space
                Layout.rightMargin: space
            }
*/
            GridLayout{
                //Layout.topMargin: space
                Layout.leftMargin: space
                Layout.rightMargin: space
                columnSpacing: space
                columns: 2


                Label {
                    text: "Password"
                    //Layout.rightMargin: space
                }
                TextField {
                    id: passwordField
                    selectByMouse: true
                    placeholderText: "Password"
                    Layout.fillWidth: true
                    //Layout.leftMargin: space
                    //Layout.rightMargin: space
                    //Layout.rightMargin: space
                    enabled: false
                }

                Label {
                    text: "Category"
                    //Layout.rightMargin: space

                }

                ComboBox{
                    id: categoryComboBox
                    model:categoryListModel
                    textRole: "description"
                    Layout.fillWidth: true
                    onCurrentTextChanged: {
                        if(categoryComboBox.currentIndex != -1){
                            categoryPassword = categoryListModel.get(categoryComboBox.currentIndex).password;
                            updatePasswordDevice()
                        }
                    }
                }

                Label {
                    text: "Brand"
                    //Layout.rightMargin: space
                }

                ComboBox{
                    id: brandComboBox
                    model:brandListModel
                    textRole: "name"
                    Layout.fillWidth: true
                    onCurrentTextChanged: {
                        if(brandComboBox.currentIndex != -1){
                            brandPassword = brandListModel.get(brandComboBox.currentIndex).password;
                            updatePasswordDevice()
                        }
                    }
                }

                Label {
                    text: "Number"
                    //Layout.rightMargin: space
                }
                TextField {
                    id: numberField
                    selectByMouse: true
                    placeholderText: "Number"
                    Layout.fillWidth: true
                    //Layout.rightMargin: space
                    onCursorPositionChanged: {
                        updatePasswordDevice()

                    }
                }

                Label {
                    text: "Description"
                    //Layout.rightMargin: space
                }
                TextArea {
                    id: descriptionField
                    selectByMouse: true
                    placeholderText: "Description"
                    Layout.fillWidth: true
                    wrapMode: TextArea.Wrap
                    //Layout.rightMargin: space

                }

                Label {
                    text: "Model"
                    //Layout.rightMargin: space
                }
                TextField {
                    id: modelField
                    selectByMouse: true
                    placeholderText: "Model"
                    Layout.fillWidth: true
                    //Layout.rightMargin: space

                }

                Label {
                    text: "S/N"
                    //Layout.rightMargin: space
                }
                TextField {
                    id: serialNumberField
                    selectByMouse: true
                    placeholderText: "Serial number"
                    Layout.fillWidth: true
                    //Layout.rightMargin: space

                }
            }            
            /*
            Label {
                text: "<b>Device location</b>"
                Layout.topMargin: space
                Layout.fillWidth: true
                Layout.leftMargin: space
                //Layout.rightMargin: space
            }

            GridLayout{
                Layout.topMargin: space
                Layout.leftMargin: space
                Layout.rightMargin: space
                columns: 1

                RowLayout{

                    ColumnLayout{
                        Label {
                            text: "Year"
                        }

                        TextField{
                            id: yearTextField
                            selectByMouse: true
                            placeholderText: "YYYY"
                            Layout.fillWidth: true
                        }
                    }

                    ColumnLayout{
                        Label {
                            text: "Month"
                        }

                        TextField{
                            id: monthTextField
                            selectByMouse: true
                            placeholderText: "MM"
                            Layout.fillWidth: true
                        }
                    }

                    ColumnLayout{
                        Label {
                            text: "Day"
                        }

                        TextField{
                            id: dayTextField
                            selectByMouse: true
                            placeholderText: "DD"
                            Layout.fillWidth: true
                        }
                    }

                    Button{
                        text: "Today"
                        onClicked: {
                            var date = new Date();
                            yearTextField.text = date.getFullYear();
                            dayTextField.text = date.getDate();
                            monthTextField.text = date.getMonth() + 1;
                        }
                    }

                }

                ColumnLayout{
                    Layout.fillWidth: true

                    Label {
                        text: "Map"
                        Layout.rightMargin: space
                        Layout.fillWidth: true
                    }

                    ComboBox{
                        id: mapComboBox
                        model:mapListModel
                        Layout.fillWidth: true
                        onCurrentTextChanged: Def.loadBuildingList(mapComboBox.currentText)

                    }

                    Label {
                        text: "Building"
                        Layout.rightMargin: space
                        Layout.fillWidth: true

                    }

                    ComboBox{
                        id: buildingComboBox
                        model:buildingListModel
                        Layout.fillWidth: true
                        onCurrentTextChanged: Def.loadZoneList(buildingComboBox.currentText,
                                                               mapComboBox.currentText)

                    }

                    Label {
                        text: "Zone"
                        Layout.rightMargin: space
                        Layout.fillWidth: true
                    }

                    ComboBox{
                        id: zoneComboBox
                        model:zoneListModel
                        Layout.fillWidth: true

                    }

                }

            }

            Button{
                Label{
                    text: "Save new location"
                    id: saveLocation
                    anchors.centerIn: parent
                    color: "Black"
                }
                Layout.topMargin: space
                Layout.fillWidth: true
                Layout.leftMargin: space
                Layout.rightMargin: space
                //Layout.bottomMargin: space
                onClicked: Def.saveLocation(passwordField.text,
                                            monthTextField.text,
                                            dayTextField.text,
                                            yearTextField.text,
                                            zoneComboBox.currentText,
                                            buildingComboBox.currentText,
                                            mapComboBox.currentText)
            }*/

            Button{
                Label{
                    id: button
                    anchors.centerIn: parent
                    color: "Black"
                }
                //Layout.topMargin: space
                Layout.fillWidth: true
                Layout.leftMargin: space
                Layout.rightMargin: space
                Layout.bottomMargin: space
                onClicked: Def.saving(newState)
            }


        }
    }
}
