# up and down search history using current entry
Set-PSReadlineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Chord DownArrow -Function HistorySearchForward

# Tab autocomplete
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
