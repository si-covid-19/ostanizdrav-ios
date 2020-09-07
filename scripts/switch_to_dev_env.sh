#!zsh
set -euo pipefail

script_dir=${0:a:h}
cd $script_dir/../src/xcode/ENA/ENA/Source/Client/HTTP\ Client

# Strings to be replaced
distr_endp='https://svc90.main.px.t-online.de'
subm_endp='https://submission.coronawarn.app'
verif_endp='https://verification.coronawarn.app'

# Replace endpoints
sed "s,$distr_endp,$SECRET_DIST_URL,g ; s,$subm_endp,$SECRET_SUBM_URL,g ; s,$verif_endp,$SECRET_VERIF_URL,g" HTTPClient+Configuration.swift > tmp.swift

# Replace original file
mv tmp.swift HTTPClient+Configuration.swift

cd -
