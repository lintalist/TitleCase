/*

Function   : TitleCase()
Purpose    : Title case (capital case, headline style), example
             "The Quick Brown Fox Jumps over the Lazy Dog"
             A mixed-case style with all words capitalised, except for certain subsets
             -- https://en.wikipedia.org/wiki/Letter_case#Title_case
Version    : 1.0
Source     : https://github.com/lintalist/TitleCase
License    : See license.txt for further details (GPL-2.0)

History:
v1.0 - initial version

Documentation:

Options:

- Text    sentence to convert to TitleCase
- lang    language to use (reads from ini), default "en" for English
- ini     ini file to use, default "TitleCase.ini". 
          If there is no INI present in A_ScriptDir it will create a default one ("en" only)

The text is transformed first to AutoHotkey Title case format. 

After that several functions are called to process exceptions in the order as outlined below in the INI setup.

Ini setup - all keys are CSV lists:

[lang]
LowerCaseList=         words you would prefer to have lowercase: a,and,is,the,etc [1]
UpperCaseList=         words you would prefer to have uppercase: AHK,IBM,UK
MixedCaseList=         words you would prefer to have MixedCase: AutoHotkey,iPhone
ExceptionsList=        [2]
AlwaysLowerCaseList=   final check to ensure that any of the actions above haven't transformed specific words

[1] Also does RegExReplace(Text, "im)([’'`])s","$1s") ; to prevent grocer'S
[2] Also does RegExReplace(Text, "im)[\.:;] \K([a-z])","$U{1}") ; first letter after .:; uppercase

The ini file can have multiple [sections] for speficic languages - you can also use multiple INI files

*/

TitleCase(Text,lang="en",ini="TitleCase.ini")
	{
	 static settings:={}
	 If !InStr(ini,"\")
	 	ini:=A_ScriptDir "\" ini
	 IfNotExist, %ini%
		TitleCase_Ini(ini)
	 inilist=LowerCaseList,UpperCaseList,MixedCaseList,ExceptionsList,AlwaysLowerCaseList
	 loop, parse, inilist, CSV
	 	{
 		 IniRead, key, %ini%, %lang%, %A_LoopField%
 		 If (key = "ERROR")
 		 	key:=""
		 settings[A_LoopField]:=key
	 	}
	 StringLower, Text, Text, T
	 Text:=TitleCase_LowerCaseList(Text,settings.LowerCaseList)
	 Text:=TitleCase_UpperCaseList(Text,settings.UpperCaseList)
	 Text:=TitleCase_MixedCaseList(Text,settings.MixedCaseList)
	 Text:=TitleCase_ExceptionsList(Text,settings.ExceptionsList)
	 Text:=TitleCase_AlwaysLowerCaseList(Text,settings.AlwaysLowerCaseList)
	 Text:=RegExReplace(Text,"^(.)","$U{1}") ; ensure first char is always upper case
	 Return Text
	}

TitleCase_LowerCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Text:=RegExReplace(Text, "im)([’'`])s","$1s") ; to prevent grocer'S
	 Return Text
	}

TitleCase_UpperCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return Text
	}

TitleCase_MixedCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return Text
	}

TitleCase_ExceptionsList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Text:=RegExReplace(Text, "im)[\.:;] \K([a-z])","$U{1}") ; first letter after .:; uppercase
	 Return text
	}
	
TitleCase_AlwaysLowerCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return text
	}

; create ini if not present, that way we don't overwrite any user changes in future updates
TitleCase_Ini(ini)
	{
FileAppend,
(
; -------------------------------------------------------------------------------------------
; TitleCase - https://github.com/lintalist/TitleCase
; ------------------------------------------------------------------------------------------

[en]
LowerCaseList=a,an,and,amid,as,at,atop,be,but,by,for,from,in,into,is,it,its,nor,not,of,off,on,onto,or,out,over,past,per,plus,than,the,till,to,up,upon,v,via,with
UpperCaseList=AHK,IBM,UK,USA
MixedCaseList=AutoHotkey,iPod,iPad,iPhone
ExceptionsList=
AlwaysLowerCaseList=

)
, %ini%, UTF-16
	}
