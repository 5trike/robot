*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${URL_BLOCK_SERVICES}          http://admin:password@192.168.1.1/BKS_service.htm
${URL_LAN_SETUP}        http://admin:password@192.168.1.1/LAN_lan.htm
${BROWSER}    firefox

*** Keywords ***
Start
    SeleniumLibrary.Open Browser    ${URL_BLOCK_SERVICES}  	${BROWSER}    
    block port   0

End
    SeleniumLibrary.Close All Browsers

Deblock port
    SeleniumLibrary.Click Element  //*[contains(@value,"never")]
    
Setup block port
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

Block port
    [Arguments]   ${port}
    SeleniumLibrary.Go To    ${URL_BLOCK_SERVICES}
    Run Keyword If   '${port}'=='0'   Deblock port   ELSE   Setup block port   ${port}
    SeleniumLibrary.Click Element  //*[contains(@value, "Apply")]

Turn off DHCP server
    ConsoleDialogs.Pause Execution  message=Turn off DHCP. Hit [Return] to continue.
    #SeleniumLibrary.Go To    ${URL_LAN_SETUP}
    #Click Element    //*[@id="target"]/table/tbody/tr[2]/td/div/table/tbody/tr[10]/td/input
    #Click Element    //form[@id='target']/table/tbody/tr/td/button/span
    #Handle Alert

Turn on DHCP server
    ConsoleDialogs.Pause Execution  message=Turn off DHCP. Hit [Return] to continue.
    #SeleniumLibrary.Go To    ${URL_LAN_SETUP} 
    #Sleep   5s
    #Click Element    //*[@id="target"]/table/tbody/tr[2]/td/div/table/tbody/tr[10]/td/input
    #Click Element    //form[@id='target']/table/tbody/tr/td/button/span

*** Comments ***
#*** Test Cases ***
Test
    Start
    Turn off DHCP server
    Sleep  20
    Turn on DHCP server
    Sleep  20
    End
