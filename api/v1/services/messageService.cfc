<cfcomponent output="false">
    <cffunction name="getMessagesWithUser" access="public" returnType="any">        
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
            <cfset arrayAppend(result, {
                "id" = messages.id,
                "content" = messages.content,
                "createdAt" = messages.created_at,
                "user" = {
                    "id" = messages.from_user_id,
                    "username" = messages.username
                }
            })>
        </cfloop>

        <cfreturn result>
    </cffunction>

    <cffunction name="saveMessage" access="public" returnType="any">
        <cfargument name="content" type="string" required="true">
        <cfargument name="fromUserId" type="numeric" required="true">

        <cfquery name="message" dataSource="chatMainDb">
            INSERT INTO messages (content, original_content, from_user_id, created_at)
            VALUES (
                <cfqueryparam value="#arguments.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.content#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.fromUserId#" cfsqltype="cf_sql_integer">,
                now()
            )
            RETURNING *
        </cfquery>

        <cfreturn message>
    </cffunction>
</cfcomponent>