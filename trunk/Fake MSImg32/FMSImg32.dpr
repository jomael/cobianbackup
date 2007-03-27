{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                Cobian Backup Black Moon                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 2000-2006 by Luis Cobian              ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{The toolbar uses the function GradientFill that is NOT available in
windows NT. Collin Winson has the following library that creates a fake
MSImg32 which contains this function.

It is important that this DLL only should be distributed on NT}

library FMSImg32;

uses
  Windows;

{$R *.res}


(*=========================================================================­===* 
 | function GradientFill 
      | 
 | 
      | 
 | The contents of this file are subject to the Mozilla Public License 
      | 
 | Version 1.1 (the "License"); you may not use this file except in 
      | 
 | compliance with the License. You may obtain a copy of the License at 
      | 
 | http://www.mozilla.org/MPL/ 
      | 
 | 
      | 
 | Software distributed under the License is distributed on an "AS IS" 
basis, | 
 | WITHOUT WARRANTY OF ANY KIND, either express or implied. See the 
License   | 
 | for the specific language governing rights and limitations under the 
      | 
 | License. 
      | 
 | 
      | 
 | Copyright © Colin Wilson 2006  All Rights Reserved 
       | 
 | 
      | 
 | Implement a subset of the Windows GradientFill function, sufficient 
to     | 
 | support Delphi 2006 applications. 
      | 
 | 
      | 
 | 1.  It only support rectangles, not triangles. 
      | 
 | 2.  It only supports a single rectangle 
      | 
 | 
      | 
 | Hence, NumVertex must be 2, defining the two opposite corners of the 
      | 
 | Rectangle. 
      | 
 | 
      | 
 | NumMesh must be 1, with the mesh containing either TGradientRect (0, 
1),   | 
 | or TGradientRect (1, 0) 
      | 
 | 
      | 
 | Mode must be either GRADIENT_FILL_RECT_H or GRADIENT_FILL_RECT_V 
      | 


*==========================================================================­==*) 


function GradientFill(DC: HDC; Vertex: PTriVertex; NumVertex: ULONG; 
Mesh: Pointer; NumMesh, Mode: ULONG): BOOL; stdcall; 
var 
  x1, y1, x2, y2, i : Integer; 
  v1, v2 : PTriVertex; 
  r1, g1, b1 : COLOR16; 
  r2, g2, b2 : COLOR16; 
  oldPen : HPEN; 
  oldColor : TColorRef; 
  gr : PGradientRect; 


  function FadeShade (c1, c2 : COLOR16; n, minN, maxN : Integer) : 
Byte; 
  var 
    i1, i2 : Integer; 
  begin 
    Dec (n, minN); 
    Dec (maxN, minN); 
    i1 := c1; 
    i2 := c2; 


    Dec (i2, i1); 
    result := (i1 + (i2 * n) div maxN) shr 8; 
  end; 


  procedure UseColor (color : TColorRef); 
  begin 
    if color <> oldColor then 
    begin 
      if oldPen = $ffffffff then 
        oldPen := SelectObject (dc, CreatePen (PS_SOLID, 1, color)) 
      else 
        DeleteObject (SelectObject (dc, CreatePen (PS_SOLID, 1, 
color))); 


      oldColor := color 
    end 
  end; 


  procedure Swap (var a, b : Integer); 
  var 
    t : Integer; 
  begin 
    t := a; 
    a := b; 
    b := t; 
  end; 


begin 
  result := True; 
  if (NumVertex <> 2) or (NumMesh <> 1) or ((mode <> 
GRADIENT_FILL_RECT_H) and (mode <> GRADIENT_FILL_RECT_V)) then 
    Exit; 


  gr := PGradientRect (Mesh); 


  v1 := Vertex; 
  Inc (v1, gr^.UpperLeft); 


  v2 := Vertex; 
  Inc (v2, gr^.LowerRight); 


  x1 := v1^.x; 
  y1 := v1^.y; 
  x2 := v2^.x; 
  y2 := v2^.y; 


  r1 := v1^.Red; 
  g1 := v1^.Green; 
  b1 := v1^.Blue; 


  r2 := v2^.Red; 
  g2 := v2^.Green; 
  b2 := v2^.Blue; 


  if y2 < y1 then 
  begin 
    i := y2; 
    y2 := y1; 
    y1 := i 
  end; 


  if x2 < x1 then 
  begin 
    i := x2; 
    x2 := x1; 
    x1 := i 
  end; 


  oldColor := $ffffffff; 
  oldPen := $ffffffff; 
  try 
    if mode = GRADIENT_FILL_RECT_V then 
      for i := y1 to y2 do 
      begin 
        UseColor (RGB (FadeShade (r1, r2, i, y1, y2), FadeShade (g1, 
g2, i, y1, y2), FadeShade (b1, b2, i, y1, y2))); 


        MoveToEx (dc, x1, i, Nil); 
        LineTo (dc, x2, i); 
      end 
    else 
      for i := x1 to x2 do 
      begin 
        UseColor (RGB (FadeShade (r1, r2, i, x1, x2), FadeShade (g1, 
g2, i, x1, x2), FadeShade (b1, b2, i, x1, x2))); 


        MoveToEx (dc, i, y1, Nil); 
        LineTo (dc, i, y2); 
      end 
  finally 
    if oldPen <> $ffffffff then 
      DeleteObject (SelectObject (dc, oldPen)) 
  end 
end; 


exports GradientFill; 


begin 
end. 


