<cfcomponent output="false">

    <cffunction name="broadcastMessage" access="public" returntype="void">
        <cfargument name="message" type="string" required="true">

        <cfset writeLog(file="websocket", text="Broadcasting message: " & arguments.message)>

        <cfset wsSendMessage(channel="chatChannel", message=arguments.message)>
    </cffunction>

</cfcomponent>
