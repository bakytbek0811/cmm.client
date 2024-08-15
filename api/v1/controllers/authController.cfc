<cfcomponent rest="true" restPath="auth">
    <cffunction name="checkAuth" httpMethod="GET" restPath="check-auth" access="remote" returnType="boolean">
        <cftry>
            <cfset jwt = new lib.jwt.models.jwt()>
            <cfset headers = getHTTPRequestData().headers>

            <cfif structKeyExists(headers, "Cookie")>
                <cfset token = headers["Cookie"]>
                <cfset token = replace(token, "ACCESSTOKEN=", "", "one")>

                <cfset jwtToken = jwt.decode(token, "secret-key", ["HS256"])>
                <cfreturn true>
            </cfif>

            <cfreturn false>
            
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

        <cfset var payload = {
                "sub" = user.id,
                "iat" = Now()
            }>

        <cfset jwt = new '/opt/cmm.client/lib/jwt/models/jwt.cfc'()>

        <cfset jwtToken = jwt.encode(payload, "secret-key", "HS256")>

        <cfcookie  name="accessToken" value="#jwtToken#">

        <cfreturn jwtToken>
    </cffunction>
</cfcomponent>