import QtQuick 2.0

Item {
    property alias lm: lm2
    ListModel{
        id:lm2

        ListElement{
            nom: "FutuRock Web Browser"
            des: "Navergador Web para los oyentes de FutuRock. Este navegador está diseñado solo para navegar por las Redes Sociales más importantes de la manera más facil, ágil y dinámica aprovechando al máximo tu pantalla."
            dev: "@nextsigner"
            urlgit: "https://github.com/nextsigner/futurock"
            img2: "https://github.com/nextsigner/futurock/blob/master/screenshot.png?raw=true"
            tipo: "linux-osx-windows"
        }
        ListElement{
            nom: "unik-qml-blogger"
            des: "Esta aplicación nos permite utilizar Blogger.com
como un editor o entorno para publicar y probar código QML de ejemplo
del blog sobre programación QML de @nextsigner, el suyo, otro blogger o
sitio web en donde exista código QML disponible."
            dev: "@nextsigner"
            urlgit: "https://github.com/nextsigner/unik-qml-blogger"
            img2: "https://github.com/nextsigner/unik-qml-blogger/blob/master/screenshot.png?raw=true"
            tipo: "linux-osx-windows"
        }
        ListElement{
            nom: "RickyPapi Web Browser"
            des: "Navergador Web para Los Rickytos de Matias Ponce. Este navegador está diseñado solo para navegar por las Redes Sociales más importantes de la manera más facil, ágil y dinámica aprovechando al máximo tu pantalla."
            dev: "@nextsigner"
            urlgit: "https://github.com/nextsigner/rickypapi"
            img2: "https://github.com/nextsigner/rickypapi/blob/master/screenshot.png?raw=true"
            tipo: "linux-osx-windows"
        }
        ListElement{
            nom: "naty"
            des: "Esta aplicaciòn aùn està en fase de desarrollo. Se està desarrollando en los dìas de Marzo de 2018 para ser utilizada en Android y Ordenadores de Escritorio. La aplicaciòn no cuenta aùn con todos los menus terminados y su uso se recomienda solo a los fines de probar unik qml engine en Android. Se intentarà terminar el desarrollo a la brevedad."
            dev: "@nextsigner"
            urlgit: "https://github.com/nextsigner/naty"
            img2: "https://github.com/nextsigner/naty/blob/master/screenshot.png?raw=true"
            tipo: "linux-osx-windows-android"
        }

        ListElement{
            nom: "semitimes"
            des: "Primer Reloj QML creado para la lista de Aplicaciones QML disponibles para unik qml engine."
            dev: "@nextsigner"
            urlgit: "https://github.com/nextsigner/semitimes/tree/master/semitimes_m1"
            img2: "https://github.com/nextsigner/semitimes/blob/master/semitimes_m1/screenshot.png?raw=true"
            tipo: "linux-osx-windows-android"
        }


        ListElement{
            nom: "semitimes_year"
            des: "Reloj Calendario QML creado para la lista de Aplicaciones QML disponibles para unik qml engine.\nEste reloj està disponible en el formato UPK."
            dev: "@nextsigner"
            urlgit: "https://raw.githubusercontent.com/nextsigner/semitimes/master/semitimes_year.upk"
            img2: "https://raw.githubusercontent.com/nextsigner/semitimes/master/semitimes_year/screenshot.png"
            tipo: "linux-osx-windows-android"
        }
        ListElement{nom: "spacer";des:"";dev:"";img2:"";tipo: "linux-osx-windows-android"}



    }

}
