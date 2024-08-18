<cfcomponent output="false">
    <cffunction name="getData" returnType="any" access="public">
        <cfargument name="key" required="true" type="string">

        <cfscript>
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            data = jedis.get(arguments.key);
            
            jedis.close();

            return data;
        </cfscript>
    </cffunction>

    <cffunction  name="setData" returnType="void" access="public">
        <cfargument name="key" required="true" type="string">
        <cfargument name="value" required="true" type="string">

        <cfscript>
            jedis = createObject("java", "redis.clients.jedis.Jedis").init("94.247.135.81", 6370);

            jedis.set(arguments.key, arguments.value);

            jedis.close();
        </cfscript>
    </cffunction>
</cfcomponent>