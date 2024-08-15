<cfcomponent rest="true" restPath="auth">
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

        <cfset var token = JWTEncode(payload, "HS256", "yourSecretKey")>
        <cfreturn token>
    </cffunction>
</cfcomponent>