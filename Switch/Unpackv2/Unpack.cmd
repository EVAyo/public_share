@echo off
setlocal enableDelayedExpansion
rmdir /s /Q "%~dp0\Temp"
cls
:: Wrong file extension
::
::
IF NOT %~x1==.xci (
		IF NOT %~x1==.nsp (
			echo Wrong file. Put correct *.nsp file or *.xci file
			pause
			exit
	)
)
::Good file extensions
::
::
IF %~x1==.nsp (
	mkdir "%~dp0\Temp"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --intype=pfs0 --pfs0dir="%~dp0\ExtractedNSP" %1
	set NSP=1
	cls
)
IF DEFINED NSP GOTO GONSP
IF %~x1==.xci (
	mkdir "%~dp0\Temp"
	mkdir "%~dp0\ExtractedXCI"
	"%~dp0\hactool.exe" -k "%~dp0keys.txt" --intype=xci --securedir="%~dp0\ExtractedXCI" %1
	set XCI=1
	cls
)
:: XCI Choose patch
::
::
IF DEFINED XCI (
	echo If your patch was inside XCI, press "1" and ENTER
	echo If you don't have patch, just only press ENTER
	echo .
	echo .
	echo .
	set /p patch2="Drop here your *.nsp patch file and press ENTER: "
	cls
)
IF NOT DEFINED patch2 GOTO XCINoPatch
IF %patch2%==1 GOTO NoNSPPatchXCI
IF DEFINED patch2 GOTO XCIPatch
:: NSP Choose patch
::
::
:GONSP

IF DEFINED NSP (
	where /r "%~dp0\ExtractedNSP" *.tik > "%~dp0\Temp\loc.txt"
	set /p lokal=< "%~dp0\Temp\loc.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\loc.txt" | FIND /C ":" > "%~dp0\Temp\linestik2.txt"
	set /p linestik2=< "%~dp0\Temp\linestik2.txt"
)
IF %linestik2% NEQ 1 (
	rmdir /s /Q "%~dp0\Temp"
	echo "Wrong quanity of *.tik file in ExtractedNSP folder. Extracting canceled."
	echo "Press ENTER to delete ExtractedNSP folder"
	pause
	rmdir /s /Q "%~dp0\ExtractedNSP"
	exit
)
IF DEFINED NSP set local=!lokal!
IF DEFINED NSP %~dp0\tf.exe %local% > "%~dp0\Temp\klucz.txt"
IF DEFINED NSP set /p titlekey=< "%~dp0\Temp\klucz.txt"
IF DEFINED NSP set tk=!titlekey!
IF DEFINED NSP (
	cls
	echo ---If you don't have patch file, just only press ENTER---
	set /p patch="Drop here your *.nsp patch file and press ENTER: "
	cls
)
IF NOT DEFINED patch GOTO NSPUnpatched
:: NSP Patched
::
::
IF DEFINED patch (
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --intype=pfs0 --pfs0dir="%~dp0\ExtractedNSPatch" %patch%
	cls
	where /r %~dp0\ExtractedNSPatch /q *.xml
	set xmlfile=%ERRORLEVEL%
)
IF %xmlfile%==0 (
	where /r "%~dp0\ExtractedNSPatch" *.xml > "%~dp0\Temp\xml.txt"
	where /r "%~dp0\ExtractedNSPatch" *.tik > "%~dp0\Temp\tik.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\tik.txt" | FIND /C ":" > "%~dp0\Temp\linestik.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\xml.txt" | FIND /C ":" > "%~dp0\Temp\lines.txt"
	set /p lines=< "%~dp0\Temp\lines.txt"
	set /p linestik=< "%~dp0\Temp\linestik.txt"
)
IF %linestik% NEQ 1 (
	rmdir /s /Q "%~dp0\Temp"
	echo "Wrong quantity of *.tik file in ExtractedNSPatch folder. Extracting canceled."
	echo "Press ENTER to delete ExtractedNSPatch folder"
	pause
	rmdir /s /Q "%~dp0\ExtractedNSPatch"
	exit
)
IF NOT %lines%==1 (
	echo "You got different quantity than 1 XML file in ExtractedNSPatch folder. Auto searching canceled."
	GOTO NoXML
)
IF %xmlfile%==0 (
	set /p recurse=< "%~dp0\Temp\xml.txt"
	set var=Program
)
IF %xmlfile%==0 (
	type %recurse%|"%~dp0\findrepl.bat" "%var%" /o:0:+1 |find /v "%var%" > "%~dp0\Temp\temp.txt"
	type "%~dp0\Temp\temp.txt"|"%~dp0\findrepl.bat" " " "" > "%~dp0\Temp\temp2.txt"
	type "%~dp0\Temp\temp2.txt"|"%~dp0\findrepl.bat" "<Id>" "%~dp0ExtractedNSPatch\" > "%~dp0\Temp\temp.txt"
	type "%~dp0\Temp\temp.txt"|"%~dp0\findrepl.bat" "</Id>" ".nca" > "%~dp0\Temp\temp2.txt"
	type "%~dp0\Temp\temp2.txt"|"%~dp0\findrepl.bat" "\\" "\" > "%~dp0\Temp\temp.txt"
	set /p patchnca=< "%~dp0\Temp\temp.txt"
	cls
)

