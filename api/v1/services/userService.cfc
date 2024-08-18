<cfcomponent>
    <cffunction  name="saveUser" returnType="any" access="public">
        <cfargument name="username" required="true" type="string">

        <cfquery name="user" datasource="chatMainDb">
            INSERT INTO users (username, registration_date) 
            VALUES (
                <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
                now()
            )
            RETURNING *
        </cfquery>

        <cfreturn user>
    </cffunction>
</cfcomponent>