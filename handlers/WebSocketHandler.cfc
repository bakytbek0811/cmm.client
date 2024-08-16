<cfcomponent output="false">
    
    <cffunction name="onWSOpen">
        <cfargument name="wsEvent" type="struct">

        <cfset APPLICATION.connectedClients[wsEvent.wsSession] = wsEvent.wsSession>
    </cffunction>

    <cffunction name="onWSClose">
        <cfargument name="wsEvent" type="struct">

        <cfset structDelete(APPLICATION.connectedClients, wsEvent.wsSession)>
    </cffunction>

    <cffunction name="onWSMessage">
        <cfargument name="wsEvent" type="struct">

        <cfset writeLog(file="websocket", text="Received message: " & wsEvent.data)>

        <cfset wsEvent.data = serializeJSON(wsEvent.data)>
        
        
    </cffunction>

</cfcomponent>
