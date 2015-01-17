# string2wav

An windows analog of unix "text2wav" application, based on Microsoft SAPI (Speech API) that speak text from file or string, by choosen voice.

Work with "UTF-8", "UTF-8 with BOM", "ANSI" encoded files

Speak by voices installed to your OS (by default in Windows 7 for ex. available only English female voice)

You can find addition voices. 
For ex. most used for Russian language:

   - Alyona (Acapela Group)
   - Katerina и Milena (ScanSoft - RealSpeak)
   
For work you must have SAPI installed (Windows 7 and later includes SAPI by default)
Tested on Windows 7, Windows 2008 with SAPI 5.4

Usage : 

See dist/test.bat for example commands

Available options :

**-list** : List voices and the number
**-volume** : Set volume from 0 to 10
**-rate** : Set rate from -10 to 10
**-o** : Set output wav file name
**-voice** : Set voice (select by number from -list)
**-s** : Set string (use quotes, recommend only English)
**-f** : Load string from file

## License 

 [GNU General Public License v3](http://www.gnu.org/licenses/gpl.html) 