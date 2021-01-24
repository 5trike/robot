*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${on}    https://maker.ifttt.com/trigger/plugON/with/key/4TJpG7nFhuPV3WjtVr9R8
${off}    https://maker.ifttt.com/trigger/plugOFF/with/key/4TJpG7nFhuPV3WjtVr9R8
${BROWSER}    firefox

*** Keywords ***
ON
    SeleniumLibrary.Open Browser	${on}	${BROWSER}

OFF
    SeleniumLibrary.Open Browser	${off}	${BROWSER}

*** Test Cases ***
Test 1
    ON
    Sleep  20
    OFF