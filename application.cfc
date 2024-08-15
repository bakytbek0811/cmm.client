<cfcomponent output="false">
    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "/opt/cmm.client/lib">

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>

        <cfset wsConfig = {
            channels = {
                chatChannel = {
                    listener = "handlers.WebSocketHandler"
                }
            }
        }>
        <cfset application.wsConfig = wsConfig>
        <cfset APPLICATION.connectedClients = {}>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>