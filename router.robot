*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${URL_ROUTER}          http://admin:password@192.168.1.1/BKS_service.htm

*** Keywords ***
Start
    SeleniumLibrary.Open Browser    ${URL_ROUTER}  	${BROWSER}    
    router.block port   0

End
    SeleniumLibrary.Close All Browsers

Deblock port
    SeleniumLibrary.Click Element  //*[contains(@value,"never")]
    #SeleniumLibrary.Click Element  //*[contains(@value, "Apply")

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
    SeleniumLibrary.Go To    ${URL_ROUTER}
    #SeleniumLibrary.Switch Window  NETGEAR Router WNDR3400v3
    Run Keyword If   '${port}'=='0'   Deblock port   ELSE   Setup block port   ${port}
    SeleniumLibrary.Click Element  //*[contains(@value, "Apply")]

#*** Test Cases ***
#Test
#    Init
#    Finish
