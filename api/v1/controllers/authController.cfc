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

        <cfset SetTimeZone("UTC")>

        <cfquery name="user" datasource="chatMainDb">
            INSERT INTO users (username, registration_date) 
            VALUES (
                <cfqueryparam value="#data.username#" cfsqltype="cf_sql_varchar">,
                now()
            )
            RETURNING *
        </cfquery>

        <cfset jwtToken = "">

        <cfscript>
            function generateRandomToken(len) {
                var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                var token = "";
                
                for (var i = 1; i <= len; i++) {
                    token &= characters.charAt(randRange(1, len(characters)) - 1);
                }
                
                return token;
            }

            jwtToken = generateRandomToken(20);
            
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            jedis.set("cmm:accessToken:" & jwtToken, user.id);

            jedis.close();
        </cfscript>

        <cfcookie  name="accessToken" value="#jwtToken#">

        <cfreturn jwtToken>
    </cffunction>
</cfcomponent>