IF %xmlfile%==1 (
	:NoXML
	echo "Not found correct XML file. You need to choose NCA file manually."
	echo "Drop here correct NCA file (probably the biggest one) from ExtractedNSPatch folder in"
	echo %~dp0
	set /p patchnca="and press ENTER: "
	cls
)
IF DEFINED patch (
	where /r "%~dp0\ExtractedNSPatch" *.tik > "%~dp0\Temp\loc2.txt"
	set /p lokal2=< "%~dp0\Temp\loc2.txt"
	set local2=!lokal2!
)
IF DEFINED patch "%~dp0\tf.exe" %local2% > "%~dp0\Temp\klucz2.txt"
IF DEFINED patch (
	set /p titlekey2=< "%~dp0\Temp\klucz2.txt"
	set tk2=!titlekey2!
	where /r "%~dp0\ExtractedNSP" /q *.xml
	set xmlfile2=%ERRORLEVEL%
)
IF %xmlfile2%==0 (
	where /r "%~dp0\ExtractedNSP" *.xml > "%~dp0\Temp\xml2.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\xml2.txt" | FIND /C ":" > "%~dp0\Temp\lines2.txt"
	set /p lines2=< "%~dp0\Temp\lines2.txt"
)
IF NOT %lines2%==1 (
	echo You got different quantity than 1 XML file in ExtractedNSP folder. Auto searching canceled.
	GOTO NoXML2
)
IF %xmlfile2%==0 set /p recurse2=< "%~dp0\Temp\xml2.txt"
IF %xmlfile2%==0 (
	type %recurse2%|"%~dp0\findrepl.bat" "%var%" /o:0:+1 |find /v "%var%" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" " " "" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "<Id>" "%~dp0ExtractedNSP\" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" "</Id>" ".nca" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "\\" "\" > "%~dp0\Temp\tempa.txt"
	set /p bs=< "%~dp0\Temp\tempa.txt"
	cls
)

IF %xmlfile2%==1 (
	:NoXML2
	echo "Not found correct XML file. You need to drop NCA file manually."
	echo "Drop here correct NCA file (probably the biggest one) from ExtractedNSP folder in"
	ECHO %~dp0
	set /p bs="and press ENTER: "
	cls
)
IF DEFINED patch (
	mkdir "%~dp0\DecryptedNCA"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --titlekey=%tk% --plaintext="%~dp0\DecryptedNCA\Decrypted.nca" %bs%
	cls
	mkdir "%~dp0\patched_%~n1"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --titlekey=%tk2% --romfsdir="%~dp0\patched_%~n1\romfs" --exefsdir="%~dp0\patched_%~n1\exefs" --basenca="%~dp0\DecryptedNCA\Decrypted.nca" %patchnca%
	rmdir /s /Q "%~dp0\Temp"
	echo .
	rmdir /s /Q "%~dp0\DecryptedNCA"
	echo .
	echo Finished cleaning. Game files should have been extracted to
	echo %~dp0\patched_%~n1
	echo .
	echo Press ENTER to delete all temporary files
	pause
	rmdir /s /Q "%~dp0\ExtractedNSPatch"
	rmdir /s /Q "%~dp0\ExtractedNSP"
	echo Done
	pause
	EXIT
)
:: NSP Unpatched
::
::
:NSPUnpatched

