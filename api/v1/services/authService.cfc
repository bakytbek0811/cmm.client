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

        <cfscript>
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            fromUserId = jedis.get("cmm:accessToken:" & token);

            if (fromUserId > 0) {
                return fromUserId;
            }
        </cfscript>
        
        <cfreturn 0>
    </cffunction>
</cfcomponent>