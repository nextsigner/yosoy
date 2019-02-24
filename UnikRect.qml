import QtQuick 2.0

Rectangle {
    id: r
    property int borderWidth: 6
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#ff0000";
        }
        GradientStop {
            position: 1.00;
            color: "#ff8000";
        }
    }
    Rectangle{
        width: r.width-r.borderWidth
        height: r.borderWidth
        anchors.centerIn: r
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#ff8000";
            }
            GradientStop {
                position: 1.00;
                color: "#ff0000";
            }
        }
    }
}