where /r "%~dp0\ExtractedNSP" /q *.xml
IF %ERRORLEVEL%==1 (
	:NoXMLNSP
	echo "Not found correct XML file. You need to drop NCA file manually."
	echo "Drop here correct NCA file (probably the biggest one) from ExtractedNSP folder in"
	ECHO %~dp0
	set /p bs="and press ENTER: "
	GOTO Defined2
)
IF %ERRORLEVEL%==0 (
	where /r "%~dp0\ExtractedNSP" *.xml > "%~dp0\Temp\xml2.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\xml2.txt" | FIND /C ":" > "%~dp0\Temp\lines2.txt"
	set /p lines2=< "%~dp0\Temp\lines2.txt"
)
IF NOT %lines2%==1 (
	echo "You got different quantity than 1 XML file in ExtractedNSP folder. Auto searching canceled."
	GOTO NoXMLNSP
)
IF %ERRORLEVEL%==0 (
	set /p recurse2=< "%~dp0\Temp\xml2.txt"
	set var=Program
)
IF %ERRORLEVEL%==0 (
	type %recurse2%|"%~dp0\findrepl.bat" "%var%" /o:0:+1 |find /v "%var%" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" " " "" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "<Id>" "%~dp0ExtractedNSP\" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" "</Id>" ".nca" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "\\" "\" > "%~dp0\Temp\tempa.txt"
	set /p bs=< "%~dp0\Temp\tempa.txt"
	cls
)
IF DEFINED NSP (
	:Defined2
	mkdir "%~dp0\%~n1"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --titlekey=%tk% --romfsdir="%~dp0\%~n1\romfs" --exefsdir="%~dp0\%~n1\exefs" %bs%
	rmdir /s /Q "%~dp0\Temp"
	echo .
	echo .
	echo Finished cleaning. Game files should have been extracted to
	echo %~dp0\%~n1
	echo .
	echo Press ENTER to delete all temporary files
	pause
	rmdir /s /Q "%~dp0\ExtractedNSP"
	echo Done
	pause
	EXIT
)
:: XCI Unpatched
::
::
:XCINoPatch

echo "XCI images doesn't contain XML file. You need to drop NCA file manually."
echo "Drop here correct NCA file (probably the biggest one) from ExtractedXCI folder in"
ECHO %~dp0
set /p bs="and press ENTER: "
mkdir "%~dp0\%~n1"
"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --romfsdir="%~dp0\%~n1\romfs" --exefsdir="%~dp0\%~n1\exefs" %bs%
echo "%~dp0\hactool.exe" -x -k "%~dp0\keys.txt" --romfsdir="%~dp0\%~n1\romfs" --exefsdir="%~dp0\%~n1\exefs" %bs%
rmdir /s /Q "%~dp0\Temp"
echo .
echo Game files should have been extracted to
echo %~dp0\%~n1
echo .
echo Press ENTER to delete all temporary files
pause
rmdir /s /Q "%~dp0\ExtractedXCI"
echo Done
pause
exit
:: XCI Patched NSP
::
::
:XCIPatch

