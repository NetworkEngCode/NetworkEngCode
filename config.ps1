# =========================
# config.ps1
# =========================

$Config = @{
    Username  = "NetworkEngCode"
    BirthYear = 1988

    # ASCII art file (left side)
    AsciiArtFile = ".\ascii-art.txt"

    # Output SVGs
    OutputFiles = @{
        Dark  = "dark_mode.svg"
        Light = "light_mode.svg"
    }

    # Layout / spacing
    Layout = @{
        Width       = 900
        Height      = 700
        FontSize    = 14
        LineHeight  = 18

        # Left ASCII block position
        AsciiX      = 20
        AsciiY      = 95

        # Right-side content position
        ContentX    = 420  # <--- Increased value for separation
        ContentY    = 140

        TargetWidth = 56
    }

    # Profile information
    Profile = [ordered]@{
        OS                      = "Windows"
        Host                    = "N/A"
        Kernel                  = "Network Automation Engineer"
        IDE                     = "VS Code"
        "Languages.Programming" = "Python"
        Hobbies                 = "Networking, Automation"
    }

    # Contact information
    Contact = [ordered]@{
        GitHub   = "NetworkEngCode"
        LinkedIn = "jerryrico"
    }

    # Color themes
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
