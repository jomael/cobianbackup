object form_Extractor: Tform_Extractor
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 46
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object l_Operation: TTntLabel
    Left = 8
    Top = 6
    Width = 384
    Height = 16
    AutoSize = False
    Caption = 'Operation'
  end
  object cb_Main: TCobBarW
    Left = 8
    Top = 25
    Width = 384
    Height = 11
    ColorBorder = clGray
    ColorFace = 16759080
    ColorBack = 16444640
  end
  object Unzip: TZipForge
    ExtractCorruptedFiles = False
    CompressionLevel = clFastest
    CompressionMode = 1
    CurrentVersion = '2.70 '
    SpanningMode = smNone
    SpanningOptions.AdvancedNaming = True
    SpanningOptions.VolumeSize = vsAutoDetect
    Options.FlushBuffers = True
    Options.OEMFileNames = True
    InMemory = False
    OnFileProgress = UnzipFileProgress
    OnOverallProgress = UnzipOverallProgress
    Zip64Mode = zmDisabled
    Left = 304
    Top = 8
  end
end
