# string2wav
string to wav 

Speaks text files to wav using Microsoft Speech API <br>
An windows analog of unix "text2wave" application, based on Microsoft SAPI (Speech API) that speak text from file or string, by choosen voice.

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

**-list** : List available voices<br>
**-volume** : Set volume from 0 to 10<br>
**-rate** : Set rate from -10 to 10<br>
**-o** : Set output wav file name (absolute or relative path)<br>
**-voice** : Set voice (select by number from -list)<br>
**-s** : Set string (use quotes, recommend only English)<br>
**-f** : Set input file to load string from (absolute or relative path)<br>

## License 

 [GNU General Public License v3](http://www.gnu.org/licenses/gpl.html) 
