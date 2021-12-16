
param(
	[Parameter(Mandatory=$False)] [string[]] $Locations=@() 
)

$logfilepath="C:\Windows\Temp\kcsirtLog4jScan.log"
Start-Transcript -Path $logfilepath
Write-Debug "Starting search"


$ProvidedInput = $False
$DRIVES = Get-PSDrive -PSProvider FileSystem

if( $Locations.Length -gt 0 ){
	$ProvidedInput = $True
	$DRIVES = $Locations
}


foreach($DRIVE in $DRIVES){
	Write-Information "Searching drive $($DRIVE) for vulnerable .jar, .java and .class files"
	
	if( $ProvidedInput ){
		$FILELIST = GCI "$($DRIVE)" -Recurse -Force -Include *.jar,*.java,*.class -EA SilentlyContinue -EV +ErrorFileList
	}
	else {
		$FILELIST = GCI "$($DRIVE.Root)" -Recurse -Force -Include *.jar,*.java,*.class -EA SilentlyContinue -EV +ErrorFileList
	}
	
	if( $ErrorFileList ) {
		Write-Information "#######################################"
		Write-Information "## LISTING ALL ACCESS ERRORS
		Write-Information "#######################################"
		foreach( $ErrorFile in  $ErrorFileList ){
			Write-Information "$ErrorFile"
		}
		Write-Information "#######################################"
		Write-Information "## END OF ACCESS ERRORS LISTING
		Write-Information "#######################################"
		Write-Information ""
	}

	foreach($FILE in $FILELIST) {
		if( $FILE -match ".(java|class)$" ) {
			if ( $FILE -match '(jndi|log4j)'){
				Write-Warning "Detected JNDI Class in: $($FILE)"
			}
		}
		else {
			$Result = $(Select-String "JndiLookup.class" "$($FILE)" -ErrorAction SilentlyContinue -ErrorVariable ErrorValue)
			if( $ErrorValue ){
				Write-Information "ERROR PROCESSING: $($FILE)"
				foreach( $Error in $ErrorValue){
					Write-Debug "$($Error)"
				}
			}
			elseif ( $Result ){
				Write-Warning "Detected JNDI Class in: $($Result.Path)"
			}
		}
	}
}

Stop-Transcript