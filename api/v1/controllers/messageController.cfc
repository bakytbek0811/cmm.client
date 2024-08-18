<cfcomponent rest="true" restPath="/messages" output="false">
    <cffunction httpMethod="GET" name="getMessages" restPath="/" access="remote" returnType="any" produces="application/json">
        <cfargument name="page" type="numeric" required="false" restArgSource="query" default="1">
        <cfargument name="size" type="numeric" required="false" restArgSource="query" default="50">
        
        <cfreturn new services.messageService().getMessagesWithUser(arguments.page, arguments.size)>
    </cffunction>

    <cffunction httpMethod="POST" name="sendMessage" restPath="/send" access="remote" returnType="any" produces="application/json">
        <cfset httpRequestData = getHTTPRequestData()>
        <cfset data = deserializeJSON(httpRequestData.content)>

        <cfset SetTimeZone("UTC")>

        <cfif NOT structKeyExists(data, "content")>
            <cfheader statusCode="404" statusText="Bad request.">
            <cfthrow message="Missing required parameter: content" type="InvalidRequestException">
        </cfif>

        <cfset authService = new services.authService()>

        <cfset fromUserId = authService.getUserIdFromToken()>

        <cfquery name="message" dataSource="chatMainDb">
            INSERT INTO messages (content, original_content, from_user_id, created_at)
            VALUES (
                <cfqueryparam value="#data.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#data.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#fromUserId#" cfsqltype="cf_sql_integer">,
                now()
            )
            RETURNING *
        </cfquery>

        <cfset new services.policyFilterService().sendMessageToQueueForPolicyCheck(message)>
    </cffunction>
</cfcomponent>
