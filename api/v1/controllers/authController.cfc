<cfcomponent rest="true" restPath="auth">
    <cffunction name="checkAuth" httpMethod="GET" restPath="check-auth" access="remote" returnType="boolean" produces="text/plain">
        <cftry>
            <cfset authService = new services.authService()>

            <cfset authService.getUserIdFromToken()>
            
            <cfreturn true>
        <cfcatch>
            <cfreturn false>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction httpMethod="POST" name="login" restPath="login" access="remote" returnType="any" produces="application/json">
        <cfset httpRequestData = getHTTPRequestData()>
        <cfset data = deserializeJSON(httpRequestData.content)>
        <cfset tokenService = new services.tokenService()>
        <cfset redisService = new services.redisService()>

        <cfset SetTimeZone("UTC")>

        <cfset userService = new services.userService()>
        <cfset var user = userService.getUserByUsername(data.username)>

        <cfset jwtToken = "">

        <cfscript>
            jwtToken = tokenService.generateRandomToken(20);

            redisService.setData("cmm:accessToken:" & jwtToken, user.id);
        </cfscript>

        <cfcookie  name="accessToken" value="#jwtToken#">

        <cfreturn jwtToken>
    </cffunction>
</cfcomponent>