<cfcomponent output="false">
    <cffunction  name="generateRandomToken" returnType="string" access="public">
        <cfargument name="len" required="true" type="numeric">

        <cfscript>
            var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var token = "";
                
            for (var i = 1; i <= arguments.len; i++) {
                token &= characters.charAt(randRange(1, len(characters)) - 1);
            }
                
            return token;
        </cfscript>
    </cffunction>
</cfcomponent>