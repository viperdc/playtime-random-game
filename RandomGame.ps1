function global:OnScriptLoaded()
{
}

function global:OnGameStarting()
{
    param(
        $game
    )
}

function global:OnGameStarted()
{
    param(
        $game
    )
}

function global:OnGameStopped()
{
    param(
        $game,
        $elapsedSeconds
    )
}

function global:OnGameInstalled()
{
    param(
        $game
    )     
}

function global:OnGameUninstalled()
{
    param(
        $game
    )    
}

function global:RandomGame()
{
	$games = $PlayniteApi.Database.GetGames()
	$count = $games.Count
	
	While ($play -ne "Yes") {
		$attempt = 0
		$test = 99
		While ($test -ne 0)
		{
			if ($attempt -gt 100)
			{ 
				$PlayniteApi.Dialogs.ShowMessage("Max attempts reached, aborting.")
				return
			}

			$rand = Get-Random -Maximum $count # 5
			$game = $games | Select -Skip $rand -First 1
			$test = TestGame($game)
			
			$attempt = $attempt + 1
		}

		$ButtonType = [System.Windows.MessageBoxButton]::YesNo
		$play = $PlayniteApi.Dialogs.ShowMessage("Do you want to play?",$game,$ButtonType)
	}
}


function global:TestGame($tgame)
{
	if ($tgame.IsInstalled -eq $False) { return 1 } # Checks if game is installed, skips if not
	if ($tgame.Hidden -eq $True) { return 2 } # Checks if game is hidden, skips if not
	if ($tgame.CompletionStatus -eq "Completed") { return = 3 }	 # Checks if game is completed, skips if not
	if ($tgame.CompletionStatus -eq "Beaten") { return = 4 }  # Checks if game is beaten, skips if not
	return 0
}
