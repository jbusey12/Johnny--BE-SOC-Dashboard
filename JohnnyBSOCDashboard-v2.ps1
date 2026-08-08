# ============================================================
# JOHNNY B.E. SOC DASHBOARD v2
# Windows Security / Security+ Practice Dashboard
# ============================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ------------------------------------------------------------
# MAIN FORM
# ------------------------------------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "Johnny B.E. SOC Dashboard v2"
$form.Size = New-Object System.Drawing.Size(1200,700)
$form.StartPosition = "CenterScreen"
$form.BackColor = "Black"
$form.ForeColor = "Lime"
$form.FormBorderStyle = "Sizable"
$form.MaximizeBox = $true

# ------------------------------------------------------------
# TITLE
# ------------------------------------------------------------

$title = New-Object System.Windows.Forms.Label
$title.Text = "JOHNNY B.E. SOC DASHBOARD v2"
$title.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    18,
    [System.Drawing.FontStyle]::Bold
)
$title.ForeColor = "Lime"
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(400,20)

$form.Controls.Add($title)

# ------------------------------------------------------------
# OUTPUT WINDOW
# ------------------------------------------------------------

$output = New-Object System.Windows.Forms.TextBox
$output.Multiline = $true
$output.ReadOnly = $true
$output.ScrollBars = "Vertical"
$output.Font = New-Object System.Drawing.Font("Consolas",10)
$output.BackColor = "Black"
$output.ForeColor = "Lime"
$output.Location = New-Object System.Drawing.Point(20,70)
$output.Size = New-Object System.Drawing.Size(850,500)

$form.Controls.Add($output)

# ------------------------------------------------------------
# OUTPUT FUNCTION
# ------------------------------------------------------------

function Write-OutputBox($text) {

    $output.AppendText(
        "`r`n============================================================`r`n"
    )

    $output.AppendText($text)

    $output.AppendText("`r`n")

    $output.SelectionStart = $output.Text.Length
    $output.ScrollToCaret()
}

# ------------------------------------------------------------
# BUTTON STYLING FUNCTION
# ------------------------------------------------------------

function Set-SOCButtonStyle($button) {

    $button.Size = New-Object System.Drawing.Size(200,40)
    $button.BackColor = "Black"
    $button.ForeColor = "Lime"
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderColor = "Lime"
    $button.FlatAppearance.BorderSize = 1

}

# ============================================================
# NETSTAT
# ============================================================

$btnNetstat = New-Object System.Windows.Forms.Button
$btnNetstat.Text = "Netstat"
$btnNetstat.Location = New-Object System.Drawing.Point(900,80)

Set-SOCButtonStyle $btnNetstat

$btnNetstat.Add_Click({

    try {

        $result = netstat -ano | Out-String

        Write-OutputBox(
            "NETSTAT - NETWORK CONNECTIONS`r`n" +
            $result
        )

    }
    catch {

        Write-OutputBox(
            "Unable to run Netstat.`r`n$($_.Exception.Message)"
        )

    }

})

$form.Controls.Add($btnNetstat)

# ============================================================
# IPCONFIG
# ============================================================

$btnIP = New-Object System.Windows.Forms.Button
$btnIP.Text = "IPConfig"
$btnIP.Location = New-Object System.Drawing.Point(900,130)

Set-SOCButtonStyle $btnIP

$btnIP.Add_Click({

    try {

        $result = ipconfig /all | Out-String

        Write-OutputBox(
            "IPCONFIG - NETWORK CONFIGURATION`r`n" +
            $result
        )

    }
    catch {

        Write-OutputBox(
            "Unable to run IPConfig.`r`n$($_.Exception.Message)"
        )

    }

})

$form.Controls.Add($btnIP)

# ============================================================
# PROCESSES
# ============================================================

$btnProc = New-Object System.Windows.Forms.Button
$btnProc.Text = "Processes"
$btnProc.Location = New-Object System.Drawing.Point(900,180)

Set-SOCButtonStyle $btnProc

$btnProc.Add_Click({

    try {

        $result = Get-Process |
            Sort-Object CPU -Descending |
            Select-Object -First 25 |
            Format-Table Name,Id,CPU,WS -Auto |
            Out-String

        Write-OutputBox(
            "TOP PROCESSES BY CPU`r`n" +
            $result
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve processes.`r`n$($_.Exception.Message)"
        )

    }

})

$form.Controls.Add($btnProc)

# ============================================================
# ACTIVE CONNECTIONS
# ============================================================

$btnConnections = New-Object System.Windows.Forms.Button
$btnConnections.Text = "Active Connections"
$btnConnections.Location = New-Object System.Drawing.Point(900,230)

Set-SOCButtonStyle $btnConnections

