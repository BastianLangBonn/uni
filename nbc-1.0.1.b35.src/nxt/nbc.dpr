program nbc;

{$APPTYPE CONSOLE}

uses
{$IFNDEF FPC}
  FastMM4 in '..\FastMM4.pas',
  FastMM4Messages in '..\FastMM4Messages.pas',
  FastMove in '..\FastMove.pas',
{$ENDIF}
{$IFDEF CAN_DOWNLOAD}
  uSpirit in '..\bricktools\uSpirit.pas',
  FantomSpirit in '..\bricktools\FantomSpirit.pas',
{$ENDIF}
  Classes,
  SysUtils,
  uCmdLineUtils in '..\uCmdLineUtils.pas',
  ParamUtils in '..\ParamUtils.pas',
  uVersionInfo in '..\uVersionInfo.pas',
  mwGenericLex in '..\mwGenericLex.pas',
  uCommonUtils in '..\uCommonUtils.pas',
  uGenLexer in '..\uGenLexer.pas',
  uNBCLexer in '..\uNBCLexer.pas',
  uNXCLexer in '..\uNXCLexer.pas',
  uNBCInterface in 'uNBCInterface.pas',
  uNXTClasses in 'uNXTClasses.pas',
  uRICComp in 'uRICComp.pas',
  uRPGComp in 'uRPGComp.pas',
  uNXCComp in 'uNXCComp.pas',
  Parser10 in 'Parser10.pas';

{$IFDEF WIN32}
{$R *.RES}
{$ENDIF}

{$I nbc_preproc.inc}

resourcestring
  UsageSyntax    = 'Syntax: %s [options] filename [options]';
  UsagePort      = '   -S=<portname>: specify port name (COMn or usb), resource name, or alias';
  UsageBT        = '   -BT: use bluetooth';
  UsageDownload  = '   -d: download program';
  UsageBinary    = '   -b: treat input file as a binary file (don''t compile it)';
  UsageQuiet     = '   -q: quiet';
  UsageNoSystem  = '   -n: prevent the system file from being included';
  UsageDefine    = '   -D=<sym>[=<value>]: define macro <sym>';
  UsageDecompile = '   -x: decompile program';
  UsageOptimize  = '   -Z[1|2]: turn on compiler optimizations';
  UsageOutput    = '   -O=<outfile> : specify output file';
  UsageErrors    = '   -E=<filename> : write compiler errors to <filename>';
  UsageIncludes  = '   -I=<path>: search <path> for include files';
  UsageNBCOutput = '   -nbc=<filename> : save NXC intermediate NBC code to <filename>';
  UsageListing   = '   -L=<filename> : generate code listing to <filename>';
  UsageSymbols   = '   -Y=<filename> : generate symbol table to <filename>';
  UsageWarnings  = '   -w[-|+] : warnings off or on [default is off]';
  UsageEnhanced  = '   -EF : enhanced firmware';
  UsageSafecall  = '   -safecall: NXC will wrap all function calls in Acquire/Release';
  UsageAPI       = '   -api: dump the API to stdout';
  UsageHelp      = '   -help : display command line options';


procedure PrintUsage;
begin
  PrintVersion(COMPILATION_TIMESTAMP);
  WriteLn(Format(UsageSyntax, [progName]));
  WriteLn('');
//  WriteLn('   -T=<target>: target must be NXT (optional)');
{$IFDEF CAN_DOWNLOAD}
  WriteLn(UsagePort);
  WriteLn(UsageBT);
  Writeln(UsageDownload);
  Writeln(UsageBinary);
  Writeln(UsageQuiet);
{$ENDIF}
  Writeln(UsageNoSystem);
  Writeln(UsageDefine);
//  Writeln('   -U=<sym>: undefine macro <sym>');
  Writeln(UsageDecompile);
  Writeln(UsageOptimize);
  Writeln(UsageOutput);
  Writeln(UsageErrors);
  Writeln(UsageIncludes);
  Writeln(UsageNBCOutput);
  Writeln(UsageListing);
  Writeln(UsageSymbols);
  Writeln(UsageWarnings);
  Writeln(UsageEnhanced);
  Writeln(UsageSafecall);
  Writeln(UsageAPI);
  Writeln(UsageHelp);
  // compiler also takes an undocumented "nxt name" parameter which is
  // used to tell the compiler what the downloaded program should be called
  // on the NXT: -N=<nxtname>
