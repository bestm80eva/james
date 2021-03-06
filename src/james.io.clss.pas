{
  MIT License

  Copyright (c) 2017 Marcos Douglas B. Santos

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit James.IO.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.Data.Clss,
  James.IO;

type
  TFile = class(TInterfacedObject, IFile)
  private
    FFileName: string;
    FStream: IDataStream;
  public
    constructor Create(const FileName: string; Stream: IDataStream); overload;
    class function New(const FileName: string; Stream: IDataStream): IFile; overload;
    class function New(const FileName: string): IFile; overload;
    function Path: string;
    function Name: string;
    function FileName: string;
    function Stream: IDataStream;
  end;

implementation

{ TFile }

constructor TFile.Create(const FileName: string; Stream: IDataStream);
begin
  inherited Create;
  FFileName := FileName;
  FStream := Stream;
end;

class function TFile.New(const FileName: string; Stream: IDataStream): IFile;
begin
  Result := Create(FileName, Stream);
end;

class function TFile.New(const FileName: string): IFile;
begin
  Result := Create(FileName, TDataStream.New(''));
end;

function TFile.Path: string;
begin
  Result := SysUtils.ExtractFilePath(FFileName);
end;

function TFile.Name: string;
begin
  Result := SysUtils.ExtractFileName(FFileName);
end;

function TFile.FileName: string;
begin
  Result := FFileName;
end;

function TFile.Stream: IDataStream;
var
  Buf: TFileStream;
begin
  if FStream.Size > 0 then
  begin
    Result := FStream;
    Exit;
  end;
  if not FileExists(FFileName) then
    raise EFileNotFoundException.CreateFmt('File "%s" not found', [FFileName]);
  Buf := TFileStream.Create(FFileName, fmOpenRead);
  try
    Result := TDataStream.New(Buf);
  finally
    Buf.Free;
  end;
end;

end.

