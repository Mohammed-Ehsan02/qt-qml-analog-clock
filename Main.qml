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
        border.color: "black"
        border.width: 2

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



    }
}

