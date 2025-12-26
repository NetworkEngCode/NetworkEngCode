# config.ps1

$Config = @{
    Username  = "NetworkEngCode"
    BirthYear = 1988

    AsciiArtFile = ".\ascii-art.txt"

    OutputFiles = @{
        Dark  = "dark_mode.svg"
        Light = "light_mode.svg"
    }

    Layout = @{
        Width       = 900
        Height      = 560
        FontSize    = 14
        LineHeight  = 18

        AsciiX      = 20
        AsciiY      = 75

        ContentX    = 360
        ContentY    = 95

        TargetWidth = 56
    }

    Profile = [ordered]@{
        OS                      = "Windows"
        Host                    = "N/A"
        Kernel                  = "Network Automation Engineer"
        IDE                     = "VS Code"
        "Languages.Programming" = "Python"
        Hobbies                 = "Networking, Automation"
    }

    Contact = [ordered]@{
        GitHub   = "NetworkEngCode"
        LinkedIn = "jerryrico"
    }

    Colors = @{
        Dark = @{
            Background = "#0d1117"
            Text       = "#c9d1d9"
            Key        = "#58a6ff"
            Value      = "#c9d1d9"
            Dots       = "#8b949e"
            AddColor   = "#3fb950"
            DelColor   = "#f85149"
        }
        Light = @{
            Background = "#ffffff"
            Text       = "#24292f"
            Key        = "#0969da"
            Value      = "#24292f"
            Dots       = "#57606a"
            AddColor   = "#1a7f37"
            DelColor   = "#cf222e"
        }
    }
}
