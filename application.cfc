<cfcomponent output="false">
    <cfset this.name = "ChatApp">

    <cfset SetTimeZone("UTC")>

    <cffunction  name="onStartApplication" returntype="boolean" output="false">
        <cfset initRestApplication("./api/v1/controllers", "api")>   

        <cfreturn true>
    </cffunction>
</cfcomponent>