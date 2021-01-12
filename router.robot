*** Settings ***
Library  OperatingSystem
Library  SeleniumLibrary
Library  DateTime

*** Variables ***
${ROUTER_URL}          http://admin:password@192.168.1.1/BKS_service.htm
${BROWSER}      headlessfirefox         #firefox

*** Keywords ***
deblock port
    SeleniumLibrary.Click Element  //*[contains(@value,"never")]
    SeleniumLibrary.Click Element  //*[contains(@value, "Apply")]

setup block port
    [Arguments]   ${port}
    SeleniumLibrary.Click Element    //*[contains(@name, 'Edit')]
    SeleniumLibrary.Select From List By Label  //*[contains(@name, "service_type")]   User Defined
    SeleniumLibrary.Select From List By Label  //*[contains(@name, "protocol")]   TCP/UDP
    ${portstart}=   Set Variable If    '${port}'=='65535'   1    ${port}
    SeleniumLibrary.Input Text    //*[contains(@name, "portstart")]   ${portstart} 
    SeleniumLibrary.Input Text    //*[contains(@name, "portend")]    ${port}
    ${d}=   Get time
    SeleniumLibrary.Input Text    //*[contains(@name, "userdefined")]    ${d}
    SeleniumLibrary.Click Element  //*[contains(@value, "Accept")]
    SeleniumLibrary.Click Element  //*[contains(@value,"always")]    

block port
    [Arguments]   ${port}
    SeleniumLibrary.Open Browser    ${ROUTER_URL}  	${BROWSER}
    Run Keyword If   '${port}'=='0'   deblock port   ELSE   setup block port   ${port}

    SeleniumLibrary.Click Element  //*[contains(@value, "Apply")]
    SeleniumLibrary.Close Browser