IF NOT %patch2% EQU 1 (
	mkdir "%~dp0\ExtractedNSPatch"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --intype=pfs0 --pfs0dir="%~dp0\ExtractedNSPatch" %patch2%
	cls
)
IF NOT %patch2% EQU 1 (
	where /r "%~dp0\ExtractedNSPatch" *.tik > "%~dp0\Temp\tik4.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\tik4.txt" | FIND /C ":" > "%~dp0\Temp\linestik4.txt"
	set /p linestik4=< "%~dp0\Temp\linestik4.txt"
)
IF %linestik4% NEQ 1 (
	rmdir /s /Q "%~dp0\Temp"
	echo "Wrong quantity of *.tik file in ExtractedNSPatch folder. Extracting canceled."
	echo "Press ENTER to delete ExtractedNSPatch folder"
	pause
	rmdir /s /Q "%~dp0\ExtractedNSPatch"
	exit
)
IF NOT %patch2% EQU 1 (
	where /r "%~dp0\ExtractedNSPatch" /q *.xml
)
IF %ERRORLEVEL%==0 (
	where /r "%~dp0\ExtractedNSPatch" *.xml > "%~dp0\Temp\xml2.txt"
	FINDSTR /R /N "^.*$" "%~dp0\Temp\xml2.txt" | FIND /C ":" > "%~dp0\Temp\lines3.txt"
	set /p lines3=< "%~dp0\Temp\lines3.txt"
)
IF NOT %lines3%==1 (
	echo "You got different quantity than 1 XML file in ExtractedNSPatch folder. Auto searching canceled."
	GOTO NoXMLXCIPatch
)
IF %ERRORLEVEL%==0 (
	set /p recurse2=< "%~dp0\Temp\xml2.txt"
	set var=Program
)
IF %ERRORLEVEL%==0 (
	type %recurse2%|"%~dp0\findrepl.bat" "%var%" /o:0:+1 |find /v "%var%" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" " " "" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "<Id>" "%~dp0ExtractedNSPatch\" > "%~dp0\Temp\tempa.txt"
	type "%~dp0\Temp\tempa.txt"|"%~dp0\findrepl.bat" "</Id>" ".nca" > "%~dp0\Temp\tempa2.txt"
	type "%~dp0\Temp\tempa2.txt"|"%~dp0\findrepl.bat" "\\" "\" > "%~dp0\Temp\tempa.txt"
	set /p patchnca=< "%~dp0\Temp\tempa.txt"
	cls
)
IF %ERRORLEVEL%==1 (
	:NoXMLXCIPatch
	echo %ERRORLEVEL%
	echo "Not found correct XML file in update. You need to drop NCA file manually."
	echo "Drop here correct NCA file (probably the biggest one) from ExtractedNSP folder in"
	ECHO %~dp0
	set /p patchnca="and press ENTER: "
)
IF NOT %patch2% EQU 1 (
	where /r "%~dp0\ExtractedNSPatch" *.tik > "%~dp0\Temp\loc2.txt"
	set /p lokal2=< "%~dp0\Temp\loc2.txt"
	set local2=!lokal2!
)
IF NOT %patch2% EQU 1 %~dp0\tf.exe %local2% > "%~dp0\Temp\klucz2.txt"
IF NOT %patch2% EQU 1 (
	set /p titlekey2=< "%~dp0\Temp\klucz2.txt"
	set tk2=!titlekey2!
)
IF NOT %patch2% EQU 1 (
	echo "XCI images doesn't contain XML file. You need to drop NCA file manually."
	echo "Drop here correct NCA file (probably the biggest one) from ExtractedXCI folder in"
	ECHO %~dp0
	set /p bs="and press ENTER: "
	cls
)
IF NOT %patch2% EQU 1 (
	mkdir "%~dp0\patched_%~n1"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --titlekey=%tk2% --romfsdir="%~dp0\patched_%~n1\romfs" --exefsdir="%~dp0\patched_%~n1\exefs" --basenca="%bs%" %patchnca%
	rmdir /s /Q "%~dp0\Temp"
	echo .
	echo .
	echo .
	echo Finished cleaning. Game files should have been extracted to
	echo %~dp0\patched_%~n1
	echo .
	echo .
	echo .
	echo Press ENTER to delete all temporary files
	pause
	rmdir /s /Q "%~dp0\ExtractedNSPatch"
	rmdir /s /Q "%~dp0\ExtractedXCI"
	echo Done
	pause
	EXIT
)
:: XCI Patched NCA
::
::
:NoNSPPatchXCI
IF %patch2%==1 (
	echo "XCI images doesn't contain XML file. You need to drop NCA files manually."
	echo "Drop here correct NCA patch file (probably the second biggest file) from ExtractedXCI in folder"
	echo %~dp0
	set /p update="and press ENTER: "
	cls
)
IF %patch2%==1 (
	echo "Drop here correct NCA game file (probably the biggest one) from ExtractedXCI in folder"
	echo %~dp0
	set /p bs="and press ENTER: "
	cls
)
	mkdir "%~dp0\patched_%~n1"
	"%~dp0\hactool.exe" -x -k "%~dp0keys.txt" --romfsdir="%~dp0\patched_%~n1\romfs" --exefsdir="%~dp0\patched_%~n1\exefs" --basenca="%bs%" %update%
	echo .
	rmdir /s /Q "%~dp0\Temp"
	echo .
	echo Game files should have been extracted to
	echo %~dp0\patched_%~n1
	echo .
	echo Press ENTER to delete all temporary files
	pause
	rmdir /s /Q "%~dp0\ExtractedXCI"
	echo Done
	pause
	exit
)