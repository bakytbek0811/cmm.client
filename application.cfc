<cfcomponent output="false">
    <cfset this.name = "ChatApp";>

    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "/opt/cmm.client/lib">

    <cfset this.wschannels = [{
        name = "chatChannel" 
    }]>

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>

        <cfset application.wsConfig = wsConfig>
        <cfset APPLICATION.connectedClients = {}>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>