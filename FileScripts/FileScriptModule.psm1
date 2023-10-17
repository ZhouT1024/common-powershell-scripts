# 隐藏文件
function Hide-File($path='./') {
    $fileType = (Get-Item $path -Force)
    if ($filetype -is [System.IO.DirectoryInfo]) {
        # 隐藏目录及目录下的文件
        $path = $path -replace "/","\" # D:\users\40344\
        $path = $path -replace "\\$","" # D:\users\40344
        attrib +s +h ($path + '\*') /S /D
        attrib +s +h $path
    } elseif ($fileType -is [System.IO.FileInfo]) {
        # 隐藏文件
        attrib +s +h $path
    } elseif ($fileType -is [System.Object[]]) {
        # 隐藏多个文件
        # D:\users\40344\desktop\test\*
        attrib +s +h $path /S /D
    }
}

# 取消隐藏文件
function Remove-Hide ($path) {
    $fileType = (Get-Item $path -Force)
    if ($filetype -is [System.IO.DirectoryInfo]) {
        # 显示目录及子文件
        $path = $path -replace "/","\" # D:\users\40344\
        $path = $path -replace "\\$","" # D:\users\40344
        attrib -s -h ($path + '\*') /S /D
        attrib -s -h $path
    } elseif ($fileType -is [System.IO.FileInfo]) {
        # 显示文件
        attrib -s -h $path
    } elseif ($fileType -is [System.Object[]]) {
        # 显示多个文件
        # D:\users\40344\desktop\test\*
        attrib -s -h $path /S /D
    }
}

# 遍历隐藏的文件
function Get-HideFile {
    Param( [String]$path="./" )
    Get-ChildItem $path -attribute h
}

# 批量重命名
function Rename-Items {
    Param(
        [String]$search,
        [String]$replace
    )

    $oldSearch = $search
    $search = '*' + $search + '*'
    Get-ChildItem -attribute h,!h -Name -path $search | ForEach-Object {
        $newName = $_ -replace $oldSearch,$replace
        Rename-Item $_ $newName
    }
}