end;

var
  C : TNBCCompiler;
  F : TextFile;
  i : integer;
  Filename : string;
  TheErrorCode : integer;

procedure HandleWriteMessages(aStrings : TStrings);
var
  i : integer;
begin
  // write compiler messages to output
  if redirectErrorsToFile then
  begin
    for i := 0 to aStrings.Count - 1 do
      WriteLn(F, aStrings[i]);
  end
  else
  begin
    for i := 0 to aStrings.Count - 1 do
      WriteLn(ErrOutput, aStrings[i]);
  end;
end;

begin
  TheErrorCode := 0;

try
  if ParamSwitch('-help', False) then
  begin
    PrintUsage;
    Exit;
  end;

  if ParamCount = 0 then
  begin
    PrintUsageError(COMPILATION_TIMESTAMP);
    TheErrorCode := 1;
    Exit;
  end;

  Filename := getFilenameParam();
  if (Trim(Filename) = '') and not ParamSwitch('-api', False) then
  begin
    PrintUsageError(COMPILATION_TIMESTAMP);
    TheErrorCode := 1;
    Exit;
  end;

  try
    C := TNBCCompiler.Create;
    try
      LoadParamDefinitions(C.ExtraDefines);
      C.OnWriteMessages          := HandleWriteMessages;
      C.InputFilename            := Filename;
      C.DefaultIncludeDir        := DEFAULT_INCLUDE_DIR;
      C.IgnoreSystemFile         := ParamSwitch('-n', False);
      C.Quiet                    := ParamSwitch('-q', False);
      C.WriteCompilerOutput      := ParamSwitch('-L', False);
      C.CompilerOutputFilename   := ParamValue('-L', False);
      C.WriteSymbolTable         := ParamSwitch('-Y', False);
      C.SymbolTableFilename      := ParamValue('-Y', False);
      C.WriteIntermediateCode    := ParamSwitch('-nbc', False);
      C.IntermediateCodeFilename := ParamValue('-nbc', False);
      C.WriteOutput              := ParamSwitch('-O', False);
      C.OutputFilename           := ParamValue('-O', False);
      C.UseSpecialName           := ParamSwitch('-N', False);
      C.SpecialName              := ParamValue('-N', False);
      C.OptimizationLevel        := 1;
      if ParamSwitch('-Z', False) or ParamSwitch('-Z2', False) then
        C.OptimizationLevel      := 2
      else if ParamSwitch('-Z1', False) then
        C.OptimizationLevel      := 1
      else if ParamSwitch('-Z0', False) then
        C.OptimizationLevel      := 0;
      C.UsePort                  := ParamSwitch('-S', False);
      C.PortName                 := ParamValue('-S', False);
      C.UseBluetooth             := ParamSwitch('-BT', False);
      C.BinaryInput              := ParamSwitch('-b', False);
      C.Download                 := ParamSwitch('-d', False);
      C.MoreIncludes             := ParamSwitch('-I', False);
      C.IncludePaths             := ParamValue('-I', False);
      C.WarningsAreOn            := ParamSwitch('-w+', False);
      C.EnhancedFirmware         := ParamSwitch('-EF', False);
      C.SafeCalls                := ParamSwitch('-safecall', False);
      if Filename <> '' then
      begin
        if ParamSwitch('-x', False) then
        begin
          C.Decompile;
          for i := 0 to C.Decompilation.Count - 1 do
            WriteLn(C.Decompilation[i]);
        end
        else
        begin
          setErrorOutputFile(F);
          try
            TheErrorCode := C.Execute;
          finally
            CloseFile(F);
          end;
        end;
      end;
      if ParamSwitch('-api', False) then
        C.DumpAPI(ParamIntValue('-api', 0, False));
    finally
      C.Free;
    end;
  except
    TheErrorCode := 1;
  end;

finally
  if TheErrorCode <> 0 then
    Halt(TheErrorCode);
end;

end.
