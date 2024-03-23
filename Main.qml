import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    visible: true
    width: 300
    height: 350
    title: "Analog Clock"

    Rectangle {
        id: clockFace
        width: 300
        height: 300
        color: "lightgrey"
        // anchors.centerIn: parent
        border.color: "black"
        border.width: 2
        property real secondAngle: 0
        property real minuteAngle: 0
        property real hourAngle: 0
        property bool settingTime: false
        property real initialAngle: 0
        property   real dragStartX: 0
        property   real dragStartY: 0

        Timer {
            id: timer
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                if (!clockFace.settingTime) {
                    let currentTime = new Date();
                    clockFace.secondAngle = currentTime.getSeconds() * 6;
                    clockFace.minuteAngle = currentTime.getMinutes() * 6;
                    clockFace.hourAngle = (currentTime.getHours() % 12 + currentTime.getMinutes() / 60) * 30;
                    secondHand.rotation = clockFace.secondAngle;
                    minuteHand.rotation = clockFace.minuteAngle;
                    hourHand.rotation = clockFace.hourAngle;
                }
            }
        }

        Canvas {
            id: face
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                var centerX = width / 2;
                var centerY = height / 2;
                var radius = Math.min(centerX, centerY) - 10;

            
                ctx.save();
                ctx.font = "16px Arial";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                for (var number = 1; number <= 12; number++) {
                    var angle = number * Math.PI / 6;
                    var numeral = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"][number - 1];
                    ctx.fillText(numeral, centerX + Math.cos(angle - Math.PI / 2) * radius * 0.85, centerY + Math.sin(angle - Math.PI / 2) * radius * 0.85);
                }
                ctx.restore();
                ctx.save();
                ctx.beginPath();
                for (var i = 0; i < 12; i++) {
                    angle = i * Math.PI / 6;
                    ctx.moveTo(centerX + Math.cos(angle) * (radius - 10), centerY + Math.sin(angle) * (radius - 10));
                    ctx.lineTo(centerX + Math.cos(angle) * radius, centerY + Math.sin(angle) * radius);
                }
                ctx.stroke();
                ctx.restore();
            }
        }

    
        Rectangle {
            id: hourHand
            x: face.width / 2 - 5
            y: face.height / 2 - 50
            width: 10
            height: 60
            color: "black"
            transformOrigin: Item.Bottom
            rotation: hourAngle
        
            MouseArea {
                id: hourHandMouseArea
                anchors.fill: parent
                onPressed: {
                    clockFace.settingTime = true;
                    if (clockFace.settingTime) {
                        // Save the initial mouse position
                        clockFace.dragStartX = mouseX;
                        clockFace.dragStartY = mouseY;
                    }
                }

                onPositionChanged: {
                    if (clockFace.settingTime) {
                        var centerX = clockFace.width / 2;
                        var centerY = clockFace.height / 2;
                        var dx = mouseX - clockFace.dragStartX;
                        var dy = mouseY - clockFace.dragStartY;
                        var angleDiff = Math.atan2(dy, dx) * 180 / Math.PI;
                        clockFace.hourAngle += angleDiff;
                        hourHand.rotation = clockFace.hourAngle;
                        clockFace.dragStartX = mouseX;
                        clockFace.dragStartY = mouseY;
                    }
                }
            }
        }
    
        Rectangle {
            id: minuteHand
            x: face.width / 2 - 3
            y: face.height / 2 - 70
            width: 6
            height: 80
            color: "black"
            transformOrigin: Item.Bottom
            rotation: minuteAngle
        
            MouseArea {
                id: minuteHandMouseArea
                anchors.fill: parent
                onPressed: { clockFace.settingTime = true; }
                onPositionChanged: {
                    if (clockFace.settingTime) {
                        var dx = mouseX - face.width / 2;
                        var dy = mouseY - face.height / 2;
                        var angle = Math.atan2(dy, dx) * 180 / Math.PI;
                        if (angle < 0)
                            angle += 360;
                        angle -= 90;
                        if (angle < 0)
                            angle += 360;
                        clockFace.minuteAngle = angle;
                        minuteHand.rotation = angle;
                    }
                }
            }
        }

        Rectangle {
            id: secondHand
            x: face.width / 2 - 1
            y: face.height / 2 - 90
            width: 2
            height: 100
            color: "red"
            transformOrigin: Item.Bottom
            rotation: secondAngle
        }


        Rectangle {
            id: resetButton
            width: 100
            height: 30
            color: "orange"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        
            anchors.bottomMargin: -40

            Text {
                text: "Reset Time"
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    clockFace.settingTime = false;
                    let currentTime = new Date();
                    clockFace.secondAngle = currentTime.getSeconds() * 6;
                    clockFace.minuteAngle = currentTime.getMinutes() * 6;
                    clockFace.hourAngle = (currentTime.getHours() % 12 + currentTime.getMinutes() / 60) * 30;
                    secondHand.rotation = clockFace.secondAngle;
                    minuteHand.rotation = clockFace.minuteAngle;
                    hourHand.rotation = clockFace.hourAngle;
                }
            }
        }


    }

    Component.onCompleted: {
        let currentTime = new Date();
        clockFace.secondAngle = currentTime.getSeconds() * 6;
        clockFace.minuteAngle = currentTime.getMinutes() * 6;
        clockFace.hourAngle = (currentTime.getHours() % 12 + currentTime.getMinutes() / 60) * 30;
        secondHand.rotation = clockFace.secondAngle;
        minuteHand.rotation = clockFace.minuteAngle;
        hourHand.rotation = clockFace.hourAngle;
    }
}

