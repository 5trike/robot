*** Settings ***
Library           OperatingSystem
Library    XML
Library    String
Library    BuiltIn


*** Keywords ***
Try
    [Arguments]     ${xml}
    #${elentype}    Evaluate    type($xml).__name__
    ${elemcount}    Get Element Count    ${xml}
    ${elemattr}    Get Element Attributes    ${xml}
    ${txt}    Get Elements Texts    source    xpath
    Log To Console    \nElem: ${xml}
    Log To Console    Type: ${elentype}
    Log To Console    Count: ${elemcount}
    Log To Console    Attr: ${elemattr} 

*** Test Cases ***
Test 1
    ${xml}    Get File    test.txt
    ${xml}    Parse Xml    ${xml}
    ${txt}   Get Elements Texts    ${xml}    //*[contains(@resource-id, 'text_unit_name')]
    Log To Console    ${txt}
*** Comments ***
    Try    ${xml}
    ${xml}    Set Variable    ${xml}[0][0][0][0][0][0][2][1][0][0]
    Try    ${xml}
    ${chld}    Get Child Elements    ${xml}
    Log To Console    Chld: ${chld}

    #FOR    ${elem}    IN    @{elems}
    #Log To Console    ${elem}
    #${xmla}    Get Element Attributes    ${elem}
    #Log To Console    ${xmla}
    #END


