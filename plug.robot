*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${on}    https://maker.ifttt.com/trigger/plugON/with/key/4TJpG7nFhuPV3WjtVr9R8
${off}    https://maker.ifttt.com/trigger/plugOFF/with/key/4TJpG7nFhuPV3WjtVr9R8
${BROWSER}    firefox

*** Keywords ***
On
    SeleniumLibrary.Go To	${on}
    #Log To Console    Power on

Off
    SeleniumLibrary.Go To	${off}
    #Log To Console    Power off

*** Comments ***
#*** Test Cases ***
Test 1
    SeleniumLibrary.Open Browser    ${on}  	${BROWSER}    
    ON
    Sleep  20
    OFF