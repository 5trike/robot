*** Settings ***
Library    OperatingSystem
Library    XML
Library    BuiltIn
Library    Collections

*** Variables ***


*** Keywords ***
#Try
#    [Arguments]     ${xml}
#    ${elentype}    Evaluate    type($xml).__name__
#    ${elemcount}    Get Element Count    ${xml}
#    ${elemattr}    Get Element Attributes    ${xml}
#    ${chld}    Get Child Elements    ${xml}
#    #${txt}    Get Elements Texts    source    xpath
#    Log To Console    \nElem: ${xml}
#    Log To Console    Type: ${elentype}
#    Log To Console    Count: ${elemcount}
#    Log To Console    Attr: ${elemattr} 
#    Log To Console    Chld: ${chld}

Save param    
    [Arguments]     ${item}    ${dict}
    ${name}    XML.Get Element Attribute    ${item}[0][0]    text
    ${value}    XML.Get Element Attribute    ${item}[0][2]    text
    Set To Dictionary  ${DICT}    ${name}    ${value}
    #log to console   ${dict}    #${name} : ${value}
    
#*** Test Cases ***
Source
    [Arguments]    ${xml}
    #${infos}    Set variable  noPrnt.ApplianceState    noPrnt.DoorState   noPrnt.SensorTemperature[3]
    #${dict}    Create dictionary
    ${xml}    Get File    test.txt
    ${xml}    Parse Xml    ${xml}
    ${xml}    Set Variable    ${xml}[0][0][0][0][0][0][2]
    ${params}    XML.Get Child Elements    ${xml}
    FOR    ${param}  IN  @{params}
    ${count}    XML.Get Child Elements  ${param}[0]
    ${count}    Get length    ${count}
    Run keyword if    '${count}'=='3'    Save param  ${param}    ${dict}
    END


*** Comments ***
Test 1
    
    ${txt}   Get Elements Texts    ${xml}    //*[contains(@resource-id, 'text_unit_name')]
    Log To Console    ${txt}

    #FOR    ${elem}    IN    @{elems}
    #Log To Console    ${elem}
    #${xmla}    Get Element Attributes    ${elem}
    #Log To Console    ${xmla}
    #END


    #${keys}    Get attr from Webelements     //*[@resource-id="com.electrolux.ecp.client.sdk.app.selector:id/text_unit_name"]
    #${values}   Get attr from Webelements      //*[@resource-id="com.electrolux.ecp.client.sdk.app.selector:id/text_unit_value"]
    
    #${dict}    Create dictionary from lists    ${keys}    ${values}
    #Set Global Variable  ${t}  1
    #Return From Keyword    ${dict}
    #Log To Console    \n-------
    #Log To Console    \nDICTIONARY:${dict}

    #    eclick    //*[contains(@text,"${text}")]
#    ${txt}    Get Source
#    Log to Console  ${txt}
#    Log To Console    \n${dict}[${text}]

Create dictionary from lists
    [Arguments]   ${list1}    ${list2}
    ${cnt}    Get length   ${list2}
    Log To Console    ${t}
    ${dictish}    Create Dictionary
    FOR  ${i}  IN RANGE  ${cnt}
    Log To Console    ${i} 
    Set To Dictionary   ${dict}  ${list1}[${i}]  ${list2}[${i}]
    Log To Console   
    END
    Log To Console    1 ${dict} 
#    Return From Keyword    ${dict}

Create dictionary if not exists
    &{dictish}    Create Dictionary
    Set Global Variable    ${dict}    ${dictish}

    #Get value   noPrnt.Ssid
    #eclick    com.electrolux.ecp.client.sdk.app.selector:id/text_components_count
    #${keys}    Get attr from Webelements     //*[@resource-id="com.electrolux.ecp.client.sdk.app.selector:id/text_unit_name"]
    #${values}   Get attr from Webelements      //*[@resource-id="com.electrolux.ecp.client.sdk.app.selector:id/text_unit_value"]
    #${return}    Create dictionary from lists    ${keys}    ${values}
    #${key}    Set Variable    noPrnt.TargetTemperature[3]
    #Log To Console    \n${key} = ${return}[${key}] 
    #Log Many
    End

    TC01
    Start
    Choose appliance
    Find parameter  noPrnt.DefrostTemperature[3]

    eclick    //android.widget.ImageView[@content-desc="More options"]
    eclick    //*[contains(@text, 'Register appliance...')

Get attr from Webelements
    [Arguments]   ${loc}    ${attr}=text
    ${items}   Get Webelements     ${loc}
    ${return}    Create List  
    FOR    ${item}     IN      @{items}
    ${type}    Evaluate    type($item).__name__
    ${next}    Set Variable If    '${type}'=='WebElement'  ${item.${attr}}
    Append To List    ${return}    ${next}
    END
    Log To Console    \nLIST: ${loc} ${return}
    Return From Keyword    ${return}


