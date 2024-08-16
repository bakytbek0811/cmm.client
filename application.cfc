<cfcomponent output="false">
    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "/opt/cmm.client/lib">

    <cfset this.wschannels = [{
        name = "chatChannel", 
        cfclistener = "handlers.WebSocketHandler"
    }]>

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>

        <cfset application.wsConfig = wsConfig>
        <cfset APPLICATION.connectedClients = {}>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>