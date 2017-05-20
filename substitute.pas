unit substitute;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,StrUtils;

procedure subit(infile,outfile,ctrldir:string);

implementation

function PatternMatch(StartOffset:word;var Pattern:Shortstring;var SearchStr:string):boolean;
var
  LPattern,LSearchStr,x:integer;
  r:boolean;
begin
     r:=false;
   LPattern:=Length(Pattern);
   LSearchStr:=Length(SearchStr);
   if ((StartOffset+LPattern)<=LSearchStr) and (LPattern>0) then
   begin
        r:=true;
        for x:=1 to LPattern do
        begin
             if (Pattern[x] <> SearchStr[StartOffset+x]) then
             begin
                  r:=false;
                  break;
             end;
        end;
   result := r;
end;
end;

function AppendToFileName(Path,fn:string):string;
var
L,M,N:integer;
begin
L := Length(fn);
if L >1 then
begin
  M := L;
  while (M > 1) and (MidStr(fn,M,1) = '\') do Dec(M);
  N:=1;
  while (N < L) and (MidStr(fn,n,1) = '\') do inc(N);
  if N <=M then
  begin
    fn := MidStr(fn,N,M - N + 1);
    if (RightStr(path,1) <> '\') and (LeftStr(fn,1) <> '\') then path := path + '\';
    Result := Path + fn;
  end
  else
    Result := path
  end
  else
  Result := path;
end;

procedure FileToStr(fn:string;var TS:TStringList);
begin
If Assigned(TS)=false then
begin
TS := TStringList.Create();
end
else TS.Clear();
TS.LoadFromFile(fn);
end;

procedure subit(infile,outfile,ctrldir:string);
var
  control:TStringlist;
  fn,a,rt,cf:string;
  SubList:TStringList;
  R,c,x,cfc,p,l:integer;
  FIP,FOP:TextFile;
  replacements:array of TStringList;
  CC:Array Of Char;
  CMDS:Array of ShortString;
begin
     replacements := nil;
       If DirectoryExists(ctrldir)= false then raise Exception.Create('No such control directory '+ctrldir);
       If FileExists(infile)= false then raise Exception.Create('No such input file exists '+infile);
       cf := AppendToFileName(ctrldir,'control.txt');
       If FileExists(cf) = false then raise Exception.Create('Control file is not present '+cf);
       control:=TStringList.Create();
       control.LoadFromFile(cf);
       cfc := control.Count;
       SetLength(CC,cfc);
       SetLength(Replacements,cfc);
       SetLength(CMDS,cfc);
       try
       R:=0;
       while(R < cfc) do
       begin
            a := control.Strings[R];
            l:=Length(a);
            if l>0 then
               begin
               p:=Pos('|',a);
               if (p > 0) and (length(a)>p) then
               begin
                 CC[R]:=a[p+1];
                 CMDS[R] := leftstr(a,p-1);

               end
               else
               begin
                 CC[R]:='C';
                 CMDS[R]:=a;
               end;
            fn:=AppendToFileName(ctrldir,CMDS[R])+'.txt';
            If FileExists(fn) = false then raise Exception.Create('The replacer file '+fn+' does not exist reGcode failed, create file or ammend control.txt');
            SubList:=nil;
            FileToStr(fn,SubList);
            replacements[R]:=SubList;
            end;
            Inc(R);
      end;
      AssignFile(FIP,infile);
      Reset(FIP);
      AssignFile(FOP,outfile);
      ReWrite(FOP);
      while(not(EOF(FIP))) do
      begin
           ReadLn(FIP,a);
           for x:=0 to cfc -1 do
           begin
                Sublist := replacements[x];
                rt := sublist.Text;
                case CC[X] of
                'A':a := StringReplace(a,CMDS[x],rt,[rfReplaceAll]);
                'C':if PatternMatch(0,CMDS[x],a) then a:= rt;
                else
                  raise Exception.Create('Unknow control code in control.txt at line '+IntToStr(x));
                end;
           end;
           WriteLn(FOP,a);
      end;
finally
       CloseFile(FIP);
       CloseFile(FOP);
       cfc :=Length(replacements);
       for c:=0 to cfc-1 do
       begin
                 if Assigned(replacements[c]) then replacements[c].Free;
        end;
     end;
end;

end.

