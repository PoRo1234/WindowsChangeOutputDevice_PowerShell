# 전환할 출력 장치 이름을 설정합니다.
$device1 = "device_name_1"  # 출력장치1 이름
$device2 = "device_name_2"  # 출력장치2 이름

try {
    # Audio Device Cmdlets 모듈이 설치되어 있는지 확인합니다.
    if (-not (Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
        Write-Output "AudioDeviceCmdlets 모듈이 설치되어 있지 않습니다. 먼저 모듈을 설치하세요."
        throw "모듈 설치 필요"
    }

    # Audio Device Cmdlets 모듈을 가져옵니다.
    Import-Module AudioDeviceCmdlets

    # 현재 출력 장치를 확인합니다.
    $currentDevice = (Get-AudioDevice -List | Where-Object { $_.Default -eq "Playback" }).Name

    # 장치 이름이 정확한지 확인
    Write-Output "현재 출력 장치: $currentDevice"

    # 현재 출력 장치에 따라 다른 장치로 전환합니다.
    if ($currentDevice -eq $device1) {
        # device2의 GUID 또는 인덱스를 찾아서 변경합니다.
        $device2Object = Get-AudioDevice -List | Where-Object { $_.Name -eq $device2 }
        if ($device2Object) {
            Set-AudioDevice -Index $device2Object.Index
            Write-Output "출력 장치를 $device2로 변경했습니다."
        } else {
            Write-Output "$device2 장치를 찾을 수 없습니다."
        }
    }
    elseif ($currentDevice -eq $device2) {
        # device1의 GUID 또는 인덱스를 찾아서 변경합니다.
        $device1Object = Get-AudioDevice -List | Where-Object { $_.Name -eq $device1 }
        if ($device1Object) {
            Set-AudioDevice -Index $device1Object.Index
            Write-Output "출력 장치를 $device1로 변경했습니다."
        } else {
            Write-Output "$device1 장치를 찾을 수 없습니다."
        }
    }
    else {
        Write-Output "현재 출력 장치가 설정된 장치와 일치하지 않습니다. 기본 장치로 $device1을 설정합니다."
        # 기본 장치로 설정
        $device1Object = Get-AudioDevice -List | Where-Object { $_.Name -eq $device1 }
        if ($device1Object) {
            Set-AudioDevice -Index $device1Object.Index
        } else {
            Write-Output "$device1 장치를 찾을 수 없습니다."
        }
    }

} catch {
    # 오류가 발생하면 예외 메시지를 출력합니다.
    Write-Output "오류가 발생했습니다: $_"
    Write-Output "설정된 출력 장치 이름을 확인하거나 AudioDeviceCmdlets 모듈 설치를 확인하세요."
}
