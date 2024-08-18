<cfcomponent>
    <cffunction name="getUserIdFromToken" returnType="numeric" access="public">
        <cfset headers = getHTTPRequestData().headers>

        <cfset cookieString = headers["Cookie"]>
        <cfset cookieParts = listToArray(cookieString, "; ")>

        <cfloop array="#cookieParts#" index="part">
            <cfif left(part, 12) eq "ACCESSTOKEN=">
                <cfset token = replace(part, "ACCESSTOKEN=", "", "one")>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfset redisService = new services.redisService()>

        <cfscript>
            fromUserId = redisService.getData("cmm:accessToken:" & token);

            if (fromUserId > 0) {
                return fromUserId;
            }
        </cfscript>

        <cfif fromUserId eq 0>
            <cfheader statusCode="401" statusText="Unauthorized.">
            <cfthrow message="Unauthorized" type="UnauthorizedException">
        </cfif>
    </cffunction>
</cfcomponent>