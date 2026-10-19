param(
    [int]$Depth = 1800
)

# Convert the latest CSV records into fixed-width memories for $readmemh.
# Each output line is {date YYYYMMDD, close in cents, volume} in hexadecimal.

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

function Convert-CsvToMemory {
    param(
        [string]$CsvPath,
        [string]$MemoryPath
    )

    $rows = @(Import-Csv -LiteralPath $CsvPath | Select-Object -Last $Depth)
    $lines = foreach ($row in $rows) {
        $date = [DateTime]::ParseExact(
            $row.Date,
            'yyyy-MM-dd',
            [Globalization.CultureInfo]::InvariantCulture
        )
        $dateValue = [int64]$date.ToString('yyyyMMdd')
        $closeCents = [int64][Math]::Round(
            ([double]$row.Close) * 100,
            0,
            [MidpointRounding]::AwayFromZero
        )
        $volume = [int64][Math]::Round(
            [double]$row.Volume,
            0,
            [MidpointRounding]::AwayFromZero
        )

        '{0:X8}{1:X4}{2:X8}' -f $dateValue, $closeCents, $volume
    }

    [IO.File]::WriteAllLines(
        $MemoryPath,
        [string[]]$lines,
        [Text.Encoding]::ASCII
    )
}

Convert-CsvToMemory `
    (Join-Path $scriptDirectory 'AMD.csv') `
    (Join-Path $scriptDirectory 'AMD_seed.mem')

Convert-CsvToMemory `
    (Join-Path $scriptDirectory 'MCD.csv') `
    (Join-Path $scriptDirectory 'MCD_seed.mem')
