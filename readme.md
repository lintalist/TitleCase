# TitleCase - capital case, headline style function for AutoHotkey

**Purpose**: Title case (capital case, headline style)<sup>[1]</sup>, example  

"The Quick Brown Fox Jumps over the Lazy Dog"

<sup>[1]</sup> A mixed-case style with all words capitalised, except for certain subsets  
-- https://en.wikipedia.org/wiki/Letter_case#Title_case

AutoHotkey forum thread: https://autohotkey.com/boards/viewtopic.php?f=6&t=58981

## Usage

    TitleCase(Text[,lang="en",ini="TitleCase.ini"])

**Options:**

_Text_

> The string to convert to TitleCase.
	
_lang_

> Language (or actually "SECTION") to use (reads from ini). Default "en" (for English). You can add your own sections (see below).

_ini_

> Ini-file to use. Default is `TitleCase.ini`. If there is no INI present in `A_ScriptDir` it will create a default one, with "en" only.

## How it works

The text is transformed first to AutoHotkey Title case format using [StringLower](https://autohotkey.com/docs/commands/StringLower.htm)  
So "GONE with the WIND" would become "Gone With The Wind"

After that several (find and replace) functions are called to process exceptions in the order as outlined below in the INI setup.

Ini setup - All keys are CSV lists:

```ini
[lang]
LowerCaseList=         words you would prefer to have lowercase: a,and,is,the,etc [1]
UpperCaseList=         words you would prefer to have uppercase: AHK,IBM,UK
MixedCaseList=         words you would prefer to have MixedCase: AutoHotkey,iPhone
ExceptionsList=        [2]
AlwaysLowerCaseList=   final check to ensure that any of the actions above haven't transformed specific words
```

[1] Also does: ```RegExReplace(Text, "im)([’'`])s","$1s")``` ; to prevent grocer'S   
[2] Also does: ```RegExReplace(Text, "im)[\.:;] \K([a-z])","$U{1}")``` ; first letter after .:; uppercase

The ini-file can have multiple [Sections] for specific languages or situations. Or you can prepare a different INI file for each situation.

Note: If you prepare your own ini files be sure to use UTF-16 encoded files to ensure proper processing of Unicode / extended ASCII characters. See the AutoHotkey [IniRead](https://autohotkey.com/docs/commands/IniRead.htm) documentation.

v1.2+ Added RegExReplace() to address 1st 2nd 3rd 4th etc `1ST, 22ND` -> `1st, 22nd`

## Examples:

(with default TitleCase.ini and English)

In : autohotkey voted best scripting language in the world: IBM survey  
Out: AutoHotkey Voted Best Scripting Language in the World: IBM Survey

In : the QUICK BROWN fox jumps over the lazy dog  
Out: The Quick Brown Fox Jumps over the Lazy Dog

In : Get help with using AutoHotkey and its commands and hotkeys  
Out: Get Help with Using AutoHotkey and its Commands and Hotkeys

In : Post your working scripts, libraries and tools  
Out: Post Your Working Scripts, Libraries and Tools

In : Helpful script writing tricks and HowTo's  
Out: Helpful Script Writing Tricks and Howto's

In : Discuss features, issues, about Editors for AHK  
Out: Discuss Features, Issues, About Editors for AHK

Copyright Lintalist. See license.txt
