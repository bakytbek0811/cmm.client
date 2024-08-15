<cfcomponent output="false">

    <cffunction name="onMessage">
        <cfargument name="wsEvent" type="struct">
        
        <cfset writeLog(file="websocket", text="Received message: " & wsEvent.data)>
        
        <cfloop collection="#APPLICATION.connectedClients#" item="key">
            <cfset wsSendMessage(APPLICATION.connectedClients[key].wsSession, wsEvent.data)>
        </cfloop>
    </cffunction>

</cfcomponent>
