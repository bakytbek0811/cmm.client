<cfcomponent output="false">
    <cffunction name="getMessagesWithUser" access="public" returnType="any">
        <cfset SetTimeZone("UTC")>
        
        <cfargument name="page" type="numeric" required="true">
        <cfargument name="size" type="numeric" required="true">

        <cfset var offset = ((arguments.page - 1) * arguments.size)>

        <cfquery name="messages" datasource="chatMainDb">
            SELECT 
                m.id, 
                m.content, 
                m.from_user_id, 
                m.created_at, 
                u.username as username
            FROM 
                messages m
            INNER JOIN 
                users u 
            ON 
                m.from_user_id = u.id
            ORDER BY 
                m.created_at DESC
            LIMIT 
                <cfqueryparam value="#arguments.size#" cfsqltype="cf_sql_integer">
            OFFSET 
                <cfqueryparam value="#offset#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset var result = []>

        <cfloop query="messages">
            <cfset messageData = {
                "id" = messages.id,
                "content" = messages.content,
                "createdAt" = messages.created_at,
                "user" = {
                    "id" = messages.from_user_id,
                    "username" = messages.username
                }
            }>

            <cfset arrayAppend(result, messageData)>
        </cfloop>

        <cfreturn result>
    </cffunction>
</cfcomponent>