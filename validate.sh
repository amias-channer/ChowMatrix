#!/bin/bash

# install functions
install_pluginval_linux()
{
    curl -L "https://github.com/Tracktion/pluginval/releases/download/latest_release/pluginval_Linux.zip" -o pluginval.zip
    unzip pluginval > /dev/null
    echo "./pluginval"
}

install_pluginval_mac()
{
    curl -L "https://github.com/Tracktion/pluginval/releases/download/latest_release/pluginval_macOS.zip" -o pluginval.zip
    unzip pluginval > /dev/null
    echo "pluginval.app/Contents/MacOS/pluginval"
}

install_pluginval_win()
{
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://github.com/Tracktion/pluginval/releases/download/latest_release/pluginval_Windows.zip -OutFile pluginval.zip"
    powershell -Command "Expand-Archive pluginval.zip -DestinationPath ."
    echo "./pluginval.exe"
}

# install
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    pluginval=$(install_pluginval_linux)
    plugin="build/ChowMatrix_artefacts/Release/VST3/ChowMatrix.vst3"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    pluginval=$(install_pluginval_mac)
    plugin="build/ChowMatrix_artefacts/VST3/ChowMatrix.vst3"
else
    pluginval=$(install_pluginval_win)
    plugin="build/ChowMatrix_artefacts/Release/VST3/ChowMatrix.vst3"
fi

echo "Pluginval installed at ${pluginval}"
echo "Validating ${plugin}"
$pluginval --strictness-level 8 --validate-in-process --validate $plugin
result=$?

# clean up
rm -Rf pluginval*
exit $result
