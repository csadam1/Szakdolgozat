# Szakdolgozat
 
A szakdolgozatom témája egy Androidra és iOS-re fejlesztett sakk játék alkalmazás. Részletesebb információ az implementációról a szakdolgozatom dokumentációjában, a Szakdolgozat.pdf fájlban található.

## Android

Az Android implementáció a chess-android mappában található meg. Mivel a tesztelés során az Android Studio IDE egy bugnak köszönhetően nem tudta futtatni a JUnit5 teszteket, ezért egy külön projektként kiimportáltam és teszteltem a programot a Chess-android-test mappában.

## iOS

Az iOS-re készített implementációm virtuális gépen készítettem el MacOS környezetben. Az applikáció csak ebben a környezetben tesztelhető. Az implementáció a Chess-ios mappában található.

## Web

Az alkalmazáshoz készítettem egy webszervert és kliensoldalt is. A webszerver és a kliens egymásnak küldenek adatokat, socket-ek küldését és fogadását tartalmazza.