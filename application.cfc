<cfcomponent output="false">
    <cfset SetTimeZone("UTC")>

    <cfset this.mappings["/lib"] = "C:/test-task/cmm.client/lib">

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>
        <cfreturn true>
    </cffunction>
</cfcomponent>