param(
  # Version to build
  [Parameter()]
  [ValidateSet("1.2", "1.3", "1.9")]
  [String[]]
  $Versions = ("1.2", "1.3", "1.9"),

  # Base image name
  [Parameter()]
  [String]
  $BaseImageName = "phoenix-builder",

  # Whether to pull base image before build
  [Parameter()]
  [Switch]
  $UpdateBase = $false,

  # Docker image namespace (e.g. Docker hub username)
  [Parameter(Mandatory)]
  [String]
  $ImageNamespace,

  # Whether to squash the image
  [Parameter()]
  [Switch]
  $NoSquash = $false
)

foreach ($Version in $Versions) {
  $ImageName = "${ImageNamespace}/${BaseImageName}:${Version}"

  Write-Host "-> Building $ImageName ..."

  $GitVersion = $(git rev-parse HEAD)
  $BuildOptions = @("--build-arg=git_version=${GitVersion}")

  if ($UpdateBase) {
    $BuildOptions += "--pull=true"
  }

  docker build $BuildOptions -t $ImageName $(Join-Path -Path $PSScriptRoot -ChildPath $Version)

  if (!$SkipSquash) {
    docker-squash -t $ImageName $ImageName
  }
}