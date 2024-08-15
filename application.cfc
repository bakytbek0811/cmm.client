<cfcomponent output="false">
    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "/opt/chat/cmm.client/lib/">

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>
        <cfreturn true>
    </cffunction>
</cfcomponent>