$btnConnections.Add_Click({

    try {

        $connections = Get-NetTCPConnection -State Established `
            -ErrorAction Stop |
            Select-Object `
                LocalAddress,
                LocalPort,
                RemoteAddress,
                RemotePort,
                State,
                OwningProcess |
            Format-Table -Auto |
            Out-String

        Write-OutputBox(
            "ESTABLISHED TCP CONNECTIONS`r`n" +
            $connections
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve active TCP connections.`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnConnections)

# ============================================================
# MICROSOFT DEFENDER STATUS
# ============================================================

$btnDefender = New-Object System.Windows.Forms.Button
$btnDefender.Text = "Defender Status"
$btnDefender.Location = New-Object System.Drawing.Point(900,280)

Set-SOCButtonStyle $btnDefender

$btnDefender.Add_Click({

    try {

        $defender = Get-MpComputerStatus -ErrorAction Stop |
            Select-Object `
                AntivirusEnabled,
                AntispywareEnabled,
                RealTimeProtectionEnabled,
                BehaviorMonitorEnabled,
                IoavProtectionEnabled,
                NISEnabled,
                AntivirusSignatureLastUpdated,
                QuickScanEndTime |
            Format-List |
            Out-String

        Write-OutputBox(
            "MICROSOFT DEFENDER STATUS`r`n" +
            $defender
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve Microsoft Defender status.`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnDefender)

# ============================================================
# WINDOWS FIREWALL
# ============================================================

$btnFirewall = New-Object System.Windows.Forms.Button
$btnFirewall.Text = "Firewall Status"
$btnFirewall.Location = New-Object System.Drawing.Point(900,330)

Set-SOCButtonStyle $btnFirewall

$btnFirewall.Add_Click({

    try {

        $firewall = Get-NetFirewallProfile -ErrorAction Stop |
            Select-Object Name,Enabled,DefaultInboundAction,DefaultOutboundAction |
            Format-Table -Auto |
            Out-String

        Write-OutputBox(
            "WINDOWS FIREWALL STATUS`r`n" +
            $firewall
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve firewall status.`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnFirewall)

# ============================================================
# DNS CACHE
# ============================================================

$btnDNS = New-Object System.Windows.Forms.Button
$btnDNS.Text = "DNS Cache"
$btnDNS.Location = New-Object System.Drawing.Point(900,380)

Set-SOCButtonStyle $btnDNS

$btnDNS.Add_Click({

    try {

        $dns = Get-DnsClientCache -ErrorAction Stop |
            Select-Object -First 50 `
                Entry,
                Name,
                Type,
                Data |
            Format-Table -Auto |
            Out-String

        Write-OutputBox(
            "DNS CLIENT CACHE`r`n" +
            $dns
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve DNS cache.`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnDNS)

# ============================================================
# SECURITY EVENTS
# ============================================================

$btnEvents = New-Object System.Windows.Forms.Button
$btnEvents.Text = "Security Events"
$btnEvents.Location = New-Object System.Drawing.Point(900,430)

Set-SOCButtonStyle $btnEvents

$btnEvents.Add_Click({

    try {

        $events = Get-WinEvent `
            -LogName "Security" `
            -MaxEvents 20 `
            -ErrorAction Stop |
            Select-Object `
                TimeCreated,
                Id,
                LevelDisplayName,
                ProviderName |
            Format-Table -Auto |
            Out-String

        Write-OutputBox(
            "RECENT WINDOWS SECURITY EVENTS`r`n" +
            $events
        )

    }
    catch {

        Write-OutputBox(
            "Unable to read the Windows Security event log.`r`n" +
            "Try running PowerShell as Administrator.`r`n`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnEvents)

# ============================================================
# SYSTEM INFORMATION
# ============================================================

$btnSystem = New-Object System.Windows.Forms.Button
$btnSystem.Text = "System Info"
$btnSystem.Location = New-Object System.Drawing.Point(900,480)

Set-SOCButtonStyle $btnSystem

$btnSystem.Add_Click({

    try {

        $computer = Get-CimInstance Win32_ComputerSystem
        $os = Get-CimInstance Win32_OperatingSystem

        $info = @"

Computer Name : $env:COMPUTERNAME
User          : $env:USERNAME
Manufacturer  : $($computer.Manufacturer)
Model         : $($computer.Model)
Windows       : $($os.Caption)
Version       : $($os.Version)
Build         : $($os.BuildNumber)
Architecture  : $($os.OSArchitecture)
Last Boot     : $($os.LastBootUpTime)

"@

        Write-OutputBox(
            "SYSTEM INFORMATION`r`n" +
            $info
        )

    }
    catch {

        Write-OutputBox(
            "Unable to retrieve system information.`r`n" +
            $($_.Exception.Message)
        )

    }

})

$form.Controls.Add($btnSystem)

# ============================================================
# CLEAR OUTPUT
# ============================================================

$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "Clear Output"
$btnClear.Location = New-Object System.Drawing.Point(900,530)

Set-SOCButtonStyle $btnClear

$btnClear.Add_Click({

    $output.Clear()

})

$form.Controls.Add($btnClear)

# ============================================================
# STATUS BAR
# ============================================================

$status = New-Object System.Windows.Forms.Label
$status.Text = "Ready"
$status.ForeColor = "Lime"
$status.Font = New-Object System.Drawing.Font("Consolas",9)
$status.AutoSize = $true
$status.Location = New-Object System.Drawing.Point(20,590)

$form.Controls.Add($status)

# ============================================================
# LIVE CLOCK
# ============================================================

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000

$timer.Add_Tick({

    $status.Text =
        "READY  |  " +
        $env:COMPUTERNAME +
        "  |  " +
        (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

})

$timer.Start()

# ============================================================
# STARTUP MESSAGE
# ============================================================

$startup = @"

JOHNNY B.E. SOC DASHBOARD v2
--------------------------------------------

System: $env:COMPUTERNAME
User:   $env:USERNAME

Dashboard ready.

Select a security tool from the right panel.

"@

$output.Text = $startup

# ------------------------------------------------------------
# DISPLAY DASHBOARD
# ------------------------------------------------------------

[void]$form.ShowDialog()