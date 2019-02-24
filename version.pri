VERSION_YEAR=2016
win32 {
    VERSION_MAJ1=$$system("echo  %date%")
    VERSION_MAJ2 =$$split(VERSION_MAJ1, "/")#07 08 2018
    VERSION_MAJ3 =$$member(VERSION_MAJ2, 2)
    VERSION_MAJ4 =$$split(VERSION_MAJ3, "")
    VERSION_MAJ5 =$$member(VERSION_MAJ4, 2)
    VERSION_MAJ6 =$$member(VERSION_MAJ4, 3)
    VERSION_MAJ7=$$system("set /a  $$VERSION_MAJ3 - $$VERSION_YEAR")

    MDIA1=$$member(VERSION_MAJ2, 0)
    MDIA2=$$split(MDIA1, "")
    MDIA3=$$member(MDIA2, 0)
    greaterThan(MDIA3, 9){
        MDIA4=$$MDIA3
    }else{
        MDIA4=$$member(MDIA2, 1)
    }
    VERSION_MEN1=$$system("echo  %time%")
    VERSION_MEN2 =$$split(VERSION_MEN1, ":")#07 08 2018
    VERSION_MEN3 =$$member(VERSION_MEN2, 1)
    VERSION_MEN4=$$system("resources\\week.bat $$MDIA4 $$member(VERSION_MAJ2, 1) $$member(VERSION_MAJ2, 2)")
    NUMWEEK=$$system("set /a  $$VERSION_MEN4 + 1")

    #message(Date: $$MDIA1)
    #message(Month: $$member(VERSION_MAJ2, 1))
    #message(Week: $$NUMWEEK)

    VERSION_MEN5=$$system("echo  %time%")
    VERSION_MEN6 =$$split(VERSION_MEN5, ":")
    VERSION_MEN7 =$$member(VERSION_MEN6, 0)
    VERSION_MEN8 =$$member(VERSION_MEN6, 1)
    VERSION_MEN9=$$system("set /a  $$MDIA4 + $$MMES4 + $$VERSION_MEN7 + $$VERSION_MEN8")
    greaterThan(VERSION_MEN9, 99){
        VERSION_MEN10=$$VERSION_MEN9
    }else{
        VERSION_MEN10=0$$VERSION_MEN9
    }
    APPVERSION=$$VERSION_MAJ7"."$$NUMWEEK$$VERSION_MEN10
    message(Windows App Version $$APPVERSION)
} else:unix {
    VERSION_MAJ1=$$system(date +%Y)
    VERSION_MAJ= $$system("echo $(($$VERSION_MAJ1 - $$VERSION_YEAR))")
    VERSION_MEN1= $$system("echo $((($$system(date +%-m) * $$system(date +%-d)) + $$system(date +%-H) + $$system(date +%-M)))")

    greaterThan(VERSION_MEN1, 99){
        VERSION_MEN2=$$VERSION_MEN1
    }else{
        VERSION_MEN2=0$$VERSION_MEN1
    }
    APPVERSION=$$VERSION_MAJ"."$$system(date +%W)$$VERSION_MEN2
    message(App Version $$APPVERSION)
}
