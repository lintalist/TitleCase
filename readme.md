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

Ini setup - All keys are CSV lists apart from the find and replace pairs defined by _find _replace:

```ini
[lang]
LowerCaseList=            words you would prefer to have lowercase: a,and,is,the,etc [1]
UpperCaseList=            words you would prefer to have uppercase: AHK,IBM,UK
MixedCaseList=            words you would prefer to have MixedCase: AutoHotkey,iPhone
ExceptionsList=           [2]
AlwaysLowerCaseList=      final check to ensure that any of the actions above haven't transformed specific words
OrdinalIndicator_Find=    Regular Expression to FIND
OrdinalIndicator_Replace= Regular Expression to REPLACE (see ordinal below)
Hypen1_Find=
Hypen1_Replace=
Hypen2_Find=
Hypen2_Replace=

```

[1] Also does: ```RegExReplace(Text, "im)([’'`])s","$1s")``` ; to prevent grocer'S   
[2] Also does: ```RegExReplace(Text, "im)[\.:;] \K([a-z])","$U{1}")``` ; first letter after .:; uppercase

## Pairs

Apart from the CSV lists you can also define find and replace pairs in the INI to handle special use cases such as Ordinal numbers.

You can define a pair by using the same keyword and append "_find" and "_replace", example:

```ini
Hypen1_Find   =im)-\K(.)
Hypen1_Replace=$U{1}
```

These pairs are regular expessions and are used as follows:

    Text:=RegExReplace(Text,pair_find,pair_replace)

### Ordinal Numbers

"Ordinal numbers may be written in English with numerals and letter suffixes: 1st, 2nd or 2d, 3rd or 3d, 4th, 11th, 21st, 101st, 477th, etc., with the suffix acting as an ordinal indicator."  
-- https://en.wikipedia.org/wiki/Ordinal_numeral

English is included by default, a possible example for French is provided below.

#### English

```ini
OrdinalIndicator_Find   =im)\b(\d+)(st|nd|rd|th)\b
OrdinalIndicator_Replace=$1$L{2}
```

#### French

```ini
OrdinalIndicator_Find   =im)\b(\d+)(er|re|e)\b
OrdinalIndicator_Replace=$1$L{2}
```

## Languages

The ini-file can have multiple [Sections] for specific languages or situations. Or you can prepare a different INI file for each situation.

Note: If you prepare your own ini files be sure to use UTF-16 encoded files to ensure proper processing of Unicode / extended ASCII characters. See the AutoHotkey [IniRead](https://autohotkey.com/docs/commands/IniRead.htm) documentation.

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

In : AUTOHOTKEY IS THE 1ST SCRIPTING LANGUAGE WITH HOTKEYS and has User-contributed features  
Out: AutoHotkey is the 1st Scripting Language with Hotkeys and Has User-Contributed Features

Copyright Lintalist. See license.txt
