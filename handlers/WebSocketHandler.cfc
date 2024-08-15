<cfcomponent output="false">

    <cffunction name="onOpen">
        <cfargument name="wsEvent" type="struct">
        <cfset var clientId = createUUID()>
        <cfset APPLICATION.connectedClients[clientId] = wsEvent.session>
        <cfset writeLog(file="websocket", text="Client connected: " & clientId)>
    </cffunction>

    <cffunction name="onClose">
        <cfargument name="wsEvent" type="struct">
        <cfloop collection="#APPLICATION.connectedClients#" item="key">
            <cfif APPLICATION.connectedClients[key] eq wsEvent.session>
                <cfset structDelete(APPLICATION.connectedClients, key)>
                <cfset writeLog(file="websocket", text="Client disconnected: " & key)>
                <cfbreak>
            </cfif>
        </cfloop>
    </cffunction>

</cfcomponent>
