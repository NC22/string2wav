(*******************************************************************************
* *
* Author : NC22 *
* Version : 1.0 *
* Copyright : NC22 2015 *
* *
* License: *
* [GNU General Public License v3](http://www.gnu.org/licenses/gpl.html) 
* *
*******************************************************************************)

program string2wav;
         
uses
  windows, SpeechLib_TLB, SysUtils, Classes, ActiveX;

{$APPTYPE CONSOLE}
// {$R *.res}

var filename : UTF8String;
    str : UTF8String;

    speakStr : WideString;

    vi : integer;
    i : integer;

    spvoice: TSpvoice;
    spFileStream: TSpFileStream;

    voice : ISpeechObjectToken;
    voices: ISpeechObjectTokens;

// todo change sound quality

function LoadFileToStr(const FileName: TFileName): UTF8String;
var
  FileStream : TFileStream;
  t : Cardinal;
const
 UTF8BOM = $BFBBEF;
begin
  FileStream:= TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);

  t := 0;
  if (FileStream.Size > 3) then FileStream.ReadBuffer(t, 3);

  if (t <> 0) and (t = UTF8BOM) then
   FileStream.Seek(3, soBeginning)
  else
   FileStream.Seek(0, soBeginning);

    try
     if FileStream.Size > 0 then
     begin
        SetLength(Result, FileStream.Size);
        FileStream.Read(Pointer(Result)^, FileStream.Size);
     end;
    finally
     FileStream.Free;
    end;
end;

procedure ProgramExit;
begin
   FreeConsole;
end;

{
function ConProc(CtrlType : DWord) : Boolean; stdcall; far;
begin

  case CtrlType of
    CTRL_BREAK_EVENT: ProgramExit;
    CTRL_CLOSE_EVENT: ProgramExit;
    CTRL_LOGOFF_EVENT: ProgramExit;
    CTRL_SHUTDOWN_EVENT: ProgramExit;
    else

  end;

  result := true;
end;
}

function getParamValue(i : integer) : AnsiString;
begin
    Result := '';
    if i + 1 > ParamCount then begin
        writeln('please set value for param ' + ParamStr(i));
        ProgramExit;
    end;
    
    Result := AnsiString(ParamStr(i + 1));
end;

begin

    AllocConsole();
    SetConsoleOutputCP(1251); {DOS + rus symbols}
    SetConsoleCP(1251);

   //SetConsoleCtrlHandler(@ConProc, true);

    CoInitialize(nil);

    spvoice := TSpvoice.Create(nil);
    spFileStream := TspFileStream.Create(nil);

    str := '';
    filename := '';
    
    voices := spvoice.Getvoices('','');

    if ParamCount <= 0 then
    begin
        writeln('Usage:');
        writeln('   string2wav.exe -p1 <value> -p2 <value> ... -pN <value>');
        writeln('   ');
        writeln('Arguments:');
        writeln('   -list       List available voices');
        writeln('   -volume     Set volume from 0 to 10');
        writeln('   -rate       Set rate from -10 to 10');
        writeln('   -o          Set output wav file name');
        writeln('   -voice      Set voice (select by number from -list)');
        writeln('   -s          Set string (use quotes, recommend only English)');
        writeln('   -f          Load string from file (use file encoded to "UTF-8" or "UTF-8 with BOM" is recommended, also tested with "ANSI" with Russian text examples)');
        writeln('   ');
        writeln('Examples:');
        writeln('   string2wav.exe -o "c:\out.wav" -voice 1 -s "hello world"');
        writeln('   string2wav.exe -o "c:\out.wav" -voice 1 -f "text.txt"');
        ProgramExit;
        exit;
    end;

    i := 1;
    while i <= ParamCount do begin

        if ParamStr(i) = '-list' then begin
            for vi := 0 to voices.Count - 1 do begin
                writeln(inttostr(vi+1) + ': ' + voices.Item(vi).GetDescription(0));
            end;

            ProgramExit;
            exit;
        end
        else if ParamStr(i) = '-o' then begin
            filename := getParamValue(i);
            i := i + 1;
        end
        else if ParamStr(i) = '-rate' then begin
            vi := strtoint(getParamValue(i));
            i := i + 1;
            if (vi > 10) or (vi < -10) then
            begin
                writeln('Rate bad value (min -10 max 10)');
                ProgramExit;
                exit;
            end;

            spvoice.Rate := vi;
        end
        else if ParamStr(i) = '-volume' then begin
            vi := strtoint(getParamValue(i));
            i := i + 1;
            if (vi > 10) or (vi < 0) then
            begin
                writeln('Volume bad value (min 0 max 10)');
                ProgramExit;
                exit;
            end;

            spvoice.Volume := vi;
        end
        else if ParamStr(i) = '-voice' then begin
            vi := strtoint(getParamValue(i));
            i := i + 1;

           if (vi > voices.Count) then begin
                writeln('Unknown voice');
                ProgramExit;
                exit;
            end;

            voice := ISpeechObjectToken(voices.Item(vi-1)); // list command shows from 1.
            // writeln('voice ' + inttostr(vi) + ' - ' + voice.GetDescription(0));
            spvoice.voice := voice;
        end
        else if ParamStr(i) = '-s' then begin
            str := getParamValue(i);
            i := i + 1;
        end
        else if ParamStr(i) = '-f' then begin
            str := getParamValue(i);
            i := i + 1;

            if FileExists(str) then
                str := LoadFileToStr(str)
            else begin
                writeln('File not found: ' + str);
                ProgramExit;
                exit;
            end;
        end
        else begin
            writeln('Unknown parametr ' + ParamStr(i));
            ProgramExit;
            exit;
        end;

        i := i + 1;
    end;

    if (Length(filename) = 0) then begin
        writeln('Parametr -o (output file) is not set');
        ProgramExit;
        exit;
    end;

    if (Length(str) = 0) then begin
        writeln('Nothing to read (empty string)');
        ProgramExit;
        exit;
    end;

   spFileStream.Format.type_ := SAFT44kHz16BitMono;
   spFileStream.Open(filename, SSFMCreateForWrite, False);

   spvoice.AudioOutputStream := spFileStream.DefaultInterface;

   speakStr := Utf8Decode(str);
   if (Length(speakStr) <= 0) then

   {
     happens when file was saved to ANSI
     but speak utf-8 string in this case seems to be ok
   }

      speakStr := str;
      
   spvoice.Speak(speakStr, SVSFDefault or SVSFlagsAsync);
   spvoice.WaitUntilDone(-1);

   spFileStream.Close;

   // CharToOem(AnsiString(Utf8ToAnsi(str)), test);    test : PAnsiChar;
   // writeln(AnsiString(str));
   
   ProgramExit;   
end.
