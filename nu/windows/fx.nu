# open a location in file explorer
export def fx [location = "."] {
    powershell -C $"open ($location)"
}