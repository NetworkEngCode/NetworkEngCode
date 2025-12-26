$Config = @{
    Username  = "NetworkEngCode"
    BirthYear = 1988

    # ASCII art file (must exist in repo root)
    AsciiArtFile = ".\ascii-art.txt"

    # Output SVG filenames
    OutputFiles = @{
        Dark  = "dark_mode.svg"
        Light = "light_mode.svg"
    }

    # Layout / spacing settings
    Layout = @{
        Width       = 900
        Height      = 520
        FontSize    = 14
        LineHeight  = 18
        AsciiX      = 25
        ContentX    = 360
        TargetWidth = 56
    }

    # Color themes
    Colors = @{
        Dark = @{
            Background = "#0d1117"
            Text       = "#c9d1d9"
            Key        = "#58a6ff"
            Value      = "#8b949e"
            Dots       = "#30363d"
            AddColor   = "#3fb950"
            DelColor   = "#f85149"
        }

        Light = @{
            Background = "#ffffff"
            Text       = "#24292f"
            Key        = "#0969da"
            Value      = "#57606a"
            Dots       = "#d0d7de"
            AddColor   = "#1a7f37"
            DelColor   = "#cf222e"
        }
    }

    # Profile info (left-aligned terminal style)
    Profile = [ordered]@{
        OS                      = "Windows"
        Host                    = "N/A"
        Kernel                  = "Network Automation Engineer"
        IDE                     = "VS Code"
        "Languages.Programming" = "Python"
        Hobbies                 = "Networking, Automation"
    }

    # Contact info
    Contact = [ordered]@{
        GitHub   = "NetworkEngCode"
        LinkedIn = "jerryrico"
    }
}
